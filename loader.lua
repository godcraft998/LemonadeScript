-- Đảm bảo game đã tải xong
if not game:IsLoaded() then
    game.Loaded:Wait()
end

-- Đảm bảo LocalPlayer tồn tại
local Players = game:GetService("Players")
local player = Players.LocalPlayer

while not player do
    task.wait()
    player = Players.LocalPlayer
end

loadstring(game:HttpGet("https://raw.githubusercontent.com/godcraft998/LemonadeScript/refs/heads/main/ARX/main.lua"))();