
Character = Class{
    init = function(self)
        -- 50/50 chance for each gender
        self.gender = "female"
        self.stat = {
            str = { name="Strength", value=8, desc="Description missing"},
            int = { name="Intelligence", value=8, desc="Description missing"},
            wis = { name="Wisdom", value=8, desc="Description missing"},
            dex = { name="Dexterity", value=8, desc="Description missing"},
            con = { name="Constitution", value=8, desc="Description missing"},
            cha = { name="Charisma", value=8, desc="Description missing"},
        }
    end
}

function Character:update(dt)

end

function Character:draw()

end

function Character:isMale()
    return self.gender == "male"
end

function Character:isFemale()
    return self.gender == "female"
end