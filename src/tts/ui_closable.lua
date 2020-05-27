local set = require("shark/util/set")

local UiClosable = {}
UiClosable.__index = UiClosable

function UiClosable:init()
    self.active_player_colors = set.new{}
end

function UiClosable:toggle(player_color)
    if set.contains(self.active_player_colors, player_color) then
        self:close(player_color)
    else
        self:open(player_color)
    end
end

function UiClosable:open(...)
    for _, player_color in ipairs{...} do
        set.add(self.active_player_colors, player_color)
    end

    self:updateVisibility()
end

function UiClosable:close(...)
    for _, player_color in ipairs{...} do
        set.remove(self.active_player_colors, player_color)
    end

    self:updateVisibility()
end

function UiClosable:closeAll()
    self.active_player_colors = set.new{}

    self:updateVisibility()
end

function UiClosable:updateVisibility()
    local visibility_list = table.concat(set.list(self.active_player_colors), '|')

    UI.setAttribute(self.element_id, 'visibility', visibility_list)
    UI.setAttribute(self.element_id, 'active', not set.empty(self.active_player_colors))
end

return UiClosable
