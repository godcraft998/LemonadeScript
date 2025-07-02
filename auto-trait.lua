local PrimaryTrait = game:GetService("ReplicatedStorage"):WaitForChild("Player_Data"):WaitForChild("Empty1808"):WaitForChild("Collection"):WaitForChild("Songjinwuu:Evo").PrimaryTrait.Value
local SecondaryTrait = game:GetService("ReplicatedStorage"):WaitForChild("Player_Data"):WaitForChild("Empty1808"):WaitForChild("Collection"):WaitForChild("Songjinwuu:Evo").SecondaryTrait.Value

while(wait(1)) do
    local PrimaryTrait = game:GetService("ReplicatedStorage"):WaitForChild("Player_Data"):WaitForChild("Empty1808"):WaitForChild("Collection"):WaitForChild("Songjinwuu:Evo").PrimaryTrait.Value
    local SecondaryTrait = game:GetService("ReplicatedStorage"):WaitForChild("Player_Data"):WaitForChild("Empty1808"):WaitForChild("Collection"):WaitForChild("Songjinwuu:Evo").SecondaryTrait.Value

    local WhiteList = {
        "Sovereign",
        "Duplicator",
        "Capitalist"
    }

    local breakLoop = false;

    for i = 1, #WhiteList do
        if PrimaryTrait == WhiteList[i] or SecondaryTrait == WhiteList[i] then
            breakLoop = true;
            break
        end
    end

    if breakLoop == false then
        local args = {
            game:GetService("ReplicatedStorage"):WaitForChild("Player_Data"):WaitForChild("Empty1808"):WaitForChild("Collection"):WaitForChild("Songjinwuu:Evo"),
            "Reroll",
            "Main",
            "Shards"
        }
        game:GetService("ReplicatedStorage"):WaitForChild("Remote"):WaitForChild("Server"):WaitForChild("Gambling"):WaitForChild("RerollTrait"):FireServer(unpack(args))
    end
end