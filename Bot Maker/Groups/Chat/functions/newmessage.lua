local _M = {}

_M.get = function(data, command)

    return function(dialogdata, i, scroll)

        --Дополнительное смещение позиции y (отодвигание последующих от данного сообщения)
        local y_ = 0

        local icon_, dir = command.icon()

        local align, txr, width
        if dialogdata[i].sender == "bot" then

            align = "left" txr = icon_ width = dw - 200
            local len = utf8.len(system.pathForFile("", directory))
            if dir == directory then txr = (bots[data["bot"].data.id].path):sub(len + 2, utf8.len(bots[data["bot"].data.id].path)).."/"..txr end
        
        elseif dialogdata[i].sender == "user" then
            
            align = "right" txr = "Textures/user_.png" width = dw - 200
        
        end

        local message = display.newGroup()

        --Иконка
        local frame = display.newRoundedRect(cx, cy, 100, 100, 100/3) message:insert(frame)
        if dialogdata[i].sender == "bot" then frame.fill = {type = "image", filename = txr or "Textures/unknown.png", baseDir = dir} elseif dialogdata[i].sender == "user" then frame.fill = {type = "image", filename = txr or "Textures/unknown.png"} end

        --Имя отправителя
        local title = display.newText({text = dialogdata[i].name, font = "Fonts/Ubuntu/Ubuntu-Regular", fontSize = 32.5, width = width, align = align}) message:insert(title)

        --Текст
        local fontSize = 25
        local text
        if type(dialogdata[i].data) == "table" then

            local y = 0
            text = display.newGroup() text.anchorChildren = true
            for k = 1, #dialogdata[i].data do

                --pcall(function()

                local piece = display.newText({text = dialogdata[i].data[k].text, font = font, fontSize = fontSize, width = width, align = align})
                y = y + piece.height/2
                display.remove(piece)

                local piece
                local create = function(font)

                    piece = display.newText({text = dialogdata[i].data[k].text, font = font, fontSize = fontSize, width = width, align = align}) text:insert(piece)
                    piece.y = y
                    --Проверка на дополнительные параметры для текста
                    if dialogdata[i].data[k].color then

                        piece:setFillColor(dialogdata[i].data[k].color[1], dialogdata[i].data[k].color[2], dialogdata[i].data[k].color[3])

                    end

                end create("Fonts/Ubuntu/Ubuntu-Light")

                --Проверка типа текста
                if dialogdata[i].data[k].class then

                    --Ссылка
                    if dialogdata[i].data[k].class == "link" then

                        display.remove(piece)
                        create("Fonts/Ubuntu/Ubuntu-Bold")
                        piece:setFillColor(94/255, 251/255, 255/255)
                        piece:addEventListener("touch", function(event) scroll:takeFocus(event) system.openURL(dialogdata[i].data[k].link) end)

                    --Жирный текст
                    elseif dialogdata[i].data[k].class == "bold" then

                        display.remove(piece)
                        create("Fonts/Ubuntu/Ubuntu-Regular")

                    --Цветной текст
                    elseif dialogdata[i].data[k].class == "color" then

                        piece:setFillColor(dialogdata[i].data[k].color[1]/255, dialogdata[i].data[k].color[2]/255, dialogdata[i].data[k].color[3]/255)
                        
                    --Изображение
                    elseif dialogdata[i].data[k].class == "image" then

                        local filename = "image"..func.genID(10, {{65, 90}, {97, 122}, {48, 57}})..".png"
                        y_ = y_ + 400
                        network.download(dialogdata[i].data[k].link, "GET", 
                        function(event)

                            if event.isError then

                            elseif scroll.x then

                                local image = display.newImage(event.response.filename, event.response.baseDirectory) scroll:insert(image)
                                --Масштабирование изображения под ширину экрана
                                local imagef = image.width/400
                                image.width = 400
                                image.height = image.height/imagef
                                
                                if image.height > 400 then

                                    local imagef = image.height/400
                                    image.height = 400
                                    image.width = image.width/imagef

                                end
                                image.x, image.y = frame.x + frame.width/2 + image.width/2 + 25, text.y + text.height/2 + image.height/2 + 25
                                
                                --os.remove(system.pathForFile(event.response.filename, event.response.baseDirectory))

                            else

                                --display.remove(image)

                            end
                            
                        end, filename, system.TemporaryDirectory)
                    
                    end

                end

                y = y + piece.height/2
                
                --end)

            end

        elseif type(dialogdata[i].data) == "string" or type(dialogdata[i].data) == "number" then

            text = display.newText({text = dialogdata[i].data, font = "Fonts/Ubuntu/Ubuntu-Light", fontSize = fontSize, width = width, align = align})

        end
        text.alpha = 0.5
        message:insert(text)

        --Проверка ориентации сообщения
        if dialogdata[i].sender == "bot" then

            frame.x, frame.y = frame.width/2 + 25, data["message.y"] + frame.height/2
            title.x, title.y = frame.x + frame.width/2 + title.width/2 + 25, frame.y - frame.height/2 + title.height/2
            text.x, text.y = frame.x + frame.width/2 + text.width/2 + 25, title.y + title.height/2 + text.height/2 + 10

        elseif dialogdata[i].sender == "user" then

            frame.x, frame.y = dw - frame.width/2 - 25, data["message.y"] + frame.height/2
            title.x, title.y = frame.x - frame.width/2 - title.width/2 - 25, frame.y - frame.height/2 + title.height/2
            text.x, text.y = frame.x - frame.width/2 - text.width/2 - 25, title.y + title.height/2 + text.height/2 + 10

        end

        --Кнопки в сообщении
        local y = 0
        if dialogdata[i].buttons then

            for j = 1, #dialogdata[i].buttons do

                local params, format = {"text", "click", "color"}, true
                for k = 1, #params do

                    if dialogdata[i].buttons[j][params[k]] then else format = false end

                end

                if format == true then

                    local button = display.newRoundedRect(0, 0, text.width, 65, 25) message:insert(button)
                    button.x, button.y = text.x - text.width/2 + button.width/2, text.y + text.height/2 + button.height/2 + 25 + y
                    if #dialogdata[i].buttons[j].color >= 3 then

                        button:setFillColor(dialogdata[i].buttons[j].color[1], dialogdata[i].buttons[j].color[2], dialogdata[i].buttons[j].color[3])

                    else
                        
                        button:setFillColor(pallete.background_[1], pallete.background_[2], pallete.background_[3])

                    end

                    button.title = display.newText(dialogdata[i].buttons[j].text, 0, button.y, "Fonts/Ubuntu/Ubuntu-Light", 25) message:insert(button.title)
                    button.title.x = button.x - button.width/2 + button.title.width/2 + 25
                    button.title.alpha = 0.5

                    local button_
                    button:addEventListener("touch",
                    function(event)

                        if event.phase == "began" then
                            display.getCurrentStage():setFocus(event.target)
                            button_ = display.newRoundedRect(event.target.x, event.target.y, event.target.width/1.25, event.target.height, 0) message:insert(button_)
                            button_.alpha = 0.05
                            transition.to(button_.path, {radius = 25, time = 100})
                            transition.to(button_, {xScale = 1.25, time = 50})
                            transition.to(button.title, {xScale = 1, yScale = 1, time = 100})
                        elseif event.phase == "moved" then
                            scroll:takeFocus(event)
                            transition.to(button_, {alpha = 0, time = 250, onComplete = function() if button_.x then display.remove(button_) end end})
                            transition.to(button.title, {xScale = 1, yScale = 1, time = 100})
                        elseif event.phase == "ended" then
                            display.getCurrentStage():setFocus(nil)
                            transition.to(button_, {alpha = 0, time = 250, onComplete = function() if button_.x then display.remove(button_) end end})
                            transition.to(button.title, {xScale = 1, yScale = 1, time = 100})
                            timer.performWithDelay(250, 
                            function()
            
                                if type(dialogdata[i].buttons[j].click) == "function" then dialogdata[i].buttons[j].click() end
            
                            end, 1)
            
                        end
            
                        return true
                    
                    end)

                    y = y + button.height + 25

                end

            end

        end

        data["message.y"] = data["message.y"] + message.height + 50 + y_

        if i == #dialogdata then

            

        end

        scroll:insert(message)

        scroll.height_ = data["message.y"]
        scroll.data = dialogdata

        if scroll.height_ > dacth - 290 then

            scroll:scrollTo("bottom", {time = 100,
            onComplete = function()
            
            end})

        end

        return message

    end

end

return _M