
local module = {}

if not math.round then
    function math.round(number, digits)
        if not digits or digits == 0 then
            return math.floor(number + 0.5)
        else
            local shift_factor = 10^digits
            return math.floor(shift_factor * number + 0.5) / shift_factor
        end
    end
end

if not table.collect then
    function table.collect(list, member_or_func, from, to)
        local result = {}

        if type(member_or_func) == 'function' then
            for i, item in module.ipairs_slice(list, from, to) do
                table.insert(result, member_or_func(item, i))
            end
        else
            for _, item in module.ipairs_slice(list, from, to) do
                table.insert(result, item[member_or_func])
            end
        end

        return result
    end
end

if not table.move then
    -- from https://github.com/Validark/Lua-table-functions

    -- MIT License
    --
    -- Copyright (c) 2018 Validark
    --
    -- Permission is hereby granted, free of charge, to any person obtaining a copy
    -- of this software and associated documentation files (the "Software"), to deal
    -- in the Software without restriction, including without limitation the rights
    -- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    -- copies of the Software, and to permit persons to whom the Software is
    -- furnished to do so, subject to the following conditions:
    --
    -- The above copyright notice and this permission notice shall be included in all
    -- copies or substantial portions of the Software.
    --
    -- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    -- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    -- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    -- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    -- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    -- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
    -- SOFTWARE.

    function table.move(a1, f, e, t, a2)
    	a2 = a2 or a1
    	t = t + e

    	for i = e, f, -1 do
    		t = t - 1
    		a2[t] = a1[i]
    	end

    	return a2
    end
end

if not table.append then
    function table.append(list, other_list)
        return table.move(other_list, 1, #other_list, #list + 1, list)
    end
end

if not table.values then
    function table.values(list)
        local values = {}

        for _, value in pairs(list) do
            table.insert(values, value)
        end

        return values
    end
end

local function ipairs_iterator(state, last_index)
    if last_index >= state.to then
        return
    end

    local current_index = last_index + 1
    local value = state.list[current_index]

    if value then
        return current_index, value
    end
end

function module.ipairs_slice(list, from, to)
    if not from or from < 1 then
        from = 1
    end

    if not to then
        to = #list
    end

    if from == 1 and to == #list then
        return ipairs(list)
    end

    state = { list = list, to = to }

    return ipairs_iterator, state, from - 1
end

function module.equal(lhs, rhs)
    if lhs == rhs then
        return true
    end

    if type(lhs) ~= type(rhs) then
        return false
    end

    if type(lhs) == 'table' and #lhs == #rhs then
        for key, value in pairs(lhs) do
            if not module.equal(value, rhs[key]) then
                return false
            end
        end

        return true
    end

    return false
end

function module.separate_thousands(number)
    local MIN_LENGTH = 5
    local GROUP_LENGTH = 3
    local GROUP_SEPARATOR = ','

    local number_string = tostring(number)
    local length = string.len(number_string)

    if length < MIN_LENGTH then
        return number_string
    end

    local groups = {}
    local number_of_groups = math.ceil(length / GROUP_LENGTH)
    local offset = (-length) % GROUP_LENGTH

    for i = 1, number_of_groups do
        local first_index = (i - 1) * GROUP_LENGTH + 1 - offset
        local last_index = first_index + GROUP_LENGTH - 1

        local substring = string.sub(number_string, math.max(1, first_index), last_index)

        table.insert(groups, substring)
    end

    return table.concat(groups, GROUP_SEPARATOR)
end

local ORDINAL_SUFFIXES = {
    [0] = 'th',
    [1] = 'st',
    [2] = 'nd',
    [3] = 'rd',
    [4] = 'th',
}

function module.format_ordinal(number)
    local suffix_index = math.min(#ORDINAL_SUFFIXES, number % 10)
    local suffix = ORDINAL_SUFFIXES[suffix_index]

    return tostring(number)..suffix
end

local DEGREES_PER_RADIAN = 180 / math.pi

function module.rad2deg(number)
    return number * DEGREES_PER_RADIAN
end

function module.between(number, min, max)
    return number >= min and number < max
end

return module
