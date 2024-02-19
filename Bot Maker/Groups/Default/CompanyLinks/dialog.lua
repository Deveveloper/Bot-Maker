local _M = {}

_M.get = function()

    return function(BOT, DIALOG, command, bot)

        return function()

            if BOT.get.lastmessage('other').data == '/start' and BOT.get.lastmessage('other').sender == 'user' then
    
                timer.performWithDelay(100, function() BOT.send.message({{text = 'DevTop Studio'}, {text = '\n\n> Чтобы посмотреть информацию о компании: введите /telegram или /projects'}, {text = '', class = 'image', link = 'https://tweshot.ru/icons/icon.png'}}, 'bot', _M.data().name, {
                    
                }) end, 1)
    
            end
            if BOT.get.lastmessage('other').data == '/telegram' and BOT.get.lastmessage('other').sender == 'user' then

                timer.performWithDelay(100, function() BOT.send.message({{text = '\nНаш Телеграм', class = 'link', link = 'https://t.me/devtopstudio'}}, 'bot', _M.data().name, {
                    
                }) end, 1)

            end
            if BOT.get.lastmessage('other').data == '/projects' and BOT.get.lastmessage('other').sender == 'user' then

                timer.performWithDelay(100, function() BOT.send.message({{text = '\nНаши проекты', class = 'link', link = 'https://apps.rustore.ru/developer/1c64af2e'}}, 'bot', _M.data().name, {
                    
                }) end, 1)
                end
    
        end
    
    end

end

_M.icon = function()

    return 'icon.png'

end

_M.data = function()

    return {
        name = "CompanyLinka",
        description = "Ссылки на проекты DevTop Studio"
    }

end

return _M