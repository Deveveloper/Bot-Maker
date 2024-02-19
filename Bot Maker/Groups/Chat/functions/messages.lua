local _M = {}

_M.get = function(data)

    return function(__M, dialogdata)

        local scroll = widget.newScrollView(
            {
                isBounceEnabled = true,
                horizontalScrollDisabled = true,
                width = width,
                height = dacth - 260,
                scrollWidth = dw,
                scrollHeight = dacth,
                top = 0, left = 0,
                x = cx, y = originY + 100 + 55 + (dacth - 260)/2,
                hideBackground = true,
                hideScrollBar = true
            }
        )
        --Задний фон
        local background = display.newRect(cx, cy, dw, dacth*2)
        background.fill = {
            type = "gradient",
            color1 = {pallete.background_[1], pallete.background_[2], pallete.background_[3]},
            color2 = {pallete.background[1], pallete.background[2], pallete.background[3]},
            direction = "right"
        }
        timer.performWithDelay(0,
        function()

            background:toBack()
        
        end, 0)

        data["message.y"] = 0
        --Отступ свехру
        local empty = display.newRect(cx, data["message.y"], 25, 25) empty.isVisible = false data["message.y"] = data["message.y"] + empty.height scroll:insert(empty)
        --Цикл по диалогу (сообщениям)
        for i = 1, #dialogdata do

            local message = data["newmessage"](dialogdata, i, scroll)

        end

        scroll.height_ = data["message.y"]
        scroll.data = dialogdata

        return scroll, background

    end

end

return _M