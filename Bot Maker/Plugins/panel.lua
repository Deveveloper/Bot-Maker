local _M = {}
local widget = require('widget')

_M.create = function(x, y, data, close)

    local width, height = 300, 500

    local panelgroup = display.newGroup()

    local background = display.newRect(cx, cy, dw, dacth*4) panelgroup:insert(background)
    background:setFillColor(0, 0, 0)
    background.alpha = 0.5

    local frame = display.newRoundedRect(x, y, width, height, 50) panelgroup:insert(frame)
    frame:setFillColor(pallete.background[1], pallete.background[2], pallete.background[3])

    local scroll = widget.newScrollView(
        {
            isBounceEnabled = true,
            horizontalScrollDisabled = true,
            width = width,
            height = height - 100,
            scrollWidth = dw,
            scrollHeight = dacth,
            top = 0, left = 0,
            x = x, y = y,
            hideBackground = true
        }
    ) panelgroup:insert(scroll)

    local y_ = 50/4
    for i = 1, #data do

        local group = display.newGroup()

        local button = display.newRect(0, y_, frame.width, 50) group:insert(button)
        button.alpha = 0.005
        button.x = button.width/2 + 50

        local text = display.newText(data[i][1], 0, y_, "Fonts/Ubuntu/Ubuntu-Light", 30) group:insert(text)
        text.x = text.width/2 + 50
        text.alpha = 0.5

        local button_
        button:addEventListener("touch",
        function(event)

            if event.phase == "began" then
                display.getCurrentStage():setFocus(event.target)
                local x, y = event.target:localToContent(0, 0)
                button_ = display.newRoundedRect(scroll.x, y, event.target.width/1.25, event.target.height, 50) panelgroup:insert(button_)
                button_.alpha = 0.05
                transition.to(button_.path, {radius = 0, time = 100})
                transition.to(button_, {xScale = 1.25, time = 50})
            elseif event.phase == "moved" then
                scroll:takeFocus(event)
                transition.to(button_, {alpha = 0, time = 250, onComplete = function() if button_.x then display.remove(button_) end end})
            elseif event.phase == "ended" then
                display.getCurrentStage():setFocus(nil)
                transition.to(button_, {alpha = 0, time = 250, onComplete = function() if button_.x then display.remove(button_) end end})
                timer.performWithDelay(250, 
                function()

                    data[i][2]()

                end, 1)

            end

            return true
        
        end)

        y_ = y_ + group.height

        scroll:insert(group)

    end

    background:addEventListener("touch", 
    function(event)

        if event.phase == "ended" then

            display.remove(panelgroup)
            close()

        end

        return true

    end)

    return panelgroup

end

return _M