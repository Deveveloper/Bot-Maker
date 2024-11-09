local _M = {}

_M.create = function()

    --Группа сцены
    _M.group = display.newGroup()

    local ekey = function(event)

        if event.keyName == "back" and event.phase == "up" then
            app:clearAllGroups()
            _Chats.create()
            return true
        elseif event.keyName == "e" and event.phase == "up" then
            app:clearAllGroups()
            _Chats.create()
            return true
        end

        return false

    end
    Runtime:addEventListener("key", ekey)

    local data = require('Groups.Settings.data').get(_M)

    local strokeWidth = 1.5
    if platform == "Win" or env == "simulator" then

        strokeWidth = 3

    end

    --Задний фон
    local background = display.newRect(cx, cy, dw, dacth*2)
    background.fill = {
        type = "gradient",
        color1 = {pallete.background_[1], pallete.background_[2], pallete.background_[3]},
        color2 = {pallete.background[1], pallete.background[2], pallete.background[3]},
        direction = "right"
    }

    local uppanel = display.newRect(cx, 0, dw, 150)
    uppanel.y = originY + uppanel.height/1.7
    uppanel.fill = {
        type = "gradient",
        color1 = {pallete.background[1], pallete.background[2], pallete.background[3]},
        color2 = {pallete.background[1], pallete.background[2], pallete.background[3]},
        direction = "left"
    }

    local line = display.newRoundedRect(cx, 0, dw - 60, strokeWidth, strokeWidth)
    line.alpha = 0.25/2
    line.y = uppanel.y + uppanel.height/2 + line.height/2 + 1

    local icon = display.newImageRect("Textures/settings.png", 65, 65)
    icon.x, icon.y = icon.width/2 + 30 + 25, uppanel.y
    icon.alpha = 1

    local title = display.newText("Настройки", 0, 0, "Fonts/Ubuntu/Ubuntu-Regular", 35)
    title.x, title.y = icon.x + icon.width/2 + title.width/2 + 25, icon.y - icon.height/2 + title.height/2
    title.alpha = 1

    local subtitle = display.newText("Дополнительные функции.", 0, 0, "Fonts/Ubuntu/Ubuntu-Light", 25)
    subtitle.x, subtitle.y = icon.x + icon.width/2 + subtitle.width/2 + 25, title.y + title.height/2 + subtitle.height/2
    subtitle.alpha = 0.5

    local scroll = widget.newScrollView(
        {
            isBounceEnabled = true,
            horizontalScrollDisabled = true,
            width = width,
            height = dacth - 100,
            scrollWidth = dw,
            scrollHeight = dacth,
            top = 0, left = 0,
            x = cx, y = uppanel.y + (dacth)/2 + strokeWidth + 25,
            hideBackground = true,
            hideScrollBar = true
        }
    )

    local height = 75
    local y = height/2 + 25
    local settings = {
        {"Импорт бота", "Выберите файл с исходными данными бота.", "download.png",
        function()

            data["import"]()
        
        end}
    }
    
    for i = 1, #settings do

        local group = display.newGroup()

        local frame = display.newRect(cx, y, dw, height*2) group:insert(frame)
        frame:setFillColor(pallete.background[1], pallete.background[2], pallete.background[3], 0.01)

        local icon = display.newRoundedRect(cx, cy, height/1.25, height/1.25, height/1.25/3) group:insert(icon)
        icon.fill = {type = "image", filename = "Textures/"..settings[i][3]}
        icon.x, icon.y = icon.width/2 + 30 + 25, frame.y

        local name = display.newText(settings[i][1], 0, 0, "Fonts/Ubuntu/Ubuntu-Regular", 35) group:insert(name)
        name.x, name.y = icon.x + icon.width/2 + name.width/2 + 25, icon.y - icon.height/2 + name.height/2

        local subtitle = display.newText(settings[i][2], 0, 0, "Fonts/Ubuntu/Ubuntu-Light", 25) group:insert(subtitle)
        subtitle.x, subtitle.y = icon.x + icon.width/2 + subtitle.width/2 + 25, name.y + name.height/2 + subtitle.height/2
        subtitle.alpha = 0.5

        icon.y = (subtitle.y + subtitle.height/2) - (name.y - name.height/2) frame.y = icon.y

        local button_
        frame:addEventListener("touch",
        function(event)

            if event.phase == "began" then
                display.getCurrentStage():setFocus(event.target)
                button_ = display.newRoundedRect(event.target.x, event.target.y, event.target.width, event.target.height, 85) scroll:insert(button_)
                button_.alpha = 0.05
                transition.to(button_.path, {radius = 0, time = 100})
            elseif event.phase == "moved" then
                scroll:takeFocus(event)
                transition.to(button_, {alpha = 0, time = 250, onComplete = function() if button_.x then display.remove(button_) end end})
            elseif event.phase == "ended" then
                display.getCurrentStage():setFocus(nil)
                transition.to(button_, {alpha = 0, time = 250, onComplete = function() if button_.x then display.remove(button_) end end})
                timer.performWithDelay(250, 
                function()
                    
                    settings[i][4]()

                end, 1)

            end

            return true
        
        end)
        
        scroll:insert(group)

        y = y + group.height

    end

    --Объекты сцены
    _M.objects = {
        {background},
        {uppanel, line, icon, title, subtitle, scroll}
    }
    --Слушатели сцены
    _M.listeners = {{Runtime, ekey, "key"}}

    for layer = 1, #_M.objects do

        for object = 1, #_M.objects[layer] do

            _M.group:insert(_M.objects[layer][object])

        end

    end
    for listener = 1, #_M.listeners do

        table.insert(allListeners, _M.listeners[listener])

    end
    table.insert(allGroups, _M.group)

end

return _M