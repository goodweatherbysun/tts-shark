
local module = {}

function module.inspect(...)
    local strings = {}

    for i, arg in ipairs{ ... } do
        strings[i] = JSON.encode(arg)
    end

    print(table.concat(strings, ' '))
end

function module.dumpVector(vector)
    local x = math.round(vector.x, 3)
    local y = math.round(vector.y, 3)
    local z = math.round(vector.z, 3)

    Notes.setNotes('{ x = ' .. x .. ', y = ' .. y .. ', z = ' .. z .. ' }')
end

return module
