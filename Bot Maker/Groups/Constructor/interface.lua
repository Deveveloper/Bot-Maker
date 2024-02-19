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

    blocksclasses = {

        events = {

            OnStart = {
                
                title = "При старте",
                color = {162, 107, 243},
                types = {"end"}

            }
            
        },
        bot = {

            SendMessage = {

                title = "Отправить сообщение",
                color = {55, 155, 118},
                types = {"began", "end"},
                type = "get_text",
                params = {
                    {text = "Текст", data = "Ваше сообщение..."}
                }

            }

        }

    }

    local data = require('Groups.Constructor.data').get(_M)

    --Задний фон
    local background = display.newRect(cx, cy, dw, dacth)
    background.fill = {
        type = "gradient",
        color1 = {pallete.background_[1], pallete.background_[2], pallete.background_[3]},
        color2 = {pallete.background[1], pallete.background[2], pallete.background[3]},
        direction = "right"
    }

    local blocks = {
        {
            class = "events",
            name = "OnStart"
        },
        {
            class = "bot",
            name = "SendMessage"
        },
    }

    local block1 = data["BLOCK"].create(cx, cy, {
        id = 1,
        width = 300,
        height = 120,
        data = blocks[1]
    })

    local block2 = data["BLOCK"].create(cx, cy + 300, {
        id = 1,
        width = 300,
        height = 300,
        data = blocks[2]
    })

    --Объекты сцены
    _M.objects = {
        {background},
        {data["groups"].lines},
        {data["groups"].blocks}
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