--[==[ [Mateo Hub - Protected Engine v3.2] ]==]
local _ENV = (getgenv or function() return _G end)()
local _U = {
    [1] = "\83\99\114\101\101\110\71\117\105",
    [2] = "\67\111\114\101\71\117\105",
    [3] = "\80\108\97\121\101\114\71\117\105",
    [4] = "\70\114\97\109\101",
    [5] = "\84\101\120\116\76\97\98\101\108",
    [6] = "\83\99\114\111\108\108\105\110\103\70\114\97\109\101",
    [7] = "\84\101\120\116\66\117\116\116\111\110",
    [8] = "\85\73\67\111\114\110\101\114",
    [9] = "\85\73\8\116\114\111\107\101"
}

local function _D(i)
    local t = _U[i] or ""
    local r = ""
    for c = 1, #t do r = r .. string.char(t:byte(c)) end
    return r
end

local _Thm = {
    ["Neon"] = {M = Color3.fromRGB(15, 15, 20), A = Color3.fromRGB(0, 255, 150), S = Color3.fromRGB(25, 25, 35), H = Color3.fromRGB(35, 35, 48)},
    ["Rojo"] = {M = Color3.fromRGB(20, 15, 15), A = Color3.fromRGB(255, 50, 50), S = Color3.fromRGB(35, 25, 25), H = Color3.fromRGB(48, 35, 35)},
    ["Oscuro"] = {M = Color3.fromRGB(12, 12, 12), A = Color3.fromRGB(80, 80, 80), S = Color3.fromRGB(20, 20, 20), H = Color3.fromRGB(30, 30, 30)},
    ["Amatista"] = {M = Color3.fromRGB(18, 14, 25), A = Color3.fromRGB(170, 85, 255), S = Color3.fromRGB(28, 22, 38), H = Color3.fromRGB(38, 30, 50)}
}

local _TS = game:GetService("TweenService")
local function _Tw(o, i, p)
    local t = _TS:Create(o, TweenInfo.new(unpack(i)), p)
    t:Play()
    return t
end

local _M = {}
_M.__index = _M

function _M:CrearWindow(cfg)
    local s = setmetatable({}, _M)
    s._N = cfg.Nombre or "Mateo Hub"
    s._S = cfg.Subtitulo or "by Mateo"
    s._TName = cfg.Tema or "Neon"
    s._RGB = cfg.BordesRGB or false
    s._CThm = _Thm[s._TName] or _Thm["Neon"]
    s.TC = 0
    
    local PL = game:GetService("Players")
    local LP = PL.LocalPlayer
    local CG = game:GetService("CoreGui")
    local RS = game:GetService("RunService")
    local UIS = game:GetService("UserInputService")
    
    if s.SG then s.SG:Destroy() end
    s.SG = Instance.new(_D(1))
    s.SG.Name = "\77\97\116\101\111\72\117\98\83\101\99\117\114\101\85\73"
    s.SG.ResetOnSpawn = false
    pcall(function() s.SG.Parent = CG end)
    if not s.SG.Parent then s.SG.Parent = LP:WaitForChild(_D(3)) end
    
    s.MF = Instance.new(_D(4))
    s.MF.Size = UDim2.new(0, 420, 0, 260)
    s.MF.Position = UDim2.new(0.5, -210, 0.5, -130)
    s.MF.BackgroundColor3 = s._CThm.M
    s.MF.BorderSizePixel = 0
    s.MF.Parent = s.SG
    
    Instance.new(_D(8), s.MF).CornerRadius = UDim.new(0, 8)
    
    local dg, di, ds, dp
    s.MF.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
            dg = true
            ds = inp.Position
            dp = s.MF.Position
            inp.Changed:Connect(function()
                if inp.UserInputState == Enum.UserInputState.End then dg = false end
            end)
        end
    end)
    s.MF.InputChanged:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch then di = inp end
    end)
    UIS.InputChanged:Connect(function(inp)
        if inp == di and dg then
            local dl = inp.Position - ds
            s.MF.Position = UDim2.new(dp.X.Scale, dp.X.Offset + dl.X, dp.Y.Scale, dp.Y.Offset + dl.Y)
        end
    end)
    
    local rs = Instance.new(_D(9))
    rs.Thickness = 2
    rs.Parent = s.MF
    if s._RGB then
        task.spawn(function()
            local h = 0
            while s.MF and s.MF.Parent do
                h = (h + 0.01) % 1
                rs.Color = Color3.fromHSV(h, 1, 1)
                RS.RenderStepped:Wait()
            end
        end)
    else
        rs.Color = s._CThm.A
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
    
    local cb = Instance.new(_D(7), s.MF)
    cb.Size = UDim2.new(0, 20, 0, 20)
    cb.Position = UDim2.new(1, -26, 0, 5)
    cb.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    cb.Text = "X"
    cb.TextColor3 = Color3.fromRGB(255, 255, 255)
    cb.Font = Enum.Font.GothamBold
    cb.TextSize = 9
    Instance.new(_D(8), cb).CornerRadius = UDim.new(1, 0)
    cb.MouseButton1Click:Connect(function() s.SG:Destroy() end)
    
    local mz = false
    local mb = Instance.new(_D(7), s.MF)
    mb.Size = UDim2.new(0, 20, 0, 20)
    mb.Position = UDim2.new(1, -50, 0, 5)
    mb.BackgroundColor3 = Color3.fromRGB(220, 150, 50)
    mb.Text = "-"
    mb.TextColor3 = Color3.fromRGB(255, 255, 255)
    mb.Font = Enum.Font.GothamBold
    mb.TextSize = 11
    Instance.new(_D(8), mb).CornerRadius = UDim.new(1, 0)
    mb.MouseButton1Click:Connect(function()
        mz = not mz
        if s.TH then s.TH.Visible = not mz end
        if s.PCC then s.PCC.Visible = not mz end
        _Tw(s.MF, {0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out}, {Size = mz and UDim2.new(0, 420, 0, 30) or UDim2.new(0, 420, 0, 260)})
    end)
    
    s.TH = Instance.new(_D(6))
    s.TH.Size = UDim2.new(0, 110, 1, -38)
    s.TH.Position = UDim2.new(0, 8, 0, 32)
    s.TH.BackgroundTransparency = 1
    s.TH.CanvasSize = UDim2.new(0, 0, 0, 0)
    s.TH.ScrollBarThickness = 2
    s.TH.Parent = s.MF
    
    local ul = Instance.new("\85\73\76\105\115\116\76\97\121\111\117\116")
    ul.Padding = UDim.new(0, 4)
    ul.Parent = s.TH
    
    s.PCC = Instance.new(_D(4), s.MF)
    s.PCC.Size = UDim2.new(1, -125, 1, -38)
    s.PCC.Position = UDim2.new(0, 120, 0, 32)
    s.PCC.BackgroundTransparency = 1
    
    return s
end

function _M:CrearTab(tn)
    if not self.PCC then return end
    local s = self
    s.TC = s.TC + 1
    
    local tb = Instance.new(_D(7))
    tb.Size = UDim2.new(1, 0, 0, 28)
    tb.BackgroundColor3 = s._CThm.S
    tb.Font = Enum.Font.GothamMedium
    tb.Text = " " .. tn
    tb.TextColor3 = Color3.fromRGB(160, 160, 160)
    tb.TextSize = 11
    tb.TextXAlignment = Enum.TextXAlignment.Left
    tb.Parent = s.TH
    Instance.new(_D(8), tb).CornerRadius = UDim.new(0, 6)
    
    local tp = Instance.new(_D(6))
    tp.Size = UDim2.new(1, 0, 1, 0)
    tp.Position = UDim2.new(0, 0, 0, 0)
    tp.BackgroundTransparency = 1
    tp.Visible = false
    tp.CanvasSize = UDim2.new(0, 0, 0, 0)
    tp.ScrollBarThickness = 2
    tp.Parent = s.PCC
    
    local pl = Instance.new("\85\73\76\105\115\116\76\97\121\111\117\116")
    pl.Padding = UDim.new(0, 6)
    pl.Parent = tp
    
    pl:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        tp.CanvasSize = UDim2.new(0, 0, 0, pl.AbsoluteContentSize.Y + 15)
    end)
    
    tb.MouseButton1Click:Connect(function()
        for _, p in ipairs(s.PCC:GetChildren()) do if p:IsA(_D(6)) then p.Visible = false end end
        for _, b in ipairs(s.TH:GetChildren()) do if b:IsA(_D(7)) then _Tw(b, {0.2}, {TextColor3 = Color3.fromRGB(160, 160, 160), BackgroundColor3 = s._CThm.S}) end end
        tp.Visible = true
        _Tw(tb, {0.2}, {TextColor3 = s._CThm.A, BackgroundColor3 = s._CThm.H})
    end)
    
    if s.TC == 1 then
        tp.Visible = true
        tb.TextColor3 = s._CThm.A
        tb.BackgroundColor3 = s._CThm.H
    end
    
    local El = {}
    
    function El:AddButton(txt, cb)
        local b = Instance.new(_D(7))
        b.Size = UDim2.new(1, -6, 0, 30)
        b.BackgroundColor3 = s._CThm.S
        b.Font = Enum.Font.Gotham
        b.Text = " " .. txt
        b.TextColor3 = Color3.fromRGB(220, 220, 220)
        b.TextSize = 11
        b.TextXAlignment = Enum.TextXAlignment.Left
        b.Parent = tp
        Instance.new(_D(8), b).CornerRadius = UDim.new(0, 6)
        b.MouseButton1Click:Connect(function() if cb then pcall(cb) end end)
    end
    
    function El:AddToggle(txt, cb)
        local tg = false
        local b = Instance.new(_D(7))
        b.Size = UDim2.new(1, -6, 0, 30)
        b.BackgroundColor3 = s._CThm.S
        b.Font = Enum.Font.Gotham
        b.Text = " " .. txt
        b.TextColor3 = Color3.fromRGB(220, 220, 220)
        b.TextSize = 11
        b.TextXAlignment = Enum.TextXAlignment.Left
        b.Parent = tp
        Instance.new(_D(8), b).CornerRadius = UDim.new(0, 6)
        
        local ind = Instance.new(_D(4), b)
        ind.Size = UDim2.new(0, 16, 0, 16)
        ind.Position = UDim2.new(1, -22, 0.5, -8)
        ind.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
        Instance.new(_D(8), ind).CornerRadius = UDim.new(1, 0)
        
        b.MouseButton1Click:Connect(function()
            tg = not tg
            _Tw(ind, {0.2}, {BackgroundColor3 = tg and s._CThm.A or Color3.fromRGB(50, 50, 60)})
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
        lbl.Parent = tp
        return lbl
    end

    function El:AddDropdown(txt, list, cb)
        local op = false
        local df = Instance.new(_D(4))
        df.Size = UDim2.new(1, -6, 0, 30)
        df.BackgroundColor3 = s._CThm.S
        df.ClipsDescendants = true
        df.Parent = tp
        Instance.new(_D(8), df).CornerRadius = UDim.new(0, 6)
        
        local mb = Instance.new(_D(7), df)
        mb.Size = UDim2.new(1, 0, 0, 30)
        mb.BackgroundTransparency = 1
        mb.Font = Enum.Font.Gotham
        mb.Text = "  " .. txt .. " ▾"
        mb.TextColor3 = Color3.fromRGB(220, 220, 220)
        mb.TextSize = 11
        mb.TextXAlignment = Enum.TextXAlignment.Left
        
        local ll = Instance.new("\85\73\76\105\115\116\76\97\121\111\117\116")
        ll.Padding = UDim.new(0, 2)
        ll.Parent = df
        
        local function uh()
            if op then
                local ch = 35 + (#list * 26)
                _Tw(df, {0.2}, {Size = UDim2.new(1, -6, 0, ch)})
                mb.Text = "  " .. txt .. " ▴"
            else
                _Tw(df, {0.2}, {Size = UDim2.new(1, -6, 0, 30)})
                mb.Text = "  " .. txt .. " ▾"
            end
        end
        
        for _, item in ipairs(list) do
            local ib = Instance.new(_D(7), df)
            ib.Size = UDim2.new(1, -10, 0, 24)
            ib.Position = UDim2.new(0, 5, 0, 0)
            ib.BackgroundColor3 = s._CThm.M
            ib.Font = Enum.Font.Gotham
            ib.Text = "   " .. tostring(item)
            ib.TextColor3 = Color3.fromRGB(180, 180, 180)
            ib.TextSize = 10
            ib.TextXAlignment = Enum.TextXAlignment.Left
            Instance.new(_D(8), ib).CornerRadius = UDim.new(0, 4)
            
            ib.MouseButton1Click:Connect(function()
                op = false
                uh()
                pcall(cb, item)
            end)
        end
        
        mb.MouseButton1Click:Connect(function()
            op = not op
            uh()
        end)
    end
    
    return El
end

return _M
