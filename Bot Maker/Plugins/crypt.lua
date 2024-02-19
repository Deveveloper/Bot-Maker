local _M = {}

local code = {}

--Шифр Цезаря
code['cesar'] = function(text, shift, mode, v)

    local output = ""

    if mode == "encrypt" then

        count = 1

    elseif mode == "decrypt" then

        count = -1

    end

    --Анализ
    local i = 1
    local c, c_
    if #text > 1024 then
        c = 1024
        c_ = math.round(#text/1024) + 10
    else
        c = #text
        c_ = 1
    end
    timer.performWithDelay(1,
    function()

        for j = 1, c do

            --Смещение, замена символа
            local char = string.byte(text, i)
            char = (char + count*shift)%256
            local nchar = char
            output = output..string.char(nchar)

            v["progress"] = {i, #text}

            if i >= #text then v["result"] = output else i = i + 1 end
    
        end
    
    end, c_)

end

--Шифр Гронсфельда
code['gronsfeld'] = function(text, shift, mode, v, fast)

    local output = ""

    if mode == "encrypt" then

        count = -1

    elseif mode == "decrypt" then

        count = 1

    end

    --Создание таблицы из ключа
    local shift_ = tostring(shift)
    shift_ = shift_:gsub("", ".")
    shift_ = func.split(shift_, ".")

    --Анализ
    local i = 1
    local key = 1
    local c, c_
    if #text > 1024 then
        c = 1024
        c_ = math.round(#text/1024) + 10
    else
        c = #text
        c_ = 1
    end
    if fast == nil or fast == false then

        timer.performWithDelay(1,
        function()

            for j = 1, c do

                --Смещение, замена символа
                local char = string.byte(text, i)
                char = (char + count*tonumber(shift_[key]))%256
                local nchar = char
                if i < #text + 1 then output = output..string.char(nchar) else  end

                if key < #shift_ then key = key + 1 else key = 1 end

                v["progress"] = {i, #text}

                if i >= #text then v["result"] = output break else i = i + 1 end

            end
        
        end, c_)

    elseif fast == true then

        for j = 1, #text do

            --Смещение, замена символа
            local char = string.byte(text, i)
            char = (char + count*tonumber(shift_[key]))%256
            local nchar = char
            if i < #text + 1 then output = output..string.char(nchar) else  end

            if key < #shift_ then key = key + 1 else key = 1 end

            if i >= #text then v["result"] = output break else i = i + 1 end

        end
        v["result"] = output

    end

end

--Шифр смещения битов
code['bits'] = function(text, shift, mode, v)

    local output = ""

    --Создание таблицы-ключа из строки
    shift = tostring(shift)
    shift = shift:gsub("", ".") shift = func.split(shift, ".")

    --Перевод данных в двоичный код
    local value_ = func.binary(text)
    local value = value_:gsub("", ".") value = func.split(value, ".")

    local new = {}
    local count = 1
    local i = 1
    --Анализ
    timer.performWithDelay(1,
    function()

        for b = 1, 8 do

            --Разбивание на байт (8 бит)
            local current = value_:sub(i, 8*count)
            current = current:gsub("", ".") current = func.split(current, ".")

            --Замена битов
            for j = 1, #current do

                if mode == "encrypt" then

                    new[j] = current[tonumber(shift[j])]

                elseif mode == "decrypt" then

                    new[tonumber(shift[j])] = current[j]

                end

            end

            --Соединение в единый текст
            for j = 1, #new do

                output = output..new[j]
                
            end
            new = {}

            if i >= #value and v["result"] == nil then output = func.char(output) v["result"] = output else i = i + 8 count = count + 1 end
            v["progress"] = {i, #value}

        end

    end, math.round(#value/(8*8)) + 1)

end

--Шифр Виженера
code['vigener'] = function(text, shift, mode)

    local output = ""

    if mode == "encrypt" then

        m = text
        k = shift

        k = k:rep(math.ceil(#m/#k))
        c = ""
        for i = 1, #m do
            local j = m:sub(i, i)
            local char = string.char((string.byte(j) + string.byte(k:sub(i, i)) - 2*string.byte('A'))%26 + string.byte('A'))
            c = c..char
        end

        output = c

    elseif mode == "decrypt" then

        c = text
        k = shift

        k = k:rep(math.ceil(#c/#k))
        m = ""
        for i = 1, #c do
            local j = c:sub(i, i)
            local char = string.char((string.byte(j) - string.byte(k:sub(i, i)) + 26)%26 + string.byte('A'))
            m = m..char
        end

        output = m

    end
    
    return output

end

local crypt = function(text, shift, mode, crypt_, v, fast)

    return code[crypt_](text, shift, mode, v, fast)

end

_M.encrypt = function(text, shift, crypt_, v, fast)

    return crypt(text, shift, "encrypt", crypt_, v, fast)

end

_M.decrypt = function(text, shift, crypt_, v, fast)

    return crypt(text, shift, "decrypt", crypt_, v, fast)

end

return _M