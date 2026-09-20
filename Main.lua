--[==[ [Mateo Hub - Draggable & Fixed Engine] ]==]
local _ENV = (getgenv or function() return _G end)()
local _U = {
    [1] = "\83\99\114\101\101\110\71\117\105",
    [2] = "\67\111\114\101\71\117\105",
    [3] = "\80\108\97\121\101\114\71\117\105",
    [4] = "\70\114\97\109\101",
    [5] = "\84\101\120\116\76\97\98\101\108",
    [6] = "\83\99\114\111\108\108\105\110\103\70\114\97\109\101",
    [7] = "\84\101\120\116\66\117\116\116\111\110",
    [8] = "\85\73\67\111\114\110\101\114"
}

local function _D(i)
    local t = _U[i] or ""
    local r = ""
    for c = 1, #t do r = r .. string.char(t:byte(c)) end
    return r
end

local Themes = {
    ["Neon"] = {Main = Color3.fromRGB(15, 15, 20), Accent = Color3.fromRGB(0, 255, 150), Secondary = Color3.fromRGB(25, 25, 35)},
    ["Rojo"] = {Main = Color3.fromRGB(20, 15, 15), Accent = Color3.fromRGB(255, 50, 50), Secondary = Color3.fromRGB(35, 25, 25)},
    ["Oscuro"] = {Main = Color3.fromRGB(12, 12, 12), Accent = Color3.fromRGB(80, 80, 80), Secondary = Color3.fromRGB(20, 20, 20)},
    ["Amatista"] = {Main = Color3.fromRGB(18, 14, 25), Accent = Color3.fromRGB(170, 85, 255), Secondary = Color3.fromRGB(28, 22, 38)}
}

local _M = {}
_M.__index = _M

function _M:CrearWindow(cfg)
    local s = setmetatable({}, _M)
    s._N = cfg.Nombre or "Mateo Hub"
    s._S = cfg.Subtitulo or "by Mateo"
    s._KS = cfg.KeySistem or "No"
    s._K = cfg.Key or ""
    s._ThemeName = cfg.Tema or "Neon"
    s._RGB = cfg.BordesRGB or false
    s._CurrTheme = Themes[s._ThemeName] or Themes["Neon"]
    s.TabsCount = 0
    
    local PL = game:GetService("Players")
    local LP = PL.LocalPlayer
    local CG = game:GetService("CoreGui")
    local RS = game:GetService("RunService")
    local UIS = game:GetService("UserInputService")
    
    local function _Build()
        if s.SG then s.SG:Destroy() end
        s.SG = Instance.new(_D(1))
        s.SG.Name = "MateoHubSecureUI"
        s.SG.ResetOnSpawn = false
        pcall(function() s.SG.Parent = CG end)
        if not s.SG.Parent then s.SG.Parent = LP:WaitForChild(_D(3)) end
        
        -- Tamaño más chico y compacto (420x260)
        s.MF = Instance.new(_D(4))
        s.MF.Size = UDim2.new(0, 420, 0, 260)
        s.MF.Position = UDim2.new(0.5, -210, 0.5, -130)
        s.MF.BackgroundColor3 = s._CurrTheme.Main
        s.MF.BorderSizePixel = 0
        s.MF.Parent = s.SG
        
        Instance.new(_D(8), s.MF).CornerRadius = UDim.new(0, 8)
        
        -- Sistema para arrastrar la GUI (Draggable)
        local dragging, dragInput, dragStart, startPos
        s.MF.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                dragStart = input.Position
                startPos = s.MF.Position
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        dragging = false
                    end
                end)
            end
        end)
        
        s.MF.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                dragInput = input
            end
        end)
        
        UIS.InputChanged:Connect(function(input)
            if input == dragInput and dragging then
                local delta = input.Position - dragStart
                s.MF.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
        end)
        
        local rgbStroke = Instance.new("UIStroke")
        rgbStroke.Thickness = 2
        rgbStroke.Parent = s.MF
        if s._RGB then
            task.spawn(function()
                local h = 0
                while s.MF and s.MF.Parent do
                    h = (h + 0.01) % 1
                    rgbStroke.Color = Color3.fromHSV(h, 1, 1)
                    RS.RenderStepped:Wait()
                end
            end)
        else
            rgbStroke.Color = s._CurrTheme.Accent
        end
        
        s.TL = Instance.new(_D(5))
        s.TL.Size = UDim2.new(1, -80, 0, 30)
        s.TL.Position = UDim2.new(0, 8, 0, 0)
        s.TL.BackgroundTransparency = 1
        s.TL.Font = Enum.Font.GothamBold
        s.TL.Text = s._N .. " <font color='#00AAFF'>| " .. s._S .. "</font>"
        s.TL.RichText = true
        s.TL.TextColor3 = Color3.fromRGB(255, 255, 255)
        s.TL.TextSize = 13
        s.TL.TextXAlignment = Enum.TextXAlignment.Left
        s.TL.Parent = s.MF
        
        -- Botón Cerrar
        local closeBtn = Instance.new(_D(7), s.MF)
        closeBtn.Size = UDim2.new(0, 20, 0, 20)
        closeBtn.Position = UDim2.new(1, -26, 0, 5)
        closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        closeBtn.Text = "X"
        closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        closeBtn.Font = Enum.Font.GothamBold
        closeBtn.TextSize = 9
        Instance.new(_D(8), closeBtn).CornerRadius = UDim.new(1, 0)
        closeBtn.MouseButton1Click:Connect(function() s.SG:Destroy() end)
        
        -- Botón Minimizar
        local minimized = false
        local minBtn = Instance.new(_D(7), s.MF)
        minBtn.Size = UDim2.new(0, 20, 0, 20)
        minBtn.Position = UDim2.new(1, -50, 0, 5)
        minBtn.BackgroundColor3 = Color3.fromRGB(220, 150, 50)
        minBtn.Text = "-"
        minBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        minBtn.Font = Enum.Font.GothamBold
        minBtn.TextSize = 11
        Instance.new(_D(8), minBtn).CornerRadius = UDim.new(1, 0)
        
        minBtn.MouseButton1Click:Connect(function()
            minimized = not minimized
            if s.TH then s.TH.Visible = not minimized end
            if s.PCContainer then s.PCContainer.Visible = not minimized end
            s.MF.Size = minimized and UDim2.new(0, 420, 0, 30) or UDim2.new(0, 420, 0, 260)
        end)
        
        -- Contenedor de Pestañas (Izquierda)
        s.TH = Instance.new(_D(6))
        s.TH.Size = UDim2.new(0, 110, 1, -38)
        s.TH.Position = UDim2.new(0, 8, 0, 32)
        s.TH.BackgroundTransparency = 1
        s.TH.CanvasSize = UDim2.new(0, 0, 0, 0)
        s.TH.ScrollBarThickness = 2
        s.TH.Parent = s.MF
        
        local UL = Instance.new("UIListLayout")
        UL.Padding = UDim.new(0, 4)
        UL.Parent = s.TH
        
        -- Contenedor General para las Páginas (Derecha)
        s.PCContainer = Instance.new(_D(4), s.MF)
        s.PCContainer.Size = UDim2.new(1, -125, 1, -38)
        s.PCContainer.Position = UDim2.new(0, 120, 0, 32)
        s.PCContainer.BackgroundTransparency = 1
    end
    
    if s._KS == "Si" then
        local KG = Instance.new(_D(1))
        pcall(function() KG.Parent = CG end)
        if not KG.Parent then KG.Parent = LP:WaitForChild(_D(3)) end
        
        local KF = Instance.new(_D(4), KG)
        KF.Size = UDim2.new(0, 280, 0, 150)
        KF.Position = UDim2.new(0.5, -140, 0.5, -75)
        KF.BackgroundColor3 = s._CurrTheme.Main
        Instance.new(_D(8), KF).CornerRadius = UDim.new(0, 8)
        
        local kStroke = Instance.new("UIStroke", KF)
        kStroke.Thickness = 2
        kStroke.Color = s._CurrTheme.Accent
        
        local kTitle = Instance.new(_D(5), KF)
        kTitle.Size = UDim2.new(1, -20, 0, 25)
        kTitle.Position = UDim2.new(0, 10, 0, 8)
        kTitle.BackgroundTransparency = 1
        kTitle.Font = Enum.Font.GothamBold
        kTitle.Text = s._N .. " - Key System"
        kTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
        kTitle.TextSize = 13
        kTitle.TextXAlignment = Enum.TextXAlignment.Center
        
        local KB = Instance.new("TextBox", KF)
        KB.Size = UDim2.new(0.85, 0, 0, 30)
        KB.Position = UDim2.new(0.075, 0, 0.38, 0)
        KB.PlaceholderText = "Ingresa tu key..."
        KB.Text = ""
        KB.BackgroundColor3 = s._CurrTheme.Secondary
        KB.TextColor3 = Color3.fromRGB(255, 255, 255)
        KB.Font = Enum.Font.Gotham
        KB.TextSize = 11
        Instance.new(_D(8), KB).CornerRadius = UDim.new(0, 6)
        
        local BT = Instance.new(_D(7), KF)
        BT.Size = UDim2.new(0.85, 0, 0, 30)
        BT.Position = UDim2.new(0.075, 0, 0.68, 0)
        BT.Text = "Verificar Key"
        BT.BackgroundColor3 = s._CurrTheme.Accent
        BT.TextColor3 = Color3.fromRGB(255, 255, 255)
        BT.Font = Enum.Font.GothamBold
        BT.TextSize = 11
        Instance.new(_D(8), BT).CornerRadius = UDim.new(0, 6)
        
        BT.MouseButton1Click:Connect(function()
            if KB.Text == s._K or s._K == "" then
                KG:Destroy()
                _Build()
            else
                KB.Text = ""
                KB.PlaceholderText = "¡Key Incorrecta!"
            end
        end)
    else
        _Build()
    end
    
    return s
end

function _M:CrearTab(tn)
    if not self.PCContainer then return end
    s = self
    s.TabsCount = s.TabsCount + 1
    
    local TB = Instance.new(_D(7))
    TB.Size = UDim2.new(1, 0, 0, 28)
    TB.BackgroundColor3 = s._CurrTheme.Secondary
    TB.Font = Enum.Font.GothamMedium
    TB.Text = " " .. tn
    TB.TextColor3 = Color3.fromRGB(160, 160, 160)
    TB.TextSize = 11
    TB.TextXAlignment = Enum.TextXAlignment.Left
    TB.Parent = s.TH
    Instance.new(_D(8), TB).CornerRadius = UDim.new(0, 6)
    
    local TP = Instance.new(_D(6))
    TP.Size = UDim2.new(1, 0, 1, 0)
    TP.Position = UDim2.new(0, 0, 0, 0)
    TP.BackgroundTransparency = 1
    TP.Visible = false
    TP.CanvasSize = UDim2.new(0, 0, 0, 0)
    TP.ScrollBarThickness = 2
    TP.Parent = s.PCContainer
    
    local PL = Instance.new("UIListLayout")
    PL.Padding = UDim.new(0, 5)
    PL.Parent = TP
    
    PL:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        TP.CanvasSize = UDim2.new(0, 0, 0, PL.AbsoluteContentSize.Y + 10)
    end)
    
    TB.MouseButton1Click:Connect(function()
        for _, p in ipairs(s.PCContainer:GetChildren()) do
            if p:IsA(_D(6)) then p.Visible = false end
        end
        for _, b in ipairs(s.TH:GetChildren()) do
            if b:IsA(_D(7)) then b.TextColor3 = Color3.fromRGB(160, 160, 160) end
        end
        TP.Visible = true
        TB.TextColor3 = s._CurrTheme.Accent
    end)
    
    if s.TabsCount == 1 then
        TP.Visible = true
        TB.TextColor3 = s._CurrTheme.Accent
    end
    
    local El = {}
    
    function El:AddButton(txt, cb)
        local b = Instance.new(_D(7))
        b.Size = UDim2.new(1, -6, 0, 30)
        b.BackgroundColor3 = s._CurrTheme.Secondary
        b.Font = Enum.Font.Gotham
        b.Text = " " .. txt
        b.TextColor3 = Color3.fromRGB(220, 220, 220)
        b.TextSize = 11
        b.TextXAlignment = Enum.TextXAlignment.Left
        b.Parent = TP
        Instance.new(_D(8), b).CornerRadius = UDim.new(0, 6)
        
        b.MouseButton1Click:Connect(function()
            if cb then pcall(cb) end
        end)
    end
    
    function El:AddToggle(txt, cb)
        local tg = false
        local b = Instance.new(_D(7))
        b.Size = UDim2.new(1, -6, 0, 30)
        b.BackgroundColor3 = s._CurrTheme.Secondary
        b.Font = Enum.Font.Gotham
        b.Text = " " .. txt
        b.TextColor3 = Color3.fromRGB(220, 220, 220)
        b.TextSize = 11
        b.TextXAlignment = Enum.TextXAlignment.Left
        b.Parent = TP
        Instance.new(_D(8), b).CornerRadius = UDim.new(0, 6)
        
        local ind = Instance.new(_D(4), b)
        ind.Size = UDim2.new(0, 16, 0, 16)
        ind.Position = UDim2.new(1, -22, 0.5, -8)
        ind.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
        Instance.new(_D(8), ind).CornerRadius = UDim.new(1, 0)
        
        b.MouseButton1Click:Connect(function()
            tg = not tg
            ind.BackgroundColor3 = tg and s._CurrTheme.Accent or Color3.fromRGB(50, 50, 60)
            pcall(cb, tg)
        end)
    end
    
    function El:AddSlider(txt, min, max, cb)
        local sl = Instance.new(_D(4))
        sl.Size = UDim2.new(1, -6, 0, 42)
        sl.BackgroundColor3 = s._CurrTheme.Secondary
        sl.Parent = TP
        Instance.new(_D(8), sl).CornerRadius = UDim.new(0, 6)
        
        local lb = Instance.new(_D(5), sl)
        lb.Size = UDim2.new(1, -8, 0, 18)
        lb.Position = UDim2.new(0, 5, 0, 3)
        lb.BackgroundTransparency = 1
        lb.Font = Enum.Font.Gotham
        lb.Text = " " .. txt .. ": " .. tostring(min)
        lb.TextColor3 = Color3.fromRGB(220, 220, 220)
        lb.TextSize = 10
        lb.TextXAlignment = Enum.TextXAlignment.Left
        
        local br = Instance.new(_D(4), sl)
        br.Size = UDim2.new(1, -14, 0, 5)
        br.Position = UDim2.new(0, 7, 0, 26)
        br.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
        Instance.new(_D(8), br).CornerRadius = UDim.new(1, 0)
        
        local fl = Instance.new(_D(4), br)
        fl.Size = UDim2.new(0, 0, 1, 0)
        fl.BackgroundColor3 = s._CurrTheme.Accent
        Instance.new(_D(8), fl).CornerRadius = UDim.new(1, 0)
        
        local dr = false
        br.InputBegan:Connect(function(io)
            if io.UserInputType == Enum.UserInputType.MouseButton1 or io.UserInputType == Enum.UserInputType.Touch then dr = true end
        end)
        game:GetService("UserInputService").InputEnded:Connect(function(io)
            if io.UserInputType == Enum.UserInputType.MouseButton1 or io.UserInputType == Enum.UserInputType.Touch then dr = false end
        end)
        game:GetService("UserInputService").InputChanged:Connect(function(io)
            if dr and (io.UserInputType == Enum.UserInputType.MouseMovement or io.UserInputType == Enum.UserInputType.Touch) then
                local ps = math.clamp((io.Position.X - br.AbsolutePosition.X) / br.AbsoluteSize.X, 0, 1)
                fl.Size = UDim2.new(ps, 0, 1, 0)
                local vl = math.floor(min + ((max - min) * ps))
                lb.Text = " " .. txt .. ": " .. tostring(vl)
                pcall(cb, vl)
            end
        end)
    end
    
    function El:AddTextbox(txt, ph, cb)
        local bx = Instance.new(_D(4))
        bx.Size = UDim2.new(1, -6, 0, 30)
        bx.BackgroundColor3 = s._CurrTheme.Secondary
        bx.Parent = TP
        Instance.new(_D(8), bx).CornerRadius = UDim.new(0, 6)
        
        local inp = Instance.new("TextBox", bx)
        inp.Size = UDim2.new(1, -10, 1, 0)
        inp.Position = UDim2.new(0, 5, 0, 0)
        inp.BackgroundTransparency = 1
        inp.Font = Enum.Font.Gotham
        inp.PlaceholderText = ph or txt
        inp.Text = ""
        inp.TextColor3 = Color3.fromRGB(255, 255, 255)
        inp.PlaceholderColor3 = Color3.fromRGB(120, 120, 120)
        inp.TextSize = 10
        inp.TextXAlignment = Enum.TextXAlignment.Left
        
        inp.FocusLost:Connect(function(ep)
            if ep then pcall(cb, inp.Text) end
        end)
    end
    
    return El
end

return _M
