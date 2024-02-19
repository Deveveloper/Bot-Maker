local _M = {}

_M.create = function()

    --Группа сцены
    _M.group = display.newGroup()

    local data = require('Groups.Chats.data').get(_M)

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
    uppanel.fill = {
        type = "gradient",
        color1 = {pallete.background[1], pallete.background[2], pallete.background[3]},
        color2 = {pallete.background[1], pallete.background[2], pallete.background[3]},
        direction = "left"
    }
    local y = originY + uppanel.height/1.7
    if env ~= "simulator" then y = y end
    uppanel.y = y

    local line = display.newRoundedRect(cx, 0, dw - 60, strokeWidth, strokeWidth)
    line.alpha = 0.25/2
    line.y = uppanel.y + uppanel.height/2 + line.height/2 + 1

    local icon = display.newImageRect("Textures/iconalpha.png", 60*2, 60*2)
    icon.x, icon.y = icon.width/4 + 30 + 25, uppanel.y
    icon.alpha = 1

    local title = display.newText("Bot Maker.", 0, 0, "Fonts/Ubuntu/Ubuntu-Light", 45)
    title.x, title.y = icon.x + icon.width/4 + title.width/2 + 50, uppanel.y
    title.alpha = 1

    local subtitle = display.newText("Перейдите к выбранному боту.", 0, 0, "Fonts/Ubuntu/Ubuntu-Light", 25)
    subtitle.x, subtitle.y = icon.x + icon.width/4 + subtitle.width/2 + 25, title.y + title.height/2 + subtitle.height/2
    subtitle.alpha = 0

    local scroll = widget.newScrollView(
        {
            isBounceEnabled = true,
            horizontalScrollDisabled = true,
            width = width,
            height = dacth - 200,
            scrollWidth = dw,
            scrollHeight = dacth,
            top = 0, left = 0,
            x = cx, y = uppanel.y + (dacth)/2 + strokeWidth + 25 - 50,
            hideBackground = true,
            hideScrollBar = true
        }
    )

    local height = 150
    local y = height/2 + 25/2
    for i = 1, #bots do

        local group = display.newGroup()

        --Данные бота, функция для запуска кода исходных файлов бота, разделитель для пути к файлу
        local command, f, s
        if pcall(function() require(bots[i].path..'.dialog') end) == false then
            
            --Возвращает код, запущенный с помощью loadstring() из папки Documents Directory
            f, s = function(_) local file = io.open(bots[i].path.."/".._..".lua", "r") if file then return loadstring(file:read("*a"))() end end, "/"

        else

            --Возвращает код, запущенный с помощью require() из папки Resources Directory
            f, s = function(_) return require(bots[i].path..".".._) end, "."

        end

        command = f('dialog')

        --if file then io.close(file) end

        local icon_, dir = command.icon()

        if dir == directory then

            local len = utf8.len(system.pathForFile("", directory))
            icon_ = (bots[i].path):sub(len + 2, utf8.len(bots[i].path)).."/"..icon_

        end

        local frame = display.newRect(cx, y, dw, height) group:insert(frame)
        frame:setFillColor(pallete.background[1], pallete.background[2], pallete.background[3], 0.01)

        local icon = display.newRoundedRect(cx, cy, height/1.25, height/1.25, height/1.25/3) group:insert(icon)
        icon.fill = {type = "image", filename = icon_ or "Textures/unknown.png", baseDir = dir}
        icon.x, icon.y = icon.width/2 + 25, frame.y
        --icon.alpha = 0.5

        local name = display.newText(command.data().name, 0, 0, "Fonts/Ubuntu/Ubuntu-Regular", 40) group:insert(name)
        name.x, name.y = icon.x + icon.width/2 + name.width/2 + 25, icon.y - icon.height/2 + name.height/2
        --name.alpha = 0.5

        local verified = display.newImageRect("Textures/verified_.png", 22.5, 22.5) group:insert(verified)
        verified.x, verified.y = name.x + name.width/2 + verified.width/2 + 10, name.y + 3
        verified.alpha = 0.25

        --Проверка: верифицирован ли бот
        timer.performWithDelay(10, function() if verify.result ~= f('verify') then

            verified.alpha = 0

        end end, 1)

        local sender, subtitle
        if #bots[i].chat.data > 0 then

            if bots[i].chat.data[#bots[i].chat.data].sender == "user" then

                sender = "Вы"

            else

                sender = "Бот"

            end

            --Проверка на формат последнего сообщения в чате
            local text
            if type(bots[i].chat.data[#bots[i].chat.data].data) == "table" then

                if bots[i].chat.data[#bots[i].chat.data].data.class ~= "image" then

                    text = (sender..": "..utf8.sub(bots[i].chat.data[#bots[i].chat.data].data[1].text, 1, 25).."..."):gsub("\n", " ")

                else

                    text = "<Изображение>"

                end

            else

                text = (sender..": "..utf8.sub(bots[i].chat.data[#bots[i].chat.data].data, 1, 25).."..."):gsub("\n", " ")

            end

            subtitle = display.newText(text, 0, 0, "Fonts/Ubuntu/Ubuntu-Light", 30) group:insert(subtitle)
            subtitle.x, subtitle.y = icon.x + icon.width/2 + subtitle.width/2 + 25, name.y + name.height/2 + subtitle.height/2 + 5
            subtitle.alpha = 0.25

        else

            subtitle = display.newText("Начните диалог!", 0, 0, "Fonts/Ubuntu/Ubuntu-Light", 30) group:insert(subtitle)
            subtitle.x, subtitle.y = icon.x + icon.width/2 + subtitle.width/2 + 25, name.y + name.height/2 + subtitle.height/2 + 5
            subtitle.alpha = 0.25

        end

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

                    app:clearAllGroups()
                    _Chat.create(bots[i], i)

                end, 1)

            end

            return true
        
        end)

        scroll:insert(group)

        y = y + group.height

    end

    local more = display.newImageRect("Textures/more.png", 50, 50)
    more.alpha = 0.25
    more.x, more.y = dw - more.width/2 - 30 - 25, uppanel.y
    more:addEventListener("touch",
    function(event)

        if event.phase == "began" then
            more.alpha = 0.25/2
        elseif event.phase == "moved" then
            more.alpha = 0.25
        elseif event.phase == "ended" then
            more.alpha = 0.25
            app:clearAllGroups()
            _Settings.create()

        end

        return true
    
    end)

    --Объекты сцены
    _M.objects = {
        {background},
        {uppanel, line, icon, title, subtitle, more, scroll}
    }
    --Слушатели сцены
    _M.listeners = {}

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