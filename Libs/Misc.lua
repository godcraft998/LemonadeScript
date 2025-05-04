--[[ 
Optimized FPS Boost Script by ChatGPT (original by VEXER666) 
Removes textures, shadows, sky, accessories, and clothing.
Includes toggleable black screen UI for max FPS gain.
]]

local modules = {};

local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

--⚡ FPS Optimization
function modules:optimizeGame()
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("Decal") or obj:IsA("Texture") or obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Smoke") or obj:IsA("Fire") then
            obj:Destroy()
        elseif obj:IsA("BasePart") then
            obj.Material = Enum.Material.SmoothPlastic
            obj.Color = Color3.fromRGB(128, 128, 128)
            obj.Reflectance = 0
            obj.CastShadow = false
        end
    end

    -- Simplify lighting
    Lighting.GlobalShadows = false
    Lighting.FogEnd = 1e10
    Lighting.Brightness = 0
    Lighting.TimeOfDay = "00:00:00"
    local sky = Lighting:FindFirstChildOfClass("Sky")
    if sky then sky:Destroy() end

    -- Remove clothing/accessories
    for _, plr in ipairs(Players:GetPlayers()) do
        local char = plr.Character or plr.CharacterAdded:Wait()
        for _, item in ipairs(char:GetChildren()) do
            if item:IsA("Shirt") or item:IsA("Pants") or item:IsA("Accessory") then
                item:Destroy()
            end
        end
    end

    -- Low quality mode
    pcall(function()
        settings().Rendering.QualityLevel = Enum.QualityLevel.Level1
    end)

    -- Optional FPS cap
    if setfpscap then setfpscap(60) end
end

--🖥️ Black Screen UI
function modules:blackScreen()
    local gui = Instance.new("ScreenGui", PlayerGui)
    gui.Name = "FPSBoostUI"
    gui.ResetOnSpawn = false

    local frame = Instance.new("Frame", gui)
    frame.Size = UDim2.new(0, 130, 0, 45)
    frame.Position = UDim2.new(0.85, 0, 0.1, 0)
    frame.BackgroundColor3 = Color3.new(0, 0, 0)
    frame.BackgroundTransparency = 0.4
    frame.BorderSizePixel = 0

    local button = Instance.new("TextButton", frame)
    button.Size = UDim2.new(1, 0, 1, 0)
    button.BackgroundTransparency = 0.2
    button.TextColor3 = Color3.new(1, 1, 1)
    button.Text = "Blank Screen: OFF"
    button.Font = Enum.Font.SourceSansBold
    button.TextSize = 16

    local overlay = Instance.new("Frame", gui)
    overlay.BackgroundColor3 = Color3.new(0, 0, 0)
    overlay.Size = UDim2.new(1, 0, 1, 0)
    overlay.Visible = false
    overlay.ZIndex = 10

    button.MouseButton1Click:Connect(function()
        overlay.Visible = not overlay.Visible
        button.Text = overlay.Visible and "Blank Screen: ON" or "Blank Screen: OFF"
    end)
end

return modules;
