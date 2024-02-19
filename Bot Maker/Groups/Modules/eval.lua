local _M = {}

_M.get = function(value)
    
    local mathenv = {
        math = math,
        tonumber = tonumber
    }
    
    local go = function()

        local chunk, errorMessage = loadstring("return "..value)
        if chunk then

            setfenv(chunk, mathenv)

            local success, result = pcall(chunk)

            if success then

                return result

            else

                return "Ошибка выполнения выражения: "..result

            end

        else

            return "Ошибка компиляции выражения: "..errorMessage

        end

    end
    
    local result, err = go()

    return result

end

return _M