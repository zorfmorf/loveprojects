-- the logicHandler is tasked with updating the various game assets, 
-- calculating collisions, etc


-- update possions of all objects
function logicHandler_updateObjects(dt)
    for i,o in pairs(entities) do
        o:update(dt)
    end
end


-- check for collisions
function logicHandler_checkCollisions()

end
