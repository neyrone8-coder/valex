local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "valex | beta 1.0",
   LoadingTitle = "Загрузка valex...",
   LoadingSubtitle = "by tg@dawnnscript",
   ConfigurationSaving = { Enabled = false }
})

local Player = game.Players.LocalPlayer
local Lighting = game:GetService("Lighting")
local RainbowColor = Color3.fromRGB(255, 0, 0)

-- Глобальные состояния
_G.WallbangKill = false
_G.HitboxEnabled = false
_G.HitboxSize = 10
_G.ESPEnabled = false
_G.RainbowMode = false
_G.ChinaHatEnabled = false
_G.AuraEnabled = false
_G.CapeEnabled = false
_G.CustomAnims = false
_G.NightMode = false
_G.NoFallDamage = false
_G.SpamEnabled = false

-- Сохранение настроек света
local defaultTime = Lighting.TimeOfDay
local defaultBrightness = Lighting.Brightness
local defaultOutdoorAmbient = Lighting.OutdoorAmbient

-- Цикл радуги
task.spawn(function()
    local h = 0
    while task.wait(0.05) do
        h = (h + 0.01) % 1
        RainbowColor = Color3.fromHSV(h, 1, 1)
    end
end)

---------------------------------------------------------
-- ВСЕ ВИЗУАЛЬНЫЕ ФУНКЦИИ (Шляпа, Аура, Плащ, Анимации)
---------------------------------------------------------

local function CreateChinaHat(char)
    if char:FindFirstChild("ValexChinaHat") then char.ValexChinaHat:Destroy() end
    if not _G.ChinaHatEnabled then return end
    local hat = Instance.new("Part", char)
    hat.Name = "ValexChinaHat"
    hat.Size = Vector3.new(2, 0.4, 2)
    hat.CanCollide = false
    local mesh = Instance.new("SpecialMesh", hat)
    mesh.MeshType = Enum.MeshType.FileMesh
    mesh.MeshId = "rbxassetid://1778999"
    mesh.Scale = Vector3.new(2.5, 0.6, 2.5)
    local weld = Instance.new("Weld", hat)
    weld.Part0 = hat weld.Part1 = char:WaitForChild("Head") weld.C0 = CFrame.new(0, -0.7, 0)
    task.spawn(function() while hat.Parent do hat.Color = _G.RainbowMode and RainbowColor or Color3.fromRGB(40,40,40) task.wait(0.1) end end)
end

local function CreateAura(char)
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    if root:FindFirstChild("ValexAuraEff") then root.ValexAuraEff:Destroy() end
    if not _G.AuraEnabled then return end
    local sparkles = Instance.new("Sparkles", root)
    sparkles.Name = "ValexAuraEff"
    task.spawn(function() while sparkles.Parent do sparkles.SparkleColor = RainbowColor task.wait(0.1) end end)
end

local function CreateCape(char)
    if char:FindFirstChild("ValexCape") then char.ValexCape:Destroy() end
    if not _G.CapeEnabled then return end
    local torso = char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso")
    if not torso then return end
    local cape = Instance.new("Part", char)
    cape.Name = "ValexCape"
    cape.Size = Vector3.new(1.8, 2.6, 0.05)
    cape.CanCollide = false
    local gui = Instance.new("SurfaceGui", cape)
    gui.Face = Enum.NormalId.Back
    local lab = Instance.new("TextLabel", gui)
    lab.Size = UDim2.new(1,0,1,0) lab.Text = "valex" lab.BackgroundTransparency = 1 lab.TextColor3 = Color3.new(1,1,1) lab.TextScaled = true
    local motor = Instance.new("Motor", cape)
    motor.Part0 = cape motor.Part1 = torso motor.C0 = CFrame.new(0, 0.8, -0.55) * CFrame.Angles(math.rad(10), 0, 0)
    task.spawn(function() while cape.Parent do cape.Color = _G.RainbowMode and RainbowColor or Color3.fromRGB(30,30,30) task.wait(0.1) end end)
end

local function ApplyAnims(char)
    if not _G.CustomAnims then return end
    local anims = {idle = "rbxassetid://616087083", walk = "rbxassetid://616091570", run = "rbxassetid://616091570", jump = "rbxassetid://616089532", fall = "rbxassetid://616088527"}
    local animate = char:WaitForChild("Animate")
    for name, id in pairs(anims) do
        if animate:FindFirstChild(name) then animate[name]:FindFirstChildOfClass("Animation").AnimationId = id end
    end
end

---------------------------------------------------------
-- МЕНЮ
---------------------------------------------------------
local CombatTab = Window:CreateTab("combat")

CombatTab:CreateToggle({Name = "WALLBANG AUTO-KILL", CurrentValue = false, Callback = function(v) _G.WallbangKill = v end})
CombatTab:CreateToggle({Name = "Включить Hitbox", CurrentValue = false, Callback = function(v) _G.HitboxEnabled = v end})
CombatTab:CreateSlider({Name = "Размер Hitbox", Range = {2, 25}, Increment = 1, CurrentValue = 10, Callback = function(v) _G.HitboxSize = v end})

local VisualTab = Window:CreateTab("VisualTab")
VisualTab:CreateToggle({Name = "Night Mode", CurrentValue = false, Callback = function(v) 
    _G.NightMode = v 
    if v then Lighting.TimeOfDay = "00:00:00" Lighting.Brightness = 0.5 Lighting.OutdoorAmbient = Color3.fromRGB(20, 20, 40)
    else Lighting.TimeOfDay = defaultTime Lighting.Brightness = defaultBrightness Lighting.OutdoorAmbient = defaultOutdoorAmbient end
end})
VisualTab:CreateToggle({Name = "Радужный режим", CurrentValue = false, Callback = function(v) _G.RainbowMode = v end})
VisualTab:CreateToggle({Name = "ESP (ВХ)", CurrentValue = false, Callback = function(v) _G.ESPEnabled = v end})
VisualTab:CreateToggle({Name = "China Hat", CurrentValue = false, Callback = function(v) _G.ChinaHatEnabled = v if Player.Character then CreateChinaHat(Player.Character) end end})
VisualTab:CreateToggle({Name = "Аура", CurrentValue = false, Callback = function(v) _G.AuraEnabled = v if Player.Character then CreateAura(Player.Character) end end})
VisualTab:CreateToggle({Name = "Плащ valex", CurrentValue = false, Callback = function(v) _G.CapeEnabled = v if Player.Character then CreateCape(Player.Character) end end})
VisualTab:CreateToggle({Name = "Анимации Ninja", CurrentValue = false, Callback = function(v) _G.CustomAnims = v if Player.Character then ApplyAnims(Player.Character) end end})

local PlayerTab = Window:CreateTab("Player")
PlayerTab:CreateSlider({Name = "Скорость", Range = {16, 200}, Increment = 1, CurrentValue = 16, Callback = function(v) if Player.Character then Player.Character.Humanoid.WalkSpeed = v end end})
PlayerTab:CreateToggle({Name = "No-Fall Damage", CurrentValue = false, Callback = function(v) _G.NoFallDamage = v end})

local MiscTab = Window:CreateTab("misc")
MiscTab:CreateToggle({Name = "Chat Spam", CurrentValue = false, Callback = function(v) _G.SpamEnabled = v end})

---------------------------------------------------------
-- ГЛАВНЫЕ ЦИКЛЫ
---------------------------------------------------------
task.spawn(function()
    while task.wait(0.1) do
        if _G.WallbangKill and Player.Character then
            local tool = Player.Backpack:FindFirstChildOfClass("Tool") or Player.Character:FindFirstChildOfClass("Tool")
            if tool then
                if tool.Parent ~= Player.Character then Player.Character.Humanoid:EquipTool(tool) end
                for _, target in pairs(game.Players:GetPlayers()) do
                    if target ~= Player and target.Character and target.Character:FindFirstChild("Head") and target.Character.Humanoid.Health > 0 then
                        local remote = tool:FindFirstChildOfClass("RemoteEvent") or tool:FindFirstChild("Shoot") or game:GetService("ReplicatedStorage"):FindFirstChild("ShootEvent")
                        if remote then remote:FireServer(target.Character.Head.Position) end
                    end
                end
            end
        end
    end
end)

task.spawn(function()
    while task.wait(0.5) do
        for _, p in pairs(game.Players:GetPlayers()) do
            if p ~= Player and p.Character then
                local h = p.Character:FindFirstChild("ValexESP") or Instance.new("Highlight", p.Character)
                h.Enabled = _G.ESPEnabled
                h.FillColor = _G.RainbowMode and RainbowColor or Color3.new(1,0,0)
                local hrp = p.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    hrp.Size = _G.HitboxEnabled and Vector3.new(_G.HitboxSize, _G.HitboxSize, _G.HitboxSize) or Vector3.new(2, 2, 1)
                    hrp.Transparency = _G.HitboxEnabled and 0.7 or 1
                end
            end
        end
        if _G.

SpamEnabled then
            local r = game:GetService("ReplicatedStorage"):FindFirstChild("DefaultChatSystemChatEvents")
            if r then r.SayMessageRequest:FireServer("WIN WITH VALEX", "All") end
        end
    end
end)

Player.CharacterAdded:Connect(function(char)
    task.wait(1)
    if _G.ChinaHatEnabled then CreateChinaHat(char) end
    if _G.AuraEnabled then CreateAura(char) end
    if _G.CapeEnabled then CreateCape(char) end
    if _G.CustomAnims then ApplyAnims(char) end
end)

Rayfield:Notify({Title = "valex", Content = "Все функции восстановлены!", Duration = 5})
