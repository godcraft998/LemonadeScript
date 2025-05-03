local DiscordLib = loadstring(game:HttpGet"https://raw.githubusercontent.com/godcraft998/RobloxScript/refs/heads/main/re-Vanis%20Lib.lua")()

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Player = game:GetService("Players").LocalPlayer;
local PlayerGui = Player.PlayerGui;
local Values = ReplicatedStorage:WaitForChild("Values"):WaitForChild("Game");
local UnitsInfo = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Info"):WaitForChild("Units"));
local PlayerData = ReplicatedStorage:WaitForChild("Player_Data"):WaitForChild(Player.Name):WaitForChild("Data");
local PlayerCollection = ReplicatedStorage:WaitForChild("Player_Data"):WaitForChild(Player.Name):WaitForChild("Collection");

local MainConfig = {
    ['lobby'] = {
        ['auto-reroll-trait'] = false,
        ['reroll-trait'] = nil,
    },
    ['game'] = {
        ['auto-start'] = false,
        ['auto-replay'] = false,
        ['auto-next'] = false,
    },
    ['upgrades'] = {
        ['unit-loadout'] = {
            ['1'] = {
                ['name'] = nil,
                ['max-upgrade'] = 0,
                ['auto-deloy'] = false,
                ['auto-upgrade'] = false,
                ['deloy-if-max'] = false
            },
            ['2'] = {
                ['name'] = nil,
                ['max-upgrade'] = 0,
                ['auto-deloy'] = false,
                ['auto-upgrade'] = false,
                ['deloy-if-max'] = false
            },
            ['3'] = {
                ['name'] = nil,
                ['max-upgrade'] = 0,
                ['auto-deloy'] = false,
                ['auto-upgrade'] = false,
                ['deloy-if-max'] = false
            },
            ['4'] = {
                ['name'] = nil,
                ['max-upgrade'] = 0,
                ['auto-deloy'] = false,
                ['auto-upgrade'] = false,
                ['deloy-if-max'] = false
            },
            ['5'] = {
                ['name'] = nil,
                ['max-upgrade'] = 0,
                ['auto-deloy'] = false,
                ['auto-upgrade'] = false,
                ['deloy-if-max'] = false
            },
            ['6'] = {
                ['name'] = nil,
                ['max-upgrade'] = 0,
                ['auto-deloy'] = false,
                ['auto-upgrade'] = false,
                ['deloy-if-max'] = false
            }
        }
    }
}

local Objects = {};

function GuiCreate()
    local win = DiscordLib:Window("Lemonade v1");

    local Main = win:Server("Main", "http://www.roblox.com/asset/?id=6031075938")

    local Lobby = Main:Channel("Lobby");

    Lobby:Toggle('Auto Reroll Trait', false, function(toggle)
        MainConfig['lobby']['auto-reroll-trait'] = toggle;
    end);

    Lobby:Dropdown("Trait Select", {"Range I", "Range II", "Range III",
                            "HP I", "HP II", "HP III",
                            "Damage I", "Damage II", "Damage III",
                            "Sniper", "Brute", "Tank", "Investor",
                            "Jack of All", "Crackshot", "Pure Strength", "Juggernaut", "Banker",
                            "Seraph", "Capitalist", "Duplicator", "Sovereign"}, function(value)
        MainConfig['lobby']['reroll-trait'] = value;
    end);

    local Game = Main:Channel("Game");

    Game:Toggle('Vote Start', false, function(toggle)
        MainConfig['game']['auto-start'] = toggle;
    end);

    Game:Toggle('Auto Replay', false, function(toggle)
        MainConfig['game']['auto-replay'] = toggle;
    end);

    Game:Toggle('Auto Next', false, function(toggle)
        MainConfig['game']['auto-next'] = toggle;
    end);
    
    Game:Toggle('Auto Play Toggle', false, function(toggle)
        local args = {
            [1] = "AutoPlay",
        }

        game:GetService("ReplicatedStorage"):WaitForChild("Remote"):WaitForChild("Server"):WaitForChild("Units"):WaitForChild("AutoPlay"):FireServer(unpack(args))
    end);

    
    local Upgrades = win:Server("Upgrades", "");

    for i = 1, 6 do
        Objects['UnitLoadout' .. i] = Main:Channel("UnitLoadout " .. i);
        Objects['UnitLoadout' .. i]:Label("Auto Deloy " .. i, false, function(toggle)
            MainConfig['upgrade']['unit-loadout'][tostring(i)]['unit-loadout'] = toggle;
        end)
        Objects['UnitLoadout' .. i]:Label("Auto Upgrade " .. i, false, function(toggle)
            MainConfig['upgrade']['unit-loadout'][tostring(i)]['unit-loadout'] = toggle;
        end)
        Objects['UnitLoadout' .. i]:Label("Deloy If Max " .. i, false, function(toggle)
            MainConfig['upgrade']['unit-loadout'][tostring(i)]['unit-loadout'] = toggle;
        end)
    end
end

local function GetInfo(unitName)
    local unitInfo = UnitsInfo[unitName];
    if unitInfo then
        return unitInfo;
    else
        error("Unit not found: " .. unitName);
    end
end

local function GetMaxUpgrade(unitName)
    local unitInfo = GetInfo(unitName);
    if unitInfo and unitInfo.Upgrade then
        return #unitInfo.Upgrade + 1;
    else
        error("Max upgrade not found for unit: " .. unitName);
    end
end

local function GetUnitLoadout(slot)
    local tag = PlayerData:WaitForChild("UnitLoadout" .. slot).Value;
    local name = nil;

    for _, unit in pairs(PlayerCollection:GetChildren()) do
        if (unit.Tag.Value == tag) then
            name = unit.Name;
            break;
        end
    end

    return name;
end

local function saveConfig()
    if (not isfolder("Lemonade")) then
        makefolder("Lemonade")
    end
    writefile("Lemonade/" .. Player.Name .. ".json", game:GetService("HttpService"):JSONEncode(MainConfig));
end

local function loadConfig()
    if (isfile("Lemonade/" .. Player.Name .. ".json")) then
        local config = readfile("Lemon Hub" .. Player.Name .. ".json");
        MainConfig = game:GetService("HttpService"):JSONDecode(config);
    end
end

local function EventHandler()
    PlayerGui.ChildAdded:Connect(function(child)
        if (child.Name == 'GameEndedAnimationUI') or (child.Name == 'Flash') then
            child:Destroy();
        end
    end)

    local vu = game:GetService("VirtualUser")
    game:GetService("Players").LocalPlayer.Idled:connect(function() 
        vu:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame) 
        wait(1) 
        vu:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
    end)

    Player.OnTeleport:Connect(saveConfig)

    for i = 1, 6 do
        local slot = tostring(i);
        local unitName = GetUnitLoadout(slot);
        if (unitName ~= nil) then
            print("Unit Name: ", unitName);
            local maxUpgrade = GetMaxUpgrade(unitName);
    
            MainConfig['upgrade']['unit-loadout'][slot]['name'] = unitName;
            MainConfig['upgrade']['unit-loadout'][slot]['max-upgrade'] = maxUpgrade;
        
            PlayerData:WaitForChild("UnitLoadout" .. slot).Changed:Connect(function()
                local slot = tostring(i);
                local unitName = GetUnitLoadout(slot);
                local maxUpgrade = GetMaxUpgrade(unitName);
        
                MainConfig['upgrade']['unit-loadout'][slot]['name'] = unitName;
                MainConfig['upgrade']['unit-loadout'][slot]['max-upgrade'] = maxUpgrade;
            end)
        end
    end
end

local function workspace()
    while (true) do
        loadConfig();
    
        if (MainConfig['game']['auto-start']) and (Values:WaitForChild("VotePlaying"):WaitForChild("VoteEnabled").Value) then
            game:GetService("ReplicatedStorage"):WaitForChild("Remote"):WaitForChild("Server"):WaitForChild("OnGame"):WaitForChild("Voting"):WaitForChild("VotePlaying"):FireServer()
        end
    
        if (MainConfig['auto-replay']) and (Values:WaitForChild("VoteRetry"):WaitForChild("VoteEnabled").Value) then
            game:GetService("ReplicatedStorage"):WaitForChild("Remote"):WaitForChild("Server"):WaitForChild("OnGame"):WaitForChild("Voting"):WaitForChild("VoteRetry"):FireServer()
        end
    
        if (MainConfig['auto-next']) and (Values:WaitForChild("VoteNext"):WaitForChild("VoteEnabled").Value) then
            game:GetService("ReplicatedStorage"):WaitForChild("Remote"):WaitForChild("Server"):WaitForChild("OnGame"):WaitForChild("Voting"):WaitForChild("VoteNext"):FireServer()
        end
    
        if (Values:WaitForChild("GameRunning").Value) then
            for i = 1, 6 do
                if (MainConfig['upgrade']['unit-loadout'][tostring(i)]['auto-upgrade']) then
                    local unitName = MainConfig['upgrade']['unit-loadout'][tostring(i)]['name'];
                    local level = Player:WaitForChild("UnitsFolder"):WaitForChild(unitName):WaitForChild("Upgrade_Folder"):WaitForChild("Level").Value;
                    local maxUpgrade = MainConfig['upgrade']['unit-loadout'][tostring(i)]['max-upgrade'];
    
                    if (level < maxUpgrade) then
                        local args = {
                            Player:WaitForChild("UnitsFolder"):WaitForChild(unitName),
                            true
                        }
        
                        game:GetService("ReplicatedStorage"):WaitForChild("Remote"):WaitForChild("Server"):WaitForChild("Units"):WaitForChild("Upgrade"):FireServer(unpack(args))
                    end
                end
                if (MainConfig['upgrade']['unit-loadout'][tostring(i)]['auto-deloy']) then
                    local unitName = MainConfig['upgrade']['unit-loadout'][tostring(i)]['name'];
                    local level = Player:WaitForChild("UnitsFolder"):WaitForChild(unitName):WaitForChild("Upgrade_Folder"):WaitForChild("Level").Value;
                    local maxUpgrade = MainConfig['upgrade']['unit-loadout'][tostring(i)]['max-upgrade'];
    
                    if (MainConfig['upgrade']['unit-loadout'][tostring(i)]['deloy-if-max'] and (level >= maxUpgrade)) or not (MainConfig['upgrade']['unit-loadout'][tostring(i)]['deloy-if-max']) then
                        local args = {
                            Player:WaitForChild("UnitsFolder"):WaitForChild(unitName),
                            true
                        }
    
                        game:GetService("ReplicatedStorage"):WaitForChild("Remote"):WaitForChild("Server"):WaitForChild("Units"):WaitForChild("Deployment"):FireServer(unpack(args))
                    end
                end
                if (MainConfig['upgrade']['unit-loadout'][tostring(i)]['deloy-if-max']) then
                    local unitName = MainConfig['upgrade']['unit-loadout'][tostring(i)]['name'];
                    local level = Player:WaitForChild("UnitsFolder"):WaitForChild(unitName):WaitForChild("Upgrade_Folder"):WaitForChild("Level").Value;
                    local maxUpgrade = MainConfig['upgrade']['unit-loadout'][tostring(i)]['max-upgrade'];
        
                    print("Unit Name: ", unitName);
    
                    if (level >= maxUpgrade) then
                        local args = {
                            Player:WaitForChild("UnitsFolder"):WaitForChild(unitName),
                            true
                        }
        
                        game:GetService("ReplicatedStorage"):WaitForChild("Remote"):WaitForChild("Server"):WaitForChild("Units"):WaitForChild("Deployment"):FireServer(unpack(args))
                    end
                end
            end
        end
    
        wait(0.5);
    end    
end

