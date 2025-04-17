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

-- Title Bar Configuration
local titleBarHeight = 36
local buttonHeight = 24
local buttonPadding = 16
local sideOffset = 22

-- Title Bar Frame
local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, titleBarHeight)
titleBar.Position = UDim2.new(0, 0, 0, 0)
titleBar.BackgroundTransparency = 1
titleBar.Parent = mainFrame

-- Function to create a button
local function createButton(name, parent)
    local button = Instance.new("TextButton")
    button.Name = name .. "Button"
    button.Size = UDim2.new(0, 100, 0, buttonHeight) -- Default size, will adjust
    button.BackgroundColor3 = Color3.fromRGB(15, 18, 26)
    button.BackgroundTransparency = 0.1
    button.Text = name
    button.TextColor3 = Color3.fromRGB(220, 225, 235)
    button.Font = Enum.Font.GothamBold
    button.TextSize = 16
    button.Parent = parent
    button.AutomaticSize = Enum.AutomaticSize.X
    button.ZIndex = 3

    -- Add corner
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = button

    -- Add stroke
    local stroke = Instance.new("UIStroke")
    stroke.Thickness = 1
    stroke.Color = Color3.fromRGB(20, 24, 35)
    stroke.Transparency = 0.7
    stroke.Parent = button

    -- Add gradient
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
    gradient.Parent = button

    -- Add highlight for press effect
    local highlight = Instance.new("Frame")
    highlight.Name = "Highlight"
    highlight.Size = UDim2.new(1, 0, 1, 0)
    highlight.BackgroundColor3 = Color3.fromRGB(30, 50, 120)
    highlight.BackgroundTransparency = 1
    highlight.ZIndex = 2
    highlight.Parent = button

    local highlightCorner = Instance.new("UICorner")
    highlightCorner.CornerRadius = UDim.new(0, 12)
    highlightCorner.Parent = highlight

    -- Button effects
    button.MouseEnter:Connect(function()
        gradient.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0),
            NumberSequenceKeypoint.new(0.5, 0.05),
            NumberSequenceKeypoint.new(1, 0.2)
        })
        stroke.Transparency = 0.5
    end)

    button.MouseLeave:Connect(function()
        gradient.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0),
            NumberSequenceKeypoint.new(0.5, 0.1),
            NumberSequenceKeypoint.new(1, 0.3)
        })
        stroke.Transparency = 0.7
        highlight.BackgroundTransparency = 1
    end)

    button.MouseButton1Down:Connect(function()
        highlight.BackgroundTransparency = 0.7
    end)

    button.MouseButton1Up:Connect(function()
        highlight.BackgroundTransparency = 1
    end)

    return button
end

-- Create left button (will switch between Minimize and Back)
local leftButton = createButton("Minimize", titleBar)
leftButton.Position = UDim2.new(0, sideOffset, 0, (titleBarHeight - buttonHeight) / 2)
leftButton.AutomaticSize = Enum.AutomaticSize.X

-- Create title button
local titleButton = createButton("Delta Codex", titleBar)
titleButton.Position = UDim2.new(0.5, -titleButton.AbsoluteSize.X/2, 0, (titleBarHeight - buttonHeight) / 2)
titleButton.AutomaticSize = Enum.AutomaticSize.X

-- Create close button
local closeButton = createButton("Close", titleBar)
closeButton.Position = UDim2.new(1, -(sideOffset + closeButton.AbsoluteSize.X), 0, (titleBarHeight - buttonHeight) / 2)
closeButton.AutomaticSize = Enum.AutomaticSize.X

-- Function to update left button
local function updateLeftButton(isBack)
    leftButton.Text = isBack and "Back" or "Minimize"
end

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

-- Clear content function
local function clearContent()
    for _, child in ipairs(contentPanel:GetChildren()) do
        child:Destroy()
    end
end

-- Show button list function
local function showButtonList()
    debugPrint("showButtonList called")
    clearContent()
    updateLeftButton(false)
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
                local backBtn = updateLeftButton(true)
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

-- Button click handlers
titleButton.MouseButton1Click:Connect(function()
    updateLeftButton(false)
    titleButton.Text = "Delta Codex"
    showButtonList()
end)

leftButton.MouseButton1Click:Connect(function()
    if leftButton.Text == "Back" then
        updateLeftButton(false)
        titleButton.Text = "Delta Codex"
        showButtonList()
    end
end)

closeButton.MouseButton1Click:Connect(function()
    screenGui.Enabled = false
end)
