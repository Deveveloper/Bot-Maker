local _M = {}

_M.get = function(__M)

    local data = {}

    data["import"] = function()

        --Имя выбранного файла в Documents Directory
        local filename_ = "imported"..func.genID(10, {{65, 90}, {97, 122}, {48, 57}})..".zip"

        --Слушатель
        local zipListener = function(event)

            if event.isError == false then

                --display.newText("", cx, 0, "", 25)

                --Дешифровка lua кода
                local file = io.open(system.pathForFile("dialog.lua", directory), "r")
                local data = {} crypt.decrypt(json.decode(file:read("*a"))[1], _Key, 'gronsfeld', data, true)
                io.close(file)

                --Запись расшифрованных данных в файл
                local file = io.open(system.pathForFile("dialog.lua", directory), "w")
                file:write(data.result)

                --Получение имени бота для создания папки
                local folder = loadstring(data.result)().data().name..func.genID(3, {{65, 90}, {97, 122}, {48, 57}})
                io.close(file)

                --Создание папки с данными бота
                filesfunc:createFolder("Bots/"..folder, directory)

                --Перенос файлов в данную папку
                for i = 1, #event.response do

                    local file_ = io.open(system.pathForFile(event.response[i], directory), "rb")
                    local file = io.open(system.pathForFile("Bots/"..folder.."/"..event.response[i], directory), "wb")
                    if (file) and (file_) then

                        file:write(file_:read("*a"))

                        io.close(file) io.close(file_)

                        os.remove(system.pathForFile(event.response[i], directory))

                    end

                end

                --Добавление бота в список
                table.insert(bots, {
                    path = system.pathForFile("Bots/"..folder, directory),
                    chat = {
                        data = {}
                    }
                })
                jsonfunc:save("bots.json", directory, bots)

                --Удаление лишнего изначально выбранного файла
                os.remove(system.pathForFile(filename_, directory))

                timer.performWithDelay(0, function() app:clearAllGroups() _Chats.create() end, 1)

            end

        end

        if platform == "Win" or env == "simulator" then

            local fpath = tinyfiledialogs.openFileDialog(
                {
                    title = "Select an file",
                    default_path_and_file = os.getenv("USERPROFILE").."/Downloads/",
                    singleFilterDescription = "",
                    allow_multiple_selects = false
                }
            )
            --Проверка выбран ли файл
            if fpath ~= false then

                --Перенос файла в Documents Directory
                local file_ = io.open(fpath, "rb")
                local file = io.open(system.pathForFile(filename_, directory), "wb")
                if (file) and (file_) then

                    file:write(file_:read("*a"))

                    io.close(file) io.close(file_)

                end

                local ext = func.split(fpath, ".")
                ext = ext[#ext]

                if ext ~= "botmaker" then

                    __M.group:insert(message.create("Выберите файл с расширением .botmaker!", "Fonts/Ubuntu/Ubuntu-Light", cx, bottom - 40))

                else

                    local options = { 

                        zipFile = filename_,
                        zipBaseDir = directory,
                        dstBaseDir = directory,
                        files = nil,
                        listener = zipListener

                    }
                    --Запаковка в архив
                    zip.uncompress(options)

                end

            end

        elseif platform == "Android" then

            local fpath, ext = "", ""
            androidFilePicker.show("*/*", system.pathForFile(filename_, directory),
            function(event_)
                
                fpath = event_.filename
                
                local file = io.open(system.pathForFile(filename_, directory), "rb")
                if (file) then

                    local ext = func.split(event_.filename, ".")
                    ext = ext[#ext]
                    
                    if ext ~= "botmaker" then

                        __M.group:insert(message.create("Выберите файл с расширением .botmaker!", "Fonts/Ubuntu/Ubuntu-Light", cx, bottom - 40))
    
                    else
    
                        local options = { 
    
                            zipFile = filename_,
                            zipBaseDir = directory,
                            dstBaseDir = directory,
                            files = nil,
                            listener = zipListener
    
                        }
                        --Запаковка в архив
                        zip.uncompress(options)
    
                    end

                    os.close(file)

                end

            end)

        end

    end
    
    return data

end

return _M