local _M = {}

_M.get = function(bot)

    local test = function(f)

        pcall(f)

    end

    --Чат
    local DIALOG = {}

    --Данные чата
    DIALOG.data = {

    }
    if bots[bot.data.id].chat.data then DIALOG.data = bots[bot.data.id].chat.data end

    --Сохранение данных чата
    DIALOG.save = function()

        bots[bot.data.id].chat.data = DIALOG.data
        jsonfunc:save("bots.json", directory, bots)

    end

    --Отображение сообщения от бота в чате
    DIALOG.update = function()

        bot.update(DIALOG.data, #DIALOG.data, bot._M.scroll)

    end

    --Данные бота
    local BOT = {}

    --Получение ошибки
    BOT.error = function(class, data)

        if class == "text" then

            return {text = "ERROR: "..data}

        end

    end

    --Отделы функций бота
    BOT.send = {}
    BOT.get = {}

    --Отправка сообщения
    BOT.send.message = function(data, sender, name, _)

        table.insert(DIALOG.data, {
            time = os.date("*t"),
            class = "text",
            sender = sender,
            name = name,
            data = data,
            buttons = _.buttons
        })
        if sender == "bot" then DIALOG.update() end
        --Отправка команды на событие
        command.message()
        --Сохранение чата
        DIALOG.save()

    end

    --Получение последнего сообщения от пользователя
    BOT.get.lastmessage = function(class)

        local value = {}
        if class == "user" then

            for id = #DIALOG.data, 1, -1 do

                if DIALOG.data[id].sender == "bot" then

                    if id <= 1 then value.result = BOT.error('text', 'Сообщений от пользователя не найдено.').text break end

                elseif DIALOG.data[id].sender == "user" then

                    value.result = DIALOG.data[id]

                    break

                end

            end

        elseif class == "bot" then

            for id = #DIALOG.data, 1, -1 do

                if DIALOG.data[id].sender == "user" then

                    if id <= 1 then value.result = BOT.error('text', 'Сообщений от бота не найдено.').text break end

                elseif DIALOG.data[id].sender == "bot" then

                    value.result = DIALOG.data[id]

                    break

                end

            end

        elseif class == "other" then
            
            value.result = DIALOG.data[#DIALOG.data]

        end

        return value.result

    end

    --Параметры программы бота
    command = {
        
    }

    --Подключение исходного кода бота

    --Данные бота, функция для запуска кода исходных файлов бота, разделитель для пути к файлу
    local f, s
    if pcall(function() require(bot.data.path..'.dialog') end) == false then
        
        --Возвращает код, запущенный с помощью loadstring() из папки Documents Directory
        f, s = function(_) local file = io.open(bot.data.path.."/".._..".lua", "r") if file then return loadstring(file:read("*a"))() end end, "/"

    else

        --Возвращает код, запущенный с помощью require() из папки Resources Directory
        f, s = function(_) return require(bot.data.path..".".._) end, "."

    end

    command.go = f('dialog').get()
    command.message = command.go(BOT, DIALOG, command, bot.data)

    --Отправка /start
    if #DIALOG.data <= 0 then

        timer.performWithDelay(1000, function() BOT.send.message('/start', 'user', 'Вы', {

        }) DIALOG.update() end, 1)

    end

    --[[network.request("GET", "",
    function(event)

        print(json.encode(event))
    
    end)--]]

    return DIALOG, BOT

end

return _M