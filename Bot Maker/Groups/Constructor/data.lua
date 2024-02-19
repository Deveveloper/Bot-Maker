local _M = {}

_M.get = function(__M)

    local data = {}

    --Все данные
    data["BLOCK"] = {}

    --Выбранное крепление блока
    data["BLOCK"].target = nil

    --Линии
    data["BLOCK"].lines = {}

    --Группы
    data["groups"] = {
        blocks = display.newGroup(),
        lines = display.newGroup()
    }

    --Создание блока
    data["BLOCK"].create = function(x, y, params)

        local strokeWidth = 1.5
        if platform == "Win" or env == "simulator" then

            strokeWidth = 3

        end

        --Группа
        local block = display.newGroup()
        block.anchorChildren = true
        block.x, block.y = x, y

        --Максимальная ширина объекта
        local wmax = 0

        --Данные блока
        local bdata = params.data

        --Цвет блока
        local color = blocksclasses[bdata.class][bdata.name].color

        --Название блока
        local title = display.newText({text = blocksclasses[bdata.class][bdata.name].title, font = "Fonts/Ubuntu/Ubuntu-Light", fontSize = 30, align = "center"})

        --Основной блок
        local frame = display.newRoundedRect(x, y, params.width, params.height, 50)
        frame.fill = {
            type = "gradient",
            color1 = {color[1]/255 + 0.25, color[2]/255 + 0.25, color[3]/255 - 0.25},
            color2 = {color[1]/255, color[2]/255, color[3]/255},
            direction = "right"
        }

        --Второй блок
        local frame_ = display.newRoundedRect(x, y, params.width, params.height - 75, 0)
        frame_.x, frame_.y = frame.x, frame.y + frame.height/2 - frame_.height/2
        --frame_.alpha = 0.5
        frame_:setFillColor(pallete.light[1], pallete.light[2], pallete.light[3])

        local dframe = display.newRoundedRect(x, y, params.width, 100, 100)
        dframe.x, dframe.y = frame_.x, frame_.y + frame_.height/2 + dframe.height/16
        --dframe.alpha = 0.5
        dframe:setFillColor(pallete.light[1], pallete.light[2], pallete.light[3])

        --Вставка в группу блока всех его объектов
        block:insert(frame)
        block:insert(frame_)
        block:insert(title)
        block:insert(dframe)

        --Изменение ширины блока в максимальную ширину объекта
        for i = 1, block.numChildren do

            if block[i].width > wmax then wmax = block[i].width end

        end

        frame.width, frame_.width, dframe.width = wmax + 50, wmax + 50, wmax + 50

        --Остальные позиции
        title.x, title.y = frame.x, frame.y - frame.height/2 + title.height/2 + (frame.height - frame_.height)/4 + 2.5

        --Кнопки для соединения блоков
        local types = blocksclasses[bdata.class][bdata.name].types

        for i = 1, #types do

            local link = display.newGroup()
            link.block = block
            link.class = types[i]

            --Крепление
            local triangle = display.newPolygon(0, 0, {0, -12.5, 12.5, 12.5, -12.5, 12.5}) link:insert(triangle)
            triangle.rotation = 90
            triangle.fill = {
                type = "gradient",
                color1 = {color[1]/255 + 0.1, color[2]/255 + 0.1, color[3]/255 - 0.1},
                color2 = {color[1]/255, color[2]/255, color[3]/255},
                direction = "right"
            }

            link.anchorChildren = true
            if types[i] == "end" then

                link.x, link.y = dframe.x + dframe.width/2 - link.width/2 - 25, dframe.y + dframe.height/2 - link.height/2 - 25

            elseif types[i] == "began" then

                link.x, link.y = frame.x - frame.width/2 - link.width/2 - 25, frame.y - frame.height/2 + link.height/2 + 25

            end

            link:addEventListener("touch",
            function(event)

                if event.phase == "ended" then

                    if data["BLOCK"].target then

                        if data["BLOCK"].target.class ~= event.target.class and (data["BLOCK"].target.line == nil or event.target.line == nil) then

                            local target = data["BLOCK"].target

                            --Создание соединения
                            local line = display.newLine(0, 0, 0, 0)
                            line.strokeWidth = 5
                            line:setStrokeColor(math.random(0, 255)/255, math.random(0, 255)/255, math.random(0, 255)/255)

                            --Присваивание линии к блокам
                            line.target = {event.target, target}

                            --Вставка в таблицу
                            table.insert(data["BLOCK"].lines, line)

                            --Вставка в группу
                            data["groups"].lines:insert(line)

                            data["BLOCK"].target = nil

                        elseif data["BLOCK"].target.class == event.target.class then

                            data["BLOCK"].target = nil

                        end

                    else

                        event.target.phase = nil
                        data["BLOCK"].target = event.target

                    end

                end

                return true

            end)

            block:insert(link)

        end

        local blockparams = blocksclasses[bdata.class][bdata.name].params

        if blockparams then

            --Отображение параметров
            if blocksclasses[bdata.class][bdata.name].type == "get_text" then

                local textfield = display.newRoundedRect(frame_.x, 0, frame_.width - 50, frame_.height - 50, 25) block:insert(textfield)
                textfield.y = frame_.y + frame_.height/2 - textfield.height/2 - dframe.height/2 + 25
                textfield.alpha = 0.05

                local text = display.newText({text = blockparams[1].text, font = "Fonts/Ubuntu/Ubuntu-Light", fontSize = 25, align = "center"}) block:insert(text)
                text.alpha = 0.5
                text.x, text.y = textfield.x - textfield.width/2 + text.width/2 + 25, textfield.y - textfield.height/2 + text.height/2 + 25

            else



            end

        end

        block.id = params.id
        block:addEventListener("touch",
        function(event)

            if event.phase == "began" then

                event.target.touchOffsetX = event.x - event.target.x
                event.target.touchOffsetY = event.y - event.target.y
                event.target:toFront()

            elseif event.phase == "moved" then

                if event.target.touchOffsetX and event.target.touchOffsetY then

                    event.target.x = event.x - event.target.touchOffsetX
                    event.target.y = event.y - event.target.touchOffsetY    
                    event.target.phase = "moved"

                end

            elseif event.phase == "ended" then

            end

            return true

        end)

        data["groups"].blocks:insert(block)

        return block

    end

    --Отображение линий
    timer.performWithDelay(1,
    function()

        for i = 1, #data["BLOCK"].lines do

            if data["BLOCK"].lines[i].target then

                --Получение позиций для обновленной линии
                local target1, target2 = data["BLOCK"].lines[i].target[1], data["BLOCK"].lines[i].target[2]
                local x, y = target1:localToContent(0, 0)
                local x_, y_ = target2:localToContent(0, 0)

                --Удаление предыдущей
                display.remove(data["BLOCK"].lines[i])
                
                --Создание соединения
                data["BLOCK"].lines[i] = display.newLine(x, y, x_, y_)
                data["BLOCK"].lines[i].strokeWidth = 5
                data["BLOCK"].lines[i]:setStrokeColor(1, 1, 1, 0.25)

                --Присваивание линии к блокам
                data["BLOCK"].lines[i].target = {target1, target2}

                --Вставка в группу
                data["groups"].lines:insert(data["BLOCK"].lines[i])

                target1.line, target2.line = data["BLOCK"].lines[i], data["BLOCK"].lines[i]

            end

        end

    end, 0)
    
    return data

end

return _M