local _M = {}

_M.create = function(bot, id)

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

    --Данные бота
    bot.id = id
    _M.bot = bot

    local strokeWidth = 1.5
    if platform == "Win" or env == "simulator" then

        strokeWidth = 3

    end

    local data = require('Groups.Chat.data').get(_M)

    --Данные бота, функция для запуска кода исходных файлов бота, разделитель для пути к файлу
    local command, f, s
    if pcall(function() require(bot.path..'.dialog') end) == false then
        
        --Возвращает код, запущенный с помощью loadstring() из папки Documents Directory
        f, s = function(_) local file = io.open(bot.path.."/".._..".lua", "r") if file then return loadstring(file:read("*a"))() end end, "/"

    else

        --Возвращает код, запущенный с помощью require() из папки Resources Directory
        f, s = function(_) return require(bot.path..".".._) end, "."

    end

    command = f('dialog')

    local icon_, dir = command.icon()

    if dir == directory then

        local len = utf8.len(system.pathForFile("", directory))
        icon_ = (bot.path):sub(len + 2, utf8.len(bot.path)).."/"..icon_

    end

    local frame = display.newRoundedRect(cx, cy, 100, 100, 100/3)
    frame.fill = {type = "image", filename = icon_ or "Textures/unknown.png", baseDir = dir}
    frame.x, frame.y = frame.width/2 + 25, originY + frame.height/2 + 30

    local title = display.newText(command.data().name, 0, 0, "Fonts/Ubuntu/Ubuntu-Regular", 32.5)
    title.x, title.y = frame.x + frame.width/2 + title.width/2 + 25, frame.y - frame.height/2 + title.height/2 + 10

    local subtitle = display.newText(command.data().description, 0, 0, "Fonts/Ubuntu/Ubuntu-Light", 25)
    subtitle.x, subtitle.y = frame.x + frame.width/2 + subtitle.width/2 + 25, title.y + title.height/2 + subtitle.height/2 + 5
    subtitle.alpha = 0.5

    --Галочка
    local verified = display.newImageRect("Textures/verified_.png", 22.5, 22.5)
    verified.x, verified.y = title.x + title.width/2 + verified.width/2 + 10, title.y + 3
    verified.alpha = 0.25

    --Проверка: верифицирован ли бот
    timer.performWithDelay(10, function() if verify.result ~= f('verify') then

        verified.alpha = 0

    end end, 1)

    local line = display.newRoundedRect(cx, 0, dw - 60, strokeWidth, strokeWidth)
    line.alpha = 0.25/2
    line.y = frame.y + frame.height/2 + line.height/2 + 25

    local field = display.newGroup()

    field.frame = display.newRoundedRect(cx, 0, dw, 85, 0) field:insert(field.frame)
    field.frame:setFillColor(pallete.background[1] + 0.025, pallete.background[2] + 0.025, pallete.background[3] + 0.025)
    field.frame.x, field.frame.y = cx, bottom - field.frame.height/2
    field.frame:addEventListener("touch",
    function(event)

        if event.phase == "ended" then

            data["enter"](_M, field.hint)

        end

        return true
    
    end)

    field.hint = display.newText({text = "Введите ваше сообщение здесь...", font = "Fonts/Ubuntu/Ubuntu-Light", fontSize = 27, width = field.frame.width - 45, height = 32}) field:insert(field.hint)
    field.hint.x, field.hint.y = field.hint.width/2 + 50, field.frame.y 
    field.hint.alpha = 0.25
    field.hint.data = ""

    local send = display.newImageRect("Textures/send.png", 35, 35)
    send.x, send.y = dw - 85/2, field.frame.y
    send.x_ = send.x
    send.alpha = 0.25

    send.frame = display.newRoundedRect(send.x, send.y, 85, 85, 0)
    send.frame:setFillColor(pallete.background[1] + 0.025, pallete.background[2] + 0.025, pallete.background[3] + 0.025)

    send.frame:addEventListener("touch", data["sendclick"](_M, send, field.hint))

    local line_ = display.newRoundedRect(cx, field.frame.y + field.frame.height/2 + 35, 200, strokeWidth, strokeWidth)
    line_.alpha = 0

    data["update"](_M)

    local tap = function(event)

        native.setKeyboardFocus(nil)

        return true
    
    end
    Runtime:addEventListener("touch", tap)

    --Объекты сцены
    _M.objects = {
        {frame, title, subtitle, verified},
        {line},
        {field, send.frame, send, line_}
    }
    --Слушатели сцены
    _M.listeners = {{Runtime, ekey, "key"}, {Runtime, tap, "touch"}}

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