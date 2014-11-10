
local font = love.graphics.newFont("font/SFPixelate.ttf", 25)

hudDrawer = {}

function hudDrawer.draw()
    
    -- now draw the hud
    love.graphics.origin()
    love.graphics.setColor(255, 255, 255, 255)
    
    local x, y = love.mouse.getPosition()
    
    if showHelp then
        loadScreen_draw()
    else 
        
        love.graphics.setFont(font)

        if mouseState ~= "free" then
            
            local msg = "Left click to place building \n Right click to abort"
            love.graphics.print(msg, love.graphics.getWidth() / 2, 100, 0, 1, 1, font:getWidth(msg) / 2)
            love.graphics.draw(tileset[mouseState], love.mouse.getX(), love.mouse.getY(), 0, 1, 1, tilesize / 2, tilesize / 2)
        
        else
        
            love.graphics.print("F1: Help", love.graphics.getWidth() - tilesize - 250, 10)
        
            -- ressource display
            local sh = 10
            if #availableRessources["log"] > 0 then        
                love.graphics.draw(tileset["log"], love.graphics.getWidth() - tilesize - 5, sh)
                love.graphics.print(#availableRessources["log"], love.graphics.getWidth() - tilesize - 40, sh + tilesize / 3)
                sh = sh + 40
            end
            if #availableRessources["planks"] > 0 then        
                love.graphics.draw(tileset["planks"], love.graphics.getWidth() - tilesize - 5, sh)
                love.graphics.print(#availableRessources["planks"], love.graphics.getWidth() - tilesize - 40, sh + tilesize / 3)
                sh = sh + 40
            end
            if #availableRessources["stone"] > 0 then        
                love.graphics.draw(tileset["stone"], love.graphics.getWidth() - tilesize - 5, sh)
                love.graphics.print(#availableRessources["stone"], love.graphics.getWidth() - tilesize - 40, sh + tilesize / 3)
                sh = sh + 40
            end
            if #availableRessources["iron"] > 0 then        
                love.graphics.draw(tileset["iron"], love.graphics.getWidth() - tilesize - 5, sh)
                love.graphics.print(#availableRessources["iron"], love.graphics.getWidth() - tilesize - 40, sh + tilesize / 3)
                sh = sh + 40
            end
            if #availableRessources["gold"] > 0 then        
                love.graphics.draw(tileset["gold"], love.graphics.getWidth() - tilesize - 5, sh)
                love.graphics.print(#availableRessources["gold"], love.graphics.getWidth() - tilesize - 40, sh + tilesize / 3)
                sh = sh + 40
            end
            
            
            -- scale arrows
            if not gameHandler.isLowestLevel() then
                love.graphics.setColor(255, 255, 255, 255)
                local sc = 1
                if math.abs(x - (love.graphics.getWidth() - tilesize - 5)) < tilesize / 1.5 and 
                    math.abs(y - (love.graphics.getHeight() - tilesize * 8)) < tilesize / 1.5 then
                    
                    sc = 1.5
                end
                
                love.graphics.draw(tileset["arrow_down"], love.graphics.getWidth() - tilesize - 5, love.graphics.getHeight() - tilesize * 8, 0, 
                                sc, sc, tilesize / 2, tilesize / 2)
            end
            if not gameHandler.isHighestLevel() then
                love.graphics.setColor(255, 255, 255, 255)
                local sc = 1
                if math.abs(x - (love.graphics.getWidth() - tilesize - 5)) < tilesize / 1.5 and 
                    math.abs(y - (love.graphics.getHeight() - tilesize * 10 - 5)) < tilesize / 1.5 then
                    
                    sc = 1.5
                end
                love.graphics.draw(tileset["arrow_up"], love.graphics.getWidth() - tilesize - 5, love.graphics.getHeight() - tilesize * 10 - 5, 0,
                                    sc, sc, tilesize / 2, tilesize / 2)
            end
            
            --build panel
            sh = 10
            for i,build in pairs(buildings) do
                
                love.graphics.setColor(255, 255, 255, 255)
                
                -- disable if necessary
                if currentLayer < #world.layers then 
                    love.graphics.setColor(100, 100, 100, 150)
                else
                    if math.abs((love.graphics.getWidth() - tilesize - 10) - (x - tilesize / 2)) < tilesize / 2 and
                       math.abs((love.graphics.getHeight() - tilesize * 1.5 - sh) - (y - tilesize / 2)) < tilesize / 2 then
                        love.graphics.setColor(230, 130, 130, 150)
                        
                        -- bad style but we will use this place to handle clicks as we already know everything relevant
                        if love.mouse.isDown( "l" ) then gameHandler.buildIconClicked(build) end
                    end
                end
                
                love.graphics.draw(tileset[build], love.graphics.getWidth() - tilesize - 10, love.graphics.getHeight() - tilesize * 1.5 - sh)
                sh = sh + 40
                
            end
            
            -- draw scheduled task
            local shift = 1
            for i,task in pairs(tasklist) do
                
                if task.target:is(Ressource) then
                
                    local xpos = 10 + (shift - 1) * (tilesize + 10) 
                    love.graphics.draw(tileset[task.target.image], xpos, 10)
                            
                    if y > 10 and y <= 10 + tilesize and x > xpos and x <= xpos + tilesize then
                        love.graphics.draw(tileset["x"], xpos, 10)
                        if love.mouse.isDown("l") then gameHandler.taskClicked(i) end
                    end
                    
                    shift = shift + 1
                end
                
            end 
        end
    end

end