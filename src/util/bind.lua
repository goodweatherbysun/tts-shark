local function bind(func, context)
    return function (...)
        return func(context, table.unpack{ ... })
    end
end

return bind
