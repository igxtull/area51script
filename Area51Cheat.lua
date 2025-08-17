-- ЗОНА 51 АБСОЛЮТНОЕ ПРЕВОСХОДСТВО  
local Players = game:GetService("Players")  
local LocalPlayer = Players.LocalPlayer  
local RunService = game:GetService("RunService")  
local UIS = game:GetService("UserInputService")  

-- ===== БЕССМЕРТИЕ =====  
LocalPlayer.CharacterAdded:Connect(function(char)  
    char:WaitForChild("Humanoid").Health = 100  
    char.Humanoid:GetPropertyChangedSignal("Health"):Connect(function()  
        if char.Humanoid.Health < 100 then  
            char.Humanoid.Health = 100  
        end  
    end)  
end)  

-- ===== ESP: ВРАГИ (КРАСНЫЙ), ОРУЖИЕ (ЗЕЛЕНЫЙ), ВЫХОД (СИНИЙ) =====  
local function createESP(target, color, name)  
    local highlight = Instance.new("Highlight")  
    highlight.Name = "GHOST_" .. name  
    highlight.Adornee = target  
    highlight.FillColor = color  
    highlight.OutlineColor = Color3.new(1,1,1)  
    highlight.Parent = target  
end  

-- Отрисовка целей  
for _, obj in ipairs(workspace:GetDescendants()) do  
    if obj.Name:find("Страж") or obj:FindFirstChild("Оружие") then  
        createESP(obj, Color3.new(1,0,0), "ENEMY")  
    elseif obj.Name:find("Оруж") or obj:FindFirstChild("Ammo") then  
        createESP(obj, Color3.new(0,1,0), "WEAPON")  
    elseif obj.Name:find("Выход") or obj.Name:find("Exit") then  
        createESP(obj, Color3.new(0,0,1), "EXIT")  
    end  
end  

-- ===== АВТО-УНИЧТОЖЕНИЕ ВРАГОВ (ПРИБЛИЖЕНИЕ) =====  
RunService.Heartbeat:Connect(function()  
    if not LocalPlayer.Character then return end  
    local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")  
    if not root then return end  

    for _, enemy in ipairs(workspace:GetDescendants()) do  
        if enemy:FindFirstChild("GHOST_ENEMY") and enemy:FindFirstChild("Humanoid") then  
            local distance = (enemy.HumanoidRootPart.Position - root.Position).Magnitude  
            if distance < 30 then -- Зона смерти  
                enemy.Humanoid.Health = 0  
                enemy:Destroy()  
            end  
        end  
    end  
end)  

-- ===== ТЕЛЕКИНЕЗ ОРУЖИЯ (УДЕРЖИВАЙТЕ E) =====  
UIS.InputBegan:Connect(function(input)  
    if input.KeyCode == Enum.KeyCode.E then  
        for _, weapon in ipairs(workspace:GetDescendants()) do  
            if weapon:FindFirstChild("GHOST_WEAPON") then  
                weapon:PivotTo(LocalPlayer.Character.HumanoidRootPart.CFrame)  
            end  
        end  
    end  
end)  

-- ===== СПАВН ОРУЖИЯ (НАЖМИТЕ G) =====  
UIS.InputBegan:Connect(function(input)  
    if input.KeyCode == Enum.KeyCode.G then  
        local rocket = Instance.new("Tool")  
        rocket.Name = "РПГ-7"  
        rocket.RequiresHandle = false  
        rocket.Parent = LocalPlayer.Backpack  
        rocket.Activated:Connect(function()  
            local explosion = Instance.new("Explosion")  
            explosion.Position = LocalPlayer:GetMouse().Hit.Position  
            explosion.BlastRadius = 50  
            explosion.Parent = workspace  
        end)  
    end  
end)  

-- ===== ОТКЛЮЧЕНИЕ ЛОВУШЕК =====  
for _, trap in ipairs(workspace:GetDescendants()) do  
    if trap.Name:find("Лазер") or trap.Name:find("Ловушка") then  
        trap:Destroy()  
    end  
end  

-- ===== СУПЕР-СКОРОСТЬ (V) И ПОЛЕТ (ПРОБЕЛ/SHIFT) =====  
local FLYING = false  
UIS.InputBegan:Connect(function(input)  
    if input.KeyCode == Enum.KeyCode.V then  
        LocalPlayer.Character.Humanoid.WalkSpeed = 50  
    end  
    if input.KeyCode == Enum.KeyCode.Space then  
        FLYING = true  
    end  
end)  

UIS.InputEnded:Connect(function(input)  
    if input.KeyCode == Enum.KeyCode.Space then  
        FLYING = false  
    end  
end)  

RunService.Heartbeat:Connect(function()  
    if FLYING and LocalPlayer.Character.HumanoidRootPart then  
        LocalPlayer.Character.HumanoidRootPart.Velocity = Vector3.new(0,50,0)  
    end  
end)  

-- ===== НОЧНОЕ ВИДЕНИЕ =====  
game.Lighting.Ambient = Color3.new(1,1,1)  
game.Lighting.Brightness = 10  
`
