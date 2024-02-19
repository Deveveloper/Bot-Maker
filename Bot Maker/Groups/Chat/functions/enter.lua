local _M = {}

_M.get = function()

    return function(__M, text_)

        local group = display.newGroup()

        local background = display.newRect(cx, cy, dw, dacth*4) group:insert(background)
        background:setFillColor(0, 0, 0) background.alpha = 0.65
        background:addEventListener("touch",
        function(event)

            return true
        
        end)

        local frame = display.newRoundedRect(cx, cy, dw/1.25, 325, 50) group:insert(frame)
        frame:setFillColor(pallete.background[1], pallete.background[2], pallete.background[3])

        local hint
        local textfield = native.newTextBox(cx, dacth*5, frame.width - 110, 150) group:insert(textfield)
        textfield.font = native.newFont("Fonts/Ubuntu/Ubuntu-Light", 30)
        textfield.data = ""
        textfield:addEventListener("userInput", 
        function(event)

            if event.phase == "began" then

                transition.to(hint, {alpha = 0, time = 100})

            elseif event.phase == "editing" then

                textfield.data = event.target.text

            end

        end)
        textfield.x, textfield.y = frame.x, frame.y - frame.height/2 + textfield.height/2 + 50
        textfield.hasBackground = false
        textfield.isEditable = true
        if env ~= "simulator" or platform ~= "Win" then textfield:setTextColor(1, 1, 1, 0.25) end
        --textfield.isVisible = false

        textfield.text = text_.data

        hint = display.newText("Введите сообщение здесь...", 0, 0, "Fonts/Ubuntu/Ubuntu-Light", 30) group:insert(hint)
        hint.x, hint.y = frame.x - frame.width/2 + hint.width/2 + 50, frame.y - frame.height/2 + hint.height/2 + 50
        hint.alpha = 0

        local confirm = display.newText("Подтвердить", 0, 0, "Fonts/Ubuntu/Ubuntu-Light", 30) group:insert(confirm)
        confirm.alpha = 0.25
        confirm.x, confirm.y = frame.x + frame.width/2 - confirm.width/2 - 35, frame.y + frame.height/2 - confirm.height/2 - 35
        --local button_
        confirm:addEventListener("touch",
        function(event)

            if event.phase == "began" then
                display.getCurrentStage():setFocus(event.target)
                --button_ = display.newRoundedRect(frame.x, event.target.y, frame.width/10, event.target.height*2, 100) __M.group:insert(button_)
                --button_.alpha = 0.05
                --transition.to(button_.path, {radius = 0, time = 100})
                --transition.to(button_, {xScale = 10, time = 100})
            elseif event.phase == "moved" then
                --transition.to(button_, {alpha = 0, time = 250, onComplete = function() if button_.x then display.remove(button_) end end})
            elseif event.phase == "ended" then
                display.getCurrentStage():setFocus(nil)
                --transition.to(button_, {alpha = 0, time = 250, onComplete = function() if button_.x then display.remove(button_) end end})
                timer.performWithDelay(250, 
                function()

                    if textfield.isVisible then

                        if #textfield.text > 0 then

                            text_.text = textfield.text
                            text_.data = textfield.text
                            text_.x = text_.width/2 + 50
                            display.remove(group)

                        end

                    end

                end, 1)

            end

            return true
        
        end)

        local back = display.newText("Отмена", 0, 0, "Fonts/Ubuntu/Ubuntu-Light", 30) group:insert(back)
        back.alpha = 0.25
        back.x, back.y = confirm.x - confirm.width/2 - back.width/2 - 35, frame.y + frame.height/2 - back.height/2 - 35
        --local button_
        back:addEventListener("touch",
        function(event)

            if event.phase == "began" then
                display.getCurrentStage():setFocus(event.target)
                --button_ = display.newRoundedRect(frame.x, event.target.y, frame.width/10, event.target.height*2, 100) __M.group:insert(button_)
                --button_.alpha = 0.05
                --transition.to(button_.path, {radius = 0, time = 100})
                --transition.to(button_, {xScale = 10, time = 250})
            elseif event.phase == "moved" then
                --transition.to(button_, {alpha = 0, time = 250, onComplete = function() if button_.x then display.remove(button_) end end})
            elseif event.phase == "ended" then
                display.getCurrentStage():setFocus(nil)
                --transition.to(button_, {alpha = 0, time = 250, onComplete = function() if button_.x then display.remove(button_) end end})
                timer.performWithDelay(250, 
                function()

                    display.remove(group)

                end, 1)

            end

            return true
        
        end)

        __M.group:insert(group)

    end

end

return _M