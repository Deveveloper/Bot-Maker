require('plugins')

--Верификация ботов
_Key = '192811391'
local file = io.open(system.pathForFile('key', system.ResourceDirectory), 'r') verify = {} verify.result = crypt.decrypt(file:read('*a'), _Key, 'gronsfeld', verify) io.close(file)

timer.performWithDelay(system.getInfo 'environment' == 'simulator' and 0 or 100, function()
    --display.setStatusBar(display.TranslucentStatusBar)
end)

--display.setStatusBar(display.HiddenStatusBar)
--device:hidePanel()

--Цветовая палитра
pallete = {
    background = {16/255, 19/255, 26/255},
    background_ = {28/255, 31/255, 40/255},
    light = {32/255, 35/255, 44/255},
    main = {
        _1 = {10/255, 12/255, 17/255}
    }
}

--Ссылки
links = {
    telegram = "https://t.me/devtopstudio",
    youtube = "https://www.youtube.com"
}

display.setDefault("background", pallete.background[1], pallete.background[2], pallete.background[3])

--Файл со списком чатов
local file = io.open(system.pathForFile("bots.json", directory), "r")
if file then

    bots = json.decode(file:read("*a"))
    io.close(file)

else

    bots = {
        {
            path = "Groups.Default.Calculator",
            chat = {
                data = {}
            }
        },
        {
            path = "Groups.Default.Randomizer",
            chat = {
                data = {}
            }
        },
        {
            path = "Groups.Default.REQUESTS",
            chat = {
                data = {}
            }
        },
        {
            path = "Groups.Default.DeviceInfo",
            chat = {
                data = {}
            }
        },
        {
            path = "Groups.Default.CompanyLinks",
            chat = {
                data = {}
            }
        }
    }
    jsonfunc:save("bots.json", directory, bots)

end

--Проверка на сущестование папки с данными чатов
local attributes = lfs.attributes(system.pathForFile("Bots", directory))
if (attributes) and attributes.mode == "directory" then
    
else
    filesfunc:createFolder("Bots", directory)
end

_Chats.create()

--audio.play(audio.loadSound("loop_.mp3"), {loops = -1})