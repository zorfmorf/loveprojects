--[[
Item

An item can be found and examined by the player
--]]


Item = class()


-- begin properties
Item.__name = "Item" -- debugging purposes
Item.name = "Item X"
Item.description = "Infused with herbal essences"
Item.active = false -- items can only be fond if active
Item.image = nil
-- end properties


function Item:__init()
    
end

function Item:activate()
    self.active = true
end
