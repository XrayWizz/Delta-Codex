-- Codex.lua: Compact, Dark & Blue UI for Fruit Blox (Roblox)
-- Modern, compact, screen-switching design

-- Dark & Blue color palette
local COLORS = {
    surface = Color3.fromRGB(18, 22, 32),
    surfaceVariant = Color3.fromRGB(27, 32, 48),
    primary = Color3.fromRGB(36, 110, 255), -- Blue accent (customize this for your own Material You look!)
    onPrimary = Color3.fromRGB(255, 255, 255),
    onSurface = Color3.fromRGB(220, 230, 255),
    outline = Color3.fromRGB(40, 65, 120),
    shadow = Color3.fromRGB(0, 0, 0),
    ripple = Color3.fromRGB(80, 160, 255),
}

-- Debug function to print common statements
local function debugPrint(message)
    print("[DEBUG]: " .. message)
end

-- Create the ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CodexUI"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")

-- Check if screenGui is initialized
if not screenGui then debugPrint("screenGui is not initialized") end

-- Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 380, 0, 340)
mainFrame.Position = UDim2.new(0.5, -190, 0.42, -170)
mainFrame.BackgroundColor3 = Color3.fromRGB(10, 13, 22)
mainFrame.BackgroundTransparency = 0.15
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 14)
mainCorner.Parent = mainFrame

local mainStroke = Instance.new("UIStroke")
mainStroke.Thickness = 1
mainStroke.Color = Color3.fromRGB(20, 24, 35) -- Darker, less blue outline
mainStroke.Transparency = 0.7 -- More transparent
mainStroke.Parent = mainFrame

-- Title Bar configuration
local titleBarHeight = 36 -- Slightly reduced height
local minButtonWidth = 80
local titleBtnH = 24
local titleBtnOffset = 22
local buttonPadding = 24
local topPadding = 6 -- Reduced from 8 to bring buttons up

-- Function to calculate button width based on text
local function calculateButtonWidth(text)
    return math.max(minButtonWidth, string.len(text) * 8 + buttonPadding * 2) -- 8 pixels per character plus padding
end

-- Title Bar
local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, titleBarHeight)
titleBar.Position = UDim2.new(0, 0, 0, 0)
titleBar.BackgroundColor3 = Color3.fromRGB(10, 13, 22)
titleBar.BackgroundTransparency = 1
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame
titleBar.ZIndex = 2

-- Function to create styled button
local function createStyledButton(name, parent, size, position)
    local btnBg = Instance.new("Frame")
    btnBg.Name = name .. "ButtonBg"
    btnBg.Size = size
    btnBg.Position = position
    btnBg.BackgroundColor3 = Color3.fromRGB(15, 18, 26)
    btnBg.BackgroundTransparency = 0.1
    btnBg.Parent = parent
    btnBg.ZIndex = 2

    -- Add highlight effect frame
    local highlight = Instance.new("Frame")
    highlight.Name = "PressHighlight"
    highlight.Size = UDim2.new(1, 0, 1, 0)
    highlight.Position = UDim2.new(0, 0, 0, 0)
    highlight.BackgroundColor3 = Color3.fromRGB(30, 50, 120) -- Dark blue highlight
    highlight.BackgroundTransparency = 1 -- Start fully transparent
    highlight.ZIndex = 2
    highlight.Parent = btnBg

    -- Add corner to highlight
    local highlightCorner = Instance.new("UICorner")
    highlightCorner.CornerRadius = UDim.new(0, 12)
    highlightCorner.Parent = highlight

    local gradient = Instance.new("UIGradient")
    gradient.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0),
        NumberSequenceKeypoint.new(0.5, 0.1),
        NumberSequenceKeypoint.new(1, 0.3)
    })
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(20, 24, 35)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(15, 18, 26)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 12, 18))
    })
    gradient.Rotation = 45
    gradient.Parent = btnBg

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 12)
    btnCorner.Parent = btnBg

    local btnStroke = Instance.new("UIStroke")
    btnStroke.Thickness = 1
    btnStroke.Color = Color3.fromRGB(20, 24, 35)
    btnStroke.Transparency = 0.7
    btnStroke.Parent = btnBg

    local btn = Instance.new("TextButton")
    btn.Name = name .. "Button"
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.Position = UDim2.new(0, 0, 0, 0)
    btn.BackgroundTransparency = 1
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(220, 225, 235)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 16
    btn.ZIndex = 3
    btn.Parent = btnBg

    -- Enhanced hover and press effects
    local function updateHighlight(transparency)
        game:GetService("TweenService"):Create(highlight, TweenInfo.new(0.15), {
            BackgroundTransparency = transparency
        }):Play()
    end

    btn.MouseEnter:Connect(function()
        gradient.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0),
            NumberSequenceKeypoint.new(0.5, 0.05),
            NumberSequenceKeypoint.new(1, 0.2)
        })
        btnStroke.Transparency = 0.5
    end)

    btn.MouseLeave:Connect(function()
        gradient.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0),
            NumberSequenceKeypoint.new(0.5, 0.1),
            NumberSequenceKeypoint.new(1, 0.3)
        })
        btnStroke.Transparency = 0.7
        updateHighlight(1) -- Reset highlight when mouse leaves
    end)

    -- Add press effects
    btn.MouseButton1Down:Connect(function()
        updateHighlight(0.7) -- Show highlight when pressed
    end)

    btn.MouseButton1Up:Connect(function()
        updateHighlight(1) -- Hide highlight when released
    end)

    return btn, btnBg
end

-- Create title button
local titleBtnW = calculateButtonWidth("Delta Codex")
local titleButton, titleBtnBg = createStyledButton("Title", titleBar, 
    UDim2.new(0, titleBtnW, 0, titleBtnH), 
    UDim2.new(0.5, -titleBtnW/2, 0, topPadding))
titleButton.Text = "Delta Codex"

-- Variables to store current buttons
local currentLeftButton = nil
local currentLeftButtonBg = nil

-- Function to create/switch title bar button
local function switchTitleBarButton(buttonType)
    -- Clean up existing button
    if currentLeftButtonBg then
        currentLeftButtonBg:Destroy()
        currentLeftButton = nil
        currentLeftButtonBg = nil
    end

    -- Create new button
    local btnWidth = calculateButtonWidth(buttonType)
    local btn, btnBg = createStyledButton(buttonType, titleBar,
        UDim2.new(0, btnWidth, 0, titleBtnH),
        UDim2.new(0, titleBtnOffset, 0, topPadding))
    
    currentLeftButton = btn
    currentLeftButtonBg = btnBg
    return btn
end

-- Create close button
local closeBtnW = calculateButtonWidth("Close")
local closeBtn = createStyledButton("Close", titleBar,
    UDim2.new(0, closeBtnW, 0, titleBtnH),
    UDim2.new(1, -(titleBtnOffset + closeBtnW), 0, topPadding))

-- Content Panel
local contentPanel = Instance.new("Frame")
contentPanel.Name = "ContentPanel"
contentPanel.Size = UDim2.new(1, 0, 1, -titleBarHeight)
contentPanel.Position = UDim2.new(0, 0, 0, titleBarHeight)
contentPanel.BackgroundTransparency = 1
contentPanel.Parent = mainFrame

-- Button Names
local buttonNames = {
    "Overview", "Farming", "Sea Events", "Islands", "Quests", "Fruit",
    "Teleport", "Status", "Visual", "Shop", "Settings", "About"
}

-- Clear content panel function
local function clearContent()
    debugPrint("clearContent called")
    for _, child in ipairs(contentPanel:GetChildren()) do
        child:Destroy()
    end
end

-- Show button list function
local function showButtonList()
    debugPrint("showButtonList called")
    clearContent()
    switchTitleBarButton("Minimize")
    titleButton.Text = "Delta Codex"
    contentPanel.Visible = true
    
    local btnW, btnH = 160, 36
    local gapX, gapY = 16, 8
    local cols, rows = 2, 6
    local offsetX = 22
    local offsetY = 4

    for i, name in ipairs(buttonNames) do
        if name ~= "" then
            local col = ((i-1) % cols)
            local row = math.floor((i-1) / cols)

            local btnBg = Instance.new("Frame")
            btnBg.Name = name .. "ButtonBg"
            btnBg.Size = UDim2.new(0, btnW, 0, btnH)
            btnBg.Position = UDim2.new(0, offsetX + col * (btnW + gapX), 0, offsetY + row * (btnH + gapY))
            btnBg.BackgroundColor3 = Color3.fromRGB(15, 18, 26)
            btnBg.BackgroundTransparency = 0.1
            btnBg.Parent = contentPanel
            btnBg.ZIndex = 2

            -- Add gradient to background
            local gradient = Instance.new("UIGradient")
            gradient.Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0),
                NumberSequenceKeypoint.new(0.5, 0.1),
                NumberSequenceKeypoint.new(1, 0.3)
            })
            gradient.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(20, 24, 35)),
                ColorSequenceKeypoint.new(0.5, Color3.fromRGB(15, 18, 26)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 12, 18))
            })
            gradient.Rotation = 45
            gradient.Parent = btnBg

            -- Corner for background
            local btnCorner = Instance.new("UICorner")
            btnCorner.CornerRadius = UDim.new(0, 12)
            btnCorner.Parent = btnBg

            -- Stroke for background
            local btnStroke = Instance.new("UIStroke")
            btnStroke.Thickness = 1
            btnStroke.Color = Color3.fromRGB(20, 24, 35)
            btnStroke.Transparency = 0.7
            btnStroke.Parent = btnBg

            -- Create actual button on top
            local btn = Instance.new("TextButton")
            btn.Name = name .. "Button"
            btn.Size = UDim2.new(1, 0, 1, 0)
            btn.Position = UDim2.new(0, 0, 0, 0)
            btn.BackgroundTransparency = 1 -- Fully transparent background
            btn.Text = name
            btn.TextColor3 = Color3.fromRGB(220, 225, 235) -- Light grey text
            btn.Font = Enum.Font.GothamBold
            btn.TextSize = 16
            btn.ZIndex = 3 -- Ensure text is above gradient
            btn.Parent = btnBg

            btn.MouseButton1Click:Connect(function()
                debugPrint("Button clicked")
                contentPanel.Visible = false
                local backBtn = switchTitleBarButton("Back")
                titleButton.Text = name
                if panelBuilders[name] then
                    clearContent()
                    panelBuilders[name](contentPanel)
                end
                
                -- Set up back button click handler
                if backBtn then
                    backBtn.MouseButton1Click:Connect(function()
                        showButtonList()
                    end)
                end
            end)
        end
    end
end

-- Initialize UI
showButtonList()

-- Set up title button click handler
titleButton.MouseButton1Click:Connect(function()
    debugPrint("Title button clicked")
    showButtonList()
end)

-- Close button handler
if closeBtn then
    closeBtn.MouseButton1Click:Connect(function()
        debugPrint("Close button clicked")
        screenGui.Enabled = false
    end)
else
    debugPrint("closeBtn is not initialized")
end

-- Also add the same effects to the title button
local function addPressEffects(button, background)
    -- Add highlight effect frame
    local highlight = Instance.new("Frame")
    highlight.Name = "PressHighlight"
    highlight.Size = UDim2.new(1, 0, 1, 0)
    highlight.Position = UDim2.new(0, 0, 0, 0)
    highlight.BackgroundColor3 = Color3.fromRGB(30, 50, 120) -- Dark blue highlight
    highlight.BackgroundTransparency = 1 -- Start fully transparent
    highlight.ZIndex = 2
    highlight.Parent = background

    -- Add corner to highlight
    local highlightCorner = Instance.new("UICorner")
    highlightCorner.CornerRadius = UDim.new(0, 12)
    highlightCorner.Parent = highlight

    local function updateHighlight(transparency)
        game:GetService("TweenService"):Create(highlight, TweenInfo.new(0.15), {
            BackgroundTransparency = transparency
        }):Play()
    end

    button.MouseButton1Down:Connect(function()
        updateHighlight(0.7) -- Show highlight when pressed
    end)

    button.MouseButton1Up:Connect(function()
        updateHighlight(1) -- Hide highlight when released
    end)

    button.MouseLeave:Connect(function()
        updateHighlight(1) -- Reset highlight when mouse leaves
    end)
end

-- Apply press effects to title button after it's created
addPressEffects(titleButton, titleBtnBg)
