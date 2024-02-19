local _M = {}

_M.get = function()

    return function(BOT, DIALOG, command, bot)

        return function()
    
            if BOT.get.lastmessage('other').data == '/start' and BOT.get.lastmessage('other').sender == 'user' then
    
                --{text = '', class = 'image', link = 'https://i.postimg.cc/9M9Z9kJ8/1.png'}
                timer.performWithDelay(100, function() BOT.send.message({{text = 'Бот для отправки GET, PUT, POST и DELETE запросов.'}, {text = '\n\n> Чтобы посмотреть все команды: введите /commands'}}, 'bot', _M.data().name, {
                    
                }) end, 1)
    
            end
            if BOT.get.lastmessage('other').data == '/commands' and BOT.get.lastmessage('other').sender == 'user' then
    
                timer.performWithDelay(100, function() BOT.send.message('Запрос по ссылке\n(Методы - GET, PUT, POST, DELETE):\n\nПример: /GET <...>', 'bot', _M.data().name, {
                    
                }) end, 1)
    
            end
            if type(BOT.get.lastmessage('other').data) ~= "table" then

                if utf8.sub(BOT.get.lastmessage('other').data, 1, utf8.len('/GET')) == '/GET' and BOT.get.lastmessage('other').sender == 'user' then
    
                    link = tostring(BOT.get.lastmessage('other').data:gsub('/GET', '')):gsub(' ', '')

                    local send
                    send = function()

                        network.request(link, "GET", 
                        function(event)

                            timer.performWithDelay(100, function() BOT.send.message('Запрос отправлен по ссылке '..link..'\n\nПолучено:\n\n'..event.response.."\n\nСтатус:\n\n"..event.status, 'bot', _M.data().name, {
                                buttons = {{text = 'Еще', click = send, color = {}}}
                            }) end, 1)

                        end)

                    end send()

                end
                if utf8.sub(BOT.get.lastmessage('other').data, 1, utf8.len('/PUT')) == '/PUT' and BOT.get.lastmessage('other').sender == 'user' then
    
                    link = tostring(BOT.get.lastmessage('other').data:gsub('/PUT', '')):gsub(' ', '')

                    local send
                    send = function()

                        network.request(link, "PUT", 
                        function(event)

                            timer.performWithDelay(100, function() BOT.send.message('Запрос отправлен по ссылке '..link..'\n\nПолучено:\n\n'..event.response.."\n\nСтатус:\n\n"..event.status, 'bot', _M.data().name, {
                                buttons = {{text = 'Еще', click = send, color = {}}}
                            }) end, 1)

                        end)

                    end send()

                end
                if utf8.sub(BOT.get.lastmessage('other').data, 1, utf8.len('/POST')) == '/POST' and BOT.get.lastmessage('other').sender == 'user' then
    
                    link = tostring(BOT.get.lastmessage('other').data:gsub('/POST', '')):gsub(' ', '')

                    local send
                    send = function()

                        network.request(link, "POST", 
                        function(event)

                            timer.performWithDelay(100, function() BOT.send.message('Запрос отправлен по ссылке '..link..'\n\nПолучено:\n\n'..event.response.."\n\nСтатус:\n\n"..event.status, 'bot', _M.data().name, {
                                buttons = {{text = 'Еще', click = send, color = {}}}
                            }) end, 1)

                        end)

                    end send()

                end
                if utf8.sub(BOT.get.lastmessage('other').data, 1, utf8.len('/DELETE')) == '/DELETE' and BOT.get.lastmessage('other').sender == 'user' then
    
                    link = tostring(BOT.get.lastmessage('other').data:gsub('/DELETE', '')):gsub(' ', '')

                    local send
                    send = function()

                        network.request(link, "DELETE", 
                        function(event)

                            timer.performWithDelay(100, function() BOT.send.message('Запрос отправлен по ссылке '..link..'\n\nПолучено:\n\n'..event.response.."\n\nСтатус:\n\n"..event.status, 'bot', _M.data().name, {
                                buttons = {{text = 'Еще', click = send, color = {}}}
                            }) end, 1)

                        end)

                    end send()

                end
    
            end
    
        end
    
    end

end

_M.icon = function()

    return 'Groups/Default/REQUESTS/icon.png', system.ResourceDirectory

end

_M.data = function()

    return {
        name = "REQUESTS",
        description = "Бот для отправки интернет запросов."
    }

end

return _M