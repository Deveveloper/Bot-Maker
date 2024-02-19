local _M = {}

_M.get = function()

    return function(BOT, DIALOG, command, bot)

        return function()
    
            if BOT.get.lastmessage('other').data == '/start' and BOT.get.lastmessage('other').sender == 'user' then
    
                timer.performWithDelay(100, function() BOT.send.message({{text = 'Этот бот предназначен для выбора случайного варианта из предложенных и для различных игр для рандомного выбора.'}, {text = '\n\n> Чтобы посмотреть все команды: введите /commands'}, {text = '', class = 'image', link = 'https://i.postimg.cc/9M9Z9kJ8/1.png'}}, 'bot', _M.data().name, {
                    
                }) end, 1)
    
            end
            if BOT.get.lastmessage('other').data == '/commands' and BOT.get.lastmessage('other').sender == 'user' then
    
                timer.performWithDelay(100, function() BOT.send.message('Случайное число в выбранном диапазоне:\n/number первое число, второе число\n\nСлучайный вариант из перечня:\n/table первый вариант, второй вариант, ...', 'bot', _M.data().name, {
                    
                }) end, 1)
    
            end
            if type(BOT.get.lastmessage('other').data) ~= "table" then

                if utf8.sub(BOT.get.lastmessage('other').data, 1, utf8.len('/number')) == '/number' and BOT.get.lastmessage('other').sender == 'user' then
    
                    local range = BOT.get.lastmessage('other').data:gsub('/number', '')
                    range = range:gsub(' ', '')
                    range = func.split(range, ',')
                    if #range <= 0 then

                        timer.performWithDelay(100, function() BOT.send.message('Задан пустой диапазон: /number <...>', 'bot', _M.data().name, {
                            
                        }) end, 1)

                    end
                    if tonumber(range[1]) < tonumber(range[2]) then
                        
                        local send
                        send = function()

                            timer.performWithDelay(100, function() BOT.send.message(math.random(tonumber(range[1]), tonumber(range[2])), 'bot', _M.data().name, {
                                buttons = {{text = 'Еще', click = send, color = {}}}
                            }) end, 1)

                        end send()

                    else

                        timer.performWithDelay(100, function() BOT.send.message('Неправильный диапазон:\n\n'..range[1]..'>='..range[2], 'bot', _M.data().name, {
                            
                        }) end, 1)

                    end

                end
                if utf8.sub(BOT.get.lastmessage('other').data, 1, utf8.len('/table')) == '/table' and BOT.get.lastmessage('other').sender == 'user' then
    
                    local list = BOT.get.lastmessage('other').data:gsub('/table', '')
                    list = list:gsub(', ', ',')
                    list = func.split(list, ',')
                    if #list > 0 then
    
                        local send
                        send = function()
    
                            timer.performWithDelay(100, function() BOT.send.message(list[math.random(1, #list)], 'bot', _M.data().name, {
                                buttons = {{text = 'Еще', click = send, color = {}}}
                            }) end, 1)
    
                        end send()
    
                    else
    
                        timer.performWithDelay(100, function() BOT.send.message('Задан пустой диапазон: /table <...>', 'bot', _M.data().name, {
                            
                        }) end, 1)
    
                    end
        
                end
    
            end
    
        end
    
    end

end

_M.icon = function()

    return 'Groups/Default/Randomizer/icon.png', system.ResourceDirectory

end

_M.data = function()

    return {
        name = "Randomizer",
        description = "Бот для выбора случайного варианта."
    }

end

return _M