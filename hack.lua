-- =============================================
-- HACK v8 - FUNCIONA EM JOGOS REAIS
-- Delta Executor | Mobile + PC
-- NÃO SETA HEALTH DIRETO (sem bug invisivel)
-- =============================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local lp = Players.LocalPlayer
local cam = workspace.CurrentCamera

local aimbot = false
local shootbox = false
local espOn = false
local autoDmg = false
local shootRad = 50
local circle = nil
local RAIO_MAX = 400
local autoShootConn = nil

-- LIMPAR
for _,g in pairs(lp.PlayerGui:GetChildren()) do
    if g.Name == "DH8" then g:Destroy() end
end
for _,p in pairs(Players:GetPlayers()) do
    if p.Character then
        local h = p.Character:FindFirstChild("_HL")
        if h then h:Destroy() end
        local hd = p.Character:FindFirstChild("Head")
        if hd then
            local b = hd:FindFirstChild("_BI")
            if b then b:Destroy() end
        end
    end
end

local gui = Instance.new("ScreenGui")
gui.Name = "DH8"
gui.ResetOnSpawn = false
gui.Parent = lp.PlayerGui

-- ========== PAINEL ==========
local panel = Instance.new("Frame")
panel.Size = UDim2.new(0, 260, 0, 380)
panel.Position = UDim2.new(0.5, -130, 0.08, 0)
panel.BackgroundColor3 = Color3.fromRGB(18, 18, 28)
panel.BorderSizePixel = 0
panel.Active = true
panel.Draggable = true
panel.Parent = gui

Instance.new("UICorner", panel).CornerRadius = UDim.new(0, 12)

local ps = Instance.new("UIStroke", panel)
ps.Color = Color3.fromRGB(120, 0, 255)
ps.Thickness = 2

-- TOPO
local top = Instance.new("Frame")
top.Size = UDim2.new(1, 0, 0, 36)
top.BackgroundColor3 = Color3.fromRGB(35, 0, 80)
top.BorderSizePixel = 0
top.Parent = panel
Instance.new("UICorner", top).CornerRadius = UDim.new(0, 12)

local topFix = Instance.new("Frame")
topFix.Size = UDim2.new(1, 0, 0, 18)
topFix.Position = UDim2.new(0, 0, 0.5, 0)
topFix.BackgroundColor3 = Color3.fromRGB(35, 0, 80)
topFix.BorderSizePixel = 0
topFix.Parent = top

local titulo = Instance.new("TextLabel")
titulo.Text = "⚡ HACK v8"
titulo.TextColor3 = Color3.fromRGB(210, 150, 255)
titulo.TextSize = 16
titulo.Font = Enum.Font.GothamBold
titulo.BackgroundTransparency = 1
titulo.Size = UDim2.new(1, -50, 1, 0)
titulo.Position = UDim2.new(0, 12, 0, 0)
titulo.TextXAlignment = Enum.TextXAlignment.Left
titulo.Parent = top

local fechar = Instance.new("TextButton")
fechar.Size = UDim2.new(0, 28, 0, 28)
fechar.Position = UDim2.new(1, -34, 0.5, -14)
fechar.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
fechar.Text = "X"
fechar.TextColor3 = Color3.new(1, 1, 1)
fechar.TextSize = 14
fechar.Font = Enum.Font.GothamBold
fechar.BorderSizePixel = 0
fechar.Parent = top
Instance.new("UICorner", fechar).CornerRadius = UDim.new(0, 6)

-- BOTAO REABRIR
local reabrir = Instance.new("TextButton")
reabrir.Size = UDim2.new(0, 55, 0, 55)
reabrir.Position = UDim2.new(0, 10, 0.45, 0)
reabrir.BackgroundColor3 = Color3.fromRGB(120, 0, 255)
reabrir.Text = "⚡"
reabrir.TextColor3 = Color3.new(1, 1, 1)
reabrir.TextSize = 26
reabrir.Font = Enum.Font.GothamBold
reabrir.BorderSizePixel = 0
reabrir.Visible = false
reabrir.Active = true
reabrir.Draggable = true
reabrir.Parent = gui
Instance.new("UICorner", reabrir).CornerRadius = UDim.new(1, 0)

local rs = Instance.new("UIStroke", reabrir)
rs.Color = Color3.fromRGB(200, 100, 255)
rs.Thickness = 2

fechar.MouseButton1Click:Connect(function()
    panel.Visible = false
    reabrir.Visible = true
end)

reabrir.MouseButton1Click:Connect(function()
    panel.Visible = true
    reabrir.Visible = false
end)

-- SCROLL
local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1, -16, 1, -46)
scroll.Position = UDim2.new(0, 8, 0, 42)
scroll.BackgroundTransparency = 1
scroll.ScrollBarThickness = 4
scroll.ScrollBarImageColor3 = Color3.fromRGB(120, 0, 255)
scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
scroll.BorderSizePixel = 0
scroll.Parent = panel

local lay = Instance.new("UIListLayout", scroll)
lay.Padding = UDim.new(0, 8)
lay.SortOrder = Enum.SortOrder.LayoutOrder

-- ========== FUNCAO CRIAR OPCAO ==========
local function opcao(nome, desc, callback)
    local card = Instance.new("Frame")
    card.Size = UDim2.new(1, 0, 0, 55)
    card.BackgroundColor3 = Color3.fromRGB(28, 28, 42)
    card.BorderSizePixel = 0
    card.Parent = scroll
    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 10)

    local n = Instance.new("TextLabel")
    n.Text = nome
    n.TextColor3 = Color3.new(1, 1, 1)
    n.TextSize = 14
    n.Font = Enum.Font.GothamBold
    n.BackgroundTransparency = 1
    n.Position = UDim2.new(0, 10, 0, 6)
    n.Size = UDim2.new(1, -65, 0, 18)
    n.TextXAlignment = Enum.TextXAlignment.Left
    n.Parent = card

    local d = Instance.new("TextLabel")
    d.Text = desc
    d.TextColor3 = Color3.fromRGB(130, 130, 155)
    d.TextSize = 10
    d.Font = Enum.Font.Gotham
    d.BackgroundTransparency = 1
    d.Position = UDim2.new(0, 10, 0, 26)
    d.Size = UDim2.new(1, -65, 0, 22)
    d.TextWrapped = true
    d.TextXAlignment = Enum.TextXAlignment.Left
    d.Parent = card

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 44, 0, 24)
    btn.Position = UDim2.new(1, -54, 0.5, -12)
    btn.BackgroundColor3 = Color3.fromRGB(55, 55, 75)
    btn.Text = "OFF"
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.TextSize = 11
    btn.Font = Enum.Font.GothamBold
    btn.BorderSizePixel = 0
    btn.Parent = card
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

    local on = false
    btn.MouseButton1Click:Connect(function()
        on = not on
        btn.Text = on and "ON" or "OFF"
        btn.BackgroundColor3 = on and Color3.fromRGB(0, 160, 0) or Color3.fromRGB(55, 55, 75)
        callback(on)
    end)
end

-- ========== SLIDER ==========
local function criarSlider()
    local card = Instance.new("Frame")
    card.Size = UDim2.new(1, 0, 0, 40)
    card.BackgroundColor3 = Color3.fromRGB(28, 28, 42)
    card.BorderSizePixel = 0
    card.Parent = scroll
    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 10)

    local lbl = Instance.new("TextLabel")
    lbl.Text = "Raio: 50%"
    lbl.TextColor3 = Color3.fromRGB(170, 130, 255)
    lbl.TextSize = 12
    lbl.Font = Enum.Font.GothamBold
    lbl.BackgroundTransparency = 1
    lbl.Position = UDim2.new(0, 10, 0, 2)
    lbl.Size = UDim2.new(1, -20, 0, 16)
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = card

    local track = Instance.new("Frame")
    track.Size = UDim2.new(1, -20, 0, 10)
    track.Position = UDim2.new(0, 10, 0, 22)
    track.BackgroundColor3 = Color3.fromRGB(40, 40, 58)
    track.BorderSizePixel = 0
    track.Parent = card
    Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new(0.5, 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(120, 0, 255)
    fill.BorderSizePixel = 0
    fill.Parent = track
    Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)

    local sliding = false

    local function doSlide(x)
        local pct = math.clamp((x - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
        fill.Size = UDim2.new(pct, 0, 1, 0)
        shootRad = math.floor(pct * 100)
        lbl.Text = "Raio: " .. shootRad .. "%"
        if circle then
            local r = (shootRad / 100) * RAIO_MAX
            circle.Size = UDim2.new(0, r * 2, 0, r * 2)
            circle.Position = UDim2.new(0.5, -r, 0.5, -r)
        end
    end

    track.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1
        or i.UserInputType == Enum.UserInputType.Touch then
            sliding = true
            doSlide(i.Position.X)
        end
    end)

    UserInputService.InputChanged:Connect(function(i)
        if not sliding then return end
        if i.UserInputType == Enum.UserInputType.MouseMovement
        or i.UserInputType == Enum.UserInputType.Touch then
            doSlide(i.Position.X)
        end
    end)

    UserInputService.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1
        or i.UserInputType == Enum.UserInputType.Touch then
            sliding = false
        end
    end)
end

-- ========== UTILIDADES ==========
local function getPlayersOnScreen()
    local result = {}
    local centro = Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y / 2)
    local raio = (shootRad / 100) * RAIO_MAX

    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= lp and p.Character then
            local head = p.Character:FindFirstChild("Head")
            local hum = p.Character:FindFirstChildOfClass("Humanoid")
            if head and hum and hum.Health > 0 then
                local pos, vis = cam:WorldToViewportPoint(head.Position)
                if vis then
                    local dist = (Vector2.new(pos.X, pos.Y) - centro).Magnitude
                    if dist <= raio then
                        table.insert(result, {player = p, dist = dist, head = head})
                    end
                end
            end
        end
    end

    table.sort(result, function(a, b) return a.dist < b.dist end)
    return result
end

local function getClosestMoving()
    local best = nil
    local bestDist = math.huge
    local myRoot = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
    if not myRoot then return nil end

    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= lp and p.Character then
            local r = p.Character:FindFirstChild("HumanoidRootPart")
            local h = p.Character:FindFirstChildOfClass("Humanoid")
            if r and h and h.Health > 0 then
                local moving = h.MoveDirection.Magnitude > 0.1
                local d = (myRoot.Position - r.Position).Magnitude
                if moving and d < bestDist then
                    bestDist = d
                    best = p
                end
            end
        end
    end

    if not best then
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= lp and p.Character then
                local r = p.Character:FindFirstChild("HumanoidRootPart")
                local h = p.Character:FindFirstChildOfClass("Humanoid")
                if r and h and h.Health > 0 then
                    local d = (myRoot.Position - r.Position).Magnitude
                    if d < bestDist then
                        bestDist = d
                        best = p
                    end
                end
            end
        end
    end

    return best
end

-- ========== CRIAR AS 4 OPCOES ==========
opcao("🎯 Aimbot", "Trava mira em quem esta se movendo", function(v)
    aimbot = v
end)

opcao("💥 Shooting Box", "Atire e a bala acerta quem ta no circulo", function(v)
    shootbox = v
    if v then
        local r = (shootRad / 100) * RAIO_MAX

        circle = Instance.new("Frame")
        circle.Size = UDim2.new(0, r * 2, 0, r * 2)
        circle.Position = UDim2.new(0.5, -r, 0.5, -r)
        circle.BackgroundTransparency = 1
        circle.BorderSizePixel = 0
        circle.Parent = gui
        Instance.new("UICorner", circle).CornerRadius = UDim.new(1, 0)

        local linha = Instance.new("UIStroke", circle)
        linha.Color = Color3.fromRGB(255, 0, 60)
        linha.Thickness = 2
        linha.Transparency = 0

        local cruzH = Instance.new("Frame")
        cruzH.Size = UDim2.new(0, 14, 0, 2)
        cruzH.Position = UDim2.new(0.5, -7, 0.5, -1)
        cruzH.BackgroundColor3 = Color3.fromRGB(255, 0, 60)
        cruzH.BackgroundTransparency = 0.3
        cruzH.BorderSizePixel = 0
        cruzH.Parent = circle

        local cruzV = Instance.new("Frame")
        cruzV.Size = UDim2.new(0, 2, 0, 14)
        cruzV.Position = UDim2.new(0.5, -1, 0.5, -7)
        cruzV.BackgroundColor3 = Color3.fromRGB(255, 0, 60)
        cruzV.BackgroundTransparency = 0.3
        cruzV.BorderSizePixel = 0
        cruzV.Parent = circle
    else
        if circle then
            circle:Destroy()
            circle = nil
        end
    end
end)

criarSlider()

opcao("👁 ESP", "Mostra inimigos atras da parede", function(v)
    espOn = v
    if not v then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= lp and p.Character then
                local hl = p.Character:FindFirstChild("_HL")
                if hl then hl:Destroy() end
                local hd = p.Character:FindFirstChild("Head")
                if hd then
                    local bi = hd:FindFirstChild("_BI")
                    if bi then bi:Destroy() end
                end
            end
        end
    end
end)

opcao("⚔ Auto Dano", "Mira + atira automatico no mais proximo", function(v)
    autoDmg = v
end)

-- ========== SHOOTING BOX - SILENT AIM ==========
-- Quando voce atira, redireciona sua mira pro player
-- mais perto dentro do circulo. O dano vem da ARMA DO JOGO.
-- Nao seta health direto (sem bug invisivel).

UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if not shootbox or not circle then return end

    local isShoot = false
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        isShoot = true
    end
    if input.UserInputType == Enum.UserInputType.Touch then
        isShoot = true
    end

    if isShoot then
        local targets = getPlayersOnScreen()
        if #targets > 0 then
            local t = targets[1]
            if t.head then
                cam.CFrame = CFrame.new(cam.CFrame.Position, t.head.Position)
            end
        end
    end
end)

-- ========== ESP ==========
local function fazerESP(p)
    if p == lp then return end
    local char = p.Character
    if not char then return end

    if not char:FindFirstChild("_HL") then
        local hl = Instance.new("Highlight")
        hl.Name = "_HL"
        hl.FillColor = Color3.fromRGB(255, 0, 0)
        hl.FillTransparency = 0.7
        hl.OutlineColor = Color3.fromRGB(255, 255, 255)
        hl.OutlineTransparency = 0
        hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        hl.Parent = char
    end

    local head = char:FindFirstChild("Head")
    if head and not head:FindFirstChild("_BI") then
        local bill = Instance.new("BillboardGui")
        bill.Name = "_BI"
        bill.AlwaysOnTop = true
        bill.Size = UDim2.new(0, 120, 0, 50)
        bill.StudsOffset = Vector3.new(0, 2.5, 0)
        bill.MaxDistance = 500
        bill.Adornee = head
        bill.Parent = head

        local info = Instance.new("TextLabel")
        info.Name = "I"
        info.Size = UDim2.new(1, 0, 1, 0)
        info.BackgroundTransparency = 1
        info.TextColor3 = Color3.fromRGB(0, 255, 80)
        info.TextStrokeTransparency = 0
        info.TextStrokeColor3 = Color3.new(0, 0, 0)
        info.Font = Enum.Font.GothamBold
        info.TextSize = 13
        info.Text = p.Name
        info.Parent = bill
    end

    if head and head:FindFirstChild("_BI") then
        local hum = char:FindFirstChildOfClass("Humanoid")
        local info = head._BI:FindFirstChild("I")
        if hum and info then
            local hp = math.floor(hum.Health)
            local pct = hum.Health / hum.MaxHealth
            info.Text = p.Name .. "\n" .. hp .. " HP"
            if pct > 0.5 then
                info.TextColor3 = Color3.fromRGB(0, 255, 80)
            elseif pct > 0.25 then
                info.TextColor3 = Color3.fromRGB(255, 220, 0)
            else
                info.TextColor3 = Color3.fromRGB(255, 50, 50)
            end
        end
    end
end

-- ========== AUTO DANO (Mira + Atira Automatico) ==========
-- Funciona travando a mira e simulando cliques
-- O DANO VEM DA ARMA DO JOGO, nao seta health

local function autoAttack()
    if not autoDmg then return end
    local target = getClosestMoving()
    if not target or not target.Character then return end

    local head = target.Character:FindFirstChild("Head")
        or target.Character:FindFirstChild("HumanoidRootPart")
    if not head then return end

    -- Travar mira no alvo
    cam.CFrame = CFrame.new(cam.CFrame.Position, head.Position)

    -- Simular clique (faz sua arma atirar)
    pcall(function()
        local VIM = game:GetService("VirtualInputManager")
        local cx = cam.ViewportSize.X / 2
        local cy = cam.ViewportSize.Y / 2
        VIM:SendMouseButtonEvent(cx, cy, 0, true, game, 0)
        task.wait(0.05)
        VIM:SendMouseButtonEvent(cx, cy, 0, false, game, 0)
    end)
end

-- ========== LOOP PRINCIPAL ==========
RunService.Heartbeat:Connect(function()
    local myChar = lp.Character
    if not myChar then return end
    local myRoot = myChar:FindFirstChild("HumanoidRootPart")
    if not myRoot then return end

    -- ESP
    if espOn then
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= lp and p.Character then
                fazerESP(p)
            end
        end
    end

    -- AIMBOT
    if aimbot then
        local alvo = getClosestMoving()
        if alvo and alvo.Character then
            local head = alvo.Character:FindFirstChild("Head")
                or alvo.Character:FindFirstChild("HumanoidRootPart")
            if head then
                cam.CFrame = CFrame.new(cam.CFrame.Position, head.Position)
            end
        end
    end

    -- SHOOTING BOX (atualizar tamanho do circulo)
    if shootbox and circle then
        local r = (shootRad / 100) * RAIO_MAX
        circle.Size = UDim2.new(0, r * 2, 0, r * 2)
        circle.Position = UDim2.new(0.5, -r, 0.5, -r)
    end
end)

-- Auto Dano loop separado (atira a cada 0.3s)
task.spawn(function()
    while task.wait(0.3) do
        if autoDmg then
            autoAttack()
        end
    end
end)

-- RECONECTAR ESP
for _, p in ipairs(Players:GetPlayers()) do
    if p ~= lp then
        p.CharacterAdded:Connect(function()
            task.wait(1)
            if espOn then fazerESP(p) end
        end)
    end
end

Players.PlayerAdded:Connect(function(p)
    p.CharacterAdded:Connect(function()
        task.wait(1)
        if espOn then fazerESP(p) end
    end)
end)

print("Hack v8 carregado!")
