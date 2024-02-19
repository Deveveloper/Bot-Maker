local _M = {}

_M.get = function()

    return function(BOT, DIALOG, command, bot)

        return function()

            if BOT.get.lastmessage('other').data == '/start' and BOT.get.lastmessage('other').sender == 'user' then
    
                timer.performWithDelay(100, function() BOT.send.message({{text = 'Этот бот предназначен для выполнения математических действий.'}, {text = '\n\n> Чтобы посмотреть все команды: введите /commands'}, {text = '', class = 'image', link = 'https://i.postimg.cc/3xMR4wPT/2.png'}}, 'bot', _M.data().name, {
                    
                }) end, 1)
    
            end
            if BOT.get.lastmessage('other').data == '/commands' and BOT.get.lastmessage('other').sender == 'user' then

                timer.performWithDelay(100, function() BOT.send.message('Посмотреть возможности:\n/show\n\n> Введите математический пример', 'bot', _M.data().name, {
                    
                }) end, 1)

            end
            if BOT.get.lastmessage('other').data == '/show' and BOT.get.lastmessage('other').sender == 'user' then

                timer.performWithDelay(100, function() BOT.send.message({{text = 'math.abs()\nmath.acos()\nmath.asin()\nmath.atan()\nmath.atan2()\nmath.ceil()\nmath.cos()\nmath.cosh()\nmath.deg()\nmath.exp()\nmath.floor()\nmath.fmod()\nmath.frexp()\nmath.ldexp()\nmath.log()\nmath.log10()\nmath.max()\nmath.min()\nmath.modf()\nmath.pi\nmath.pow()\nmath.rad()\nmath.random()\nmath.randomseed()\nmath.round()\nmath.sin()\nmath.sinh()\nmath.sqrt()\nmath.tan()\nmath.tanh()'}, {text = '\nБольше информации...', class = 'link', link = 'https://docs.coronalabs.com/api/library/math'}}, 'bot', _M.data().name, {
                    
                }) end, 1)

            end
            if BOT.get.lastmessage('other').data ~= '/start' and BOT.get.lastmessage('other').data ~= '/commands' and BOT.get.lastmessage('other').data ~= '/show' and BOT.get.lastmessage('other').data ~= '/image' and BOT.get.lastmessage('other').sender == 'user' then

                timer.performWithDelay(100, function() BOT.send.message({{text = 'Результат:\n'}, {text = eval.get(DIALOG.data[#DIALOG.data].data) or 'Ошибка компиляции'}}, 'bot', _M.data().name, {
                    
                }) end, 1)

            end
    
        end
    
    end

end

_M.icon = function()

    return 'Groups/Default/Calculator/icon.png', system.ResourceDirectory

end

_M.data = function()

    return {
        name = "Calculator",
        description = "Бот для выполнения математических действий."
    }

end

return _M