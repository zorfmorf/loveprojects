
local quest = {}
local currentQuest = 0

local newQuest = 0

function questHandler_init()
    
    quest[0] = {"Placeholder", nil, 0}
    quest[1] = {"Hello! Allow me to introduce myself - I am the mayor of this little town. If you can call it that. \n Oh the conditions we have to live in ... huts made of twigs and leafs! To be shared by many! Any beggar has a better life than me ... uh I mean us! This needs to change!\n But before we can start we need more wood.\n Get it done!", "Get wood!", 0}
    quest[2] = {"Good news! I procured some wood! Now we can finally build a hut for me ... and maybe another one for you all.", "Build huts!", 0}
    quest[3] = {"That took quite long, didn't it? Hurry up, we need some stone. And to get stone we need a mineshaft.", "Build mineshaft!", 0}
    quest[4] = {"You're not the fastest one are you? \n Well enough of that. Now that we have access to stone we can finally upgrade our huts! Get us some stone and use it to improve my hut. And make sure that you hurry this time, will you?.", "Gather Stone, upgrade huts", 0}
    quest[5] = {"Now THAT's befitting for a man of my stature. However, thanks to your carelessness, we are low on tools. You can make amends by mining some iron and building a smithy.",  "Mine iron. Build smithy!", 0}
    quest[6] = {"What? A smithy? Why would you build that? Didn't you hear? There may be GOLD down there! We need to get it! NOW!!", "Mine Gold!", 0}
    quest[7] = {"WHY IS THIS TAKING SO LONG? GET ME MORE!", "Get More!", 0}
    quest[8] = {"WHAT IS HAPPENING? WHAT DID YOU DO????", nil, 0}
    
end

function questHandler_acceptQuest()
    newQuest = 0
    if currentQuest == 8 then
        state = "fin"
    end
end

function questHandler_newQuest()
    return newQuest == 1
end

function questHandler_getCurrentQuestText()
    return quest[currentQuest][1]
end

function questHandler_getShortQuestText()
    return quest[currentQuest][2]
end

function questHandler_start()
    
    if currentQuest == 0 then
        currentQuest = currentQuest + 1
        newQuest = 1
    end
    
end

function questHandler_treeCut()
    if currentQuest == 1 then
        quest[1][3] = quest[1][3] + 1
        if quest[1][3] > 2 then
            currentQuest = currentQuest + 1
            gameHandler_allowHut()
            newQuest = 1
        end
    end
end

function questHandler_hutBuilt()
    if currentQuest == 2 then
        quest[currentQuest][3] = quest[currentQuest][3] + 1
        if quest[currentQuest][3] >= 2 then
            currentQuest = currentQuest + 1
            newQuest = 1
            gameHandler_allowShaft()
        end
    end
end

function questHandler_goldMined()
    if currentQuest < 7 then
        currentQuest = 7
        newQuest = 1
    end
end

function questHandler_smithBuilt()
    if currentQuest == 5 then
        currentQuest = currentQuest + 1
        newQuest = 1
    end
end


function questHandler_hutUpgraded()
    if currentQuest == 4 then
        quest[currentQuest][3] = quest[currentQuest][3] + 1
        if quest[currentQuest][3] >= 3 then
            currentQuest = currentQuest + 1
            newQuest = 1
            gameHandler_allowSmithy()
        end
    end
end

function questHandler_shaftBuilt()
    if currentQuest == 3 then
        currentQuest = currentQuest + 1
        newQuest = 1
    end
end

function questHandler_diamondMined()
    currentQuest = 8
    newQuest = 1
end
