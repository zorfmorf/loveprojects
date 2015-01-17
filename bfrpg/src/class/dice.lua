
Dice = Class{
    init = function(self, amount, size)
        self.amount = amount
        self.size = size
    end
}

function Dice:throw()
    local result = 0
    for i = 1,self.amount do
        result = result + math.random(1, self.size)
    end
    return result
end
