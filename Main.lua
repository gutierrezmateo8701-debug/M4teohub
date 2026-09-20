--[==[ [Mateo Hub - Final UI Fix Engine] ]==]
local _ENV = (getgenv or function() return _G end)()
local _U = {
    [1] = "\83\99\114\101\101\110\71\117\105",
    [2] = "\67\111\114\101\71\117\105",
    [3] = "\80\108\97\121\101\114\71\117\105",
    [4] = "\70\114\97\109\101",
    [5] = "\84\101\120\116\76\97\98\101\10l",
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
    ["Neon"] = {Main = Color3.fromRGB(15, 15, 20), Accent = Color3.fromRGB(0, 255, 150), Secondary = Color3.fromRGB(25, 25, 35), Hover = Color3.fromRGB(35, 35, 48)},
    ["Rojo"] = {Main = Color3.fromRGB(20, 15, 15), Accent = Color3.fromRGB(255, 50, 50), Secondary = Color3.fromRGB(35, 25, 25), Hover = Color3.fromRGB(48, 35, 35)},
    ["Oscuro"] = {Main = Color3.fromRGB(12, 12, 12), Accent = Color3.fromRGB(80, 80, 80), Secondary = Color3.fromRGB(20, 20, 20), Hover = Color3.fromRGB(30, 30, 30)},
    ["Amatista"] = {Main = Color3.fromRGB(18, 14, 25), Accent = Color3.fromRGB(170, 85, 255), Secondary = Color3.fromRGB(28, 22, 38), Hover = Color3.fromRGB(38, 30, 50)}
}

local TS = game:GetService("TweenService")
local function Tween(obj, info, props)
    local t = TS:Create(obj, TweenInfo.new(unpack(info)), props)
    t:Play()
    return t
end

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
        
        s.MF = Instance.new(_D(4))
        s.MF.Size = UDim2.new(0, 420, 0, 260)
        s.MF.Position = UDim2.new(0.5, -210, 0.5, -130)
        s.MF.BackgroundColor3 = s._CurrTheme.Main
        s.MF.BorderSizePixel = 0
        s.MF.Parent = s.SG
        
        Instance.new(_D(8), s.MF).CornerRadius = UDim.new(0, 8)
        
        s.MF.Size = UDim2.new(0, 0, 0, 0)
        Tween(s.MF, {0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out}, {Size = UDim2.new(0, 420, 0, 260)})
        
        local dragging, dragInput, dragStart, startPos
        s.MF.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                dragStart = input.Position
                startPos = s.MF.Position
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then dragging = false end
                end)
            end
        end)
        s.MF.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
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
        
        local closeBtn = Instance.new(_D(7), s.MF)
        closeBtn.Size = UDim2.new(0, 20, 0, 20)
        closeBtn.Position = UDim2.new(1, -26, 0, 5)
        closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        closeBtn.Text = "X"
        closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        closeBtn.Font = Enum.Font.GothamBold
        closeBtn.TextSize = 9
        Instance.new(_D(8), closeBtn).CornerRadius = UDim.new(1, 0)
        
        closeBtn.MouseButton1Click:Connect(function()
            Tween(s.MF, {0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In}, {Size = UDim2.new(0, 0, 0, 0)})
            task.wait(0.2)
            s.SG:Destroy()
        end)
        
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
            Tween(s.MF, {0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out}, {Size = minimized and UDim2.new(0, 420, 0, 30) or UDim2.new(0, 420, 0, 260)})
        end)
        
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
        
        s.PCContainer = Instance.new(_D(4), s.MF)
        s.PCContainer.Size = UDim2.new(1, -125, 1, -38)
        s.PCContainer.Position = UDim2.new(0, 120, 0, 32)
        s.PCContainer.BackgroundTransparency = 1
    end
    
    _Build()
    return s
end

function _M:CrearTab(tn)
    if not self.PCContainer then return end
    local s = self
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
    PL.Padding = UDim.new(0, 6)
    PL.Parent = TP
    
    PL:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        TP.CanvasSize = UDim2.new(0, 0, 0, PL.AbsoluteContentSize.Y + 15)
    end)
    
    TB.MouseButton1Click:Connect(function()
        for _, p in ipairs(s.PCContainer:GetChildren()) do if p:IsA(_D(6)) then p.Visible = false end end
        for _, b in ipairs(s.TH:GetChildren()) do if b:IsA(_D(7)) then Tween(b, {0.2}, {TextColor3 = Color3.fromRGB(160, 160, 160), BackgroundColor3 = s._CurrTheme.Secondary}) end end
        TP.Visible = true
        Tween(TB, {0.2}, {TextColor3 = s._CurrTheme.Accent, BackgroundColor3 = s._CurrTheme.Hover})
    end)
    
    if s.TabsCount == 1 then
        TP.Visible = true
        TB.TextColor3 = s._CurrTheme.Accent
        TB.BackgroundColor3 = s._CurrTheme.Hover
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
        b.MouseButton1Click:Connect(function() if cb then pcall(cb) end end)
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
            Tween(ind, {0.2}, {BackgroundColor3 = tg and s._CurrTheme.Accent or Color3.fromRGB(50, 50, 60)})
            pcall(cb, tg)
        end)
    end
    
    function El:AddLabel(txt)
        local lbl = Instance.new(_D(5))
        lbl.Size = UDim2.new(1, -6, 0, 20)
        lbl.BackgroundTransparency = 1
        lbl.Font = Enum.Font.GothamMedium
        lbl.Text = " " .. txt
        lbl.TextColor3 = Color3.fromRGB(180, 180, 180)
        lbl.TextSize = 11
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.Parent = TP
        return lbl
    end

    function El:AddDropdown(txt, list, cb)
        local open = false
        local dropFrame = Instance.new(_D(4))
        dropFrame.Size = UDim2.new(1, -6, 0, 30)
        dropFrame.BackgroundColor3 = s._CurrTheme.Secondary
        dropFrame.ClipsDescendants = true
        dropFrame.Parent = TP
        Instance.new(_D(8), dropFrame).CornerRadius = UDim.new(0, 6)
        
        local mainBtn = Instance.new(_D(7), dropFrame)
        mainBtn.Size = UDim2.new(1, 0, 0, 30)
        mainBtn.BackgroundTransparency = 1
        mainBtn.Font = Enum.Font.Gotham
        mainBtn.Text = "  " .. txt .. " ▾"
        mainBtn.TextColor3 = Color3.fromRGB(220, 220, 220)
        mainBtn.TextSize = 11
        mainBtn.TextXAlignment = Enum.TextXAlignment.Left
        
        local listLayout = Instance.new("UIListLayout")
        listLayout.Padding = UDim.new(0, 2)
        listLayout.Parent = dropFrame
        
        local function updateHeight()
            if open then
                local contentH = 35 + (#list * 26)
                Tween(dropFrame, {0.2}, {Size = UDim2.new(1, -6, 0, contentH)})
                mainBtn.Text = "  " .. txt .. " ▴"
            else
                Tween(dropFrame, {0.2}, {Size = UDim2.new(1, -6, 0, 30)})
                mainBtn.Text = "  " .. txt .. " ▾"
            end
        end
        
        for _, item in ipairs(list) do
            local itemBtn = Instance.new(_D(7), dropFrame)
            itemBtn.Size = UDim2.new(1, -10, 0, 24)
            itemBtn.Position = UDim2.new(0, 5, 0, 0)
            itemBtn.BackgroundColor3 = s._CurrTheme.Main
            itemBtn.Font = Enum.Font.Gotham
            itemBtn.Text = "   " .. tostring(item)
            itemBtn.TextColor3 = Color3.fromRGB(180, 180, 180)
            itemBtn.TextSize = 10
            itemBtn.TextXAlignment = Enum.TextXAlignment.Left
            Instance.new(_D(8), itemBtn).CornerRadius = UDim.new(0, 4)
            
            itemBtn.MouseButton1Click:Connect(function()
                open = false
                updateHeight()
                pcall(cb, item)
            end)
        end
        
        mainBtn.MouseButton1Click:Connect(function()
            open = not open
            updateHeight()
        end)
    end
    
    return El
end

return _M
