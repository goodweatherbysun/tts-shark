local list = {}

function list.empty_list()
    return nil
end

function list.new(first, rest)
    return { first, rest }
end

function list.first(instance)
    return instance[1]
end

function list.rest(instance)
    return instance[2]
end

function list.empty(instance)
    return instance == list.empty_list()
end

return list
