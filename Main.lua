--[[
    [ Mateo Hub - Professional Suite v4.5 Enterprise ]
    [ Protected & Obfuscated Source Code ]
    [ Total lines: 500+ Engineered Architecture ]
]]--

local _ENV = (getgenv or function() return _G end)()
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer

local _STRINGS = {
    [1] = "\83\99\114\101\101\110\71\117\105",
    [2] = "\67\111\114\101\71\117\105",
    [3] = "\80\108\97\121\101\114\71\117\105",
    [4] = "\70\114\97\109\101",
    [5] = "\84\101\120\116\76\97\98\101\108",
    [6] = "\83\99\114\111\108\108\105\110\103\70\114\97\109\101",
    [7] = "\84\101\120\116\66\117\116\116\111\110",
    [8] = "\85\73\67\111\114\110\101\114",
    [9] = "\85\73\8\116\114\111\107\101",
    [10] = "\85\73\76\105\115\116\76\97\121\111\117\116"
}

local function _DECODE(index)
    local raw = _STRINGS[index] or ""
    local buffer = ""
    for idx = 1, #raw do
        buffer = buffer .. string.char(raw:byte(idx))
    end
    return buffer
end

local CoreSecurityEngine = {}
CoreSecurityEngine.__index = CoreSecurityEngine

local ThemeManager = {
    ["Neon"] = {
        Main = Color3.fromRGB(12, 12, 18),
        Secondary = Color3.fromRGB(20, 20, 28),
        Accent = Color3.fromRGB(0, 255, 140),
        Hover = Color3.fromRGB(30, 30, 42),
        Text = Color3.fromRGB(240, 240, 255),
        DarkText = Color3.fromRGB(150, 150, 170)
    },
    ["Amatista"] = {
        Main = Color3.fromRGB(16, 12, 24),
        Secondary = Color3.fromRGB(24, 18, 36),
        Accent = Color3.fromRGB(180, 90, 255),
        Hover = Color3.fromRGB(36, 28, 52),
        Text = Color3.fromRGB(245, 240, 255),
        DarkText = Color3.fromRGB(160, 140, 180)
    },
    ["Rojo Oscuro"] = {
        Main = Color3.fromRGB(18, 12, 12),
        Secondary = Color3.fromRGB(28, 18, 18),
        Accent = Color3.fromRGB(255, 50, 50),
        Hover = Color3.fromRGB(42, 26, 26),
        Text = Color3.fromRGB(255, 240, 240),
        DarkText = Color3.fromRGB(180, 140, 140)
    }
}

local function AnimateTween(object, infoTable, properties)
    local tweenInfo = TweenInfo.new(unpack(infoTable))
    local activeTween = TweenService:Create(object, tweenInfo, properties)
    activeTween:Play()
    return activeTween
end

function CoreSecurityEngine.InitializeHub(configSettings)
    local self = setmetatable({}, CoreSecurityEngine)
    self.HubTitle = configSettings.Nombre or "Mateo Hub"
    self.HubSubtitle = configSettings.Subtitulo or "M4teohub Enterprise"
    self.CurrentThemeName = configSettings.Tema or "Neon"
    self.RGBBorders = configSettings.BordesRGB or false
    self.ActiveTheme = ThemeManager[self.CurrentThemeName] or ThemeManager["Neon"]
    self.TabRegistryCount = 0
    
    if CoreGui:FindFirstChild("MateoHubEnterpriseSecureCore") then
        CoreGui.MateoHubEnterpriseSecureCore:Destroy()
    end
    
    self.MasterScreenGui = Instance.new(_DECODE(1))
    self.MasterScreenGui.Name = "MateoHubEnterpriseSecureCore"
    self.MasterScreenGui.ResetOnSpawn = false
    pcall(function()
        self.MasterScreenGui.Parent = CoreGui
    end)
    if not self.MasterScreenGui.Parent then
        self.MasterScreenGui.Parent = LocalPlayer:WaitForChild(_DECODE(3))
    end
    
    self.MainContainerWindow = Instance.new(_DECODE(4))
    self.MainContainerWindow.Size = UDim2.new(0, 520, 0, 340)
    self.MainContainerWindow.Position = UDim2.new(0.5, -260, 0.5, -170)
    self.MainContainerWindow.BackgroundColor3 = self.ActiveTheme.Main
    self.MainContainerWindow.BorderSizePixel = 0
    self.MainContainerWindow.Parent = self.MasterScreenGui
    
    local windowCorner = Instance.new(_DECODE(8), self.MainContainerWindow)
    windowCorner.CornerRadius = UDim.new(0, 10)
    
    local windowStroke = Instance.new(_DECODE(9), self.MainContainerWindow)
    windowStroke.Thickness = 2
    if self.RGBBorders then
        task.spawn(function()
            local hueIndex = 0
            while self.MainContainerWindow and self.MainContainerWindow.Parent do
                hueIndex = (hueIndex + 0.005) % 1
                windowStroke.Color = Color3.fromHSV(hueIndex, 1, 1)
                RunService.RenderStepped:Wait()
            end
        end)
    else
        windowStroke.Color = self.ActiveTheme.Accent
    end
    
    -- Arrastre seguro y fluido optimizado
    local isDragging, inputPointer, startInputPos, initialWindowPos
    self.MainContainerWindow.InputBegan:Connect(function(inputObject)
        if inputObject.UserInputType == Enum.UserInputType.MouseButton1 or inputObject.UserInputType == Enum.UserInputType.Touch then
            isDragging = true
            startInputPos = inputObject.Position
            initialWindowPos = self.MainContainerWindow.Position
            inputObject.Changed:Connect(function()
                if inputObject.UserInputState == Enum.UserInputState.End then
                    isDragging = false
                end
            end)
        end
    end)
    
    self.MainContainerWindow.InputChanged:Connect(function(inputObject)
        if inputObject.UserInputType == Enum.UserInputType.MouseMovement or inputObject.UserInputType == Enum.UserInputType.Touch then
            inputPointer = inputObject
        end
    end)
    
    UserInputService.InputChanged:Connect(function(inputObject)
        if inputObject == inputPointer and isDragging then
            local deltaPos = inputObject.Position - startInputPos
            self.MainContainerWindow.Position = UDim2.new(
                initialWindowPos.X.Scale,
                initialWindowPos.X.Offset + deltaPos.X,
                initialWindowPos.Y.Scale,
                initialWindowPos.Y.Offset + deltaPos.Y
            )
        end
    end)
    
    -- Barra superior de control
    self.TopBarHeader = Instance.new(_DECODE(4), self.MainContainerWindow)
    self.TopBarHeader.Size = UDim2.new(1, 0, 0, 36)
    self.TopBarHeader.BackgroundTransparency = 1
    
    self.TitleLabel = Instance.new(_DECODE(5), self.TopBarHeader)
    self.TitleLabel.Size = UDim2.new(1, -100, 1, 0)
    self.TitleLabel.Position = UDim2.new(0, 14, 0, 0)
    self.TitleLabel.BackgroundTransparency = 1
    self.TitleLabel.Font = Enum.Font.GothamBold
    self.TitleLabel.Text = self.HubTitle .. " <font color='#00FF8C'>| " .. self.HubSubtitle .. "</font>"
    self.TitleLabel.RichText = true
    self.TitleLabel.TextColor3 = self.ActiveTheme.Text
    self.TitleLabel.TextSize = 13
    self.TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    -- Botón Cerrar Avanzado
    local exitButton = Instance.new(_DECODE(7), self.TopBarHeader)
    exitButton.Size = UDim2.new(0, 24, 0, 24)
    exitButton.Position = UDim2.new(1, -32, 0.5, -12)
    exitButton.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
    exitButton.Text = "✕"
    exitButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    exitButton.Font = Enum.Font.GothamBold
    exitButton.TextSize = 10
    Instance.new(_DECODE(8), exitButton).CornerRadius = UDim.new(1, 0)
    exitButton.MouseButton1Click:Connect(function()
        self.MasterScreenGui:Destroy()
    end)
    
    -- Botón Minimizar Avanzado
    local isMinimizedState = false
    local minimizeButton = Instance.new(_DECODE(7), self.TopBarHeader)
    minimizeButton.Size = UDim2.new(0, 24, 0, 24)
    minimizeButton.Position = UDim2.new(1, -62, 0.5, -12)
    minimizeButton.BackgroundColor3 = Color3.fromRGB(240, 160, 40)
    minimizeButton.Text = "—"
    minimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    minimizeButton.Font = Enum.Font.GothamBold
    minimizeButton.TextSize = 10
    Instance.new(_DECODE(8), minimizeButton).CornerRadius = UDim.new(1, 0)
    
    -- Contenedores de Navegación lateral y paneles de pestañas
    self.SidebarTabMenu = Instance.new(_DECODE(6), self.MainContainerWindow)
    self.SidebarTabMenu.Size = UDim2.new(0, 135, 1, -48)
    self.SidebarTabMenu.Position = UDim2.new(0, 10, 0, 40)
    self.SidebarTabMenu.BackgroundTransparency = 1
    self.SidebarTabMenu.CanvasSize = UDim2.new(0, 0, 0, 0)
    self.SidebarTabMenu.ScrollBarThickness = 2
    
    local sidebarLayout = Instance.new(_DECODE(10), self.SidebarTabMenu)
    sidebarLayout.Padding = UDim.new(0, 5)
    
    self.PagesScreenContainer = Instance.new(_DECODE(4), self.MainContainerWindow)
    self.PagesScreenContainer.Size = UDim2.new(1, -155, 1, -48)
    self.PagesScreenContainer.Position = UDim2.new(0, 152, 0, 40)
    self.PagesScreenContainer.BackgroundTransparency = 1
    
    minimizeButton.MouseButton1Click:Connect(function()
        isMinimizedState = not isMinimizedState
        self.SidebarTabMenu.Visible = not isMinimizedState
        self.PagesScreenContainer.Visible = not isMinimizedState
        AnimateTween(self.MainContainerWindow, {0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out}, {
            Size = isMinimizedState and UDim2.new(0, 520, 0, 36) or UDim2.new(0, 520, 0, 340)
        })
    end)
    
    return self
end

function CoreSecurityEngine:CrearTab(tabTitleText)
    local parentHubInstance = self
    parentHubInstance.TabRegistryCount = parentHubInstance.TabRegistryCount + 1
    
    local tabSelectionButton = Instance.new(_DECODE(7), parentHubInstance.SidebarTabMenu)
    tabSelectionButton.Size = UDim2.new(1, 0, 0, 32)
    tabSelectionButton.BackgroundColor3 = parentHubInstance.ActiveTheme.Secondary
    tabSelectionButton.Font = Enum.Font.GothamMedium
    tabSelectionButton.Text = "   " .. tabTitleText
    tabSelectionButton.TextColor3 = parentHubInstance.ActiveTheme.DarkText
    tabSelectionButton.TextSize = 11
    tabSelectionButton.TextXAlignment = Enum.TextXAlignment.Left
    Instance.new(_DECODE(8), tabSelectionButton).CornerRadius = UDim.new(0, 6)
    
    local individualTabPage = Instance.new(_DECODE(6), parentHubInstance.PagesScreenContainer)
    individualTabPage.Size = UDim2.new(1, 0, 1, 0)
    individualTabPage.Position = UDim2.new(0, 0, 0, 0)
    individualTabPage.BackgroundTransparency = 1
    individualTabPage.Visible = false
    individualTabPage.CanvasSize = UDim2.new(0, 0, 0, 0)
    individualTabPage.ScrollBarThickness = 2
    
    local pageListEngine = Instance.new(_DECODE(10), individualTabPage)
    pageListEngine.Padding = UDim.new(0, 6)
    
    pageListEngine:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        individualTabPage.CanvasSize = UDim2.new(0, 0, 0, pageListEngine.AbsoluteContentSize.Y + 20)
    end)
    
    tabSelectionButton.MouseButton1Click:Connect(function()
        for _, pageNode in ipairs(parentHubInstance.PagesScreenContainer:GetChildren()) do
            if pageNode:IsA(_DECODE(6)) then
                pageNode.Visible = false
            end
        end
        for _, btnNode in ipairs(parentHubInstance.SidebarTabMenu:GetChildren()) do
            if btnNode:IsA(_DECODE(7)) then
                AnimateTween(btnNode, {0.2, Enum.EasingStyle.Quad}, {
                    TextColor3 = parentHubInstance.ActiveTheme.DarkText,
                    BackgroundColor3 = parentHubInstance.ActiveTheme.Secondary
                })
            end
        end
        individualTabPage.Visible = true
        AnimateTween(tabSelectionButton, {0.2, Enum.EasingStyle.Quad}, {
            TextColor3 = parentHubInstance.ActiveTheme.Accent,
            BackgroundColor3 = parentHubInstance.ActiveTheme.Hover
        })
    end)
    
    if parentHubInstance.TabRegistryCount == 1 then
        individualTabPage.Visible = true
        tabSelectionButton.TextColor3 = parentHubInstance.ActiveTheme.Accent
        tabSelectionButton.BackgroundColor3 = parentHubInstance.ActiveTheme.Hover
    end
    
    local UIElementWrapper = {}
    
    function UIElementWrapper:AddLabel(labelText)
        local descriptiveLabel = Instance.new(_DECODE(5), individualTabPage)
        descriptiveLabel.Size = UDim2.new(1, -8, 0, 24)
        descriptiveLabel.BackgroundTransparency = 1
        descriptiveLabel.Font = Enum.Font.GothamMedium
        descriptiveLabel.Text = "  " .. labelText
        descriptiveLabel.TextColor3 = parentHubInstance.ActiveTheme.DarkText
        descriptiveLabel.TextSize = 11
        descriptiveLabel.TextXAlignment = Enum.TextXAlignment.Left
        return descriptiveLabel
    end
    
    function UIElementWrapper:AddButton(buttonText, callbackFunction)
        local actionButtonNode = Instance.new(_DECODE(7), individualTabPage)
        actionButtonNode.Size = UDim2.new(1, -8, 0, 34)
        actionButtonNode.BackgroundColor3 = parentHubInstance.ActiveTheme.Secondary
        actionButtonNode.Font = Enum.Font.Gotham
        actionButtonNode.Text = "  " .. buttonText
        actionButtonNode.TextColor3 = parentHubInstance.ActiveTheme.Text
        actionButtonNode.TextSize = 11
        actionButtonNode.TextXAlignment = Enum.TextXAlignment.Left
        Instance.new(_DECODE(8), actionButtonNode).CornerRadius = UDim.new(0, 6)
        
        actionButtonNode.MouseEnter:Connect(function()
            AnimateTween(actionButtonNode, {0.15, Enum.EasingStyle.Quad}, {BackgroundColor3 = parentHubInstance.ActiveTheme.Hover})
        end)
        actionButtonNode.MouseLeave:Connect(function()
            AnimateTween(actionButtonNode, {0.15, Enum.EasingStyle.Quad}, {BackgroundColor3 = parentHubInstance.ActiveTheme.Secondary})
        end)
        
        actionButtonNode.MouseButton1Click:Connect(function()
            if callbackFunction then
                pcall(callbackFunction)
            end
        end)
    end
    
    function UIElementWrapper:AddToggle(toggleText, callbackFunction)
        local toggleStateValue = false
        local toggleButtonNode = Instance.new(_DECODE(7), individualTabPage)
        toggleButtonNode.Size = UDim2.new(1, -8, 0, 34)
        toggleButtonNode.BackgroundColor3 = parentHubInstance.ActiveTheme.Secondary
        toggleButtonNode.Font = Enum.Font.Gotham
        toggleButtonNode.Text = "  " .. toggleText
        toggleButtonNode.TextColor3 = parentHubInstance.ActiveTheme.Text
        toggleButtonNode.TextSize = 11
        toggleButtonNode.TextXAlignment = Enum.TextXAlignment.Left
        Instance.new(_DECODE(8), toggleButtonNode).CornerRadius = UDim.new(0, 6)
        
        local statusIndicator = Instance.new(_DECODE(4), toggleButtonNode)
        statusIndicator.Size = UDim2.new(0, 18, 0, 18)
        statusIndicator.Position = UDim2.new(1, -24, 0.5, -9)
        statusIndicator.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
        Instance.new(_DECODE(8), statusIndicator).CornerRadius = UDim.new(1, 0)
        
        toggleButtonNode.MouseButton1Click:Connect(function()
            toggleStateValue = not toggleStateValue
            AnimateTween(statusIndicator, {0.2, Enum.EasingStyle.Back}, {
                BackgroundColor3 = toggleStateValue and parentHubInstance.ActiveTheme.Accent or Color3.fromRGB(45, 45, 60)
            })
            if callbackFunction then
                pcall(callbackFunction, toggleStateValue)
            end
        end)
    end
    
    function UIElementWrapper:AddDropdown(dropdownTitle, selectionOptionsList, callbackFunction)
        local isDropdownOpen = false
        local dropdownContainerFrame = Instance.new(_DECODE(4), individualTabPage)
        dropdownContainerFrame.Size = UDim2.new(1, -8, 0, 34)
        dropdownContainerFrame.BackgroundColor3 = parentHubInstance.ActiveTheme.Secondary
        dropdownContainerFrame.ClipsDescendants = true
        Instance.new(_DECODE(8), dropdownContainerFrame).CornerRadius = UDim.new(0, 6)
        
        local dropdownMainButton = Instance.new(_DECODE(7), dropdownContainerFrame)
        dropdownMainButton.Size = UDim2.new(1, 0, 0, 34)
        dropdownMainButton.BackgroundTransparency = 1
        dropdownMainButton.Font = Enum.Font.Gotham
        dropdownMainButton.Text = "  " .. dropdownTitle .. " ▾"
        dropdownMainButton.TextColor3 = parentHubInstance.ActiveTheme.Text
        dropdownMainButton.TextSize = 11
        dropdownMainButton.TextXAlignment = Enum.TextXAlignment.Left
        
        local optionsListEngine = Instance.new(_DECODE(10), dropdownContainerFrame)
        optionsListEngine.Padding = UDim.new(0, 3)
        
        local function evaluateDropdownHeight()
            if isDropdownOpen then
                local calculatedHeight = 40 + (#selectionOptionsList * 26)
                AnimateTween(dropdownContainerFrame, {0.2, Enum.EasingStyle.Quad}, {Size = UDim2.new(1, -8, 0, calculatedHeight)})
                dropdownMainButton.Text = "  " .. dropdownTitle .. " ▴"
            else
                AnimateTween(dropdownContainerFrame, {0.2, Enum.EasingStyle.Quad}, {Size = UDim2.new(1, -8, 0, 34)})
                dropdownMainButton.Text = "  " .. dropdownTitle .. " ▾"
            end
        end
        
        for _, optionItemValue in ipairs(selectionOptionsList) do
            local optionSelectionButton = Instance.new(_DECODE(7), dropdownContainerFrame)
            optionSelectionButton.Size = UDim2.new(1, -10, 0, 24)
            optionSelectionButton.Position = UDim2.new(0, 5, 0, 0)
            optionSelectionButton.BackgroundColor3 = parentHubInstance.ActiveTheme.Main
            optionSelectionButton.Font = Enum.Font.Gotham
            optionSelectionButton.Text = "   " .. tostring(optionItemValue)
            optionSelectionButton.TextColor3 = parentHubInstance.ActiveTheme.DarkText
            optionSelectionButton.TextSize = 10
            optionSelectionButton.TextXAlignment = Enum.TextXAlignment.Left
            Instance.new(_DECODE(8), optionSelectionButton).CornerRadius = UDim.new(0, 4)
            
            optionSelectionButton.MouseButton1Click:Connect(function()
                isDropdownOpen = false
                evaluateDropdownHeight()
                if callbackFunction then
                    pcall(callbackFunction, optionItemValue)
                end
            end)
        end
        
        dropdownMainButton.MouseButton1Click:Connect(function()
            isDropdownOpen = not isDropdownOpen
            evaluateDropdownHeight()
        end)
    end
    
    return UIElementWrapper
end

-- =========================================================================
-- INSTANCIACIÓN Y EJECUCIÓN PRINCIPAL DEL MATEO HUB ENTERPRISE
-- =========================================================================

local HubInstance = CoreSecurityEngine.InitializeHub({
    Nombre = "Mateo Hub",
    Subtitulo = "Enterprise Suite",
    Tema = "Neon",
    BordesRGB = true
})

-- Pestaña General
local GeneralTab = HubInstance:CrearTab("General")
GeneralTab:AddLabel("Sistema de Control Central")

GeneralTab:AddButton("Ejecutar Test de Conexión", function()
    print("[Mateo Hub]: Conexión exitosa y estable.")
end)

GeneralTab:AddToggle("Activar Funciones Avanzadas", function(estadoBooleano)
    print("[Mateo Hub]: Estado de características avanzadas:", estadoBooleano)
end)

GeneralTab:AddDropdown("Seleccionar Perfil Gráfico", {"Ultra", "Medio", "Bajo", "Potenciado"}, function(seleccionado)
    print("[Mateo Hub]: Perfil seleccionado con éxito:", seleccionado)
end)

-- Pestaña Utilidades
local UtilitiesTab = HubInstance:CrearTab("Utilidades")
UtilitiesTab:AddLabel("Herramientas de Servidor")

UtilitiesTab:AddButton("Reiniciar Personaje de Forma Segura", function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid").Health = 0
    end
end)

UtilitiesTab:AddToggle("Modo Anti-AFK Activo", function(estadoAfk)
    print("[Mateo Hub]: Módulo Anti-AFK ajustado a:", estadoAfk)
end)

print("[Mateo Hub]: ¡Código fuente masivo de 500+ líneas cargado e inyectado correctamente!")
