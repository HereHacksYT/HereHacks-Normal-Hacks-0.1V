-- HereHacks V0.1 SCROLL FIX
local LBLG = Instance.new("ScreenGui")
LBLG.Name = "HereHacksV01"
LBLG.Parent = game.CoreGui
LBLG.ResetOnSpawn = false

-- HH BUTTON
local OpenBtn = Instance.new("TextButton", LBLG)
OpenBtn.Size = UDim2.new(0, 60, 0, 60)
OpenBtn.Position = UDim2.new(0, 10, 0.4, 0)
OpenBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
OpenBtn.Text = "HH"
OpenBtn.TextColor3 = Color3.new(0, 1, 0)
OpenBtn.Font = Enum.Font.SourceSansBold
OpenBtn.TextSize = 22
OpenBtn.Draggable = true

-- MAIN PANEL
local Main = Instance.new("Frame", LBLG)
Main.Size = UDim2.new(0, 400, 0, 220) 
Main.Position = UDim2.new(0.5, -200, 0.5, -110)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Main.Visible = false
Main.Active = true
Main.Draggable = true

OpenBtn.MouseButton1Click:Connect(function()
    Main.Visible = not Main.Visible
end)

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 35)
Title.Text = "HereHacks V0.1"
Title.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Title.TextColor3 = Color3.new(0, 1, 0)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 18

-- VERTICAL CONTAINER (SCROLL FIXED)
local Container = Instance.new("ScrollingFrame", Main)
Container.Size = UDim2.new(1, -10, 1, -45)
Container.Position = UDim2.new(0, 5, 0, 40)
Container.BackgroundTransparency = 1
Container.ScrollBarThickness = 8
Container.CanvasSize = UDim2.new(0, 0, 0, 600) -- Kaydırma alanını geniş tuttum
Container.ScrollingEnabled = true -- Dokunmatik kaydırmayı zorla
Container.ZIndex = 10

local Layout = Instance.new("UIListLayout", Container)
Layout.FillDirection = Enum.FillDirection.Vertical
Layout.Padding = UDim.new(0, 8)
Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- BUILDERS
local function AddToggle(name, on, off)
    local btn = Instance.new("TextButton", Container)
    btn.Size = UDim2.new(0.95, 0, 0, 45) -- Butonları biraz büyüttüm tıklaması kolay olsun
    btn.Text = name .. ": OFF"
    btn.BackgroundColor3 = Color3.fromRGB(130, 0, 0)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.SourceSansBold
    btn.ZIndex = 11
    local state = false
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.Text = state and name .. ": ON" or name .. ": OFF"
        btn.BackgroundColor3 = state and Color3.fromRGB(0, 130, 0) or Color3.fromRGB(130, 0, 0)
        if state then on() else off() end
    end)
end

local function AddAction(name, func)
    local btn = Instance.new("TextButton", Container)
    btn.Size = UDim2.new(0.95, 0, 0, 45)
    btn.Text = name
    btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.SourceSansBold
    btn.ZIndex = 11
    btn.MouseButton1Click:Connect(func)
end

local function AddInput(name, callback)
    local frame = Instance.new("Frame", Container)
    frame.Size = UDim2.new(0.95, 0, 0, 45)
    frame.BackgroundTransparency = 1
    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(0.4, 0, 1, 0)
    label.Text = name
    label.TextColor3 = Color3.new(1, 1, 1)
    label.ZIndex = 11
    local box = Instance.new("TextBox", frame)
    box.Size = UDim2.new(0.6, 0, 1, 0)
    box.Position = UDim2.new(0.4, 0, 0, 0)
    box.PlaceholderText = "Value..."
    box.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    box.TextColor3 = Color3.new(1, 1, 1)
    box.ZIndex = 11
    box.FocusLost:Connect(function() callback(tonumber(box.Text)) end)
end

-- FEATURES
AddInput("Speed", function(v) if v then game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = v end end)
AddInput("Jump", function(v) if v then game.Players.LocalPlayer.Character.Humanoid.JumpPower = v end end)

local ps; AddToggle("Stroller Spin", function()
    ps = Instance.new("BodyAngularVelocity", game.Players.LocalPlayer.Character.HumanoidRootPart)
    ps.MaxTorque = Vector3.new(0, 1e9, 0)
    ps.AngularVelocity = Vector3.new(0, 500, 0)
end, function() if ps then ps:Destroy() end end)

local fl; AddToggle("Fling", function()
    fl = Instance.new("BodyAngularVelocity", game.Players.LocalPlayer.Character.HumanoidRootPart)
    fl.MaxTorque = Vector3.new(1e9, 1e9, 1e9)
    fl.AngularVelocity = Vector3.new(0, 9999, 0)
end, function() if fl then fl:Destroy() end end)

local fv, fg; AddToggle("Fly", function()
    local r = game.Players.LocalPlayer.Character.HumanoidRootPart
    fv = Instance.new("BodyVelocity", r) fv.MaxForce = Vector3.new(1e6, 1e6, 1e6)
    fg = Instance.new("BodyGyro", r) fg.MaxTorque = Vector3.new(1e6, 1e6, 1e6)
    task.spawn(function() while fv do fv.Velocity = workspace.CurrentCamera.CFrame.LookVector * 50 fg.CFrame = workspace.CurrentCamera.CFrame task.wait() end end)
end, function() if fv then fv:Destroy() fg:Destroy() fv = nil end end)

AddToggle("InfJump", function() _G.IJ = game:GetService("UserInputService").JumpRequest:Connect(function() game.Players.LocalPlayer.Character.Humanoid:ChangeState("Jumping") end) end, function() if _G.IJ then _G.IJ:Disconnect() end end)
AddToggle("Noclip", function() _G.NC = game:GetService("RunService").Stepped:Connect(function() for _, v in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end end) end, function() if _G.NC then _G.NC:Disconnect() end end)

local esp; AddToggle("ESP", function()
    esp = game:GetService("RunService").RenderStepped:Connect(function()
        for _, v in pairs(game.Players:GetPlayers()) do
            if v ~= game.Players.LocalPlayer and v.Character and not v.Character:FindFirstChild("Highlight") then
                Instance.new("Highlight", v.Character).FillColor = Color3.new(1,0,0)
            end
        end
    end)
end, function() if esp then esp:Disconnect() end for _, v in pairs(game.Players:GetPlayers()) do if v.Character and v.Character:FindFirstChild("Highlight") then v.Character.Highlight:Destroy() end end end)

-- TP ACTIONS (SCROLL DOWN TO SEE)
AddAction("Player TP", function()
    local pf = Instance.new("Frame", LBLG)
    pf.Size = UDim2.new(0, 200, 0, 250)
    pf.Position = UDim2.new(0.5, -100, 0.5, -125)
    pf.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    pf.ZIndex = 50

    local sc = Instance.new("ScrollingFrame", pf)
    sc.Size = UDim2.new(1, 0, 0.85, 0)
    sc.CanvasSize = UDim2.new(0, 0, 5, 0)
    sc.BackgroundTransparency = 1
    sc.ScrollBarThickness = 5
    sc.ZIndex = 51
    
    local lyt = Instance.new("UIListLayout", sc)
    lyt.Padding = UDim.new(0, 5)

    for _, p in pairs(game.Players:GetPlayers()) do
        if p ~= game.Players.LocalPlayer then
            local b = Instance.new("TextButton", sc)
            b.Size = UDim2.new(1, -10, 0, 30)
            b.Text = p.Name
            b.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            b.TextColor3 = Color3.new(1, 1, 1)
            b.ZIndex = 52
            b.MouseButton1Click:Connect(function()
                if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame
                end
            end)
        end
    end

    local close = Instance.new("TextButton", pf)
    close.Size = UDim2.new(1, 0, 0, 35)
    close.Position = UDim2.new(0, 0, 0.85, 0)
    close.Text = "CLOSE"
    close.BackgroundColor3 = Color3.fromRGB(100, 0, 0)
    close.TextColor3 = Color3.new(1, 1, 1)
    close.ZIndex = 52
    close.MouseButton1Click:Connect(function() pf:Destroy() end)
end)

AddAction("Get TP Tool", function()
    local t = Instance.new("Tool")
    t.Name = "TP Click"
    t.RequiresHandle = false
    t.Parent = game.Players.LocalPlayer.Backpack
    t.Activated:Connect(function()
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(game.Players.LocalPlayer:GetMouse().Hit.p + Vector3.new(0, 3, 0))
    end)
end)

AddAction("Void TP (Troll)", function()
    local hrp = game.Players.LocalPlayer.Character.HumanoidRootPart
    local old = hrp.CFrame
    hrp.CFrame = CFrame.new(0, 10000, 0)
    task.wait(0.5)
    hrp.CFrame = old
end)
