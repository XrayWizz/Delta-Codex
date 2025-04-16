-- Codex.lua: Compact, Dark & Blue UI for Fruit Blox (Roblox)
-- Modern, compact, screen-switching design

-- Services
local TweenService = game:GetService("TweenService")

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

-- Main Frame (compact)
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 380, 0, 400)
mainFrame.Position = UDim2.new(0.5, -190, 0.5, -200)  -- Centered
mainFrame.BackgroundColor3 = Color3.fromRGB(10, 13, 22) -- much darker
mainFrame.BorderSizePixel = 0
mainFrame.BackgroundTransparency = 0
mainFrame.Parent = screenGui
local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 14)
mainCorner.Parent = mainFrame

local mainStroke = Instance.new("UIStroke")
mainStroke.Thickness = 1.5
mainStroke.Color = COLORS.outline
mainStroke.Transparency = 0.3
mainStroke.Parent = mainFrame

-- Store original sizes for animations
local originalMainFrameSize = mainFrame.Size
local originalMainFramePosition = mainFrame.Position
local minimizedTitleBarWidth = 120 -- Width when minimized to just show "Delta Codex"
local isMinimized = false

-- Constants for layout
local EDGE_PADDING = 22  -- Padding from edges to match main menu grid
local BUTTON_WIDTH = 80
local BUTTON_HEIGHT = 24

-- Title Bar setup
local titleBarHeight = 32
local titleBar = Instance.new("Frame")  -- Changed back to Frame
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, titleBarHeight)
titleBar.Position = UDim2.new(0, 0, 0, 0)
titleBar.BackgroundColor3 = Color3.fromRGB(10, 13, 22)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame
titleBar.ZIndex = 2

-- Add corner radius to title bar
local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 14)
titleCorner.Parent = titleBar

-- Title Button (Material You 3 style)
local titleButton = Instance.new("TextButton")
titleButton.Name = "TitleButton"
titleButton.Size = UDim2.new(0, 120, 0, BUTTON_HEIGHT)  -- Initial size, will be adjusted based on text
titleButton.Position = UDim2.new(0.5, -60, 0.5, -BUTTON_HEIGHT/2)  -- Centered
titleButton.BackgroundColor3 = Color3.fromRGB(15, 20, 30)  -- Slightly lighter than background for subtle distinction
titleButton.Text = "Delta Codex"
titleButton.TextColor3 = COLORS.onSurface
titleButton.Font = Enum.Font.GothamBold
titleButton.TextSize = 17
titleButton.AutoButtonColor = false  -- We'll handle hover effects manually
titleButton.Parent = titleBar
titleButton.ZIndex = 3

-- Add corner radius to title button
local titleBtnCorner = Instance.new("UICorner")
titleBtnCorner.CornerRadius = UDim.new(0, 10)
titleBtnCorner.Parent = titleButton

-- Add subtle stroke to title button
local titleBtnStroke = Instance.new("UIStroke")
titleBtnStroke.Thickness = 1
titleBtnStroke.Color = COLORS.outline
titleBtnStroke.Transparency = 0.8  -- Very subtle stroke
titleBtnStroke.Parent = titleButton

-- Material You 3 hover effects for title button
local function onTitleHover()
    TweenService:Create(titleButton, 
        TweenInfo.new(0.2, Enum.EasingStyle.Cubic), 
        {
            BackgroundColor3 = Color3.fromRGB(25, 32, 48),
            TextColor3 = COLORS.primary
        }
    ):Play()
    TweenService:Create(titleBtnStroke,
        TweenInfo.new(0.2, Enum.EasingStyle.Cubic),
        {Transparency = 0.6}
    ):Play()
end

local function onTitleUnhover()
    TweenService:Create(titleButton, 
        TweenInfo.new(0.2, Enum.EasingStyle.Cubic), 
        {
            BackgroundColor3 = Color3.fromRGB(15, 20, 30),
            TextColor3 = COLORS.onSurface
        }
    ):Play()
    TweenService:Create(titleBtnStroke,
        TweenInfo.new(0.2, Enum.EasingStyle.Cubic),
        {Transparency = 0.8}
    ):Play()
end

titleButton.MouseEnter:Connect(onTitleHover)
titleButton.MouseLeave:Connect(onTitleUnhover)

-- Adjust title button width based on text
local textService = game:GetService("TextService")
local textSize = textService:GetTextSize(
    titleButton.Text,
    titleButton.TextSize,
    titleButton.Font,
    Vector2.new(1000, BUTTON_HEIGHT)
)
local padding = 32  -- Padding for text (16px on each side)
titleButton.Size = UDim2.new(0, textSize.X + padding, 0, BUTTON_HEIGHT)
titleButton.Position = UDim2.new(0.5, -(textSize.X + padding)/2, 0.5, -BUTTON_HEIGHT/2)

-- Back button (aligned with left grid edge)
local backBtn = Instance.new("TextButton")
backBtn.Name = "BackButton"
backBtn.Size = UDim2.new(0, BUTTON_WIDTH, 0, BUTTON_HEIGHT)
backBtn.Position = UDim2.new(0, EDGE_PADDING, 0.5, -BUTTON_HEIGHT/2)  -- Aligned with left grid edge
backBtn.BackgroundColor3 = COLORS.surfaceVariant
backBtn.Text = "Back"
backBtn.TextColor3 = COLORS.onSurface
backBtn.Font = Enum.Font.GothamSemibold
backBtn.TextSize = 15
backBtn.AutoButtonColor = true
backBtn.Visible = false
backBtn.Parent = titleBar
backBtn.ZIndex = 4

local backCorner = Instance.new("UICorner")
backCorner.CornerRadius = UDim.new(0, 10)
backCorner.Parent = backBtn

-- Close button (aligned with right grid edge)
local closeBtn = Instance.new("TextButton")
closeBtn.Name = "CloseButton"
closeBtn.Size = UDim2.new(0, BUTTON_WIDTH, 0, BUTTON_HEIGHT)
closeBtn.Position = UDim2.new(1, -(EDGE_PADDING + BUTTON_WIDTH), 0.5, -BUTTON_HEIGHT/2)  -- Aligned with right grid edge
closeBtn.BackgroundColor3 = COLORS.surfaceVariant
closeBtn.Text = "Close"
closeBtn.TextColor3 = COLORS.onSurface
closeBtn.Font = Enum.Font.GothamSemibold
closeBtn.TextSize = 15
closeBtn.AutoButtonColor = true
closeBtn.Parent = titleBar
closeBtn.ZIndex = 4

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 10)
closeCorner.Parent = closeBtn

-- Create a clickable area in the center of title bar (avoiding buttons)
local titleClickArea = Instance.new("TextButton")
titleClickArea.Name = "TitleClickArea"
titleClickArea.Size = UDim2.new(1, -(2 * (EDGE_PADDING + BUTTON_WIDTH + 10)), 1, 0)  -- Width accounting for buttons and padding
titleClickArea.Position = UDim2.new(0, EDGE_PADDING + BUTTON_WIDTH + 5, 0, 0)  -- Positioned after back button
titleClickArea.BackgroundTransparency = 1
titleClickArea.Text = ""
titleClickArea.Parent = titleBar
titleClickArea.ZIndex = 3

-- Title Label (centered in click area)
local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "TitleLabel"
titleLabel.Size = UDim2.new(1, -20, 1, 0)
titleLabel.Position = UDim2.new(0, 10, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Delta Codex"
titleLabel.TextColor3 = COLORS.onSurface
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 17
titleLabel.TextXAlignment = Enum.TextXAlignment.Center
titleLabel.Parent = titleClickArea
titleLabel.ZIndex = 3

-- Store original positions
local originalTitleLabelPosition = titleLabel.Position

-- Add visual feedback for the click area
local function onDown()
    TweenService:Create(titleBar,
        TweenInfo.new(0.1, Enum.EasingStyle.Quad),
        {BackgroundColor3 = Color3.fromRGB(30, 39, 66)}
    ):Play()
end

local function onUp()
    TweenService:Create(titleBar,
        TweenInfo.new(0.1, Enum.EasingStyle.Quad),
        {BackgroundColor3 = Color3.fromRGB(10, 13, 22)}
    ):Play()
end

titleClickArea.MouseButton1Down:Connect(onDown)
titleClickArea.MouseButton1Up:Connect(onUp)

-- Animation Functions
local function minimizeUI()
    if isMinimized then return end
    isMinimized = true
    
    -- Visual feedback
    TweenService:Create(titleButton,
        TweenInfo.new(0.2, Enum.EasingStyle.Cubic),
        {
            BackgroundColor3 = Color3.fromRGB(30, 39, 66),
            TextColor3 = COLORS.primary
        }
    ):Play()
    
    -- Animate mainFrame
    local mainFrameTween = TweenService:Create(mainFrame, 
        TweenInfo.new(0.3, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out),
        {
            Size = UDim2.new(0, textSize.X + padding + 20, 0, titleBarHeight),  -- Added padding for minimized state
            Position = UDim2.new(0.5, -(textSize.X + padding + 20)/2, 0.5, -titleBarHeight/2)
        }
    )
    
    -- Hide content
    contentPanel.Visible = false
    closeBtn.Visible = false
    backBtn.Visible = false
    
    mainFrameTween:Play()
    wait(0.3)
    
    -- Reset visual feedback
    onTitleUnhover()
end

local function maximizeUI()
    if not isMinimized then return end
    isMinimized = false
    
    -- Visual feedback
    TweenService:Create(titleButton,
        TweenInfo.new(0.2, Enum.EasingStyle.Cubic),
        {
            BackgroundColor3 = Color3.fromRGB(30, 39, 66),
            TextColor3 = COLORS.primary
        }
    ):Play()
    
    -- Animate mainFrame
    local mainFrameTween = TweenService:Create(mainFrame,
        TweenInfo.new(0.3, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out),
        {
            Size = originalMainFrameSize,
            Position = originalMainFramePosition
        }
    )
    
    mainFrameTween:Play()
    wait(0.3)
    
    -- Show content
    contentPanel.Visible = true
    closeBtn.Visible = true
    if backBtn.Visible then  -- Only show back button if it was visible before
        backBtn.Visible = true
    end
    
    -- Reset visual feedback
    onTitleUnhover()
end

-- Connect minimize/maximize to title button
titleButton.MouseButton1Click:Connect(function()
    if isMinimized then
        maximizeUI()
    else
        minimizeUI()
    end
end)

-- Make sure buttons work
closeBtn.MouseButton1Click:Connect(function()
    screenGui.Enabled = false
end)

backBtn.MouseButton1Click:Connect(function()
    showButtonList()
    backBtn.Visible = false
    titleLabel.Text = "Delta Codex"
end)

-- Content Panel (for both button list and context screens)
local contentPanel = Instance.new("Frame")
contentPanel.Name = "ContentPanel"
contentPanel.Size = UDim2.new(1, 0, 1, -32)
contentPanel.Position = UDim2.new(0, 0, 0, 32)
contentPanel.BackgroundTransparency = 1
contentPanel.Parent = mainFrame

-- Check if contentPanel is initialized
if not contentPanel then debugPrint("contentPanel is not initialized") end

-- Button Names (custom user list, in order, Feedback changed to About)
local buttonNames = {
    "Overview", "Farming", "Sea Events", "Islands", "Quests", "Fruit",
    "Teleport", "Status", "Visual", "Shop", "Settings", "About"
}

-- Utility: Clear content panel
local function clearContent()
    debugPrint("clearContent called")
    for _, child in ipairs(contentPanel:GetChildren()) do
        child:Destroy()
    end
end

-- Utility function for creating smooth animations
local function createTween(object, properties, duration)
    debugPrint("createTween called")
    return TweenService:Create(object, TweenInfo.new(duration, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), properties)
end

-- Progress Bar component
local function createProgressBar(parent, height)
    debugPrint("createProgressBar called")
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, -24, 0, height)
    container.BackgroundColor3 = COLORS.surfaceVariant
    container.BackgroundTransparency = 0.7
    container.Parent = parent

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, height / 2)
    corner.Parent = container

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new(0, 0, 1, 0)
    fill.BackgroundColor3 = COLORS.primary
    fill.Parent = container

    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(0, height / 2)
    fillCorner.Parent = fill

    local gradient = Instance.new("UIGradient")
    gradient.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0),
        NumberSequenceKeypoint.new(0.7, 0.2),
        NumberSequenceKeypoint.new(1, 0.4)
    })
    gradient.Rotation = 90
    gradient.Parent = fill

    return {
        container = container,
        fill = fill,
        setProgress = function(progress)
            debugPrint("setProgress called")
            createTween(fill, {Size = UDim2.new(math.clamp(progress, 0, 1), 0, 1, 0)}, 0.3):Play()
        end
    }
end

-- Helper functions for all panels (Material You 3 style)
local function createSection(parent, title)
    debugPrint("createSection called")
    local section = Instance.new("Frame")
    section.Size = UDim2.new(1, -24, 0, 0)
    section.BackgroundTransparency = 1
    section.AutomaticSize = Enum.AutomaticSize.Y
    section.Parent = parent
    section.LayoutOrder = 0
    section.Padding = UDim.new(0, 16) -- Extra padding between sections

    local sectionTitle = Instance.new("TextLabel")
    sectionTitle.Size = UDim2.new(1, 0, 0, 34)
    sectionTitle.BackgroundTransparency = 1
    sectionTitle.Text = title
    sectionTitle.TextColor3 = COLORS.primary
    sectionTitle.Font = Enum.Font.GothamBlack
    sectionTitle.TextSize = 22 -- Larger, bolder
    sectionTitle.TextXAlignment = Enum.TextXAlignment.Left
    sectionTitle.Parent = section

    -- Add subtle glow effect
    local glow = Instance.new("ImageLabel")
    glow.Size = UDim2.new(0, 120, 0, 34)
    glow.BackgroundTransparency = 1
    glow.Image = "rbxassetid://7032373975"
    glow.ImageColor3 = COLORS.primary
    glow.ImageTransparency = 0.8
    glow.Parent = sectionTitle

    local cardsContainer = Instance.new("Frame")
    cardsContainer.Size = UDim2.new(1, 0, 0, 0)
    cardsContainer.Position = UDim2.new(0, 0, 0, 34)
    cardsContainer.BackgroundTransparency = 1
    cardsContainer.AutomaticSize = Enum.AutomaticSize.Y
    cardsContainer.Parent = section

    local cardLayout = Instance.new("UIListLayout")
    cardLayout.Padding = UDim.new(0, 12) -- More space between cards
    cardLayout.Parent = cardsContainer

    -- Animate section appearance
    section.BackgroundTransparency = 1
    cardsContainer.Position = UDim2.new(-0.1, 0, 0, 34)
    createTween(cardsContainer, {Position = UDim2.new(0, 0, 0, 34)}, 0.3):Play()

    return cardsContainer
end

local function createInfoCard(parent, label, value, showProgress)
    debugPrint("createInfoCard called")
    local card = Instance.new("Frame")
    card.Size = UDim2.new(1, 0, 0, showProgress and 64 or 48)
    card.BackgroundColor3 = COLORS.surfaceVariant
    card.BackgroundTransparency = 0.1
    card.Parent = parent

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = card

    local stroke = Instance.new("UIStroke")
    stroke.Thickness = 1
    stroke.Color = COLORS.outline
    stroke.Transparency = 0.4
    stroke.Parent = card

    -- Drop shadow for Material You elevation
    local shadow = Instance.new("ImageLabel")
    shadow.Name = "Shadow"
    shadow.Size = UDim2.new(1, 8, 1, 8)
    shadow.Position = UDim2.new(0, -4, 0, -2)
    shadow.BackgroundTransparency = 1
    shadow.Image = "rbxassetid://1316045217" -- soft shadow asset
    shadow.ImageTransparency = 0.85
    shadow.ZIndex = 0
    shadow.Parent = card

    -- Hover effect
    local function onHover()
        debugPrint("onHover called")
        createTween(card, {BackgroundTransparency = 0}, 0.2):Play()
        createTween(stroke, {Transparency = 0.2}, 0.2):Play()
        createTween(shadow, {ImageTransparency = 0.7}, 0.2):Play()
    end

    local function onUnhover()
        debugPrint("onUnhover called")
        createTween(card, {BackgroundTransparency = 0.1}, 0.2):Play()
        createTween(stroke, {Transparency = 0.4}, 0.2):Play()
        createTween(shadow, {ImageTransparency = 0.85}, 0.2):Play()
    end

    card.MouseEnter:Connect(onHover)
    card.MouseLeave:Connect(onUnhover)

    local labelText = Instance.new("TextLabel")
    labelText.Size = UDim2.new(1, -16, 0, 20)
    labelText.Position = UDim2.new(0, 12, 0, 6)
    labelText.BackgroundTransparency = 1
    labelText.Text = label
    labelText.TextColor3 = COLORS.onSurface
    labelText.Font = Enum.Font.GothamMedium
    labelText.TextSize = 14
    labelText.TextXAlignment = Enum.TextXAlignment.Left
    labelText.Parent = card

    local valueText = Instance.new("TextLabel")
    valueText.Size = UDim2.new(1, -16, 0, 20)
    valueText.Position = UDim2.new(0, 12, 0, 24)
    valueText.BackgroundTransparency = 1
    valueText.Text = tostring(value)
    valueText.TextColor3 = COLORS.primary
    valueText.Font = Enum.Font.GothamSemibold
    valueText.TextSize = 16
    valueText.TextXAlignment = Enum.TextXAlignment.Left
    valueText.Parent = card

    local progressBar
    if showProgress then
        progressBar = createProgressBar(card, 8)
        progressBar.container.Position = UDim2.new(0, 12, 0, 48)
    end

    -- Animate card appearance
    card.BackgroundTransparency = 1
    labelText.TextTransparency = 1
    valueText.TextTransparency = 1
    shadow.ImageTransparency = 1
    
    createTween(card, {BackgroundTransparency = 0.1}, 0.3):Play()
    createTween(labelText, {TextTransparency = 0}, 0.3):Play()
    createTween(valueText, {TextTransparency = 0}, 0.3):Play()
    createTween(shadow, {ImageTransparency = 0.85}, 0.3):Play()

    return {
        valueLabel = valueText,
        progressBar = progressBar
    }
end

-- Custom content builder for Overview Panel Screen with enhanced features
local function buildOverviewPanel(parent)
    debugPrint("buildOverviewPanel called")
    local player = game:GetService("Players").LocalPlayer
    local stats = player:FindFirstChild("leaderstats") or player
    local humanoid = player.Character and player.Character:FindFirstChild("Humanoid")
    
    -- Container for scrolling with smooth scrolling behavior
    local scrollFrame = Instance.new("ScrollingFrame")
    scrollFrame.Size = UDim2.new(1, -8, 1, -8)
    scrollFrame.Position = UDim2.new(0, 4, 0, 4)
    scrollFrame.BackgroundTransparency = 1
    scrollFrame.ScrollBarThickness = 4
    scrollFrame.ScrollBarImageColor3 = COLORS.primary
    scrollFrame.ScrollingDirection = Enum.ScrollingDirection.Y
    scrollFrame.ScrollBarImageTransparency = 0.5
    scrollFrame.Parent = parent

    -- Add smooth scrolling behavior
    local function smoothScroll(input)
        debugPrint("smoothScroll called")
        local delta = input.Position - input.LastPosition
        local topY = scrollFrame.CanvasPosition.Y
        createTween(scrollFrame, {CanvasPosition = Vector2.new(0, math.clamp(topY - delta.Y, 0, scrollFrame.AbsoluteCanvasSize.Y))}, 0.2):Play()
    end
    scrollFrame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseWheel then
            smoothScroll(input)
        end
    end)

    local listLayout = Instance.new("UIListLayout")
    listLayout.Padding = UDim.new(0, 16)
    listLayout.Parent = scrollFrame

    -- Player Info Section with avatar
    local playerSection = createSection(scrollFrame, "Player Information")
    -- Add player avatar (Material You 3 polish)
    local avatarImage = Instance.new("ImageLabel")
    avatarImage.Size = UDim2.new(0, 64, 0, 64)
    avatarImage.Position = UDim2.new(0, 12, 0, 8)
    avatarImage.BackgroundTransparency = 1
    avatarImage.Image = string.format("https://www.roblox.com/headshot-thumbnail/image?userId=%d&width=420&height=420&format=png", player.UserId)
    avatarImage.Parent = playerSection
    
    local playerCard = createInfoCard(playerSection, "Username", player.Name)
    local displayNameCard = createInfoCard(playerSection, "Display Name", player.DisplayName)
    local levelCard = createInfoCard(playerSection, "Level", stats:FindFirstChild("Level") and stats.Level.Value or "N/A")

    -- Health & Energy Section with progress bars
    local statsSection = createSection(scrollFrame, "Stats")
    local healthCard = createInfoCard(statsSection, "Health", humanoid and math.floor(humanoid.Health) or "N/A", true)
    local maxHealthCard = createInfoCard(statsSection, "Max Health", humanoid and math.floor(humanoid.MaxHealth) or "N/A")
    local energyCard = createInfoCard(statsSection, "Energy", stats:FindFirstChild("Energy") and stats.Energy.Value or "N/A", true)
    local maxEnergyCard = createInfoCard(statsSection, "Max Energy", stats:FindFirstChild("MaxEnergy") and stats.MaxEnergy.Value or "N/A")

    -- Currency Section with formatting
    local currencySection = createSection(scrollFrame, "Currency")
    local belliesCard = createInfoCard(currencySection, "Bellies", stats:FindFirstChild("Bellies") and string.format("%,d", stats.Bellies.Value) or "0")
    local fragmentsCard = createInfoCard(currencySection, "Fragments", stats:FindFirstChild("Fragments") and string.format("%,d", stats.Fragments.Value) or "0")

    -- Fruit Section with mastery progress
    local fruitSection = createSection(scrollFrame, "Devil Fruit")
    local fruitCard = createInfoCard(fruitSection, "Current Fruit", stats:FindFirstChild("DevilFruit") and stats.DevilFruit.Value or "None")
    local masteryCard = createInfoCard(fruitSection, "Mastery", stats:FindFirstChild("FruitMastery") and stats.FruitMastery.Value or "0", true)

    -- Combat Stats Section
    local combatSection = createSection(scrollFrame,"Combat Stats")
    local strengthCard = createInfoCard(combatSection, "Strength", stats:FindFirstChild("Strength") and stats.Strength.Value or "0")
    local defenseCard = createInfoCard(combatSection, "Defense", stats:FindFirstChild("Defense") and stats.Defense.Value or "0")
    local swordCard = createInfoCard(combatSection, "Sword", stats:FindFirstChild("Sword") and stats.Sword.Value or "0")
    local gunCard = createInfoCard(combatSection, "Gun", stats:FindFirstChild("Gun") and stats.Gun.Value or "0")

    -- Auto-update values with smooth animations
    local function updateValues()
        debugPrint("updateValues called")
        if humanoid then
            local health = math.floor(humanoid.Health)
            local maxHealth = math.floor(humanoid.MaxHealth)
            healthCard.valueLabel.Text = tostring(health)
            maxHealthCard.valueLabel.Text = tostring(maxHealth)
            healthCard.progressBar.setProgress(health / maxHealth)
        end
        
        -- Update other dynamic values with animations
        if stats:FindFirstChild("Level") then 
            levelCard.valueLabel.Text = tostring(stats.Level.Value)
        end
        if stats:FindFirstChild("Energy") then
            local energy = stats.Energy.Value
            local maxEnergy = stats:FindFirstChild("MaxEnergy") and stats.MaxEnergy.Value or 100
            energyCard.valueLabel.Text = tostring(energy)
            energyCard.progressBar.setProgress(energy / maxEnergy)
        end
        if stats:FindFirstChild("MaxEnergy") then 
            maxEnergyCard.valueLabel.Text = tostring(stats.MaxEnergy.Value)
        end
        if stats:FindFirstChild("Bellies") then 
            belliesCard.valueLabel.Text = string.format("%,d", stats.Bellies.Value)
        end
        if stats:FindFirstChild("Fragments") then 
            fragmentsCard.valueLabel.Text = string.format("%,d", stats.Fragments.Value)
        end
        if stats:FindFirstChild("DevilFruit") then 
            fruitCard.valueLabel.Text = tostring(stats.DevilFruit.Value)
        end
        if stats:FindFirstChild("FruitMastery") then
            local mastery = stats.FruitMastery.Value
            masteryCard.valueLabel.Text = tostring(mastery)
            masteryCard.progressBar.setProgress(mastery / 100)
        end
        if stats:FindFirstChild("Strength") then 
            strengthCard.valueLabel.Text = tostring(stats.Strength.Value)
        end
        if stats:FindFirstChild("Defense") then 
            defenseCard.valueLabel.Text = tostring(stats.Defense.Value)
        end
        if stats:FindFirstChild("Sword") then 
            swordCard.valueLabel.Text = tostring(stats.Sword.Value)
        end
        if stats:FindFirstChild("Gun") then 
            gunCard.valueLabel.Text = tostring(stats.Gun.Value)
        end
    end

    -- Update values every frame for smooth animations
    local updateConnection = game:GetService("RunService").RenderStepped:Connect(updateValues)
    
    -- Clean up when panel is destroyed
    parent.AncestryChanged:Connect(function(_, parent)
        if not parent then
            updateConnection:Disconnect()
        end
    end)
end

-- Panel builder registry for Material You 3 theme
local panelBuilders = {
    Overview = function(parent)
        debugPrint("Overview panel builder called")
        contentPanel.Visible = true
        for _, child in ipairs(contentPanel:GetChildren()) do
            child:Destroy()
        end
        buildOverviewPanel(contentPanel)
    end,
    Farming = function(parent)
        debugPrint("Farming panel builder called")
        contentPanel.Visible = true
        for _, child in ipairs(contentPanel:GetChildren()) do
            child:Destroy()
        end
        local scrollFrame = Instance.new("ScrollingFrame")
        scrollFrame.Size = UDim2.new(1, -8, 1, -8)
        scrollFrame.Position = UDim2.new(0, 4, 0, 4)
        scrollFrame.BackgroundTransparency = 1
        scrollFrame.ScrollBarThickness = 4
        scrollFrame.ScrollBarImageColor3 = COLORS.primary
        scrollFrame.ScrollingDirection = Enum.ScrollingDirection.Y
        scrollFrame.ScrollBarImageTransparency = 0.5
        scrollFrame.Parent = parent

        -- Smooth scroll behavior (like Overview)
        local function smoothScroll(input)
            debugPrint("smoothScroll called")
            local delta = input.Position - input.LastPosition
            local topY = scrollFrame.CanvasPosition.Y
            createTween(scrollFrame, {CanvasPosition = Vector2.new(0, math.clamp(topY - delta.Y, 0, scrollFrame.AbsoluteCanvasSize.Y))}, 0.2):Play()
        end
        scrollFrame.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseWheel then
                smoothScroll(input)
            end
        end)

        local listLayout = Instance.new("UIListLayout")
        listLayout.Padding = UDim.new(0, 16)
        listLayout.Parent = scrollFrame
        local section = createSection(scrollFrame,"Farming Features")
        createInfoCard(section, "Auto Farm", "Coming Soon")
        createInfoCard(section, "Auto Collect", "Coming Soon")
    end,
    ["Sea Events"] = function(parent)
        debugPrint("Sea Events panel builder called")
        contentPanel.Visible = true
        for _, child in ipairs(contentPanel:GetChildren()) do
            child:Destroy()
        end
        local scrollFrame = Instance.new("ScrollingFrame")
        scrollFrame.Size = UDim2.new(1, -8, 1, -8)
        scrollFrame.Position = UDim2.new(0, 4, 0, 4)
        scrollFrame.BackgroundTransparency = 1
        scrollFrame.ScrollBarThickness = 4
        scrollFrame.ScrollBarImageColor3 = COLORS.primary
        scrollFrame.ScrollingDirection = Enum.ScrollingDirection.Y
        scrollFrame.ScrollBarImageTransparency = 0.5
        scrollFrame.Parent = parent

        -- Smooth scroll behavior (like Overview)
        local function smoothScroll(input)
            debugPrint("smoothScroll called")
            local delta = input.Position - input.LastPosition
            local topY = scrollFrame.CanvasPosition.Y
            createTween(scrollFrame, {CanvasPosition = Vector2.new(0, math.clamp(topY - delta.Y, 0, scrollFrame.AbsoluteCanvasSize.Y))}, 0.2):Play()
        end
        scrollFrame.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseWheel then
                smoothScroll(input)
            end
        end)

        local listLayout = Instance.new("UIListLayout")
        listLayout.Padding = UDim.new(0, 16)
        listLayout.Parent = scrollFrame
        local section = createSection(scrollFrame,"Sea Events")
        createInfoCard(section, "Event Tracker", "Coming Soon")
    end,
    Islands = function(parent)
        debugPrint("Islands panel builder called")
        contentPanel.Visible = true
        for _, child in ipairs(contentPanel:GetChildren()) do
            child:Destroy()
        end
        local scrollFrame = Instance.new("ScrollingFrame")
        scrollFrame.Size = UDim2.new(1, -8, 1, -8)
        scrollFrame.Position = UDim2.new(0, 4, 0, 4)
        scrollFrame.BackgroundTransparency = 1
        scrollFrame.ScrollBarThickness = 4
        scrollFrame.ScrollBarImageColor3 = COLORS.primary
        scrollFrame.ScrollingDirection = Enum.ScrollingDirection.Y
        scrollFrame.ScrollBarImageTransparency = 0.5
        scrollFrame.Parent = parent

        -- Smooth scroll behavior (like Overview)
        local function smoothScroll(input)
            debugPrint("smoothScroll called")
            local delta = input.Position - input.LastPosition
            local topY = scrollFrame.CanvasPosition.Y
            createTween(scrollFrame, {CanvasPosition = Vector2.new(0, math.clamp(topY - delta.Y, 0, scrollFrame.AbsoluteCanvasSize.Y))}, 0.2):Play()
        end
        scrollFrame.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseWheel then
                smoothScroll(input)
            end
        end)

        local listLayout = Instance.new("UIListLayout")
        listLayout.Padding = UDim.new(0, 16)
        listLayout.Parent = scrollFrame
        local section = createSection(scrollFrame,"Islands")
        createInfoCard(section, "Island List", "Coming Soon")
    end,
    Quests = function(parent)
        debugPrint("Quests panel builder called")
        contentPanel.Visible = true
        for _, child in ipairs(contentPanel:GetChildren()) do
            child:Destroy()
        end
        local scrollFrame = Instance.new("ScrollingFrame")
        scrollFrame.Size = UDim2.new(1, -8, 1, -8)
        scrollFrame.Position = UDim2.new(0, 4, 0, 4)
        scrollFrame.BackgroundTransparency = 1
        scrollFrame.ScrollBarThickness = 4
        scrollFrame.ScrollBarImageColor3 = COLORS.primary
        scrollFrame.ScrollingDirection = Enum.ScrollingDirection.Y
        scrollFrame.ScrollBarImageTransparency = 0.5
        scrollFrame.Parent = parent

        -- Smooth scroll behavior (like Overview)
        local function smoothScroll(input)
            debugPrint("smoothScroll called")
            local delta = input.Position - input.LastPosition
            local topY = scrollFrame.CanvasPosition.Y
            createTween(scrollFrame, {CanvasPosition = Vector2.new(0, math.clamp(topY - delta.Y, 0, scrollFrame.AbsoluteCanvasSize.Y))}, 0.2):Play()
        end
        scrollFrame.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseWheel then
                smoothScroll(input)
            end
        end)

        local listLayout = Instance.new("UIListLayout")
        listLayout.Padding = UDim.new(0, 16)
        listLayout.Parent = scrollFrame
        local section = createSection(scrollFrame,"Quests")
        createInfoCard(section, "Quest List", "Coming Soon")
    end,
    Fruit = function(parent)
        debugPrint("Fruit panel builder called")
        contentPanel.Visible = true
        for _, child in ipairs(contentPanel:GetChildren()) do
            child:Destroy()
        end
        local scrollFrame = Instance.new("ScrollingFrame")
        scrollFrame.Size = UDim2.new(1, -8, 1, -8)
        scrollFrame.Position = UDim2.new(0, 4, 0, 4)
        scrollFrame.BackgroundTransparency = 1
        scrollFrame.ScrollBarThickness = 4
        scrollFrame.ScrollBarImageColor3 = COLORS.primary
        scrollFrame.ScrollingDirection = Enum.ScrollingDirection.Y
        scrollFrame.ScrollBarImageTransparency = 0.5
        scrollFrame.Parent = parent

        -- Smooth scroll behavior (like Overview)
        local function smoothScroll(input)
            debugPrint("smoothScroll called")
            local delta = input.Position - input.LastPosition
            local topY = scrollFrame.CanvasPosition.Y
            createTween(scrollFrame, {CanvasPosition = Vector2.new(0, math.clamp(topY - delta.Y, 0, scrollFrame.AbsoluteCanvasSize.Y))}, 0.2):Play()
        end
        scrollFrame.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseWheel then
                smoothScroll(input)
            end
        end)

        local listLayout = Instance.new("UIListLayout")
        listLayout.Padding = UDim.new(0, 16)
        listLayout.Parent = scrollFrame
        local section = createSection(scrollFrame,"Fruit")
        createInfoCard(section, "Fruit Inventory", "Coming Soon")
    end,
    Teleport = function(parent)
        debugPrint("Teleport panel builder called")
        contentPanel.Visible = true
        for _, child in ipairs(contentPanel:GetChildren()) do
            child:Destroy()
        end
        local teleportLocations = {
            {name = "Starter Island"},
            {name = "Jungle"},
            {name = "Desert"},
            {name = "Sky Island"},
            {name = "Snow Island"},
        }
        local scrollFrame = Instance.new("ScrollingFrame")
        scrollFrame.Size = UDim2.new(1, -8, 1, -8)
        scrollFrame.Position = UDim2.new(0, 4, 0, 4)
        scrollFrame.BackgroundTransparency = 1
        scrollFrame.ScrollBarThickness = 4
        scrollFrame.ScrollBarImageColor3 = COLORS.primary
        scrollFrame.ScrollingDirection = Enum.ScrollingDirection.Y
        scrollFrame.ScrollBarImageTransparency = 0.5
        scrollFrame.Parent = parent

        -- Smooth scroll behavior (like Overview)
        local function smoothScroll(input)
            debugPrint("smoothScroll called")
            local delta = input.Position - input.LastPosition
            local topY = scrollFrame.CanvasPosition.Y
            createTween(scrollFrame, {CanvasPosition = Vector2.new(0, math.clamp(topY - delta.Y, 0, scrollFrame.AbsoluteCanvasSize.Y))}, 0.2):Play()
        end
        scrollFrame.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseWheel then
                smoothScroll(input)
            end
        end)

        local listLayout = Instance.new("UIListLayout")
        listLayout.Padding = UDim.new(0, 16)
        listLayout.Parent = scrollFrame
        local section = createSection(scrollFrame,"Teleport Locations")
        for _, loc in ipairs(teleportLocations) do
            createInfoCard(section, loc.name, "Click to teleport")
        end
    end,
    Status = function(parent)
        debugPrint("Status panel builder called")
        contentPanel.Visible = true
        for _, child in ipairs(contentPanel:GetChildren()) do
            child:Destroy()
        end
        local scrollFrame = Instance.new("ScrollingFrame")
        scrollFrame.Size = UDim2.new(1, -8, 1, -8)
        scrollFrame.Position = UDim2.new(0, 4, 0, 4)
        scrollFrame.BackgroundTransparency = 1
        scrollFrame.ScrollBarThickness = 4
        scrollFrame.ScrollBarImageColor3 = COLORS.primary
        scrollFrame.ScrollingDirection = Enum.ScrollingDirection.Y
        scrollFrame.ScrollBarImageTransparency = 0.5
        scrollFrame.Parent = parent

        -- Smooth scroll behavior (like Overview)
        local function smoothScroll(input)
            debugPrint("smoothScroll called")
            local delta = input.Position - input.LastPosition
            local topY = scrollFrame.CanvasPosition.Y
            createTween(scrollFrame, {CanvasPosition = Vector2.new(0, math.clamp(topY - delta.Y, 0, scrollFrame.AbsoluteCanvasSize.Y))}, 0.2):Play()
        end
        scrollFrame.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseWheel then
                smoothScroll(input)
            end
        end)

        local listLayout = Instance.new("UIListLayout")
        listLayout.Padding = UDim.new(0, 16)
        listLayout.Parent = scrollFrame
        local section = createSection(scrollFrame,"Status")
        createInfoCard(section, "Player Status", "Coming Soon")
    end,
    Visual = function(parent)
        debugPrint("Visual panel builder called")
        contentPanel.Visible = true
        for _, child in ipairs(contentPanel:GetChildren()) do
            child:Destroy()
        end
        local scrollFrame = Instance.new("ScrollingFrame")
        scrollFrame.Size = UDim2.new(1, -8, 1, -8)
        scrollFrame.Position = UDim2.new(0, 4, 0, 4)
        scrollFrame.BackgroundTransparency = 1
        scrollFrame.ScrollBarThickness = 4
        scrollFrame.ScrollBarImageColor3 = COLORS.primary
        scrollFrame.ScrollingDirection = Enum.ScrollingDirection.Y
        scrollFrame.ScrollBarImageTransparency = 0.5
        scrollFrame.Parent = parent

        -- Smooth scroll behavior (like Overview)
        local function smoothScroll(input)
            debugPrint("smoothScroll called")
            local delta = input.Position - input.LastPosition
            local topY = scrollFrame.CanvasPosition.Y
            createTween(scrollFrame, {CanvasPosition = Vector2.new(0, math.clamp(topY - delta.Y, 0, scrollFrame.AbsoluteCanvasSize.Y))}, 0.2):Play()
        end
        scrollFrame.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseWheel then
                smoothScroll(input)
            end
        end)

        local listLayout = Instance.new("UIListLayout")
        listLayout.Padding = UDim.new(0, 16)
        listLayout.Parent = scrollFrame
        local section = createSection(scrollFrame,"Visual Features")
        createInfoCard(section, "Visual Enhancements", "Coming Soon")
    end,
    Shop = function(parent)
        debugPrint("Shop panel builder called")
        contentPanel.Visible = true
        for _, child in ipairs(contentPanel:GetChildren()) do
            child:Destroy()
        end
        local scrollFrame = Instance.new("ScrollingFrame")
        scrollFrame.Size = UDim2.new(1, -8, 1, -8)
        scrollFrame.Position = UDim2.new(0, 4, 0, 4)
        scrollFrame.BackgroundTransparency = 1
        scrollFrame.ScrollBarThickness = 4
        scrollFrame.ScrollBarImageColor3 = COLORS.primary
        scrollFrame.ScrollingDirection = Enum.ScrollingDirection.Y
        scrollFrame.ScrollBarImageTransparency = 0.5
        scrollFrame.Parent = parent

        -- Smooth scroll behavior (like Overview)
        local function smoothScroll(input)
            debugPrint("smoothScroll called")
            local delta = input.Position - input.LastPosition
            local topY = scrollFrame.CanvasPosition.Y
            createTween(scrollFrame, {CanvasPosition = Vector2.new(0, math.clamp(topY - delta.Y, 0, scrollFrame.AbsoluteCanvasSize.Y))}, 0.2):Play()
        end
        scrollFrame.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseWheel then
                smoothScroll(input)
            end
        end)

        local listLayout = Instance.new("UIListLayout")
        listLayout.Padding = UDim.new(0, 16)
        listLayout.Parent = scrollFrame
        local section = createSection(scrollFrame,"Shop")
        createInfoCard(section, "Shop Items", "Coming Soon")
    end,
    Settings = function(parent)
        debugPrint("Settings panel builder called")
        contentPanel.Visible = true
        for _, child in ipairs(contentPanel:GetChildren()) do
            child:Destroy()
        end
        local scrollFrame = Instance.new("ScrollingFrame")
        scrollFrame.Size = UDim2.new(1, -8, 1, -8)
        scrollFrame.Position = UDim2.new(0, 4, 0, 4)
        scrollFrame.BackgroundTransparency = 1
        scrollFrame.ScrollBarThickness = 4
        scrollFrame.ScrollBarImageColor3 = COLORS.primary
        scrollFrame.ScrollingDirection = Enum.ScrollingDirection.Y
        scrollFrame.ScrollBarImageTransparency = 0.5
        scrollFrame.Parent = parent

        -- Smooth scroll behavior (like Overview)
        local function smoothScroll(input)
            debugPrint("smoothScroll called")
            local delta = input.Position - input.LastPosition
            local topY = scrollFrame.CanvasPosition.Y
            createTween(scrollFrame, {CanvasPosition = Vector2.new(0, math.clamp(topY - delta.Y, 0, scrollFrame.AbsoluteCanvasSize.Y))}, 0.2):Play()
        end
        scrollFrame.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseWheel then
                smoothScroll(input)
            end
        end)

        local listLayout = Instance.new("UIListLayout")
        listLayout.Padding = UDim.new(0, 16)
        listLayout.Parent = scrollFrame
        local section = createSection(scrollFrame,"Settings")
        createInfoCard(section, "Settings", "Coming Soon")
    end,
    About = function(parent)
        debugPrint("About panel builder called")
        contentPanel.Visible = true
        for _, child in ipairs(contentPanel:GetChildren()) do
            child:Destroy()
        end
        local scrollFrame = Instance.new("ScrollingFrame")
        scrollFrame.Size = UDim2.new(1, -8, 1, -8)
        scrollFrame.Position = UDim2.new(0, 4, 0, 4)
        scrollFrame.BackgroundTransparency = 1
        scrollFrame.ScrollBarThickness = 4
        scrollFrame.ScrollBarImageColor3 = COLORS.primary
        scrollFrame.ScrollingDirection = Enum.ScrollingDirection.Y
        scrollFrame.ScrollBarImageTransparency = 0.5
        scrollFrame.Parent = parent

        -- Smooth scroll behavior (like Overview)
        local function smoothScroll(input)
            debugPrint("smoothScroll called")
            local delta = input.Position - input.LastPosition
            local topY = scrollFrame.CanvasPosition.Y
            createTween(scrollFrame, {CanvasPosition = Vector2.new(0, math.clamp(topY - delta.Y, 0, scrollFrame.AbsoluteCanvasSize.Y))}, 0.2):Play()
        end
        scrollFrame.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseWheel then
                smoothScroll(input)
            end
        end)

        local listLayout = Instance.new("UIListLayout")
        listLayout.Padding = UDim.new(0, 16)
        listLayout.Parent = scrollFrame
        local section = createSection(scrollFrame,"About")
        createInfoCard(section, "Delta Codex", "UI by XrayWizz, Material You 3 Themed")
    end,
}

-- Debug print for showButtonList function
local function showButtonList()
    debugPrint("showButtonList called")
    clearContent()
    backBtn.Visible = false
    titleLabel.Text = "Delta Codex"
    contentPanel.Visible = true
    local btnW, btnH = 160, 36
    local gapX, gapY = 16, 12
    local cols, rows = 2, 6
    local offsetX = 22
    local offsetY = 8 -- reduce gap between title bar and main menu buttons
    for i, name in ipairs(buttonNames) do
        if name ~= "" then
            local col = ((i-1) % cols)
            local row = math.floor((i-1) / cols)
            local btn = Instance.new("TextButton")
            btn.Name = name .. "Button"
            btn.Size = UDim2.new(0, btnW, 0, btnH)
            btn.Position = UDim2.new(0, offsetX + col * (btnW + gapX), 0, offsetY + row * (btnH + gapY))
            btn.BackgroundColor3 = COLORS.surfaceVariant
            btn.Text = name
            btn.TextColor3 = COLORS.onSurface
            btn.Font = Enum.Font.GothamSemibold
            btn.TextSize = 16
            btn.AutoButtonColor = true
            btn.Parent = contentPanel
            btn.ZIndex = 2

            local btnCorner = Instance.new("UICorner")
            btnCorner.CornerRadius = UDim.new(0, 12)
            btnCorner.Parent = btn

            local btnStroke = Instance.new("UIStroke")
            btnStroke.Thickness = 1
            btnStroke.Color = COLORS.outline
            btnStroke.Transparency = 0.4
            btnStroke.Parent = btn

            btn.MouseButton1Click:Connect(function()
                debugPrint("Button clicked")
                contentPanel.Visible = false
                backBtn.Visible = true
                titleLabel.Text = name
                if panelBuilders[name] then
                    clearContent()
                    panelBuilders[name](contentPanel)
                end
            end)
        end
    end
end

-- Ensure showButtonList is called on load
debugPrint("Calling showButtonList on load")
showButtonList()

-- Make Back button return to main menu
backBtn.MouseButton1Click:Connect(function()
    debugPrint("Back button clicked")
    showButtonList()
    backBtn.Visible = false
    titleLabel.Text = "Delta Codex"  -- Reset title to 'Delta Codex'
end)

-- Ensure Close button always works
if closeBtn then
    closeBtn.MouseButton1Click:Connect(function()
        debugPrint("Close button clicked")
        screenGui.Enabled = false
    end)
else
    debugPrint("closeBtn is not initialized")
end
