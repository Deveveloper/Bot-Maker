local _M = {}

_M.get = function()

    return function(BOT, DIALOG, command, bot)

        return function()

            if BOT.get.lastmessage('other').data == '/start' and BOT.get.lastmessage('other').sender == 'user' then
    
                timer.performWithDelay(100, function() BOT.send.message({{text = 'Этот бот предназначен для получения информации об вашем устройстве.'}, {text = '\n\n> Чтобы посмотреть все команды: введите /commands'}, {text = '', class = 'image', link = 'https://i.postimg.cc/W1S73Rw9/image.png'}}, 'bot', _M.data().name, {
                    
                }) end, 1)
    
            end
            if BOT.get.lastmessage('other').data == '/commands' and BOT.get.lastmessage('other').sender == 'user' then
    
                timer.performWithDelay(100, function() BOT.send.message('Получить доступную информацию:\n/got_all_info', 'bot', _M.data().name, {
                    
                }) end, 1)
    
            end
            if BOT.get.lastmessage('other').data == '/got_all_info' and BOT.get.lastmessage('other').sender == 'user' then

                local devices = system.getInputDevices()
                local d = {{text = "Подключенные устройства:\n\n", class = "bold"}}
 
                if (#devices > 0) then

                    for i = 1, #devices do

                        table.insert(d, {text = devices[i].displayName})
                        
                    end

                end
    
                local output = {{text = "ⓘ Информация.\n\n", class = "bold"}}
                local t = {
                    {"Платформа", system.getInfo("platformName")},
                    {"Архитектура", system.getInfo("architectureInfo")},
                    {"Модель", system.getInfo("model")..", "..system.getInfo("manufacturer")..", "..system.getInfo("name")..", Версия "..system.getInfo("platformVersion")},
                    {"Device ID", system.getInfo("deviceID")}
                }
                for i = 1, #t do

                    table.insert(output, {text = t[i][1]..":", class = "bold"})
                    table.insert(output, {text = "> "..t[i][2].."\n\n"})

                end
                for i = 1, #d do table.insert(output, d[i]) end
                timer.performWithDelay(100, function() BOT.send.message(output, 'bot', _M.data().name, {
                    
                }) end, 1)
    
            end
    
        end
    
    end

end

_M.icon = function()

    return 'Groups/Default/DeviceInfo/icon.png', system.ResourcesDirectory

end

_M.data = function()

    return {
        name = "DeviceInfo",
        description = "Бот для получения информации об устройстве."
    }

end

return _M