--[[
Actor

An actor can be interacted with at an location. 
In addition, actors appear on the evidence board

If the conversation is a string, it represents a one sentence response
when trying to talk to this actor ("Leave me alone!")
If it is a cnode object, talking to this actor starts a conversation
--]]


Actor = class()


-- begin properties
Actor.__name = "Actor" -- debugging purposes
Actor.title = "" -- e.g. Duke, Sir, Commissioner
Actor.firstname = "Jon"
Actor.lastname = "Doe"
Actor.image = nil
Actor.description = "Short summary of actors role in case"
Actor.active = false -- Actor will only appear to player if active
Actor.conversation = nil -- CNode object or a string
-- end properties

function Actor:activate()
    self.active = true
end
