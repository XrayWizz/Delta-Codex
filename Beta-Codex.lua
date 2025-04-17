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

-- Title Bar (adjusted for new dimensions)
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

-- Function to create styled button (for title bar buttons)
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

    return btn
end

-- Create title button background with dynamic width
local titleBtnW = calculateButtonWidth("Delta Codex")
local titleBtnBg = Instance.new("Frame")
titleBtnBg.Name = "TitleButtonBg"
titleBtnBg.Size = UDim2.new(0, titleBtnW, 0, titleBtnH)
titleBtnBg.Position = UDim2.new(0.5, -titleBtnW/2, 0, 8) -- Center horizontally
titleBtnBg.BackgroundColor3 = Color3.fromRGB(15, 18, 26)
titleBtnBg.BackgroundTransparency = 0.1
titleBtnBg.Parent = titleBar
titleBtnBg.ZIndex = 2

-- Add gradient to title button background
local titleGradient = Instance.new("UIGradient")
titleGradient.Transparency = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 0),
    NumberSequenceKeypoint.new(0.5, 0.1),
    NumberSequenceKeypoint.new(1, 0.3)
})
titleGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(20, 24, 35)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(15, 18, 26)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 12, 18))
})
titleGradient.Rotation = 45
titleGradient.Parent = titleBtnBg

-- Corner for title button background
local titleBtnCorner = Instance.new("UICorner")
titleBtnCorner.CornerRadius = UDim.new(0, 12)
titleBtnCorner.Parent = titleBtnBg

-- Stroke for title button background
local titleBtnStroke = Instance.new("UIStroke")
titleBtnStroke.Thickness = 1
titleBtnStroke.Color = Color3.fromRGB(20, 24, 35)
titleBtnStroke.Transparency = 0.7
titleBtnStroke.Parent = titleBtnBg

-- Create title button
titleButton = Instance.new("TextButton")
titleButton.Name = "TitleButton"
titleButton.Size = UDim2.new(1, 0, 1, 0)
titleButton.Position = UDim2.new(0, 0, 0, 0)
titleButton.BackgroundTransparency = 1
titleButton.Text = "Delta Codex"
titleButton.TextColor3 = Color3.fromRGB(220, 225, 235)
titleButton.Font = Enum.Font.GothamBold
titleButton.TextSize = 16
titleButton.ZIndex = 3
titleButton.Parent = titleBtnBg

-- Add hover effects to title button
titleButton.MouseEnter:Connect(function()
    titleGradient.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0),
        NumberSequenceKeypoint.new(0.5, 0.05),
        NumberSequenceKeypoint.new(1, 0.2)
    })
    titleBtnStroke.Transparency = 0.5
end)

titleButton.MouseLeave:Connect(function()
    titleGradient.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0),
        NumberSequenceKeypoint.new(0.5, 0.1),
        NumberSequenceKeypoint.new(1, 0.3)
    })
    titleBtnStroke.Transparency = 0.7
end)

-- Create minimize and back buttons with dynamic width
local function createTitleBarButton(buttonType)
    -- Clean up any existing buttons first
    local existingMinimize = titleBar:FindFirstChild("MinimizeButtonBg")
    local existingBack = titleBar:FindFirstChild("BackButtonBg")
    
    if existingMinimize then existingMinimize:Destroy() end
    if existingBack then existingBack:Destroy() end
    
    -- Create new button
    if buttonType == "Minimize" then
        local minimizeBtnW = calculateButtonWidth("Minimize")
        return createStyledButton("Minimize", titleBar, UDim2.new(0, minimizeBtnW, 0, titleBtnH), UDim2.new(0, titleBtnOffset, 0, topPadding))
    else
        local backBtnW = calculateButtonWidth("Back")
        return createStyledButton("Back", titleBar, UDim2.new(0, backBtnW, 0, titleBtnH), UDim2.new(0, titleBtnOffset, 0, topPadding))
    end
end

-- Initialize with Minimize button
minimizeBtn = createTitleBarButton("Minimize")

-- Function to show button list (main menu)
local function showButtonList()
    debugPrint("showButtonList called")
    clearContent()
    minimizeBtn = createTitleBarButton("Minimize")
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

            -- Create button background frame for gradient
            local btnBg = Instance.new("Frame")
            btnBg.Name = name .. "ButtonBg"
            btnBg.Size = UDim2.new(0, btnW, 0, btnH)
            btnBg.Position = UDim2.new(0, offsetX + col * (btnW + gapX), 0, offsetY + row * (btnH + gapY))
            btnBg.BackgroundColor3 = Color3.fromRGB(15, 18, 26) -- Darker base color
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
            local btnBgCorner = Instance.new("UICorner")
            btnBgCorner.CornerRadius = UDim.new(0, 12)
            btnBgCorner.Parent = btnBg

            -- Stroke for background
            local btnBgStroke = Instance.new("UIStroke")
            btnBgStroke.Thickness = 1
            btnBgStroke.Color = Color3.fromRGB(20, 24, 35)
            btnBgStroke.Transparency = 0.7
            btnBgStroke.Parent = btnBg

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

            -- Enhanced hover effect
            btn.MouseEnter:Connect(function()
                gradient.Transparency = NumberSequence.new({
                    NumberSequenceKeypoint.new(0, 0),
                    NumberSequenceKeypoint.new(0.5, 0.05),
                    NumberSequenceKeypoint.new(1, 0.2)
                })
                btnBgStroke.Transparency = 0.5
            end)

            btn.MouseLeave:Connect(function()
                gradient.Transparency = NumberSequence.new({
                    NumberSequenceKeypoint.new(0, 0),
                    NumberSequenceKeypoint.new(0.5, 0.1),
                    NumberSequenceKeypoint.new(1, 0.3)
                })
                btnBgStroke.Transparency = 0.7
            end)

            btn.MouseButton1Click:Connect(function()
                debugPrint("Button clicked")
                contentPanel.Visible = false
                backBtn = createTitleBarButton("Back")
                titleButton.Text = name
                if panelBuilders[name] then
                    clearContent()
                    panelBuilders[name](contentPanel)
                end
            end)
        end
    end
end

-- Update panel builders to handle button switching
for name, builder in pairs(panelBuilders) do
    local originalBuilder = builder
    panelBuilders[name] = function(parent)
        contentPanel.Visible = false
        backBtn = createTitleBarButton("Back")
        titleButton.Text = name
        if originalBuilder then
            originalBuilder(parent)
        end
        
        -- Set up back button click handler
        if backBtn then
            backBtn.MouseButton1Click:Connect(function()
                showButtonList()
            end)
        end
    end
end

-- Ensure showButtonList is called on load
debugPrint("Calling showButtonList on load")
showButtonList()

-- Ensure Close button always works
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
