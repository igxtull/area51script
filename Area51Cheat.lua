local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- ESP Functions
local function createESP(target)
    local esp = Instance.new("Highlight")
    esp.Name = "ESP_" .. target.Name
    esp.FillColor = Color3.new(1, 0, 0) -- Красный для врагов
    esp.OutlineColor = Color3.new(1, 1, 1)
    esp.Parent = target
    return esp
end

-- Aimbot
local function aimAt(target)
    local character = target.Character
    if character and character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(LocalPlayer.Character.HumanoidRootPart.Position, character.HumanoidRootPart.Position)
    end
end

-- Noclip
local noclipActive = false
RunService.Stepped:Connect(function()
    if noclipActive and LocalPlayer.Character then
        for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

-- Auto Steal Weapons
local function stealWeapon(weaponPart)
    if weaponPart and weaponPart.Parent then
        LocalPlayer.Character.HumanoidRootPart.CFrame = weaponPart.CFrame
        wait(0.2)
        firetouchinterest(LocalPlayer.Character.HumanoidRootPart, weaponPart, 0) -- Touch to collect
    end
end

-- GUI Toggle
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.RightControl then
        noclipActive = not noclipActive
    elseif input.KeyCode == Enum.KeyCode.Q then
        local closestTarget = nil
        local maxDist = math.huge
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                local dist = (player.Character.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
                if dist < maxDist then
                    closestTarget = player
                    maxDist = dist
                end
            end
        end
        if closestTarget then
            aimAt(closestTarget)
        end
    end
end)

-- Main Loop
while wait(1) do
    -- ESP for Players
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and not player.Character:FindFirstChild("ESP_" .. player.Name) then
            createESP(player.Character)
        end
    end

    -- Auto Steal Nearest Weapon
    for _, weapon in ipairs(workspace:GetChildren()) do
        if weapon.Name == "WeaponPart" and (weapon.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude < 50 then
            stealWeapon(weapon)
        end
    end
end
