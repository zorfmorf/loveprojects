--[[
Conversation

A conversation belongs to an actor (or possibly item, e.g. phone)

A conversation node consists of a text and a list of choices (minlen = 1)

A choice can either lead to another node or end the conversation
--]]


CNode = class()


-- begin properties
CNode.__name = "CNode" -- debugging purposes
CNode.text = "Sample text"
CNode.hint = nil -- hint to be activated on reaching this state
CNode.choices = {} -- list of choices
-- end properties


function CNode:__init(hint)
    if hint ~= nil then
        self.hint = hint
    end
end


Choice = class()


-- begin properties
Choice.__name = "Choice" -- debugging purposes
Choice.text = "Sample Choice"
Choice.req = nil -- requirement. nil means none
Choice.target = "Sample end" -- string for end or cnode
-- end properties