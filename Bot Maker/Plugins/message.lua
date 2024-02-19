local _M = {}

_M.create = function(text, font, x, y)

    local message = display.newGroup()
    message.anchorChildren = true
    message.x, message.y = x, y
    message.alpha = 0

    local text = display.newText(text, x, y, font, 30)
    text:setFillColor(1, 1, 1, 0.25)

    local frame = display.newRoundedRect(x, y, dw/1.5, 80, 50) message:insert(frame) message:insert(text)
    frame:setFillColor(pallete.light[1], pallete.light[2], pallete.light[3])
    frame.width = text.width + 100

    transition.to(message, {alpha = 1, time = 250,
    onComplete = function()

        timer.performWithDelay(2000, 
        function(event)

            transition.to(message, {alpha = 0, time = 500,
            onComplete = function()

                display.remove(message)
            
            end})

        end, 1)

    end})

    return message

end

return _M