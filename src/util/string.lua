
if not string.starts_with then
    function string.starts_with(str, start)
       return str:sub(1, #start) == start
    end
end
