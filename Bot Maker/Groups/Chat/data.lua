local _M = {}

_M.get = function(__M)

    local data = {}

    --Данные бота, функция для запуска кода исходных файлов бота, разделитель для пути к файлу
    local command, f, s
    if pcall(function() require(__M.bot.path..'.dialog') end) == false then
        
        --Возвращает код, запущенный с помощью loadstring() из папки Documents Directory
        f, s = function(_) local file = io.open(__M.bot.path.."/".._..".lua", "r") return loadstring(file:read("*a"))() end, "/"

    else

        --Возвращает код, запущенный с помощью require() из папки Resources Directory
        f, s = function(_) return require(__M.bot.path..".".._) end, "."

    end

    command = f('dialog')

    --Позиция последнего сообщения
    data["message.y"] = 0

    --Визуализация загруженных сообщений
    data["messages"] = require('Groups.Chat.functions.messages').get(data)

    --Отображение сообщения
    data["newmessage"] = require('Groups.Chat.functions.newmessage').get(data, command)

    --Обновление скролла
    data["update"] = require('Groups.Chat.functions.update').get(data)

    --Нажатие на кнопку "Отправить"
    data["sendclick"] = require('Groups.Chat.functions.sendclick').get(data)

    --Нажатие на поле ввода сообщения
    data["enter"] = require('Groups.Chat.functions.enter').get(__M)

    data["bot"] = {
        data = __M.bot,
        update = data["newmessage"],
        _M = __M
    }

    --Подключение функций диалога
    data["DIALOG"], data["BOT"] = require('Groups.Chat.functions.dialog').get(data["bot"])

    --[[network.download("https://i.postimg.cc/2Sp2pY2L/image.png", "GET", 
    function(event)

        print(json.encode(event))
        
    end, "helloCopy.png", directory)--]]
    
    return data

end

return _M