local list = require("shark/util/list")

local function registerIds(id_lookup, iterator)
    for xml_node in iterator do
        local id = (xml_node.attributes or {}).id

        if id then
            id_lookup[id] = xml_node
        end
    end
end

-- Returns an iterator which iterates through all nodes
local function traverseNode(xml_node)
    local stack = list.new({ { xml_node }, 1 }, list.empty_list())

    return function ()
        -- The idea here is to avoid unnecessary operations. An outer loop might
        -- discontinue an iteration at any moment. However, since this is a
        -- tree, we need a stack to track the iteration's state. The algorithm
        -- below uses a functional list (or singly-linked list) in a way where
        -- we don't push childrens one by one into a new array. Instead we store
        -- the children array directly and track indices.

        while not list.empty(stack) do
            local entry =  list.first(stack)
            local children = entry[1]
            local index = entry[2]

            if index <= #children then
                -- increment index for next iteration
                entry[2] = index + 1

                local node = children[index]
                local node_children = node.children

                if node_children and #node_children > 0 then
                    -- push new children to stack
                    stack = list.new({ node_children, 1 }, stack)
                end

                return children[index]
            else -- all children visited
                -- pop stack
                stack = list.rest(stack)
            end
        end

        -- no more nodes to visit
        return nil
    end
end

local UiDom = {}
UiDom.__index = UiDom

function UiDom.new(xml_table)
    local instance = {
        xml_table = xml_table,
        id_lookup = {},
    }

    setmetatable(instance, UiDom)

    registerIds(instance.id_lookup, instance:traverse())

    return instance
end

function UiDom:getElementById(id)
    return self.id_lookup[id]
end

function UiDom:appendChild(id, child)
    local xml_node = self:getElementById(id)

    if not xml_node then
        error('unknown XML node with ID ' .. id)
        return
    end

    if xml_node.children then
        table.insert(xml_node.children, child)
    else
        xml_node.children = { child }
    end

    registerIds(self.id_lookup, traverseNode(child))
end

function UiDom:traverse()
    local i = 1
    local node_iterator = nil

    return function ()
        while i <= #self.xml_table do
            if node_iterator then
                local node = node_iterator()

                if node then
                    return node
                else
                    -- continue with top level nodes
                    i = i + 1
                    node_iterator = nil
                end
            else
                local top_node = self.xml_table[i]
                node_iterator = traverseNode(top_node)

                return top_node
            end
        end

        return nil
    end
end

return UiDom
