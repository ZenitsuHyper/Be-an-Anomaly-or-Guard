[message (2).txt](https://github.com/user-attachments/files/28425832/message.2.txt)
[message (2).txt](https://github.com/user-attachments/files/28425831/message.2.txt)[message (1).txt](https://github.com/user-attachments/files/28425830/message.1.txt)local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Teams = game:GetService("Teams")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

local PlayerESP = {}
local AnomalyESP = {}
local ShowPlayerESP = false
local ShowAnomalyESP = false
local OrigConfigs = {}

local Names = {
    Entity1 = "Boiled One",
    Entity2 = "Smile Room",
    Entity3 = "Ao Oni",
    Entity4 = "SCP-173",
    Entity5 = "SCP-682",
    Entity6 = "The Locust",
    InfectionType1 = "Infected (Stage 1)",
    InfectionType2 = "Infected (Stage 2)",
    InfectionType3 = "Infected (Stage 3)",
    InfectionType4 = "Infected (Stage 4 - Apex)",
}

local Colors = {
    Entity1 = Color3.fromRGB(255, 80, 80),
    Entity2 = Color3.fromRGB(255, 255, 0),
    Entity3 = Color3.fromRGB(255, 0, 255),
    Entity4 = Color3.fromRGB(255, 140, 0),
    Entity5 = Color3.fromRGB(139, 0, 0),
    Entity6 = Color3.fromRGB(0, 255, 0),
    InfectionType1 = Color3.fromRGB(200, 200, 200),
    InfectionType2 = Color3.fromRGB(170, 170, 170),
    InfectionType3 = Color3.fromRGB(140, 140, 140),
    InfectionType4 = Color3.fromRGB(110, 110, 110),
}

local Cfg = {
    InfAmmo = false,
    FastReload = false,
    NoRecoil = false,
    FastFire = false,
    Chams = false,
}

local function IsAnomaly(p)
    if not p then return false end
    local id = p:GetAttribute("AnomalyId")
    local t = Teams:FindFirstChild("Anomalies")
    return (id and Names[id]) or (t and p.Team == t)
end

task.spawn(function()
    while true do
        for p in pairs(PlayerESP) do
            if not p.Parent or not p.Character then pcall(function() RemovePlayerESP(p) end) end
        end
        for p in pairs(AnomalyESP) do
            if not p.Parent or not p.Character then pcall(function() RemoveAnomalyESP(p) end) end
        end
        task.wait(5)
    end
end)

task.spawn(function()
    while true do
        if Camera then
            for _, v in ipairs(Camera:GetChildren()) do
                if v:IsA("CameraShake") or v.Name:lower():find("shake") then pcall(function() v:Destroy() end) end
            end
        end
        local pg = LocalPlayer:FindFirstChild("PlayerGui")
        if pg then
            for _, v in ipairs(pg:GetDescendants()) do
                if v:IsA("CameraShake") or v.Name:lower():find("shake") then pcall(function() v:Destroy() end) end
            end
        end
        task.wait(0.1)
    end
end)

local function GetTeamColor(p)
    if not p.Team then return Color3.fromRGB(255, 255, 255) end
    local n = p.Team.Name
    if n == "Guards" or n == "Special Forces" then return Color3.fromRGB(0, 100, 255) end
    if n == "Class-D" then return Color3.fromRGB(255, 165, 0) end
    if n == "Scientists" then return Color3.fromRGB(0, 255, 0) end
    return Color3.fromRGB(255, 255, 255)
end

local function GetAnomalyInfo(p)
    local id = p:GetAttribute("AnomalyId")
    local t = Teams:FindFirstChild("Anomalies")
    if id and Names[id] then return id, Names[id] end
    if t and p.Team == t then return "Unknown", "Unknown Anomaly" end
    return nil, nil
end

function CreatePlayerESP(p)
    if PlayerESP[p] then return end
    local c = p.Character
    if not c then return end
    local h = c:FindFirstChild("Head")
    if not h then return end
    local tc = GetTeamColor(p)
    local d = {player = p, obj = {}}
    local bb = Instance.new("BillboardGui")
    bb.AlwaysOnTop = true
    bb.Size = UDim2.new(0, 200, 0, 20)
    bb.StudsOffset = Vector3.new(0, 2.5, 0)
    bb.MaxDistance = 2000
    bb.Adornee = h
    bb.Enabled = ShowPlayerESP
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, 0, 1, 0)
    lbl.BackgroundTransparency = 1
    lbl.TextColor3 = tc
    lbl.TextStrokeTransparency = 0
    lbl.Text = p.Name
    lbl.Font = Enum.Font.SourceSansBold
    lbl.TextSize = 14
    lbl.Parent = bb
    bb.Parent = game.CoreGui
    d.obj.bb = bb
    PlayerESP[p] = d
end

function CreateAnomalyESP(p)
    if AnomalyESP[p] then return end
    local c = p.Character
    if not c then return end
    local h = c:FindFirstChild("Head")
    if not h then return end
    local id, name = GetAnomalyInfo(p)
    if not id then return end
    local clr = Colors[id] or Color3.fromRGB(255, 255, 255)
    local d = {player = p, obj = {}}
    local bb = Instance.new("BillboardGui")
    bb.AlwaysOnTop = true
    bb.Size = UDim2.new(0, 200, 0, 25)
    bb.StudsOffset = Vector3.new(0, 2.8, 0)
    bb.MaxDistance = 2000
    bb.Adornee = h
    bb.Enabled = ShowAnomalyESP
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, 0, 1, 0)
    lbl.BackgroundTransparency = 1
    lbl.TextColor3 = clr
    lbl.TextStrokeTransparency = 0
    lbl.Text = name
    lbl.Font = Enum.Font.SourceSansBold
    lbl.TextSize = 16
    lbl.Parent = bb
    bb.Parent = game.CoreGui
    d.obj.bb = bb
    local hl = Instance.new("Highlight")
    hl.FillColor = clr
    hl.OutlineColor = Color3.fromRGB(255, 255, 255)
    hl.FillTransparency = 0.85
    hl.OutlineTransparency = 0
    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    hl.Adornee = c
    hl.Enabled = Cfg.Chams
    hl.Parent = c
    d.obj.hl = hl
    AnomalyESP[p] = d
end

function RemovePlayerESP(p)
    local d = PlayerESP[p]
    if d then
        for _, o in pairs(d.obj) do if o and o.Parent then pcall(function() o:Destroy() end) end end
        PlayerESP[p] = nil
    end
end

function RemoveAnomalyESP(p)
    local d = AnomalyESP[p]
    if d then
        for _, o in pairs(d.obj) do if o and o.Parent then pcall(function() o:Destroy() end) end end
        AnomalyESP[p] = nil
    end
end

function UpdateESP()
    for p, d in pairs(PlayerESP) do
        if not p.Character or not p.Character.Parent then RemovePlayerESP(p); continue end
        if d.obj.bb then d.obj.bb.Enabled = ShowPlayerESP end
    end
    for p, d in pairs(AnomalyESP) do
        if not p.Character or not p.Character.Parent then RemoveAnomalyESP(p); continue end
        if d.obj.bb then d.obj.bb.Enabled = ShowAnomalyESP end
        if d.obj.hl then d.obj.hl.Enabled = Cfg.Chams end
    end
end

function ScanPlayers()
    for _, p in ipairs(Players:GetPlayers()) do
        if p == LocalPlayer then continue end
        local id, _ = GetAnomalyInfo(p)
        if not id then
            if p.Character and not PlayerESP[p] then CreatePlayerESP(p) end
        else
            if p.Character and not AnomalyESP[p] then CreateAnomalyESP(p) end
            if PlayerESP[p] then RemovePlayerESP(p) end
        end
    end
    for p in pairs(PlayerESP) do if not p.Parent then RemovePlayerESP(p) end end
    for p in pairs(AnomalyESP) do if not p.Parent then RemoveAnomalyESP(p) end end
end

local HooksReady = false

local function SaveCfg(c)
    if not OrigConfigs[c] then
        OrigConfigs[c] = {
            Firerate = c.Firerate,
            ReloadTime = c.ReloadTime,
            ClipSize = c.ClipSize,
            MinSpread = c.MinSpread,
            MaxSpread = c.MaxSpread,
        }
    end
end

local function RestoreCfg(c)
    local o = OrigConfigs[c]
    if o then
        c.Firerate = o.Firerate
        c.ReloadTime = o.ReloadTime
        c.ClipSize = o.ClipSize
        c.MinSpread = o.MinSpread
        c.MaxSpread = o.MaxSpread
    end
end

local function SetupHooks()
    if HooksReady then return end
    HooksReady = true
    task.spawn(function()
        while true do
            for _, v in ipairs(getgc(true)) do
                if type(v) == "table" and rawget(v, "Config") and rawget(v, "Tool") then
                    local c = rawget(v, "Config")
                    SaveCfg(c)
                    RestoreCfg(c)
                    if Cfg.InfAmmo then
                        local t = rawget(v, "Tool")
                        if t then
                            local a = t:FindFirstChild("Ammo")
                            if a and a:IsA("IntValue") and c.ClipSize then a.Value = c.ClipSize end
                        end
                    end
                    if Cfg.FastReload then
                        v.Reloading = false
                        if c.ReloadTime then c.ReloadTime = 0.01 end
                    end
                    if Cfg.FastFire then c.Firerate = 0.01 end
                    if Cfg.NoRecoil then
                        c.MinSpread = 0
                        c.MaxSpread = 0
                        v.Spread = 0
                    end
                end
            end
            task.wait(0.3)
        end
    end)
end

local Window = Rayfield:CreateWindow({
    Name = "Be an Anomaly or Guard",
    Icon = 0,
    LoadingTitle = "Be an Anomaly or Guard",
    LoadingSubtitle = "v1.0",
})

local CombatTab = Window:CreateTab("Combat", 4483362458)
CombatTab:CreateSection("Weapon")
CombatTab:CreateToggle({Name = "Infinite Ammo", CurrentValue = false, Callback = function(v) Cfg.InfAmmo = v; SetupHooks() end})
CombatTab:CreateToggle({Name = "Instant Reload", CurrentValue = false, Callback = function(v) Cfg.FastReload = v; SetupHooks() end})
CombatTab:CreateToggle({Name = "Fast Fire Rate", CurrentValue = false, Callback = function(v) Cfg.FastFire = v; SetupHooks() end})
CombatTab:CreateToggle({Name = "No Recoil", CurrentValue = false, Callback = function(v) Cfg.NoRecoil = v; SetupHooks() end})

local PlayerTab = Window:CreateTab("Players", 4483362458)
PlayerTab:CreateToggle({Name = "Player ESP", CurrentValue = false, Callback = function(v) ShowPlayerESP = v; if v then ScanPlayers() else for p in pairs(PlayerESP) do RemovePlayerESP(p) end end end})

local AnomalyTab = Window:CreateTab("Anomalies", 4483362458)
AnomalyTab:CreateToggle({Name = "Anomaly ESP", CurrentValue = false, Callback = function(v) ShowAnomalyESP = v; if v then ScanPlayers() else for p in pairs(AnomalyESP) do RemoveAnomalyESP(p) end end end})
AnomalyTab:CreateToggle({Name = "Chams", CurrentValue = false, Callback = function(v) Cfg.Chams = v; for _, e in pairs(AnomalyESP) do if e.obj.hl then e.obj.hl.Enabled = v end end end})

for _, p in ipairs(Players:GetPlayers()) do
    if p ~= LocalPlayer then
        p.CharacterAdded:Connect(function() task.wait(0.5); ScanPlayers() end)
        p.CharacterRemoving:Connect(function() RemovePlayerESP(p); RemoveAnomalyESP(p) end)
        p:GetAttributeChangedSignal("AnomalyId"):Connect(function() ScanPlayers() end)
    end
end

Players.PlayerAdded:Connect(function(p)
    p.CharacterAdded:Connect(function() task.wait(0.5); ScanPlayers() end)
    p.CharacterRemoving:Connect(function() RemovePlayerESP(p); RemoveAnomalyESP(p) end)
    p:GetAttributeChangedSignal("AnomalyId"):Connect(function() ScanPlayers() end)
end)

Players.PlayerRemoving:Connect(function(p) RemovePlayerESP(p); RemoveAnomalyESP(p) end)

RunService.RenderStepped:Connect(function()
    if ShowPlayerESP or ShowAnomalyESP then UpdateESP() end
end)

SetupHooks()
task.wait(1)
ScanPlayers()
