require "node"

nodeamount = 10 -- can never be < 3
noderotate = math.pi / 32

xshift= love.graphics.getWidth() / 2
yshift = love.graphics.getHeight() / 2

-- rotate node1 around node2 by the given angle (in radians)
function rotateNode(node1, node2, angle)
    
    local c = math.cos(angle)
    local s = math.sin(angle)
    
    --translate to origin
    local x = node2.x - node1.x
    local y = node2.y - node1.y
    
    local xn = x * c - y * s
    local yn = x * s + y * c
    
    xn = xn + node1.x
    yn = yn + node1.y
    
    node2.x = xn
    node2.y = yn
end

function love.load()
    
    math.randomseed(os.time())
    
    nodes = {}
    nodesNew = {}
    
    -- first generate a couple of random circles
    for i = 1,nodeamount do 
        local node  = Node:new()
        node.id = i -- so we can recreate the order later
        node.radius = math.random(5, 150)
        node.x = 1000
        node.y = 1000
        nodes[i] = node
    end
    
    -- sort by radius
    table.sort(nodes,
            function(x,y)
                return x.radius > y.radius
            end
        )
    
    -- now try to position them correctly
    -- lets start with the first three, its easy for them
    
    -- first one in center of screen
    nodes[1].x = 0
    nodes[1].y = 0
    nodesNew[1] = nodes[1]
    
    --second one is to the right
    nodes[2].x = nodes[1].x + nodes[1].radius + nodes[2].radius
    nodes[2].y = nodes[1].y
    nodesNew[2] = nodes[2]
    
    -- calculate angle between node[1] and node[3]
    local b = nodes[1].radius + nodes[3].radius
    local c = nodes[1].radius + nodes[2].radius
    local a = nodes[2].radius + nodes[3].radius
    local angle = math.acos((b * b + c * c - a * a) / (2 * b * c))
    
    -- now assume node[3] is at node[2]'s position and rotate it around node[1]
    nodes[3].x = nodes[1].x + nodes[1].radius + nodes[3].radius
    nodes[3].y = nodes[1].y
    rotateNode(nodes[1], nodes[3], angle)
    nodesNew[3] = nodes[3]
    
    -- Base triangle finished. Now to the interesting part
   
    --add every remaining node
    for i=4,4 do --#nodes do
       
        -- first find node after which to insert it
        local index = 1
        
        --first move right until we find a node with lower index
        while nodesNew[index].id > nodes[i].id and index < #nodesNew do
            index = index + 1
        end
       
        -- now move right until on the right side is a node with higher index
        while index + 1 <= #nodesNew and nodesNew[index + 1].id < nodes[i].id do
            index = index + 1
        end
        
        --insert node at current position (after index)
        table.insert(nodesNew, index + 1, nodes[i])
        
        --rotate left node
        local leftIndex = index - 1
        if leftIndex <= 0 then
            leftIndex = #nodesNew
        end
        rotateNode(nodesNew[leftIndex], nodesNew[index], -noderotate)
        
        --rotate right node
        local right = index + 2
        if right > #nodesNew then
            right = right - #nodesNew
        end
        
        local rightright = right + 1
        if rightright > #nodesNew then
            rightright = rightright - #nodesNew
        end
        rotateNode(nodesNew[rightright], nodesNew[right], noderotate)
        
        
        --now adjust new nodes position
        
    end
    
end


function love.draw()
    
    love.graphics.translate(xshift, yshift)
    
    love.graphics.setColor(255, 255, 255, 255)
    for i,node in pairs(nodesNew) do
       love.graphics.circle("fill", node.x, node.y, node.radius, 60) 
    end
    love.graphics.setColor(150, 150, 250, 255)
    for i,node in pairs(nodesNew) do
        local target = nil
        if i == table.getn(nodesNew) then
           target = nodes[1]
        else
           target = nodes[i+1]
        end
        
        love.graphics.line(node.x, node.y, target.x, target.y)
    end
end
