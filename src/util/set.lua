local set = {}

function set.new(list)
    local instance = {}

    for _, value in ipairs(list) do
        instance[value] = true
    end

    return instance
end

function set.add(instance, item)
    instance[item] = true
end

function set.remove(instance, item)
    instance[item] = nil
end

function set.contains(instance, item)
    return instance[item] ~= nil
end

function set.empty(instance, item)
    return next(instance, nil) == nil
end

function set.list(instance)
    local list = {}

    local i = 0
    for item in set.each(instance) do
        i = i + 1
        list[i] = item
    end

    return list
end

function set.iterator(instance, last_item)
    local item, _ = next(instance, last_item)
    return item
end

function set.each(instance)
    return set.iterator, instance, nil
end

return set
