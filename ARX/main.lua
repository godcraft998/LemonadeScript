local DiscordLib = loadstring(game:HttpGet"https://raw.githubusercontent.com/godcraft998/LemonadeScript/refs/heads/main/Libs/DiscordUI.lua")();
local Misc = loadstring(game:HttpGet("https://raw.githubusercontent.com/godcraft998/LemonadeScript/refs/heads/main/Libs/Misc.lua"))();

local RemoteEvent = loadstring(game:HttpGet("https://raw.githubusercontent.com/godcraft998/LemonadeScript/refs/heads/main/ARX/RemoteEvent.lua"))();

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Player = game:GetService("Players").LocalPlayer;
local PlayerGui = Player.PlayerGui;
local Values = ReplicatedStorage:WaitForChild("Values"):WaitForChild("Game");
local UnitsInfo = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Info"):WaitForChild("Units"));
local PlayerData = ReplicatedStorage:WaitForChild("Player_Data"):WaitForChild(Player.Name):WaitForChild("Data");
local PlayerCollection = ReplicatedStorage:WaitForChild("Player_Data"):WaitForChild(Player.Name):WaitForChild("Collection");

local MainConfig = {
    ['enable'] = true,
    ['lobby'] = {
        ['auto-reroll-trait'] = false,
        ['reroll-trait'] = nil,
    },
    ['mics'] = {
        ['fps-boost-enable'] = false
    },
    ['join'] = {
        ['challenge'] = {
            ['auto-challenge'] = false,
        },
        ['story'] = {
            ['map'] = nil,
            ['difficulty'] = nil,
            ['chapter'] = nil,
            ['auto-join'] = false,
        },
        ['ranger'] = {
            ['map'] = nil,
            ['stage'] = nil,
            ['auto-join'] = false,
        }
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

local GameLogic = {
    ['on-teleport'] = false,
    ['fps-boost'] = false
}

local Objects = {};

function GuiCreate()
    local win = DiscordLib:Window("Lemonade v1");
    local config = MainConfig;
    local function LobbyServer()
        local lobby = win:Server("Lobby", "http://www.roblox.com/asset/?id=6031075938");
        local trait = lobby:Channel("Trait");

        trait:Toggle('Auto Reroll Trait', false, function(toggle)
            MainConfig['lobby']['auto-reroll-trait'] = toggle;
        end);

        trait:Dropdown("Trait Select", {"Range I", "Range II", "Range III",
                                "HP I", "HP II", "HP III",
                                "Damage I", "Damage II", "Damage III",
                                "Sniper", "Brute", "Tank", "Investor",
                                "Jack of All", "Crackshot", "Pure Strength", "Juggernaut", "Banker",
                                "Seraph", "Capitalist", "Duplicator", "Sovereign"}, function(value)
            MainConfig['lobby']['reroll-trait'] = value;
        end);
    end
    LobbyServer()

    local function JoinServer()
        local join = win:Server("Join", "");

        local story = join:Channel("Story");
        story:Dropdown("Map", {"OnePiece", "Namak", "DemonSlayter", "Naruto", "OPM"}, function(value)
            MainConfig['join']['story']['map'] = value;
        end);
        story:Dropdown("Difficulty", {"Normal", "Nightmare"}, function(value)
            MainConfig['join']['story']['difficulty'] = value;
        end);
        story:Dropdown("Chapter", {"Chapter1", "Chapter2", "Chapter3", "Chapter4", "Chapter5", "Chapter6", "Chapter7", "Chapter8", "Chapter9", "Chapter10"}, function(value)
            MainConfig['join']['story']['chapter'] = toggle;
        end);
        story:Toggle("Auto Story", false, function(toggle)
            MainConfig['join']['story']['auto-join'] = toggle;
        end);

        local ranger = join:Channel("Ranger");
        ranger:Dropdown("Map", {"OnePiece", "Namak", "DemonSlayter", "Naruto", "OPM"}, function(value)
            MainConfig['join']['ranger']['map'] = value;
        end);
        ranger:Dropdown("Stage", {"Stage1", "Stage2", "Stage3"}, function(value)
            MainConfig['join']['ranger']['stage'] = value;
        end);
        ranger:Toggle("Auto Ranger", false, function(toggle)
            MainConfig['join']['ranger']['auto-join'] = toggle;
        end);

        local challenge = join:Channel("Challenge");
        challenge:Toggle("Auto Challenge", MainConfig['join']['challenge']['auto-challenge'], function(toggle)
            MainConfig['join']['challenge']['auto-challenge'] = toggle;
        end);
    end
    JoinServer()

    local function GameServer()
        local game = win:Server("Game", "");
        local voting = game:Channel("Voting");

        voting:Toggle("Auto Start", MainConfig['game']['auto-start'], function(toggle)
            MainConfig['game']['auto-start'] = toggle;
        end);

        voting:Toggle("Auto Replay", MainConfig['game']['auto-replay'], function(toggle)
            MainConfig['game']['auto-replay'] = toggle;
        end);

        voting:Toggle("Auto Next", MainConfig['game']['auto-next'], function(toggle)
            MainConfig['game']['auto-next'] = toggle;
        end);

        voting:Toggle("Auto Play Toggle", false, function(toggle)
            local args = {
                [1] = "AutoPlay",
            }

            game:GetService("ReplicatedStorage"):WaitForChild("Remote"):WaitForChild("Server"):WaitForChild("Units"):WaitForChild("AutoPlay"):FireServer(unpack(args))
        end);
    end
    GameServer();
    
    local function UpgradeServer()
        local upgrade = win:Server("Upgrade", "");

        for i = 1, 6 do
            local slot = tostring(i);
            local unit = upgrade:Channel("Unit " .. slot);

            unit:Toggle("Auto Upgrade", MainConfig['upgrades']['unit-loadout'][slot]['auto-upgrade'], function(toggle)
                MainConfig['upgrades']['unit-loadout'][slot]['auto-upgrade'] = toggle;
            end);

            unit:Toggle("Auto Deploy", MainConfig['upgrades']['unit-loadout'][slot]['auto-deloy'], function(toggle)
                MainConfig['upgrades']['unit-loadout'][slot]['auto-deloy'] = toggle;
            end);

            unit:Toggle("Deploy If Max", MainConfig['upgrades']['unit-loadout'][slot]['deloy-if-max'], function(toggle)
                MainConfig['upgrades']['unit-loadout'][slot]['deloy-if-max'] = toggle;
            end);
        end
    end
    UpgradeServer();

    task.spawn(function()
        local settings = win:Server("Settings", "");

        local fps = settings:Channel("FPS");
        fps:Toggle("FPS Boost", MainConfig['mics']['fps-boost'], function(toggle)
            MainConfig['mics']['fps-boost'] = toggle;
            if (toggle) then
                Misc:optimizeGame();
            end
        end);
    end)
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

local function mergeConfig(defaults, loaded)
    for key, value in pairs(defaults) do
        if type(value) == "table" then
            if type(loaded[key]) ~= "table" then
                loaded[key] = {}
            end
            mergeConfig(value, loaded[key])
        elseif loaded[key] == nil then
            loaded[key] = value
        end
    end
end

local function loadConfig()
    local path = "Lemonade/ARX/" .. Player.Name .. ".json";
    if isfile(path) then
        local loadedData = game:GetService("HttpService"):JSONDecode(readfile(path));
        mergeConfig(MainConfig, loadedData);
        MainConfig = loadedData; -- chứa đủ các khóa
        return true;
    end
    return false;
end

local function saveConfig()
    if (not isfolder("Lemonade/ARX")) then
        makefolder("Lemonade/ARX")
    end
    writefile("Lemonade/ARX/" .. Player.Name .. ".json", game:GetService("HttpService"):JSONEncode(MainConfig));
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
            local maxUpgrade = GetMaxUpgrade(unitName);
    
            MainConfig['upgrades']['unit-loadout'][slot]['name'] = unitName;
            MainConfig['upgrades']['unit-loadout'][slot]['max-upgrade'] = maxUpgrade;
        
            PlayerData:WaitForChild("UnitLoadout" .. slot).Changed:Connect(function()
                local slot = tostring(i);
                local unitName = GetUnitLoadout(slot);
                local maxUpgrade = GetMaxUpgrade(unitName);
        
                MainConfig['upgrades']['unit-loadout'][slot]['name'] = unitName;
                MainConfig['upgrades']['unit-loadout'][slot]['max-upgrade'] = maxUpgrade;
            end)
        end
    end
end

local function waitLoaded()
    local loadingUI = PlayerGui:WaitForChild("LoadingDataUI")
    while loadingUI.Enabled do
        task.wait()
    end
end

local function workspace()
    waitLoaded();
    loadConfig();
    wait(0.1);
    GuiCreate();
    EventHandler();
    while (MainConfig['enable']) do

        if (MainConfig['join']['challenge']['auto-challenge']) and (GameLogic['on-teleport'] == false) then
            if (game:GetService("ReplicatedStorage"):WaitForChild("Values"):WaitForChild("Game"):WaitForChild("Gamemode").Value ~= "Challenge") then
                RemoteEvent:joinChallenge();
                GameLogic['on-teleport'] = true;
            end
        end

        if (MainConfig['game']['auto-start']) and (Values:WaitForChild("VotePlaying"):WaitForChild("VoteEnabled").Value) then
            if (PlayerGui:WaitForChild("HUD"):WaitForChild("InGame"):WaitForChild("VotePlaying").Visible) then
                game:GetService("ReplicatedStorage"):WaitForChild("Remote"):WaitForChild("Server"):WaitForChild("OnGame"):WaitForChild("Voting"):WaitForChild("VotePlaying"):FireServer()
            end
        end
    
        if (MainConfig['game']['auto-replay']) and (Values:WaitForChild("VoteRetry"):WaitForChild("VoteEnabled").Value) then
            game:GetService("ReplicatedStorage"):WaitForChild("Remote"):WaitForChild("Server"):WaitForChild("OnGame"):WaitForChild("Voting"):WaitForChild("VoteRetry"):FireServer()
        end
    
        if (MainConfig['game']['auto-next']) and (Values:WaitForChild("VoteNext"):WaitForChild("VoteEnabled").Value) then
            game:GetService("ReplicatedStorage"):WaitForChild("Remote"):WaitForChild("Server"):WaitForChild("OnGame"):WaitForChild("Voting"):WaitForChild("VoteNext"):FireServer()
        end
    
        if (Values:WaitForChild("GameRunning").Value) then
            for i = 1, 6 do
                if (MainConfig['upgrades']['unit-loadout'][tostring(i)]['auto-upgrade']) then
                    local unitName = MainConfig['upgrades']['unit-loadout'][tostring(i)]['name'];
                    local level = Player:WaitForChild("UnitsFolder"):WaitForChild(unitName):WaitForChild("Upgrade_Folder"):WaitForChild("Level").Value;
                    local maxUpgrade = MainConfig['upgrades']['unit-loadout'][tostring(i)]['max-upgrade'];
    
                    if (level < maxUpgrade) then
                        local args = {
                            Player:WaitForChild("UnitsFolder"):WaitForChild(unitName),
                            true
                        }
        
                        game:GetService("ReplicatedStorage"):WaitForChild("Remote"):WaitForChild("Server"):WaitForChild("Units"):WaitForChild("Upgrade"):FireServer(unpack(args))
                    end
                end
                if (MainConfig['upgrades']['unit-loadout'][tostring(i)]['auto-deloy']) then
                    local unitName = MainConfig['upgrades']['unit-loadout'][tostring(i)]['name'];
                    local level = Player:WaitForChild("UnitsFolder"):WaitForChild(unitName):WaitForChild("Upgrade_Folder"):WaitForChild("Level").Value;
                    local maxUpgrade = MainConfig['upgrades']['unit-loadout'][tostring(i)]['max-upgrade'];
    
                    if (MainConfig['upgrades']['unit-loadout'][tostring(i)]['deloy-if-max'] and (level >= maxUpgrade)) or not (MainConfig['upgrades']['unit-loadout'][tostring(i)]['deloy-if-max']) then
                        local args = {
                            Player:WaitForChild("UnitsFolder"):WaitForChild(unitName),
                            true
                        }
    
                        game:GetService("ReplicatedStorage"):WaitForChild("Remote"):WaitForChild("Server"):WaitForChild("Units"):WaitForChild("Deployment"):FireServer(unpack(args))
                    end
                end
                if (MainConfig['upgrades']['unit-loadout'][tostring(i)]['deloy-if-max']) then
                    local unitName = MainConfig['upgrades']['unit-loadout'][tostring(i)]['name'];
                    local level = Player:WaitForChild("UnitsFolder"):WaitForChild(unitName):WaitForChild("Upgrade_Folder"):WaitForChild("Level").Value;
                    local maxUpgrade = MainConfig['upgrades']['unit-loadout'][tostring(i)]['max-upgrade'];
    
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
    
        if (MainConfig['mics']['fps-boost']) and (GameLogic['fps-boost'] == false) then
            Misc:optimizeGame();
            GameLogic['fps-boost'] = true;
        end

        wait(0.25);
    end    
end

task.spawn(workspace)