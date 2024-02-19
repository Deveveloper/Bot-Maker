local _M = {}

_M.get = function(data)

    return function(__M, icon, text_)

        local button_
        return function(event)

            if event.phase == "began" then
                display.getCurrentStage():setFocus(event.target)
                button_ = display.newRoundedRect(event.target.x, event.target.y, event.target.width, event.target.height, 85) __M.group:insert(button_)
                button_.alpha = 0
                transition.to(button_.path, {radius = 0, time = 100})
                transition.to(icon, {xScale = 1.5, yScale = 1.5, time = 100})
                transition.to(icon, {x = icon.x_ + 100, time = 100, alpha = 0, rotation = 45, transition = easing.inCirc,
                onComplete = function()

                    icon.x = icon.x_ - 40
                    transition.to(icon, {x = icon.x_, time = 500, alpha = 0.25, rotation = 0, transition = easing.outCirc})
                    transition.to(icon, {xScale = 1, yScale = 1, time = 500, transition = easing.outCirc})
                
                end})
            elseif event.phase == "moved" then
                transition.to(button_, {alpha = 0, time = 250, onComplete = function() if button_.x then display.remove(button_) end end})
                transition.to(icon, {xScale = 1, yScale = 1, time = 100})
            elseif event.phase == "ended" then
                display.getCurrentStage():setFocus(nil)
                transition.to(button_, {alpha = 0, time = 250, onComplete = function() if button_.x then display.remove(button_) end end})
                transition.to(icon, {xScale = 1, yScale = 1, time = 100})
                timer.performWithDelay(250, 
                function()

                    if #text_.data > 0 then

                        data["BOT"].send.message(text_.data, 'user', 'Вы', {

                        })
                        data["newmessage"](data["DIALOG"].data, #data["DIALOG"].data, __M.scroll)
                        text_.data, text_.text = "", "Введите ваше сообщение здесь..."
                        text_.x = text_.width/2 + 50

                    end

                end, 1)

            end

            return true

        end

    end

end

return _M