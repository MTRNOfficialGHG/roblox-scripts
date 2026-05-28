--[[
    ULTIMATE UNIVERSAL EXPLOIT
    Funktioniert in ALLEN Spielen (auch Natural Disaster Survival)
    Features: God Mode | No Cooldown | Speed | Fly | Anti-Kick
]]

local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local RS = game:GetService("ReplicatedStorage")
local WS = game:GetService("Workspace")
local UIS = game:GetService("UserInputService")
local CG = game:GetService("CoreGui")

-- Warte auf Character
repeat task.wait() until LP.Character
local char = LP.Character

-- ===== GOD MODE (100% unzerstörbar) =====
local function godMode()
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.MaxHealth = 9e9
        humanoid.Health = 9e9
        humanoid.BreakJointsOnDeath = false
        humanoid.PlatformStand = false
        
        -- Health immer zurücksetzen
        spawn(function()
            while humanoid and humanoid.Parent do
                task.wait(0.05)
                pcall(function()
                    humanoid.Health = 9e9
                end)
            end
        end)
        
        -- Alle Schadens-Events blocken
        for _, v in pairs(RS:GetDescendants()) do
            pcall(function()
                if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") then
                    local name = v.Name:lower()
                    if name:find("damage") or name:find("hit") or name:find("kill") or 
                       name:find("hurt") or name:find("take") or name:find("fall") or
                       name:find("fire") or name:find("burn") or name:find("drown") then
                        v:Destroy()
                    end
                end
            end)
        end
        
        print("[✓] God Mode aktiv")
    end
end

-- ===== KEIN FALL DAMAGE =====
local function noFallDamage()
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.UseJumpPower = true
        humanoid.JumpPower = 100
        humanoid.AutoRotate = true
        
        -- Fall Damage Remote killen
        for _, v in pairs(RS:GetDescendants()) do
            pcall(function()
                if v:IsA("RemoteEvent") and v.Name:lower():find("fall") then
                    v:Destroy()
                end
            end)
        end
    end
end

-- ===== SPEED HACK =====
local function speedHack(speed)
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.WalkSpeed = speed or 120
        print("[✓] Speed: " .. (speed or 120))
    end
end

-- ===== FLY HACK (optional) =====
local flying = false
local function toggleFly()
    flying = not flying
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    local root = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso")
    
    if flying and root and humanoid then
        humanoid.PlatformStand = true
        local bv = Instance.new("BodyVelocity")
        bv.Velocity = Vector3.new(0, 0, 0)
        bv.MaxForce = Vector3.new(4000, 4000, 4000)
        bv.Parent = root
        
        spawn(function()
            while flying do
                task.wait()
                local moveDir = Vector3.new(
                    UIS:IsKeyDown(Enum.KeyCode.D) and 1 or UIS:IsKeyDown(Enum.KeyCode.A) and -1 or 0,
                    UIS:IsKeyDown(Enum.KeyCode.Space) and 1 or UIS:IsKeyDown(Enum.KeyCode.LeftShift) and -1 or 0,
                    UIS:IsKeyDown(Enum.KeyCode.W) and 1 or UIS:IsKeyDown(Enum.KeyCode.S) and -1 or 0
                )
                bv.Velocity = (root.CFrame:VectorToObjectSpace(moveDir) * 100) + Vector3.new(0, moveDir.Y * 100, 0)
            end
        end)
    else
        if root then
            local bv = root:FindFirstChildOfClass("BodyVelocity")
            if bv then bv:Destroy() end
        end
        if humanoid then
            humanoid.PlatformStand = false
        end
    end
end

-- ===== ANTI-KICK =====
local function antiKick()
    -- Alle Remotes hooken
    for _, v in pairs(RS:GetDescendants()) do
        pcall(function()
            if v:IsA("RemoteEvent") then
                local old = v.FireServer
                v.FireServer = function(self, ...)
                    local args = {...}
                    for i, arg in ipairs(args) do
                        if type(arg) == "string" and 
                           (arg:lower():find("kick") or arg:lower():find("ban") or 
                            arg:lower():find("exploit") or arg:lower():find("cheat")) then
                            return
                        end
                    end
                    return old(self, unpack(args))
                end
            end
        end)
    end
    print("[✓] Anti-Kick aktiv")
end

-- ===== TELEPORT ZU SAFE ZONE =====
local function teleportToSafe()
    local safeParts = {}
    for _, v in pairs(WS:GetDescendants()) do
        if v:IsA("BasePart") and v.Transparency < 1 then
            local name = v.Name:lower()
            if name:find("safe") or name:find("platform") or name:find("ground") or 
               name:find("floor") or name:find("lobby") or name:find("spawn") then
                table.insert(safeParts, v)
            end
        end
    end
    
    if #safeParts > 0 then
        local root = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso")
        if root then
            root.CFrame = safeParts[1].CFrame + Vector3.new(0, 5, 0)
            print("[✓] Teleportiert")
        end
    end
end

-- ===== AUTO-REVIVE =====
local function autoRevive()
    spawn(function()
        while true do
            task.wait(0.5)
            if not LP.Character or not LP.Character:FindFirstChildOfClass("Humanoid") then
                pcall(function()
                    local revive = RS:FindFirstChild("Revive") or RS:FindFirstChild("Respawn") or RS:FindFirstChild("Spawn")
                    if revive then
                        revive:FireServer()
                    end
                end)
            end
        end
    end)
end

-- ===== MAIN EXECUTION =====
print("[*] Lade Ultimate Exploit...")
task.wait(1)

-- Warte bis Character vollständig geladen
repeat task.wait() until LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
char = LP.Character

-- Alle Features aktivieren
godMode()
noFallDamage()
speedHack(120)
antiKick()
teleportToSafe()
autoRevive()

-- Fly Toggle mit F
UIS.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.F then
        toggleFly()
    end
end)

print("========== ULTIMATE EXPLOIT AKTIV ==========")
print("[✓] God Mode | Speed | Anti-Kick | Auto-Revive")
print("[✓] Drücke F zum Fliegen")
print("============================================")
