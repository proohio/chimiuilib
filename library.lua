local ChimiUI = {}

local tween = game:GetService("TweenService")
local tweeninfo = TweenInfo.new
local input = game:GetService("UserInputService")
local run = game:GetService("RunService")

local Utility = {}
local Objects = {}

function ChimiUI:DraggingEnabled(frame, parent)
    parent = parent or frame
    local dragging = false
    local dragInput, mousePos, framePos

    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            mousePos = input.Position
            framePos = parent.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)

    input.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - mousePos
            parent.Position = UDim2.new(framePos.X.Scale, framePos.X.Offset + delta.X, framePos.Y.Scale, framePos.Y.Offset + delta.Y)
        end
    end)
end

function Utility:TweenObject(obj, properties, duration, ...)
    tween:Create(obj, tweeninfo(duration, ...), properties):Play()
end

-- Modern Theme Definitions
local themes = {
    SchemeColor = Color3.fromRGB(100, 100, 100),
    Background = Color3.fromRGB(20, 20, 20),
    Header = Color3.fromRGB(15, 15, 15),
    TextColor = Color3.fromRGB(255, 255, 255),
    ElementColor = Color3.fromRGB(30, 30, 30),
    AccentColor = Color3.fromRGB(200, 200, 200)
}

local themeStyles = {
    Chimi = {
        SchemeColor = Color3.fromRGB(255, 255, 255),
        Background = Color3.fromRGB(12, 12, 12),
        Header = Color3.fromRGB(8, 8, 8),
        TextColor = Color3.fromRGB(255, 255, 255),
        ElementColor = Color3.fromRGB(18, 18, 18),
        AccentColor = Color3.fromRGB(240, 240, 240)
    },
    DarkTheme = {
        SchemeColor = Color3.fromRGB(64, 64, 64),
        Background = Color3.fromRGB(0, 0, 0),
        Header = Color3.fromRGB(0, 0, 0),
        TextColor = Color3.fromRGB(255, 255, 255),
        ElementColor = Color3.fromRGB(20, 20, 20),
        AccentColor = Color3.fromRGB(100, 100, 100)
    },
    LightTheme = {
        SchemeColor = Color3.fromRGB(150, 150, 150),
        Background = Color3.fromRGB(255, 255, 255),
        Header = Color3.fromRGB(200, 200, 200),
        TextColor = Color3.fromRGB(0, 0, 0),
        ElementColor = Color3.fromRGB(224, 224, 224),
        AccentColor = Color3.fromRGB(180, 180, 180)
    },
    Ocean = {
        SchemeColor = Color3.fromRGB(86, 76, 251),
        Background = Color3.fromRGB(26, 32, 58),
        Header = Color3.fromRGB(38, 45, 71),
        TextColor = Color3.fromRGB(200, 200, 200),
        ElementColor = Color3.fromRGB(38, 45, 71),
        AccentColor = Color3.fromRGB(120, 110, 255)
    }
}

local LibName = tostring(math.random(1, 100))..tostring(math.random(1, 50))..tostring(math.random(1, 100))

function ChimiUI:ToggleUI()
    if game.CoreGui[LibName].Enabled then
        game.CoreGui[LibName].Enabled = false
    else
        game.CoreGui[LibName].Enabled = true
    end
end

function ChimiUI.CreateLib(libraryName, themeList)
    if not themeList then
        themeList = themes
    end
    
    -- Theme selection
    if type(themeList) == "string" then
        if themeList == "Chimi" then
            themeList = themeStyles.Chimi
        elseif themeList == "DarkTheme" then
            themeList = themeStyles.DarkTheme
        elseif themeList == "LightTheme" then
            themeList = themeStyles.LightTheme
        elseif themeList == "Ocean" then
            themeList = themeStyles.Ocean
        end
    end

    libraryName = libraryName or "Chimi UI"
    
    -- Clean up existing UI
    for i, v in pairs(game.CoreGui:GetChildren()) do
        if v:IsA("ScreenGui") and v.Name == libraryName then
            v:Destroy()
        end
    end

    -- Create UI Elements
    local ScreenGui = Instance.new("ScreenGui")
    local Main = Instance.new("Frame")
    local MainCorner = Instance.new("UICorner")
    local UIStroke = Instance.new("UIStroke")
    local MainHeader = Instance.new("Frame")
    local HeaderCorner = Instance.new("UICorner")
    local Title = Instance.new("TextLabel")
    local CloseButton = Instance.new("TextButton")
    local CloseCorner = Instance.new("UICorner")
    local Sidebar = Instance.new("Frame")
    local SidebarCorner = Instance.new("UICorner")
    local TabContainer = Instance.new("Frame")
    local TabLayout = Instance.new("UIListLayout")
    local ContentFrame = Instance.new("Frame")
    local Pages = Instance.new("Folder")
    local InfoContainer = Instance.new("Frame")
    local BlurFrame = Instance.new("Frame")

    ChimiUI:DraggingEnabled(MainHeader, Main)

    -- ScreenGui Setup
    ScreenGui.Parent = game.CoreGui
    ScreenGui.Name = LibName
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.ResetOnSpawn = false

    -- Main Frame
    Main.Name = "Main"
    Main.Parent = ScreenGui
    Main.BackgroundColor3 = themeList.Background
    Main.BorderSizePixel = 0
    Main.Position = UDim2.new(0.5, -325, 0.5, -225)
    Main.Size = UDim2.new(0, 650, 0, 450)
    Main.ClipsDescendants = true

    MainCorner.CornerRadius = UDim.new(0, 8)
    MainCorner.Parent = Main

    UIStroke.Parent = Main
    UIStroke.Color = themeList.SchemeColor
    UIStroke.Thickness = 1
    UIStroke.Transparency = 0.8

    -- Header
    MainHeader.Name = "Header"
    MainHeader.Parent = Main
    MainHeader.BackgroundColor3 = themeList.Header
    MainHeader.BorderSizePixel = 0
    MainHeader.Size = UDim2.new(1, 0, 0, 45)

    HeaderCorner.CornerRadius = UDim.new(0, 8)
    HeaderCorner.Parent = MainHeader

    local HeaderCover = Instance.new("Frame")
    HeaderCover.Parent = MainHeader
    HeaderCover.BackgroundColor3 = themeList.Header
    HeaderCover.BorderSizePixel = 0
    HeaderCover.Position = UDim2.new(0, 0, 0.7, 0)
    HeaderCover.Size = UDim2.new(1, 0, 0.3, 0)

    -- Title
    Title.Name = "Title"
    Title.Parent = MainHeader
    Title.BackgroundTransparency = 1
    Title.Position = UDim2.new(0, 20, 0, 0)
    Title.Size = UDim2.new(0, 400, 1, 0)
    Title.Font = Enum.Font.GothamBold
    Title.Text = libraryName
    Title.TextColor3 = themeList.TextColor
    Title.TextSize = 17
    Title.TextXAlignment = Enum.TextXAlignment.Left

    -- Minimize Button
    local MinimizeButton = Instance.new("TextButton")
    local MinimizeCorner = Instance.new("UICorner")
    local MinimizeStroke = Instance.new("UIStroke")
    
    MinimizeButton.Name = "Minimize"
    MinimizeButton.Parent = MainHeader
    MinimizeButton.BackgroundColor3 = themeList.ElementColor
    MinimizeButton.BorderSizePixel = 0
    MinimizeButton.Position = UDim2.new(1, -95, 0.5, -12)
    MinimizeButton.Size = UDim2.new(0, 35, 0, 24)
    MinimizeButton.Font = Enum.Font.GothamBold
    MinimizeButton.Text = "−"
    MinimizeButton.TextColor3 = themeList.TextColor
    MinimizeButton.TextSize = 18

    MinimizeCorner.CornerRadius = UDim.new(0, 5)
    MinimizeCorner.Parent = MinimizeButton

    MinimizeStroke.Parent = MinimizeButton
    MinimizeStroke.Color = themeList.SchemeColor
    MinimizeStroke.Thickness = 1
    MinimizeStroke.Transparency = 0.8

    local minimized = false
    MinimizeButton.MouseButton1Click:Connect(function()
        minimized = not minimized
        if minimized then
            Utility:TweenObject(Main, {Size = UDim2.new(0, 650, 0, 45)}, 0.3)
        else
            Utility:TweenObject(Main, {Size = UDim2.new(0, 650, 0, 450)}, 0.3)
        end
    end)

    MinimizeButton.MouseEnter:Connect(function()
        Utility:TweenObject(MinimizeStroke, {Transparency = 0.4}, 0.1)
    end)

    MinimizeButton.MouseLeave:Connect(function()
        Utility:TweenObject(MinimizeStroke, {Transparency = 0.8}, 0.1)
    end)

    -- Close Button
    local CloseStroke = Instance.new("UIStroke")
    local closeHovering = false
    
    CloseButton.Name = "Close"
    CloseButton.Parent = MainHeader
    CloseButton.BackgroundColor3 = themeList.ElementColor
    CloseButton.BorderSizePixel = 0
    CloseButton.Position = UDim2.new(1, -50, 0.5, -12)
    CloseButton.Size = UDim2.new(0, 35, 0, 24)
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.Text = "×"
    CloseButton.TextColor3 = themeList.TextColor
    CloseButton.TextSize = 20

    CloseCorner.CornerRadius = UDim.new(0, 5)
    CloseCorner.Parent = CloseButton

    CloseStroke.Parent = CloseButton
    CloseStroke.Color = themeList.SchemeColor
    CloseStroke.Thickness = 1
    CloseStroke.Transparency = 0.8

    CloseButton.MouseButton1Click:Connect(function()
        Utility:TweenObject(Main, {Size = UDim2.new(0, 0, 0, 0)}, 0.2)
        wait(0.2)
        ScreenGui:Destroy()
    end)

    local closeHovering = false
    CloseButton.MouseEnter:Connect(function()
        closeHovering = true
        Utility:TweenObject(CloseButton, {BackgroundColor3 = Color3.fromRGB(220, 50, 50)}, 0.1)
        Utility:TweenObject(CloseStroke, {Color = Color3.fromRGB(255, 70, 70), Transparency = 0.3}, 0.1)
    end)

    CloseButton.MouseLeave:Connect(function()
        closeHovering = false
        Utility:TweenObject(CloseButton, {BackgroundColor3 = themeList.ElementColor}, 0.1)
        Utility:TweenObject(CloseStroke, {Color = themeList.SchemeColor, Transparency = 0.8}, 0.1)
    end)

    -- Sidebar
    Sidebar.Name = "Sidebar"
    Sidebar.Parent = Main
    Sidebar.BackgroundColor3 = themeList.Header
    Sidebar.BorderSizePixel = 0
    Sidebar.Position = UDim2.new(0, 0, 0, 45)
    Sidebar.Size = UDim2.new(0, 180, 1, -45)

    SidebarCorner.CornerRadius = UDim.new(0, 8)
    SidebarCorner.Parent = Sidebar

    local SidebarCover = Instance.new("Frame")
    SidebarCover.Parent = Sidebar
    SidebarCover.BackgroundColor3 = themeList.Header
    SidebarCover.BorderSizePixel = 0
    SidebarCover.Position = UDim2.new(1, -8, 0, 0)
    SidebarCover.Size = UDim2.new(0, 8, 1, 0)

    -- Tab Container
    TabContainer.Name = "TabContainer"
    TabContainer.Parent = Sidebar
    TabContainer.BackgroundTransparency = 1
    TabContainer.Position = UDim2.new(0, 10, 0, 10)
    TabContainer.Size = UDim2.new(1, -20, 1, -20)

    TabLayout.Parent = TabContainer
    TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabLayout.Padding = UDim.new(0, 8)

    -- Content Frame
    ContentFrame.Name = "Content"
    ContentFrame.Parent = Main
    ContentFrame.BackgroundTransparency = 1
    ContentFrame.Position = UDim2.new(0, 190, 0, 55)
    ContentFrame.Size = UDim2.new(1, -200, 1, -65)

    Pages.Name = "Pages"
    Pages.Parent = ContentFrame

    BlurFrame.Name = "BlurFrame"
    BlurFrame.Parent = ContentFrame
    BlurFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    BlurFrame.BackgroundTransparency = 1
    BlurFrame.BorderSizePixel = 0
    BlurFrame.Size = UDim2.new(1, 0, 1, 0)
    BlurFrame.ZIndex = 999

    InfoContainer.Name = "InfoContainer"
    InfoContainer.Parent = Main
    InfoContainer.BackgroundTransparency = 1
    InfoContainer.ClipsDescendants = true
    InfoContainer.Position = UDim2.new(0, 190, 1, -35)
    InfoContainer.Size = UDim2.new(1, -200, 0, 30)

    -- Theme updating (optimized - removed button updates to prevent hover conflicts)
    coroutine.wrap(function()
        while wait(0.5) do
            Main.BackgroundColor3 = themeList.Background
            MainHeader.BackgroundColor3 = themeList.Header
            HeaderCover.BackgroundColor3 = themeList.Header
            Sidebar.BackgroundColor3 = themeList.Header
            SidebarCover.BackgroundColor3 = themeList.Header
            Title.TextColor3 = themeList.TextColor
            UIStroke.Color = themeList.SchemeColor
            if not closeHovering then
                CloseStroke.Color = themeList.SchemeColor
            end
        end
    end)()

    function ChimiUI:ChangeColor(property, color)
        if property == "Background" then
            themeList.Background = color
        elseif property == "SchemeColor" then
            themeList.SchemeColor = color
        elseif property == "Header" then
            themeList.Header = color
        elseif property == "TextColor" then
            themeList.TextColor = color
        elseif property == "ElementColor" then
            themeList.ElementColor = color
        elseif property == "AccentColor" then
            themeList.AccentColor = color
        end
    end

    local Tabs = {}
    local firstTab = true

    function Tabs:NewTab(tabName)
        tabName = tabName or "Tab"
        
        local TabButton = Instance.new("TextButton")
        local TabCorner = Instance.new("UICorner")
        local TabStroke = Instance.new("UIStroke")
        local Page = Instance.new("ScrollingFrame")
        local PageLayout = Instance.new("UIListLayout")

        local function UpdateSize()
            local contentSize = PageLayout.AbsoluteContentSize
            game.TweenService:Create(Page, TweenInfo.new(0.15, Enum.EasingStyle.Linear), {
                CanvasSize = UDim2.new(0, contentSize.X, 0, contentSize.Y)
            }):Play()
        end

        -- Page Setup
        Page.Name = tabName.."_Page"
        Page.Parent = Pages
        Page.Active = true
        Page.BackgroundTransparency = 1
        Page.BorderSizePixel = 0
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.ScrollBarThickness = 4
        Page.ScrollBarImageColor3 = themeList.SchemeColor
        Page.Visible = false

        PageLayout.Parent = Page
        PageLayout.SortOrder = Enum.SortOrder.LayoutOrder
        PageLayout.Padding = UDim.new(0, 10)

        -- Tab Button
        TabButton.Name = tabName
        TabButton.Parent = TabContainer
        TabButton.BackgroundColor3 = themeList.ElementColor
        TabButton.BackgroundTransparency = firstTab and 0 or 0.5
        TabButton.BorderSizePixel = 0
        TabButton.Size = UDim2.new(1, 0, 0, 40)
        TabButton.AutoButtonColor = false
        TabButton.Font = Enum.Font.GothamSemibold
        TabButton.Text = tabName
        TabButton.TextColor3 = themeList.TextColor
        TabButton.TextSize = 14

        TabCorner.CornerRadius = UDim.new(0, 6)
        TabCorner.Parent = TabButton

        TabStroke.Parent = TabButton
        TabStroke.Color = themeList.SchemeColor
        TabStroke.Thickness = 1
        TabStroke.Transparency = firstTab and 0.5 or 1

        if firstTab then
            Page.Visible = true
            firstTab = false
            UpdateSize()
        end

        TabButton.MouseButton1Click:Connect(function()
            for _, page in pairs(Pages:GetChildren()) do
                page.Visible = false
            end
            Page.Visible = true
            
            for _, tab in pairs(TabContainer:GetChildren()) do
                if tab:IsA("TextButton") then
                    Utility:TweenObject(tab, {BackgroundTransparency = 0.5}, 0.2)
                    if tab:FindFirstChild("UIStroke") then
                        Utility:TweenObject(tab.UIStroke, {Transparency = 1}, 0.2)
                    end
                end
            end
            
            Utility:TweenObject(TabButton, {BackgroundTransparency = 0}, 0.2)
            Utility:TweenObject(TabStroke, {Transparency = 0.5}, 0.2)
            UpdateSize()
        end)

        TabButton.MouseEnter:Connect(function()
            if Page.Visible == false then
                Utility:TweenObject(TabButton, {BackgroundTransparency = 0.3}, 0.1)
            end
        end)

        TabButton.MouseLeave:Connect(function()
            if Page.Visible == false then
                Utility:TweenObject(TabButton, {BackgroundTransparency = 0.5}, 0.1)
            end
        end)

        Page.ChildAdded:Connect(UpdateSize)
        Page.ChildRemoved:Connect(UpdateSize)

        coroutine.wrap(function()
            while wait(0.5) do
                TabButton.BackgroundColor3 = themeList.ElementColor
                TabButton.TextColor3 = themeList.TextColor
                TabStroke.Color = themeList.SchemeColor
                Page.ScrollBarImageColor3 = themeList.SchemeColor
            end
        end)()

        local Sections = {}

        function Sections:NewSection(sectionName, hidden)
            sectionName = sectionName or "Section"
            hidden = hidden or false
            
            local SectionFrame = Instance.new("Frame")
            local SectionLayout = Instance.new("UIListLayout")
            local SectionHeader = Instance.new("Frame")
            local HeaderCorner = Instance.new("UICorner")
            local SectionTitle = Instance.new("TextLabel")
            local SectionContent = Instance.new("Frame")
            local ContentLayout = Instance.new("UIListLayout")

            SectionFrame.Name = "Section"
            SectionFrame.Parent = Page
            SectionFrame.BackgroundTransparency = 1
            SectionFrame.Size = UDim2.new(1, 0, 0, 40)

            SectionLayout.Parent = SectionFrame
            SectionLayout.SortOrder = Enum.SortOrder.LayoutOrder
            SectionLayout.Padding = UDim.new(0, 6)

            SectionHeader.Name = "Header"
            SectionHeader.Parent = SectionFrame
            SectionHeader.BackgroundColor3 = themeList.SchemeColor
            SectionHeader.BackgroundTransparency = 0.95
            SectionHeader.BorderSizePixel = 0
            SectionHeader.Size = UDim2.new(1, 0, 0, 32)
            SectionHeader.Visible = not hidden

            HeaderCorner.CornerRadius = UDim.new(0, 6)
            HeaderCorner.Parent = SectionHeader

            local HeaderStroke = Instance.new("UIStroke")
            HeaderStroke.Parent = SectionHeader
            HeaderStroke.Color = themeList.SchemeColor
            HeaderStroke.Thickness = 1
            HeaderStroke.Transparency = 0.9

            SectionTitle.Parent = SectionHeader
            SectionTitle.BackgroundTransparency = 1
            SectionTitle.Size = UDim2.new(1, -20, 1, 0)
            SectionTitle.Position = UDim2.new(0, 15, 0, 0)
            SectionTitle.Font = Enum.Font.GothamBold
            SectionTitle.Text = sectionName
            SectionTitle.TextColor3 = themeList.TextColor
            SectionTitle.TextSize = 13
            SectionTitle.TextXAlignment = Enum.TextXAlignment.Left

            SectionContent.Name = "Content"
            SectionContent.Parent = SectionFrame
            SectionContent.BackgroundTransparency = 1
            SectionContent.Size = UDim2.new(1, 0, 0, 0)

            ContentLayout.Parent = SectionContent
            ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
            ContentLayout.Padding = UDim.new(0, 6)

            local function UpdateSectionSize()
                local contentSize = ContentLayout.AbsoluteContentSize
                SectionContent.Size = UDim2.new(1, 0, 0, contentSize.Y)
                local totalSize = SectionLayout.AbsoluteContentSize
                SectionFrame.Size = UDim2.new(1, 0, 0, totalSize.Y)
                UpdateSize()
            end

            SectionContent.ChildAdded:Connect(UpdateSectionSize)
            SectionContent.ChildRemoved:Connect(UpdateSectionSize)

            coroutine.wrap(function()
                while wait(0.5) do
                    SectionHeader.BackgroundColor3 = themeList.SchemeColor
                    SectionTitle.TextColor3 = themeList.TextColor
                    HeaderStroke.Color = themeList.SchemeColor
                end
            end)()

            local Elements = {}

            function Elements:NewButton(buttonName, buttonInfo, callback)
                buttonName = buttonName or "Button"
                buttonInfo = buttonInfo or "Click this button"
                callback = callback or function() end

                local Button = Instance.new("TextButton")
                local ButtonCorner = Instance.new("UICorner")
                local ButtonStroke = Instance.new("UIStroke")

                Button.Name = "Button"
                Button.Parent = SectionContent
                Button.BackgroundColor3 = themeList.ElementColor
                Button.BorderSizePixel = 0
                Button.Size = UDim2.new(1, 0, 0, 40)
                Button.AutoButtonColor = false
                Button.Font = Enum.Font.GothamSemibold
                Button.Text = buttonName
                Button.TextColor3 = themeList.TextColor
                Button.TextSize = 14

                ButtonCorner.CornerRadius = UDim.new(0, 6)
                ButtonCorner.Parent = Button

                ButtonStroke.Parent = Button
                ButtonStroke.Color = themeList.SchemeColor
                ButtonStroke.Thickness = 1
                ButtonStroke.Transparency = 0.9

                Button.MouseButton1Click:Connect(function()
                    callback()
                    Utility:TweenObject(Button, {BackgroundColor3 = themeList.SchemeColor}, 0.1)
                    wait(0.1)
                    Utility:TweenObject(Button, {BackgroundColor3 = themeList.ElementColor}, 0.1)
                end)

                Button.MouseEnter:Connect(function()
                    Utility:TweenObject(ButtonStroke, {Transparency = 0.6}, 0.1)
                end)

                Button.MouseLeave:Connect(function()
                    Utility:TweenObject(ButtonStroke, {Transparency = 0.9}, 0.1)
                end)

                coroutine.wrap(function()
                    while wait(0.5) do
                        Button.TextColor3 = themeList.TextColor
                        ButtonStroke.Color = themeList.SchemeColor
                    end
                end)()

                UpdateSectionSize()

                local ButtonFunctions = {}
                function ButtonFunctions:UpdateButton(newText)
                    Button.Text = newText
                end
                return ButtonFunctions
            end

            function Elements:NewToggle(toggleName, toggleInfo, callback)
                toggleName = toggleName or "Toggle"
                toggleInfo = toggleInfo or "Toggle something"
                callback = callback or function() end
                local toggled = false

                local Toggle = Instance.new("TextButton")
                local ToggleCorner = Instance.new("UICorner")
                local ToggleStroke = Instance.new("UIStroke")
                local ToggleLabel = Instance.new("TextLabel")
                local ToggleIndicator = Instance.new("Frame")
                local IndicatorCorner = Instance.new("UICorner")

                Toggle.Name = "Toggle"
                Toggle.Parent = SectionContent
                Toggle.BackgroundColor3 = themeList.ElementColor
                Toggle.BorderSizePixel = 0
                Toggle.Size = UDim2.new(1, 0, 0, 40)
                Toggle.AutoButtonColor = false
                Toggle.Text = ""

                ToggleCorner.CornerRadius = UDim.new(0, 6)
                ToggleCorner.Parent = Toggle

                ToggleStroke.Parent = Toggle
                ToggleStroke.Color = themeList.SchemeColor
                ToggleStroke.Thickness = 1
                ToggleStroke.Transparency = 0.9

                ToggleLabel.Parent = Toggle
                ToggleLabel.BackgroundTransparency = 1
                ToggleLabel.Position = UDim2.new(0, 15, 0, 0)
                ToggleLabel.Size = UDim2.new(1, -60, 1, 0)
                ToggleLabel.Font = Enum.Font.GothamSemibold
                ToggleLabel.Text = toggleName
                ToggleLabel.TextColor3 = themeList.TextColor
                ToggleLabel.TextSize = 14
                ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left

                ToggleIndicator.Name = "Indicator"
                ToggleIndicator.Parent = Toggle
                ToggleIndicator.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
                ToggleIndicator.BorderSizePixel = 0
                ToggleIndicator.Position = UDim2.new(1, -35, 0.5, -8)
                ToggleIndicator.Size = UDim2.new(0, 24, 0, 16)

                IndicatorCorner.CornerRadius = UDim.new(1, 0)
                IndicatorCorner.Parent = ToggleIndicator

                local IndicatorCircle = Instance.new("Frame")
                local CircleCorner = Instance.new("UICorner")
                IndicatorCircle.Parent = ToggleIndicator
                IndicatorCircle.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
                IndicatorCircle.BorderSizePixel = 0
                IndicatorCircle.Position = UDim2.new(0, 2, 0.5, -6)
                IndicatorCircle.Size = UDim2.new(0, 12, 0, 12)
                CircleCorner.CornerRadius = UDim.new(1, 0)
                CircleCorner.Parent = IndicatorCircle

                Toggle.MouseButton1Click:Connect(function()
                    toggled = not toggled
                    
                    if toggled then
                        Utility:TweenObject(IndicatorCircle, {Position = UDim2.new(1, -14, 0.5, -6)}, 0.2)
                        Utility:TweenObject(ToggleIndicator, {BackgroundColor3 = themeList.SchemeColor}, 0.2)
                    else
                        Utility:TweenObject(IndicatorCircle, {Position = UDim2.new(0, 2, 0.5, -6)}, 0.2)
                        Utility:TweenObject(ToggleIndicator, {BackgroundColor3 = Color3.fromRGB(80, 80, 80)}, 0.2)
                    end
                    
                    callback(toggled)
                end)

                Toggle.MouseEnter:Connect(function()
                    Utility:TweenObject(ToggleStroke, {Transparency = 0.6}, 0.1)
                end)

                Toggle.MouseLeave:Connect(function()
                    Utility:TweenObject(ToggleStroke, {Transparency = 0.9}, 0.1)
                end)

                coroutine.wrap(function()
                    while wait(0.5) do
                        ToggleLabel.TextColor3 = themeList.TextColor
                        ToggleStroke.Color = themeList.SchemeColor
                    end
                end)()

                UpdateSectionSize()

                local ToggleFunctions = {}
                function ToggleFunctions:UpdateToggle(newText, state)
                    if newText then
                        ToggleLabel.Text = newText
                    end
                    if state ~= nil then
                        toggled = state
                        if toggled then
                            IndicatorCircle.Position = UDim2.new(1, -14, 0.5, -6)
                            ToggleIndicator.BackgroundColor3 = themeList.SchemeColor
                        else
                            IndicatorCircle.Position = UDim2.new(0, 2, 0.5, -6)
                            ToggleIndicator.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
                        end
                        callback(toggled)
                    end
                end
                return ToggleFunctions
            end

            function Elements:NewSlider(sliderName, sliderInfo, maxValue, minValue, callback)
                sliderName = sliderName or "Slider"
                sliderInfo = sliderInfo or "Adjust value"
                maxValue = maxValue or 100
                minValue = minValue or 0
                callback = callback or function() end

                local Slider = Instance.new("Frame")
                local SliderCorner = Instance.new("UICorner")
                local SliderStroke = Instance.new("UIStroke")
                local SliderLabel = Instance.new("TextLabel")
                local SliderValue = Instance.new("TextLabel")
                local SliderTrack = Instance.new("Frame")
                local TrackCorner = Instance.new("UICorner")
                local SliderFill = Instance.new("Frame")
                local FillCorner = Instance.new("UICorner")
                local SliderButton = Instance.new("TextButton")

                Slider.Name = "Slider"
                Slider.Parent = SectionContent
                Slider.BackgroundColor3 = themeList.ElementColor
                Slider.BorderSizePixel = 0
                Slider.Size = UDim2.new(1, 0, 0, 50)

                SliderCorner.CornerRadius = UDim.new(0, 6)
                SliderCorner.Parent = Slider

                SliderStroke.Parent = Slider
                SliderStroke.Color = themeList.SchemeColor
                SliderStroke.Thickness = 1
                SliderStroke.Transparency = 0.9

                SliderLabel.Parent = Slider
                SliderLabel.BackgroundTransparency = 1
                SliderLabel.Position = UDim2.new(0, 15, 0, 5)
                SliderLabel.Size = UDim2.new(1, -80, 0, 20)
                SliderLabel.Font = Enum.Font.GothamSemibold
                SliderLabel.Text = sliderName
                SliderLabel.TextColor3 = themeList.TextColor
                SliderLabel.TextSize = 13
                SliderLabel.TextXAlignment = Enum.TextXAlignment.Left

                SliderValue.Parent = Slider
                SliderValue.BackgroundTransparency = 1
                SliderValue.Position = UDim2.new(1, -70, 0, 5)
                SliderValue.Size = UDim2.new(0, 60, 0, 20)
                SliderValue.Font = Enum.Font.GothamBold
                SliderValue.Text = tostring(minValue)
                SliderValue.TextColor3 = themeList.SchemeColor
                SliderValue.TextSize = 13
                SliderValue.TextXAlignment = Enum.TextXAlignment.Right

                SliderTrack.Parent = Slider
                SliderTrack.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
                SliderTrack.BorderSizePixel = 0
                SliderTrack.Position = UDim2.new(0, 15, 1, -18)
                SliderTrack.Size = UDim2.new(1, -30, 0, 6)

                TrackCorner.CornerRadius = UDim.new(1, 0)
                TrackCorner.Parent = SliderTrack

                SliderFill.Parent = SliderTrack
                SliderFill.BackgroundColor3 = themeList.SchemeColor
                SliderFill.BorderSizePixel = 0
                SliderFill.Size = UDim2.new(0, 0, 1, 0)

                FillCorner.CornerRadius = UDim.new(1, 0)
                FillCorner.Parent = SliderFill

                SliderButton.Parent = SliderTrack
                SliderButton.BackgroundTransparency = 1
                SliderButton.Size = UDim2.new(1, 0, 1, 0)
                SliderButton.Text = ""

                local dragging = false
                
                SliderButton.MouseButton1Down:Connect(function()
                    dragging = true
                end)

                input.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = false
                    end
                end)

                SliderButton.MouseMoved:Connect(function(x, y)
                    if dragging then
                        local percentage = math.clamp((x - SliderTrack.AbsolutePosition.X) / SliderTrack.AbsoluteSize.X, 0, 1)
                        local value = math.floor(minValue + (maxValue - minValue) * percentage)
                        
                        SliderFill.Size = UDim2.new(percentage, 0, 1, 0)
                        SliderValue.Text = tostring(value)
                        callback(value)
                    end
                end)

                Slider.MouseEnter:Connect(function()
                    Utility:TweenObject(SliderStroke, {Transparency = 0.6}, 0.1)
                end)

                Slider.MouseLeave:Connect(function()
                    Utility:TweenObject(SliderStroke, {Transparency = 0.9}, 0.1)
                end)

                coroutine.wrap(function()
                    while wait(0.5) do
                        SliderLabel.TextColor3 = themeList.TextColor
                        SliderValue.TextColor3 = themeList.SchemeColor
                        SliderFill.BackgroundColor3 = themeList.SchemeColor
                        SliderStroke.Color = themeList.SchemeColor
                    end
                end)()

                UpdateSectionSize()
            end

            function Elements:NewTextBox(textboxName, textboxInfo, callback)
                textboxName = textboxName or "TextBox"
                textboxInfo = textboxInfo or "Enter text"
                callback = callback or function() end

                local TextBoxFrame = Instance.new("Frame")
                local FrameCorner = Instance.new("UICorner")
                local FrameStroke = Instance.new("UIStroke")
                local TextBoxLabel = Instance.new("TextLabel")
                local TextBox = Instance.new("TextBox")
                local BoxCorner = Instance.new("UICorner")
                local BoxStroke = Instance.new("UIStroke")

                TextBoxFrame.Name = "TextBox"
                TextBoxFrame.Parent = SectionContent
                TextBoxFrame.BackgroundColor3 = themeList.ElementColor
                TextBoxFrame.BorderSizePixel = 0
                TextBoxFrame.Size = UDim2.new(1, 0, 0, 40)

                FrameCorner.CornerRadius = UDim.new(0, 6)
                FrameCorner.Parent = TextBoxFrame

                FrameStroke.Parent = TextBoxFrame
                FrameStroke.Color = themeList.SchemeColor
                FrameStroke.Thickness = 1
                FrameStroke.Transparency = 0.9

                TextBoxLabel.Parent = TextBoxFrame
                TextBoxLabel.BackgroundTransparency = 1
                TextBoxLabel.Position = UDim2.new(0, 15, 0, 0)
                TextBoxLabel.Size = UDim2.new(0, 120, 1, 0)
                TextBoxLabel.Font = Enum.Font.GothamSemibold
                TextBoxLabel.Text = textboxName
                TextBoxLabel.TextColor3 = themeList.TextColor
                TextBoxLabel.TextSize = 14
                TextBoxLabel.TextXAlignment = Enum.TextXAlignment.Left

                TextBox.Parent = TextBoxFrame
                TextBox.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
                TextBox.BorderSizePixel = 0
                TextBox.Position = UDim2.new(0, 140, 0.5, -12)
                TextBox.Size = UDim2.new(1, -155, 0, 24)
                TextBox.Font = Enum.Font.Gotham
                TextBox.PlaceholderText = "Type here..."
                TextBox.PlaceholderColor3 = Color3.fromRGB(120, 120, 120)
                TextBox.Text = ""
                TextBox.TextColor3 = themeList.TextColor
                TextBox.TextSize = 12
                TextBox.ClearTextOnFocus = false

                BoxCorner.CornerRadius = UDim.new(0, 4)
                BoxCorner.Parent = TextBox

                BoxStroke.Parent = TextBox
                BoxStroke.Color = themeList.SchemeColor
                BoxStroke.Thickness = 1
                BoxStroke.Transparency = 0.9

                TextBox.FocusLost:Connect(function(enter)
                    if enter then
                        callback(TextBox.Text)
                        TextBox.Text = ""
                    end
                end)

                TextBox.Focused:Connect(function()
                    Utility:TweenObject(BoxStroke, {Transparency = 0.5}, 0.1)
                end)

                TextBox.FocusLost:Connect(function()
                    Utility:TweenObject(BoxStroke, {Transparency = 0.9}, 0.1)
                end)

                TextBoxFrame.MouseEnter:Connect(function()
                    Utility:TweenObject(FrameStroke, {Transparency = 0.6}, 0.1)
                end)

                TextBoxFrame.MouseLeave:Connect(function()
                    Utility:TweenObject(FrameStroke, {Transparency = 0.9}, 0.1)
                end)

                coroutine.wrap(function()
                    while wait(0.5) do
                        TextBoxLabel.TextColor3 = themeList.TextColor
                        TextBox.TextColor3 = themeList.TextColor
                        FrameStroke.Color = themeList.SchemeColor
                        BoxStroke.Color = themeList.SchemeColor
                    end
                end)()

                UpdateSectionSize()
            end

            function Elements:NewLabel(labelText)
                labelText = labelText or "Label"

                local Label = Instance.new("TextLabel")
                local LabelCorner = Instance.new("UICorner")
                local LabelStroke = Instance.new("UIStroke")

                Label.Name = "Label"
                Label.Parent = SectionContent
                Label.BackgroundColor3 = themeList.ElementColor
                Label.BackgroundTransparency = 0.5
                Label.BorderSizePixel = 0
                Label.Size = UDim2.new(1, 0, 0, 36)
                Label.Font = Enum.Font.Gotham
                Label.Text = "  " .. labelText
                Label.TextColor3 = themeList.TextColor
                Label.TextSize = 14
                Label.TextXAlignment = Enum.TextXAlignment.Left

                LabelCorner.CornerRadius = UDim.new(0, 6)
                LabelCorner.Parent = Label

                LabelStroke.Parent = Label
                LabelStroke.Color = themeList.SchemeColor
                LabelStroke.Thickness = 1
                LabelStroke.Transparency = 0.95

                coroutine.wrap(function()
                    while wait(0.5) do
                        Label.BackgroundColor3 = themeList.ElementColor
                        Label.TextColor3 = themeList.TextColor
                        LabelStroke.Color = themeList.SchemeColor
                    end
                end)()

                UpdateSectionSize()

                local LabelFunctions = {}
                function LabelFunctions:UpdateLabel(newText)
                    Label.Text = "  " .. newText
                end
                return LabelFunctions
            end

            function Elements:NewDropdown(dropName, dropInfo, list, callback)
                dropName = dropName or "Dropdown"
                dropInfo = dropInfo or "Select option"
                list = list or {}
                callback = callback or function() end

                local opened = false
                
                local DropFrame = Instance.new("Frame")
                local DropCorner = Instance.new("UICorner")
                local DropLayout = Instance.new("UIListLayout")
                local DropHeader = Instance.new("TextButton")
                local HeaderCorner = Instance.new("UICorner")
                local HeaderStroke = Instance.new("UIStroke")
                local DropLabel = Instance.new("TextLabel")
                local DropArrow = Instance.new("TextLabel")

                DropFrame.Name = "Dropdown"
                DropFrame.Parent = SectionContent
                DropFrame.BackgroundTransparency = 1
                DropFrame.ClipsDescendants = true
                DropFrame.Size = UDim2.new(1, 0, 0, 40)

                DropLayout.Parent = DropFrame
                DropLayout.SortOrder = Enum.SortOrder.LayoutOrder
                DropLayout.Padding = UDim.new(0, 4)

                DropHeader.Name = "Header"
                DropHeader.Parent = DropFrame
                DropHeader.BackgroundColor3 = themeList.ElementColor
                DropHeader.BorderSizePixel = 0
                DropHeader.Size = UDim2.new(1, 0, 0, 40)
                DropHeader.AutoButtonColor = false
                DropHeader.Text = ""

                HeaderCorner.CornerRadius = UDim.new(0, 6)
                HeaderCorner.Parent = DropHeader

                HeaderStroke.Parent = DropHeader
                HeaderStroke.Color = themeList.SchemeColor
                HeaderStroke.Thickness = 1
                HeaderStroke.Transparency = 0.9

                DropLabel.Parent = DropHeader
                DropLabel.BackgroundTransparency = 1
                DropLabel.Position = UDim2.new(0, 15, 0, 0)
                DropLabel.Size = UDim2.new(1, -40, 1, 0)
                DropLabel.Font = Enum.Font.GothamSemibold
                DropLabel.Text = dropName
                DropLabel.TextColor3 = themeList.TextColor
                DropLabel.TextSize = 14
                DropLabel.TextXAlignment = Enum.TextXAlignment.Left

                DropArrow.Parent = DropHeader
                DropArrow.BackgroundTransparency = 1
                DropArrow.Position = UDim2.new(1, -30, 0, 0)
                DropArrow.Size = UDim2.new(0, 20, 1, 0)
                DropArrow.Font = Enum.Font.GothamBold
                DropArrow.Text = "▼"
                DropArrow.TextColor3 = themeList.SchemeColor
                DropArrow.TextSize = 12

                DropHeader.MouseButton1Click:Connect(function()
                    opened = not opened
                    
                    if opened then
                        DropFrame.Size = UDim2.new(1, 0, 0, DropLayout.AbsoluteContentSize.Y)
                        Utility:TweenObject(DropArrow, {Rotation = 180}, 0.2)
                    else
                        DropFrame.Size = UDim2.new(1, 0, 0, 40)
                        Utility:TweenObject(DropArrow, {Rotation = 0}, 0.2)
                    end
                    
                    UpdateSectionSize()
                end)

                DropHeader.MouseEnter:Connect(function()
                    Utility:TweenObject(HeaderStroke, {Transparency = 0.6}, 0.1)
                end)

                DropHeader.MouseLeave:Connect(function()
                    Utility:TweenObject(HeaderStroke, {Transparency = 0.9}, 0.1)
                end)

                for i, option in pairs(list) do
                    local Option = Instance.new("TextButton")
                    local OptionCorner = Instance.new("UICorner")
                    local OptionStroke = Instance.new("UIStroke")

                    Option.Name = "Option"
                    Option.Parent = DropFrame
                    Option.BackgroundColor3 = themeList.ElementColor
                    Option.BackgroundTransparency = 0.3
                    Option.BorderSizePixel = 0
                    Option.Size = UDim2.new(1, 0, 0, 32)
                    Option.AutoButtonColor = false
                    Option.Font = Enum.Font.Gotham
                    Option.Text = "  " .. option
                    Option.TextColor3 = themeList.TextColor
                    Option.TextSize = 12
                    Option.TextXAlignment = Enum.TextXAlignment.Left

                    OptionCorner.CornerRadius = UDim.new(0, 6)
                    OptionCorner.Parent = Option

                    OptionStroke.Parent = Option
                    OptionStroke.Color = themeList.SchemeColor
                    OptionStroke.Thickness = 1
                    OptionStroke.Transparency = 0.95

                    Option.MouseButton1Click:Connect(function()
                        DropLabel.Text = option
                        callback(option)
                        opened = false
                        DropFrame.Size = UDim2.new(1, 0, 0, 40)
                        DropArrow.Rotation = 0
                        UpdateSectionSize()
                    end)

                    Option.MouseEnter:Connect(function()
                        Utility:TweenObject(Option, {BackgroundTransparency = 0}, 0.1)
                        Utility:TweenObject(OptionStroke, {Transparency = 0.7}, 0.1)
                    end)

                    Option.MouseLeave:Connect(function()
                        Utility:TweenObject(Option, {BackgroundTransparency = 0.3}, 0.1)
                        Utility:TweenObject(OptionStroke, {Transparency = 0.95}, 0.1)
                    end)

                    coroutine.wrap(function()
                        while wait(0.5) do
                            Option.BackgroundColor3 = themeList.ElementColor
                            Option.TextColor3 = themeList.TextColor
                            OptionStroke.Color = themeList.SchemeColor
                        end
                    end)()
                end

                coroutine.wrap(function()
                    while wait(0.5) do
                        DropHeader.BackgroundColor3 = themeList.ElementColor
                        DropLabel.TextColor3 = themeList.TextColor
                        DropArrow.TextColor3 = themeList.SchemeColor
                        HeaderStroke.Color = themeList.SchemeColor
                    end
                end)()

                UpdateSectionSize()

                local DropFunctions = {}
                function DropFunctions:Refresh(newList)
                    for _, child in pairs(DropFrame:GetChildren()) do
                        if child.Name == "Option" then
                            child:Destroy()
                        end
                    end
                    
                    for i, option in pairs(newList) do
                        local Option = Instance.new("TextButton")
                        local OptionCorner = Instance.new("UICorner")
                        local OptionStroke = Instance.new("UIStroke")

                        Option.Name = "Option"
                        Option.Parent = DropFrame
                        Option.BackgroundColor3 = themeList.ElementColor
                        Option.BackgroundTransparency = 0.3
                        Option.BorderSizePixel = 0
                        Option.Size = UDim2.new(1, 0, 0, 32)
                        Option.AutoButtonColor = false
                        Option.Font = Enum.Font.Gotham
                        Option.Text = "  " .. option
                        Option.TextColor3 = themeList.TextColor
                        Option.TextSize = 12
                        Option.TextXAlignment = Enum.TextXAlignment.Left

                        OptionCorner.CornerRadius = UDim.new(0, 6)
                        OptionCorner.Parent = Option

                        OptionStroke.Parent = Option
                        OptionStroke.Color = themeList.SchemeColor
                        OptionStroke.Thickness = 1
                        OptionStroke.Transparency = 0.95

                        Option.MouseButton1Click:Connect(function()
                            DropLabel.Text = option
                            callback(option)
                            opened = false
                            DropFrame.Size = UDim2.new(1, 0, 0, 40)
                            DropArrow.Rotation = 0
                            UpdateSectionSize()
                        end)

                        Option.MouseEnter:Connect(function()
                            Utility:TweenObject(Option, {BackgroundTransparency = 0}, 0.1)
                        end)

                        Option.MouseLeave:Connect(function()
                            Utility:TweenObject(Option, {BackgroundTransparency = 0.3}, 0.1)
                        end)
                    end
                    
                    if opened then
                        DropFrame.Size = UDim2.new(1, 0, 0, DropLayout.AbsoluteContentSize.Y)
                    end
                    
                    UpdateSectionSize()
                end
                return DropFunctions
            end

            UpdateSectionSize()
            return Elements
        end

        return Sections
    end

    return Tabs
end

return ChimiUI
