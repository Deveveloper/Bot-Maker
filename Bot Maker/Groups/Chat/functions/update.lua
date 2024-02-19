local _M = {}

_M.get = function(data)

    return function(__M)

        if _scroll then display.remove(__M.scroll) end
        
        __M.scroll, background = data["messages"](__M, data["DIALOG"].data)

        if __M.scroll.height_ > dacth - 290 then

            __M.scroll.isVisible = false
            __M.scroll:scrollTo("bottom", {time = 100,
            onComplete = function()

                __M.scroll.isVisible = true
            
            end})

        end
        
        __M.group:insert(__M.scroll) __M.group:insert(background)
        __M.scroll:toBack()

    end

end

return _M