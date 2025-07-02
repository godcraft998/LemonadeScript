local enable = true;
local ticks = 0;

local function getPortals(name : string)
    local portals = require(game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("ReplicaHolder")).GetReplicaOfClass("PlayerData").Data.PortalData;
    local result = {};

    for _, portal in pairs(portals) do
        if (portal.PortalName == name) then
            table.insert(result, portal);
        end
    end

    return result;
end

local function getUnits()
    return require(game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("ReplicaHolder")).GetReplicaOfClass("PlayerData").Data.UnitData;
end

local function hasPrompt()
    return game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("Prompt");
end

local function activated(button)
    for _, conn in pairs(getconnections(button.Activated)) do
        conn.Function()
    end
end

local function selectPortal()
    local prompt = game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("Prompt");
    for _, v in pairs(prompt.Frame.Frame:GetChildren()) do
        if (type(v) == 'Frame') then
            if (v:FindFirstChild('Frame')) then
                local f = v:FindFirstChild('Frame');
                activated(f.TextButton);
            end
        end
    end
end

local function main()
    while enable do
        print("Ticks: " .. ticks);
        if (hasPrompt()) then
            wait(5);
            selectPortal();

            print("Prompt found, selecting portal...");

            wait(2);

            local portals = getPortals("Summer Laguna");
            table.sort(portals, function(a, b)
                return a.PortalData.Tier > b.PortalData.Tier;
            end)

            if (#portals > 0) then
                print("Activated portal: " .. portals[1].PortalName);
                local args = {
                    portals[1].PortalID;
                }
                game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Portals"):WaitForChild("Activate"):InvokeServer(args);
                break;
            end
        end

        ticks = ticks + 1;
        wait(0.5);
    end
end

task.spawn(main)
