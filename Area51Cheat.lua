--[[ 
   BRUTAL SURVIVAL CHEAT FOR "SURVIVE AND KILL THE KILLERS IN AREA 51"
   FEATURES: 
   1. ESP for Killers (RED), Weapons (GREEN), Health Packs (BLUE)
   2. Auto-Aim (nearest killer) with toggle (F key)
   3. Speed Hack (Press V) and Noclip (Press B)
   4. Auto-Pickup Weapons and Health
   5. Godmode (Prevents death)
--]]

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

-- GODMODE: Prevents death
LocalPlayer.CharacterAdded:Connect(function(char)
    char:WaitForChild("Humanoid").Died:Connect(function()
        char:BreakJoints()
        wait(1)
        char.Humanoid.Health = 100
        char:FindFirstChild("Head"):ClearAllChildren() -- Remove death effects
    end)
end)

-- ESP FUNCTION
local function createESP(target, color, name)
    local esp = Instance.new("Highlight")
    esp.Name = name or "KILLER_ESP"
    esp.Adornee = target
    esp.FillColor = color
    esp.OutlineColor = Color3.new(1,1,1)
    esp.FillTransparency = 0.5
    esp.Parent = target
    return esp
end

-- ESP FOR KILLERS, WEAPONS, HEALTH
for _, npc in ipairs(workspace:GetChildren()) do
    if npc.Name:find("Killer") or npc.Name:find("Zombie") then
        createESP(npc, Color3.new(1,0,0), "KILLER_ESP") -- RED = KILLER
    elseif npc.Name:find("Gun") or npc.Name:find("Weapon") then
        createESP(npc, Color3.new(0,1,0), "WEAPON_ESP") -- GREEN = WEAPON
    elseif npc.Name:find("Health") or npc.Name:find("Medkit") then
        createESP(npc, Color3.new(0,0,1), "HEALTH_ESP") -- BLUE = HEALTH
    end
end

-- AUTO-AIM TOGGLE (PRESS F)
local AUTO_AIM = false
UIS.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.F then
        AUTO_AIM = not AUTO_AIM
    end
end)

RunService.Heartbeat:Connect(function()
    if AUTO_AIM then
        local closest, dist = nil, math.huge
        for _, npc in ipairs(workspace:GetChildren()) do
            if npc:FindFirstChild("KILLER_ESP") and npc:FindFirstChild("HumanoidRootPart") then
                local d = (npc.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
                if d < dist then
                    closest = npc
                    dist = d
                end
            end
        end
        if closest then
            LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(LocalPlayer.Character.HumanoidRootPart.Position, closest.HumanoidRootPart.Position)
        end
    end
end)

-- AUTO-PICKUP WEAPONS AND HEALTH (HOLD E)
UIS.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.E then
        for _, obj in ipairs(workspace:GetChildren()) do
            if obj:FindFirstChild("WEAPON_ESP") or obj:FindFirstChild("HEALTH_ESP") then
                if obj:FindFirstChild("TouchInterest") then
                    firetouchinterest(LocalPlayer.Character.HumanoidRootPart, obj, 0)
                    firetouchinterest(LocalPlayer.Character.HumanoidRootPart, obj, 1)
                end
            end
        end
    end
end)

-- SPEED HACK (PRESS V) AND NOCLIP (PRESS B)
local SPEED_MULTIPLIER = 1
local NOCLIP = false

UIS.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.V then
        SPEED_MULTIPLIER = (SPEED_MULTIPLIER == 1) and 3 or 1
    elseif input.KeyCode == Enum.KeyCode.B then
        NOCLIP = not NOCLIP
    end
end)

RunService.Stepped:Connect(function()
    -- SPEED
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = 16 * SPEED_MULTIPLIER
    end
    -- NOCLIP
    if NOCLIP and LocalPlayer.Character then
        for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)
-- INFINITE AMMO (IF APPLICABLE)
local function infiniteAmmo()
    local old; old = hookmetamethod(game, "__namecall", function(self, ...)
        if self.Name == "FireServer" and getnamecallmethod() == "FireServer" then
            if tostring(self.Parent) == "Gun" then
                return -- Block ammo consumption
            end
        end
        return old(self, ...)
    end
end
infiniteAmmo()

-- NOTIFY
game.StarterGui:SetCore("SendNotification", {
    Title = "BRUTAL CHEAT LOADED",
    Text = "F: Auto-Aim | V: Speed | B: Noclip | E: Auto-Loot",
    Duration = 10
})
