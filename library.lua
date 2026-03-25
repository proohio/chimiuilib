local ChimiUI = {}

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

local Utility = {}

function Utility:Tween(obj, props, duration, style, direction)
	style = style or Enum.EasingStyle.Quint
	direction = direction or Enum.EasingDirection.Out
	TweenService:Create(obj, TweenInfo.new(duration, style, direction), props):Play()
end

-- ─── DRAGGING ────────────────────────────────────────────────────────────────

function ChimiUI:DraggingEnabled(frame, parent)
	parent = parent or frame
	local dragging = false
	local dragInput, mousePos, framePos

	frame.InputBegan:Connect(function(inp)
		if inp.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			mousePos = inp.Position
			framePos = parent.Position
			inp.Changed:Connect(function()
				if inp.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)

	frame.InputChanged:Connect(function(inp)
		if inp.UserInputType == Enum.UserInputType.MouseMovement then
			dragInput = inp
		end
	end)

	UserInputService.InputChanged:Connect(function(inp)
		if inp == dragInput and dragging then
			local delta = inp.Position - mousePos
			parent.Position = UDim2.new(
				framePos.X.Scale, framePos.X.Offset + delta.X,
				framePos.Y.Scale, framePos.Y.Offset + delta.Y
			)
		end
	end)
end

-- ─── THEMES ──────────────────────────────────────────────────────────────────

local themeStyles = {
	Chimi = {
		Background  = Color3.fromRGB(14, 14, 14),
		Header      = Color3.fromRGB(10, 10, 10),
		Sidebar     = Color3.fromRGB(10, 10, 10),
		Element     = Color3.fromRGB(22, 22, 22),
		Stroke      = Color3.fromRGB(255, 255, 255),
		StrokeAlpha = 0.93,
		Text        = Color3.fromRGB(255, 255, 255),
		SubText     = Color3.fromRGB(136, 136, 136),
		Accent      = Color3.fromRGB(255, 255, 255),
		ScrollBar   = Color3.fromRGB(255, 255, 255),
	},
	DarkTheme = {
		Background  = Color3.fromRGB(0, 0, 0),
		Header      = Color3.fromRGB(0, 0, 0),
		Sidebar     = Color3.fromRGB(0, 0, 0),
		Element     = Color3.fromRGB(18, 18, 18),
		Stroke      = Color3.fromRGB(80, 80, 80),
		StrokeAlpha = 0.85,
		Text        = Color3.fromRGB(255, 255, 255),
		SubText     = Color3.fromRGB(100, 100, 100),
		Accent      = Color3.fromRGB(150, 150, 150),
		ScrollBar   = Color3.fromRGB(80, 80, 80),
	},
	LightTheme = {
		Background  = Color3.fromRGB(245, 245, 245),
		Header      = Color3.fromRGB(230, 230, 230),
		Sidebar     = Color3.fromRGB(230, 230, 230),
		Element     = Color3.fromRGB(255, 255, 255),
		Stroke      = Color3.fromRGB(0, 0, 0),
		StrokeAlpha = 0.92,
		Text        = Color3.fromRGB(20, 20, 20),
		SubText     = Color3.fromRGB(120, 120, 120),
		Accent      = Color3.fromRGB(0, 0, 0),
		ScrollBar   = Color3.fromRGB(180, 180, 180),
	},
	Ocean = {
		Background  = Color3.fromRGB(18, 22, 40),
		Header      = Color3.fromRGB(14, 18, 34),
		Sidebar     = Color3.fromRGB(14, 18, 34),
		Element     = Color3.fromRGB(24, 30, 52),
		Stroke      = Color3.fromRGB(100, 100, 220),
		StrokeAlpha = 0.80,
		Text        = Color3.fromRGB(210, 210, 255),
		SubText     = Color3.fromRGB(100, 110, 180),
		Accent      = Color3.fromRGB(130, 120, 255),
		ScrollBar   = Color3.fromRGB(100, 100, 220),
	},
}

local LibName = tostring(math.random(1,999)) .. tostring(math.random(1,999))

function ChimiUI:ToggleUI()
	local gui = game.CoreGui:FindFirstChild(LibName)
	if gui then gui.Enabled = not gui.Enabled end
end

-- ─── HELPER: make a stroke ───────────────────────────────────────────────────

local function MakeStroke(parent, color, alpha, thickness)
	local s = Instance.new("UIStroke")
	s.Color = color
	s.Transparency = alpha
	s.Thickness = thickness or 1
	s.Parent = parent
	return s
end

local function MakeCorner(parent, radius)
	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, radius or 10)
	c.Parent = parent
	return c
end

-- ─── CREATE LIB ──────────────────────────────────────────────────────────────

function ChimiUI.CreateLib(libraryName, themeChoice)
	local T = themeStyles.Chimi
	if type(themeChoice) == "string" and themeStyles[themeChoice] then
		T = themeStyles[themeChoice]
	elseif type(themeChoice) == "table" then
		T = themeChoice
	end

	libraryName = libraryName or "Chimi UI"

	-- cleanup old
	for _, v in pairs(game.CoreGui:GetChildren()) do
		if v:IsA("ScreenGui") and v.Name == LibName then v:Destroy() end
	end

	-- ── ScreenGui ──────────────────────────────────────────────────────────
	local ScreenGui = Instance.new("ScreenGui")
	ScreenGui.Name = LibName
	ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	ScreenGui.ResetOnSpawn = false
	ScreenGui.Parent = game.CoreGui

	-- ── Main Frame ─────────────────────────────────────────────────────────
	local Main = Instance.new("Frame")
	Main.Name = "Main"
	Main.Parent = ScreenGui
	Main.BackgroundColor3 = T.Background
	Main.BorderSizePixel = 0
	Main.Position = UDim2.new(0.5, -360, 0.5, -260)
	Main.Size = UDim2.new(0, 720, 0, 520)
	Main.ClipsDescendants = true
	MakeCorner(Main, 14)
	local MainStroke = MakeStroke(Main, T.Stroke, 0.93)

	-- drop shadow effect (outer frame trick)
	local Shadow = Instance.new("ImageLabel")
	Shadow.Name = "Shadow"
	Shadow.AnchorPoint = Vector2.new(0.5, 0.5)
	Shadow.BackgroundTransparency = 1
	Shadow.Position = UDim2.new(0.5, 0, 0.5, 0)
	Shadow.Size = UDim2.new(1, 60, 1, 60)
	Shadow.Image = "rbxassetid://6014261993"
	Shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
	Shadow.ImageTransparency = 0.5
	Shadow.ScaleType = Enum.ScaleType.Slice
	Shadow.SliceCenter = Rect.new(49, 49, 450, 450)
	Shadow.ZIndex = 0
	Shadow.Parent = Main

	-- ── Title Bar ──────────────────────────────────────────────────────────
	local TitleBar = Instance.new("Frame")
	TitleBar.Name = "TitleBar"
	TitleBar.Parent = Main
	TitleBar.BackgroundColor3 = T.Header
	TitleBar.BorderSizePixel = 0
	TitleBar.Size = UDim2.new(1, 0, 0, 44)
	TitleBar.ZIndex = 2

	-- bottom border on titlebar
	local TitleBorder = Instance.new("Frame")
	TitleBorder.BackgroundColor3 = T.Stroke
	TitleBorder.BackgroundTransparency = 0.95
	TitleBorder.BorderSizePixel = 0
	TitleBorder.Position = UDim2.new(0, 0, 1, -1)
	TitleBorder.Size = UDim2.new(1, 0, 0, 1)
	TitleBorder.Parent = TitleBar

	local TitleLabel = Instance.new("TextLabel")
	TitleLabel.Name = "Title"
	TitleLabel.Parent = TitleBar
	TitleLabel.BackgroundTransparency = 1
	TitleLabel.Position = UDim2.new(0, 20, 0, 0)
	TitleLabel.Size = UDim2.new(1, -100, 1, 0)
	TitleLabel.Font = Enum.Font.GothamBold
	TitleLabel.Text = libraryName
	TitleLabel.TextColor3 = T.SubText
	TitleLabel.TextSize = 13
	TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

	-- window buttons (top right)
	local function MakeWindowBtn(offsetX, hoverRed)
		local Btn = Instance.new("TextButton")
		Btn.Parent = TitleBar
		Btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
		Btn.BackgroundTransparency = 0
		Btn.BorderSizePixel = 0
		Btn.Position = UDim2.new(1, offsetX, 0.5, -14)
		Btn.Size = UDim2.new(0, 28, 0, 28)
		Btn.Text = ""
		Btn.AutoButtonColor = false
		Btn.ZIndex = 3
		MakeCorner(Btn, 8)
		MakeStroke(Btn, T.Stroke, 0.94)

		-- icon line
		local Icon = Instance.new("Frame")
		Icon.BackgroundColor3 = T.SubText
		Icon.BackgroundTransparency = 0.5
		Icon.BorderSizePixel = 0
		Icon.AnchorPoint = Vector2.new(0.5, 0.5)
		Icon.Position = UDim2.new(0.5, 0, 0.5, 0)
		Icon.Size = hoverRed and UDim2.new(0, 10, 0, 1) or UDim2.new(0, 8, 0, 1)
		Icon.Parent = Btn
		MakeCorner(Icon, 2)

		Btn.MouseEnter:Connect(function()
			Utility:Tween(Btn, {BackgroundColor3 = hoverRed and Color3.fromRGB(200,40,40) or Color3.fromRGB(40,40,40)}, 0.12)
			Utility:Tween(Icon, {BackgroundTransparency = 0}, 0.12)
		end)
		Btn.MouseLeave:Connect(function()
			Utility:Tween(Btn, {BackgroundColor3 = Color3.fromRGB(30,30,30)}, 0.12)
			Utility:Tween(Icon, {BackgroundTransparency = 0.5}, 0.12)
		end)

		return Btn
	end

	local MinimizeBtn = MakeWindowBtn(-68, false)
	local CloseBtn = MakeWindowBtn(-34, true)

	-- X icon for close (two lines)
	local X1 = Instance.new("Frame")
	X1.BackgroundColor3 = T.SubText
	X1.BackgroundTransparency = 0.5
	X1.BorderSizePixel = 0
	X1.AnchorPoint = Vector2.new(0.5, 0.5)
	X1.Position = UDim2.new(0.5, 0, 0.5, 0)
	X1.Size = UDim2.new(0, 10, 0, 1)
	X1.Rotation = 45
	X1.Parent = CloseBtn
	MakeCorner(X1, 2)
	local X2 = X1:Clone()
	X2.Rotation = -45
	X2.Parent = CloseBtn
	-- remove the default icon from close
	CloseBtn:FindFirstChildWhichIsA("Frame"):Destroy()

	ChimiUI:DraggingEnabled(TitleBar, Main)

	-- ── Sidebar ────────────────────────────────────────────────────────────
	local Sidebar = Instance.new("Frame")
	Sidebar.Name = "Sidebar"
	Sidebar.Parent = Main
	Sidebar.BackgroundColor3 = T.Sidebar
	Sidebar.BorderSizePixel = 0
	Sidebar.Position = UDim2.new(0, 0, 0, 44)
	Sidebar.Size = UDim2.new(0, 155, 1, -44)

	-- right border on sidebar
	local SidebarBorder = Instance.new("Frame")
	SidebarBorder.BackgroundColor3 = T.Stroke
	SidebarBorder.BackgroundTransparency = 0.95
	SidebarBorder.BorderSizePixel = 0
	SidebarBorder.Position = UDim2.new(1, -1, 0, 0)
	SidebarBorder.Size = UDim2.new(0, 1, 1, 0)
	SidebarBorder.Parent = Sidebar

	local TabScroll = Instance.new("ScrollingFrame")
	TabScroll.Name = "TabScroll"
	TabScroll.Parent = Sidebar
	TabScroll.BackgroundTransparency = 1
	TabScroll.BorderSizePixel = 0
	TabScroll.Position = UDim2.new(0, 0, 0, 0)
	TabScroll.Size = UDim2.new(1, 0, 1, -60)
	TabScroll.ScrollBarThickness = 0
	TabScroll.CanvasSize = UDim2.new(0, 0, 0, 0)

	local TabLayout = Instance.new("UIListLayout")
	TabLayout.Parent = TabScroll
	TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
	TabLayout.Padding = UDim.new(0, 2)

	local TabPadding = Instance.new("UIPadding")
	TabPadding.PaddingTop = UDim.new(0, 8)
	TabPadding.PaddingLeft = UDim.new(0, 8)
	TabPadding.PaddingRight = UDim.new(0, 8)
	TabPadding.Parent = TabScroll

	TabLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		TabScroll.CanvasSize = UDim2.new(0, 0, 0, TabLayout.AbsoluteContentSize.Y + 16)
	end)

	-- ── Profile (bottom of sidebar) ────────────────────────────────────────
	local ProfileFrame = Instance.new("Frame")
	ProfileFrame.Name = "Profile"
	ProfileFrame.Parent = Sidebar
	ProfileFrame.BackgroundTransparency = 1
	ProfileFrame.BorderSizePixel = 0
	ProfileFrame.Position = UDim2.new(0, 0, 1, -58)
	ProfileFrame.Size = UDim2.new(1, 0, 0, 58)

	local ProfileBorder = Instance.new("Frame")
	ProfileBorder.BackgroundColor3 = T.Stroke
	ProfileBorder.BackgroundTransparency = 0.95
	ProfileBorder.BorderSizePixel = 0
	ProfileBorder.Size = UDim2.new(1, 0, 0, 1)
	ProfileBorder.Parent = ProfileFrame

	local AvatarFrame = Instance.new("Frame")
	AvatarFrame.BackgroundColor3 = T.Element
	AvatarFrame.BorderSizePixel = 0
	AvatarFrame.Position = UDim2.new(0, 10, 0.5, -16)
	AvatarFrame.Size = UDim2.new(0, 32, 0, 32)
	AvatarFrame.Parent = ProfileFrame
	MakeCorner(AvatarFrame, 100)
	MakeStroke(AvatarFrame, T.Stroke, 0.92)

	local AvatarImage = Instance.new("ImageLabel")
	AvatarImage.BackgroundTransparency = 1
	AvatarImage.Size = UDim2.new(1, 0, 1, 0)
	AvatarImage.ScaleType = Enum.ScaleType.Crop
	AvatarImage.Parent = AvatarFrame
	MakeCorner(AvatarImage, 100)

	local NameLabel = Instance.new("TextLabel")
	NameLabel.BackgroundTransparency = 1
	NameLabel.Position = UDim2.new(0, 50, 0, 10)
	NameLabel.Size = UDim2.new(1, -62, 0, 16)
	NameLabel.Font = Enum.Font.GothamBold
	NameLabel.Text = "Loading..."
	NameLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
	NameLabel.TextSize = 12
	NameLabel.TextXAlignment = Enum.TextXAlignment.Left
	NameLabel.TextTruncate = Enum.TextTruncate.AtEnd
	NameLabel.Parent = ProfileFrame

	local UserLabel = Instance.new("TextLabel")
	UserLabel.BackgroundTransparency = 1
	UserLabel.Position = UDim2.new(0, 50, 0, 28)
	UserLabel.Size = UDim2.new(1, -62, 0, 14)
	UserLabel.Font = Enum.Font.Gotham
	UserLabel.Text = "@..."
	UserLabel.TextColor3 = Color3.fromRGB(68, 68, 68)
	UserLabel.TextSize = 10
	UserLabel.TextXAlignment = Enum.TextXAlignment.Left
	UserLabel.TextTruncate = Enum.TextTruncate.AtEnd
	UserLabel.Parent = ProfileFrame

	-- online dot
	local OnlineDot = Instance.new("Frame")
	OnlineDot.BackgroundColor3 = Color3.fromRGB(34, 197, 94)
	OnlineDot.BorderSizePixel = 0
	OnlineDot.Position = UDim2.new(1, -16, 0.5, -4)
	OnlineDot.Size = UDim2.new(0, 6, 0, 6)
	OnlineDot.Parent = ProfileFrame
	MakeCorner(OnlineDot, 100)

	-- load profile info
	local localPlayer = Players.LocalPlayer
	NameLabel.Text = localPlayer.DisplayName
	UserLabel.Text = "@" .. localPlayer.Name

	-- avatar headshot
	local thumbType = Enum.ThumbnailType.HeadShot
	local thumbSize = Enum.ThumbnailSize.Size48x48
	local content, isReady = Players:GetUserThumbnailAsync(localPlayer.UserId, thumbType, thumbSize)
	AvatarImage.Image = content

	-- ── Content Area ───────────────────────────────────────────────────────
	local ContentFrame = Instance.new("Frame")
	ContentFrame.Name = "Content"
	ContentFrame.Parent = Main
	ContentFrame.BackgroundTransparency = 1
	ContentFrame.BorderSizePixel = 0
	ContentFrame.Position = UDim2.new(0, 155, 0, 44)
	ContentFrame.Size = UDim2.new(1, -155, 1, -44)

	local Pages = Instance.new("Folder")
	Pages.Name = "Pages"
	Pages.Parent = ContentFrame

	-- ── Minimize / Close logic ─────────────────────────────────────────────
	local minimized = false
	MinimizeBtn.MouseButton1Click:Connect(function()
		minimized = not minimized
		if minimized then
			Utility:Tween(Main, {Size = UDim2.new(0, 720, 0, 44)}, 0.26, Enum.EasingStyle.Quint)
		else
			Utility:Tween(Main, {Size = UDim2.new(0, 720, 0, 520)}, 0.26, Enum.EasingStyle.Quint)
		end
	end)

	CloseBtn.MouseButton1Click:Connect(function()
		Utility:Tween(Main, {Size = UDim2.new(0, 720, 0, 0)}, 0.2)
		task.delay(0.2, function() ScreenGui:Destroy() end)
	end)

	-- ── Color change API ───────────────────────────────────────────────────
	function ChimiUI:ChangeColor(property, color)
		T[property] = color
	end

	-- ── TABS ───────────────────────────────────────────────────────────────
	local Tabs = {}
	local firstTab = true
	local allTabBtns = {}
	local allPages = {}

	function Tabs:NewTab(tabName)
		tabName = tabName or "Tab"

		-- Tab button in sidebar
		local TabBtn = Instance.new("TextButton")
		TabBtn.Name = tabName
		TabBtn.Parent = TabScroll
		TabBtn.BackgroundColor3 = firstTab and Color3.fromRGB(255,255,255) or T.Element
		TabBtn.BackgroundTransparency = firstTab and 0.93 or 1
		TabBtn.BorderSizePixel = 0
		TabBtn.Size = UDim2.new(1, 0, 0, 34)
		TabBtn.AutoButtonColor = false
		TabBtn.Font = Enum.Font.GothamMedium
		TabBtn.Text = tabName
		TabBtn.TextColor3 = firstTab and T.Text or T.SubText
		TabBtn.TextSize = 12
		TabBtn.ZIndex = 2
		MakeCorner(TabBtn, 8)

		-- active indicator bar (left side)
		local ActiveBar = Instance.new("Frame")
		ActiveBar.BackgroundColor3 = Color3.fromRGB(255,255,255)
		ActiveBar.BackgroundTransparency = firstTab and 0.5 or 1
		ActiveBar.BorderSizePixel = 0
		ActiveBar.AnchorPoint = Vector2.new(0, 0.5)
		ActiveBar.Position = UDim2.new(0, 0, 0.5, 0)
		ActiveBar.Size = UDim2.new(0, 3, 0, 18)
		ActiveBar.ZIndex = 3
		ActiveBar.Parent = TabBtn
		MakeCorner(ActiveBar, 4)

		local TabStroke = MakeStroke(TabBtn, T.Stroke, firstTab and 0.92 or 1)

		-- Page (scrolling frame for this tab's content)
		local Page = Instance.new("ScrollingFrame")
		Page.Name = tabName .. "_Page"
		Page.Parent = Pages
		Page.Active = true
		Page.BackgroundTransparency = 1
		Page.BorderSizePixel = 0
		Page.Size = UDim2.new(1, 0, 1, 0)
		Page.ScrollBarThickness = 3
		Page.ScrollBarImageColor3 = Color3.fromRGB(255,255,255)
		Page.ScrollBarImageTransparency = 0.93
		Page.CanvasSize = UDim2.new(0, 0, 0, 0)
		Page.Visible = firstTab

		local PageLayout = Instance.new("UIListLayout")
		PageLayout.Parent = Page
		PageLayout.SortOrder = Enum.SortOrder.LayoutOrder
		PageLayout.Padding = UDim.new(0, 14)

		local PagePadding = Instance.new("UIPadding")
		PagePadding.PaddingTop = UDim.new(0, 14)
		PagePadding.PaddingLeft = UDim.new(0, 14)
		PagePadding.PaddingRight = UDim.new(0, 14)
		PagePadding.PaddingBottom = UDim.new(0, 14)
		PagePadding.Parent = Page

		local function UpdatePageSize()
			Page.CanvasSize = UDim2.new(0, 0, 0, PageLayout.AbsoluteContentSize.Y + 28)
		end
		PageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(UpdatePageSize)

		table.insert(allTabBtns, {btn = TabBtn, bar = ActiveBar, stroke = TabStroke})
		table.insert(allPages, Page)

		if firstTab then firstTab = false end

		TabBtn.MouseButton1Click:Connect(function()
			for _, info in pairs(allTabBtns) do
				Utility:Tween(info.btn, {BackgroundTransparency = 1, TextColor3 = T.SubText}, 0.15)
				Utility:Tween(info.bar, {BackgroundTransparency = 1}, 0.15)
				Utility:Tween(info.stroke, {Transparency = 1}, 0.15)
			end
			for _, pg in pairs(allPages) do
				pg.Visible = false
			end

			Utility:Tween(TabBtn, {BackgroundTransparency = 0.93, TextColor3 = T.Text}, 0.15)
			Utility:Tween(ActiveBar, {BackgroundTransparency = 0.5}, 0.15)
			Utility:Tween(TabStroke, {Transparency = 0.92}, 0.15)
			Page.Visible = true
			UpdatePageSize()
		end)

		TabBtn.MouseEnter:Connect(function()
			if not Page.Visible then
				Utility:Tween(TabBtn, {TextColor3 = Color3.fromRGB(170,170,170)}, 0.1)
			end
		end)
		TabBtn.MouseLeave:Connect(function()
			if not Page.Visible then
				Utility:Tween(TabBtn, {TextColor3 = T.SubText}, 0.1)
			end
		end)

		-- ── SECTIONS ───────────────────────────────────────────────────────
		local Sections = {}

		function Sections:NewSection(sectionName, hidden)
			sectionName = sectionName or "Section"
			hidden = hidden or false

			local SectionFrame = Instance.new("Frame")
			SectionFrame.Name = "Section_" .. sectionName
			SectionFrame.Parent = Page
			SectionFrame.BackgroundTransparency = 1
			SectionFrame.BorderSizePixel = 0
			SectionFrame.Size = UDim2.new(1, 0, 0, 40)

			local SectionLayout = Instance.new("UIListLayout")
			SectionLayout.Parent = SectionFrame
			SectionLayout.SortOrder = Enum.SortOrder.LayoutOrder
			SectionLayout.Padding = UDim.new(0, 6)

			-- Section header (label + divider line)
			if not hidden then
				local HeaderRow = Instance.new("Frame")
				HeaderRow.BackgroundTransparency = 1
				HeaderRow.BorderSizePixel = 0
				HeaderRow.Size = UDim2.new(1, 0, 0, 16)
				HeaderRow.LayoutOrder = 0
				HeaderRow.Parent = SectionFrame

				local HeaderLabel = Instance.new("TextLabel")
				HeaderLabel.BackgroundTransparency = 1
				HeaderLabel.Position = UDim2.new(0, 0, 0, 0)
				HeaderLabel.Size = UDim2.new(0, 0, 1, 0)
				HeaderLabel.AutomaticSize = Enum.AutomaticSize.X
				HeaderLabel.Font = Enum.Font.GothamBold
				HeaderLabel.Text = string.upper(sectionName)
				HeaderLabel.TextColor3 = Color3.fromRGB(51, 51, 51)
				HeaderLabel.TextSize = 9
				HeaderLabel.TextXAlignment = Enum.TextXAlignment.Left
				HeaderLabel.Parent = HeaderRow

				-- letter spacing via small spaces hack not needed; just use the label
				local Divider = Instance.new("Frame")
				Divider.BackgroundColor3 = Color3.fromRGB(255,255,255)
				Divider.BackgroundTransparency = 0.95
				Divider.BorderSizePixel = 0
				Divider.AnchorPoint = Vector2.new(0, 0.5)
				Divider.Position = UDim2.new(0, 0, 0.5, 0)
				Divider.Size = UDim2.new(1, 0, 0, 1)
				Divider.LayoutOrder = 1
				Divider.Parent = SectionFrame
			end

			local ContentList = Instance.new("Frame")
			ContentList.Name = "Content"
			ContentList.Parent = SectionFrame
			ContentList.BackgroundTransparency = 1
			ContentList.BorderSizePixel = 0
			ContentList.Size = UDim2.new(1, 0, 0, 0)
			ContentList.LayoutOrder = 2

			local ContentLayout = Instance.new("UIListLayout")
			ContentLayout.Parent = ContentList
			ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
			ContentLayout.Padding = UDim.new(0, 6)

			local function UpdateSizes()
				ContentList.Size = UDim2.new(1, 0, 0, ContentLayout.AbsoluteContentSize.Y)
				SectionFrame.Size = UDim2.new(1, 0, 0, SectionLayout.AbsoluteContentSize.Y)
				UpdatePageSize()
			end
			ContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(UpdateSizes)

			-- ── ELEMENT FACTORY ────────────────────────────────────────────

			-- shared element base
			local function MakeElementBase(height)
				local el = Instance.new("Frame")
				el.BackgroundColor3 = T.Element
				el.BorderSizePixel = 0
				el.Size = UDim2.new(1, 0, 0, height or 46)
				el.Parent = ContentList
				MakeCorner(el, 10)
				MakeStroke(el, T.Stroke, 0.94)
				return el
			end

			local Elements = {}

			-- ── BUTTON ─────────────────────────────────────────────────────
			function Elements:NewButton(buttonName, buttonInfo, callback)
				buttonName = buttonName or "Button"
				callback = callback or function() end

				local El = MakeElementBase(40)
				local elStroke = El:FindFirstChildWhichIsA("UIStroke")

				local Lbl = Instance.new("TextLabel")
				Lbl.BackgroundTransparency = 1
				Lbl.Position = UDim2.new(0, 14, 0, 0)
				Lbl.Size = UDim2.new(1, -14, 1, 0)
				Lbl.Font = Enum.Font.GothamMedium
				Lbl.Text = buttonName
				Lbl.TextColor3 = T.SubText
				Lbl.TextSize = 12
				Lbl.TextXAlignment = Enum.TextXAlignment.Left
				Lbl.Parent = El

				local Btn = Instance.new("TextButton")
				Btn.BackgroundTransparency = 1
				Btn.BorderSizePixel = 0
				Btn.Size = UDim2.new(1, 0, 1, 0)
				Btn.Text = ""
				Btn.AutoButtonColor = false
				Btn.ZIndex = 2
				Btn.Parent = El

				Btn.MouseButton1Click:Connect(function()
					-- flash white
					Utility:Tween(El, {BackgroundColor3 = Color3.fromRGB(255,255,255)}, 0.08)
					Utility:Tween(Lbl, {TextColor3 = Color3.fromRGB(0,0,0)}, 0.08)
					task.delay(0.18, function()
						Utility:Tween(El, {BackgroundColor3 = T.Element}, 0.15)
						Utility:Tween(Lbl, {TextColor3 = T.SubText}, 0.15)
					end)
					callback()
				end)

				Btn.MouseEnter:Connect(function()
					Utility:Tween(elStroke, {Transparency = 0.88}, 0.1)
					Utility:Tween(Lbl, {TextColor3 = Color3.fromRGB(187,187,187)}, 0.1)
				end)
				Btn.MouseLeave:Connect(function()
					Utility:Tween(elStroke, {Transparency = 0.94}, 0.1)
					Utility:Tween(Lbl, {TextColor3 = T.SubText}, 0.1)
				end)

				UpdateSizes()

				local Funcs = {}
				function Funcs:UpdateButton(newText) Lbl.Text = newText end
				return Funcs
			end

			-- ── TOGGLE ─────────────────────────────────────────────────────
			function Elements:NewToggle(toggleName, toggleInfo, callback)
				toggleName = toggleName or "Toggle"
				callback = callback or function() end
				local toggled = false

				local El = MakeElementBase(46)
				local elStroke = El:FindFirstChildWhichIsA("UIStroke")

				local Lbl = Instance.new("TextLabel")
				Lbl.BackgroundTransparency = 1
				Lbl.Position = UDim2.new(0, 14, 0, 0)
				Lbl.Size = UDim2.new(1, -60, 1, 0)
				Lbl.Font = Enum.Font.GothamMedium
				Lbl.Text = toggleName
				Lbl.TextColor3 = T.SubText
				Lbl.TextSize = 12
				Lbl.TextXAlignment = Enum.TextXAlignment.Left
				Lbl.Parent = El

				-- toggle pill
				local Pill = Instance.new("Frame")
				Pill.BackgroundColor3 = Color3.fromRGB(42, 42, 42)
				Pill.BorderSizePixel = 0
				Pill.AnchorPoint = Vector2.new(1, 0.5)
				Pill.Position = UDim2.new(1, -14, 0.5, 0)
				Pill.Size = UDim2.new(0, 38, 0, 22)
				Pill.Parent = El
				MakeCorner(Pill, 100)

				local Circle = Instance.new("Frame")
				Circle.BackgroundColor3 = Color3.fromRGB(85, 85, 85)
				Circle.BorderSizePixel = 0
				Circle.Position = UDim2.new(0, 3, 0.5, -8)
				Circle.Size = UDim2.new(0, 16, 0, 16)
				Circle.Parent = Pill
				MakeCorner(Circle, 100)

				local Btn = Instance.new("TextButton")
				Btn.BackgroundTransparency = 1
				Btn.BorderSizePixel = 0
				Btn.Size = UDim2.new(1, 0, 1, 0)
				Btn.Text = ""
				Btn.AutoButtonColor = false
				Btn.ZIndex = 2
				Btn.Parent = El

				Btn.MouseButton1Click:Connect(function()
					toggled = not toggled
					if toggled then
						Utility:Tween(Pill, {BackgroundColor3 = Color3.fromRGB(255,255,255)}, 0.2)
						Utility:Tween(Circle, {Position = UDim2.new(1, -19, 0.5, -8), BackgroundColor3 = Color3.fromRGB(17,17,17)}, 0.2)
					else
						Utility:Tween(Pill, {BackgroundColor3 = Color3.fromRGB(42,42,42)}, 0.2)
						Utility:Tween(Circle, {Position = UDim2.new(0, 3, 0.5, -8), BackgroundColor3 = Color3.fromRGB(85,85,85)}, 0.2)
					end
					callback(toggled)
				end)

				Btn.MouseEnter:Connect(function()
					Utility:Tween(elStroke, {Transparency = 0.88}, 0.1)
					Utility:Tween(Lbl, {TextColor3 = Color3.fromRGB(187,187,187)}, 0.1)
				end)
				Btn.MouseLeave:Connect(function()
					Utility:Tween(elStroke, {Transparency = 0.94}, 0.1)
					Utility:Tween(Lbl, {TextColor3 = T.SubText}, 0.1)
				end)

				UpdateSizes()

				local Funcs = {}
				function Funcs:UpdateToggle(newText, state)
					if newText then Lbl.Text = newText end
					if state ~= nil then
						toggled = state
						if toggled then
							Pill.BackgroundColor3 = Color3.fromRGB(255,255,255)
							Circle.Position = UDim2.new(1, -19, 0.5, -8)
							Circle.BackgroundColor3 = Color3.fromRGB(17,17,17)
						else
							Pill.BackgroundColor3 = Color3.fromRGB(42,42,42)
							Circle.Position = UDim2.new(0, 3, 0.5, -8)
							Circle.BackgroundColor3 = Color3.fromRGB(85,85,85)
						end
						callback(toggled)
					end
				end
				return Funcs
			end

			-- ── SLIDER ─────────────────────────────────────────────────────
			function Elements:NewSlider(sliderName, sliderInfo, maxValue, minValue, callback)
				sliderName = sliderName or "Slider"
				maxValue = maxValue or 100
				minValue = minValue or 0
				callback = callback or function() end

				local El = MakeElementBase(60)
				local elStroke = El:FindFirstChildWhichIsA("UIStroke")

				local Lbl = Instance.new("TextLabel")
				Lbl.BackgroundTransparency = 1
				Lbl.Position = UDim2.new(0, 14, 0, 8)
				Lbl.Size = UDim2.new(1, -70, 0, 16)
				Lbl.Font = Enum.Font.GothamMedium
				Lbl.Text = sliderName
				Lbl.TextColor3 = T.SubText
				Lbl.TextSize = 12
				Lbl.TextXAlignment = Enum.TextXAlignment.Left
				Lbl.Parent = El

				-- value badge
				local ValFrame = Instance.new("Frame")
				ValFrame.BackgroundColor3 = Color3.fromRGB(31,31,31)
				ValFrame.BorderSizePixel = 0
				ValFrame.AnchorPoint = Vector2.new(1, 0)
				ValFrame.Position = UDim2.new(1, -14, 0, 7)
				ValFrame.Size = UDim2.new(0, 36, 0, 18)
				ValFrame.Parent = El
				MakeCorner(ValFrame, 6)
				MakeStroke(ValFrame, T.Stroke, 0.93)

				local ValLbl = Instance.new("TextLabel")
				ValLbl.BackgroundTransparency = 1
				ValLbl.Size = UDim2.new(1, 0, 1, 0)
				ValLbl.Font = Enum.Font.GothamBold
				ValLbl.Text = tostring(minValue)
				ValLbl.TextColor3 = T.Text
				ValLbl.TextSize = 11
				ValLbl.Parent = ValFrame

				-- track
				local TrackBg = Instance.new("Frame")
				TrackBg.BackgroundColor3 = Color3.fromRGB(255,255,255)
				TrackBg.BackgroundTransparency = 0.92
				TrackBg.BorderSizePixel = 0
				TrackBg.Position = UDim2.new(0, 14, 1, -18)
				TrackBg.Size = UDim2.new(1, -28, 0, 4)
				TrackBg.Parent = El
				MakeCorner(TrackBg, 100)

				local Fill = Instance.new("Frame")
				Fill.BackgroundColor3 = Color3.fromRGB(255,255,255)
				Fill.BackgroundTransparency = 0.3
				Fill.BorderSizePixel = 0
				Fill.Size = UDim2.new(0, 0, 1, 0)
				Fill.Parent = TrackBg
				MakeCorner(Fill, 100)

				local Knob = Instance.new("Frame")
				Knob.BackgroundColor3 = Color3.fromRGB(255,255,255)
				Knob.BorderSizePixel = 0
				Knob.AnchorPoint = Vector2.new(0.5, 0.5)
				Knob.Position = UDim2.new(0, 0, 0.5, 0)
				Knob.Size = UDim2.new(0, 14, 0, 14)
				Knob.ZIndex = 3
				Knob.Parent = TrackBg
				MakeCorner(Knob, 100)

				-- big invisible hit button
				local HitBtn = Instance.new("TextButton")
				HitBtn.BackgroundTransparency = 1
				HitBtn.BorderSizePixel = 0
				HitBtn.Position = UDim2.new(0, 14, 0, 0)
				HitBtn.Size = UDim2.new(1, -28, 1, 0)
				HitBtn.Text = ""
				HitBtn.AutoButtonColor = false
				HitBtn.ZIndex = 4
				HitBtn.Parent = El

				local currentValue = minValue
				local dragging = false

				local function SetValue(val)
					val = math.clamp(math.floor(val), minValue, maxValue)
					currentValue = val
					local pct = (val - minValue) / (maxValue - minValue)
					Fill.Size = UDim2.new(pct, 0, 1, 0)
					Knob.Position = UDim2.new(pct, 0, 0.5, 0)
					ValLbl.Text = tostring(val)
					callback(val)
				end

				local function CalcFromMouse(x)
					local trackPos = TrackBg.AbsolutePosition.X
					local trackWidth = TrackBg.AbsoluteSize.X
					local pct = math.clamp((x - trackPos) / trackWidth, 0, 1)
					SetValue(minValue + (maxValue - minValue) * pct)
				end

				HitBtn.MouseButton1Down:Connect(function()
					dragging = true
					CalcFromMouse(UserInputService:GetMouseLocation().X)
				end)

				UserInputService.InputEnded:Connect(function(inp)
					if inp.UserInputType == Enum.UserInputType.MouseButton1 then
						dragging = false
					end
				end)

				UserInputService.InputChanged:Connect(function(inp)
					if dragging and inp.UserInputType == Enum.UserInputType.MouseMovement then
						CalcFromMouse(inp.Position.X)
					end
				end)

				El.MouseEnter:Connect(function()
					Utility:Tween(elStroke, {Transparency = 0.88}, 0.1)
					Utility:Tween(Lbl, {TextColor3 = Color3.fromRGB(187,187,187)}, 0.1)
				end)
				El.MouseLeave:Connect(function()
					Utility:Tween(elStroke, {Transparency = 0.94}, 0.1)
					Utility:Tween(Lbl, {TextColor3 = T.SubText}, 0.1)
				end)

				UpdateSizes()
			end

			-- ── TEXTBOX ────────────────────────────────────────────────────
			function Elements:NewTextBox(textboxName, textboxInfo, callback)
				textboxName = textboxName or "TextBox"
				callback = callback or function() end

				local El = MakeElementBase(40)
				local elStroke = El:FindFirstChildWhichIsA("UIStroke")

				local Lbl = Instance.new("TextLabel")
				Lbl.BackgroundTransparency = 1
				Lbl.Position = UDim2.new(0, 14, 0, 0)
				Lbl.Size = UDim2.new(0, 110, 1, 0)
				Lbl.Font = Enum.Font.GothamMedium
				Lbl.Text = textboxName
				Lbl.TextColor3 = T.SubText
				Lbl.TextSize = 12
				Lbl.TextXAlignment = Enum.TextXAlignment.Left
				Lbl.Parent = El

				local InputBg = Instance.new("Frame")
				InputBg.BackgroundColor3 = Color3.fromRGB(15,15,15)
				InputBg.BorderSizePixel = 0
				InputBg.Position = UDim2.new(0, 128, 0.5, -12)
				InputBg.Size = UDim2.new(1, -142, 0, 24)
				InputBg.Parent = El
				MakeCorner(InputBg, 7)
				local inputStroke = MakeStroke(InputBg, T.Stroke, 0.93)

				local Box = Instance.new("TextBox")
				Box.BackgroundTransparency = 1
				Box.BorderSizePixel = 0
				Box.Position = UDim2.new(0, 8, 0, 0)
				Box.Size = UDim2.new(1, -8, 1, 0)
				Box.Font = Enum.Font.Gotham
				Box.PlaceholderText = "Enter value..."
				Box.PlaceholderColor3 = Color3.fromRGB(68, 68, 68)
				Box.Text = ""
				Box.TextColor3 = T.Text
				Box.TextSize = 11
				Box.TextXAlignment = Enum.TextXAlignment.Left
				Box.ClearTextOnFocus = false
				Box.Parent = InputBg

				Box.Focused:Connect(function()
					Utility:Tween(inputStroke, {Transparency = 0.82}, 0.1)
				end)
				Box.FocusLost:Connect(function(enter)
					Utility:Tween(inputStroke, {Transparency = 0.93}, 0.1)
					if enter then callback(Box.Text) end
				end)

				El.MouseEnter:Connect(function()
					Utility:Tween(elStroke, {Transparency = 0.88}, 0.1)
				end)
				El.MouseLeave:Connect(function()
					Utility:Tween(elStroke, {Transparency = 0.94}, 0.1)
				end)

				UpdateSizes()
			end

			-- ── LABEL ──────────────────────────────────────────────────────
			function Elements:NewLabel(labelText)
				labelText = labelText or "Label"

				local El = Instance.new("Frame")
				El.BackgroundColor3 = Color3.fromRGB(17,17,17)
				El.BorderSizePixel = 0
				El.Size = UDim2.new(1, 0, 0, 34)
				El.Parent = ContentList
				MakeCorner(El, 10)
				MakeStroke(El, T.Stroke, 0.96)

				local Lbl = Instance.new("TextLabel")
				Lbl.BackgroundTransparency = 1
				Lbl.Position = UDim2.new(0, 14, 0, 0)
				Lbl.Size = UDim2.new(1, -14, 1, 0)
				Lbl.Font = Enum.Font.Gotham
				Lbl.Text = labelText
				Lbl.TextColor3 = Color3.fromRGB(68, 68, 68)
				Lbl.TextSize = 11
				Lbl.TextXAlignment = Enum.TextXAlignment.Left
				Lbl.Parent = El

				UpdateSizes()

				local Funcs = {}
				function Funcs:UpdateLabel(newText) Lbl.Text = newText end
				return Funcs
			end

			-- ── DROPDOWN ───────────────────────────────────────────────────
			function Elements:NewDropdown(dropName, dropInfo, list, callback)
				dropName = dropName or "Dropdown"
				list = list or {}
				callback = callback or function() end

				local opened = false

				local Container = Instance.new("Frame")
				Container.BackgroundTransparency = 1
				Container.BorderSizePixel = 0
				Container.ClipsDescendants = true
				Container.Size = UDim2.new(1, 0, 0, 40)
				Container.Parent = ContentList

				local ContainerLayout = Instance.new("UIListLayout")
				ContainerLayout.Parent = Container
				ContainerLayout.SortOrder = Enum.SortOrder.LayoutOrder
				ContainerLayout.Padding = UDim.new(0, 4)

				-- header row
				local Header = Instance.new("Frame")
				Header.BackgroundColor3 = T.Element
				Header.BorderSizePixel = 0
				Header.Size = UDim2.new(1, 0, 0, 40)
				Header.LayoutOrder = 0
				Header.Parent = Container
				MakeCorner(Header, 10)
				local headerStroke = MakeStroke(Header, T.Stroke, 0.94)

				local HeaderLbl = Instance.new("TextLabel")
				HeaderLbl.BackgroundTransparency = 1
				HeaderLbl.Position = UDim2.new(0, 14, 0, 0)
				HeaderLbl.Size = UDim2.new(1, -40, 1, 0)
				HeaderLbl.Font = Enum.Font.GothamMedium
				HeaderLbl.Text = dropName
				HeaderLbl.TextColor3 = T.SubText
				HeaderLbl.TextSize = 12
				HeaderLbl.TextXAlignment = Enum.TextXAlignment.Left
				HeaderLbl.Parent = Header

				local Arrow = Instance.new("TextLabel")
				Arrow.BackgroundTransparency = 1
				Arrow.AnchorPoint = Vector2.new(1, 0.5)
				Arrow.Position = UDim2.new(1, -14, 0.5, 0)
				Arrow.Size = UDim2.new(0, 16, 0, 16)
				Arrow.Font = Enum.Font.GothamBold
				Arrow.Text = "v"
				Arrow.TextColor3 = Color3.fromRGB(68,68,68)
				Arrow.TextSize = 10
				Arrow.Parent = Header

				local HeaderBtn = Instance.new("TextButton")
				HeaderBtn.BackgroundTransparency = 1
				HeaderBtn.BorderSizePixel = 0
				HeaderBtn.Size = UDim2.new(1, 0, 1, 0)
				HeaderBtn.Text = ""
				HeaderBtn.AutoButtonColor = false
				HeaderBtn.ZIndex = 2
				HeaderBtn.Parent = Header

				-- options
				local OptionsFrame = Instance.new("Frame")
				OptionsFrame.BackgroundColor3 = Color3.fromRGB(17,17,17)
				OptionsFrame.BorderSizePixel = 0
				OptionsFrame.Size = UDim2.new(1, 0, 0, 0)
				OptionsFrame.LayoutOrder = 1
				OptionsFrame.ClipsDescendants = true
				OptionsFrame.Parent = Container
				MakeCorner(OptionsFrame, 10)
				MakeStroke(OptionsFrame, T.Stroke, 0.9)

				local OptionsLayout = Instance.new("UIListLayout")
				OptionsLayout.Parent = OptionsFrame
				OptionsLayout.SortOrder = Enum.SortOrder.LayoutOrder
				OptionsLayout.Padding = UDim.new(0, 0)

				local OptionsPad = Instance.new("UIPadding")
				OptionsPad.PaddingTop = UDim.new(0, 4)
				OptionsPad.PaddingBottom = UDim.new(0, 4)
				OptionsPad.Parent = OptionsFrame

				local function BuildOptions(optList)
					for _, c in pairs(OptionsFrame:GetChildren()) do
						if c:IsA("TextButton") then c:Destroy() end
					end
					for _, opt in pairs(optList) do
						local OptBtn = Instance.new("TextButton")
						OptBtn.BackgroundColor3 = Color3.fromRGB(255,255,255)
						OptBtn.BackgroundTransparency = 1
						OptBtn.BorderSizePixel = 0
						OptBtn.Size = UDim2.new(1, 0, 0, 32)
						OptBtn.AutoButtonColor = false
						OptBtn.Font = Enum.Font.Gotham
						OptBtn.Text = opt
						OptBtn.TextColor3 = Color3.fromRGB(102,102,102)
						OptBtn.TextSize = 11
						OptBtn.TextXAlignment = Enum.TextXAlignment.Left
						OptBtn.ZIndex = 3
						OptBtn.Parent = OptionsFrame

						local OptPad = Instance.new("UIPadding")
						OptPad.PaddingLeft = UDim.new(0, 14)
						OptPad.Parent = OptBtn

						OptBtn.MouseEnter:Connect(function()
							Utility:Tween(OptBtn, {BackgroundTransparency = 0.95, TextColor3 = T.Text}, 0.1)
						end)
						OptBtn.MouseLeave:Connect(function()
							Utility:Tween(OptBtn, {BackgroundTransparency = 1, TextColor3 = Color3.fromRGB(102,102,102)}, 0.1)
						end)

						OptBtn.MouseButton1Click:Connect(function()
							HeaderLbl.Text = opt
							callback(opt)
							opened = false
							Utility:Tween(OptionsFrame, {Size = UDim2.new(1, 0, 0, 0)}, 0.16, Enum.EasingStyle.Quint)
							Utility:Tween(Arrow, {Rotation = 0}, 0.16)
							Container.Size = UDim2.new(1, 0, 0, 40)
							UpdateSizes()
						end)
					end
				end

				BuildOptions(list)

				HeaderBtn.MouseButton1Click:Connect(function()
					opened = not opened
					local totalH = OptionsLayout.AbsoluteContentSize.Y + 8
					if opened then
						Utility:Tween(OptionsFrame, {Size = UDim2.new(1, 0, 0, totalH)}, 0.18, Enum.EasingStyle.Quint)
						Utility:Tween(Arrow, {Rotation = 180}, 0.16)
						Container.Size = UDim2.new(1, 0, 0, 40 + 4 + totalH)
					else
						Utility:Tween(OptionsFrame, {Size = UDim2.new(1, 0, 0, 0)}, 0.15, Enum.EasingStyle.Quint)
						Utility:Tween(Arrow, {Rotation = 0}, 0.15)
						Container.Size = UDim2.new(1, 0, 0, 40)
					end
					UpdateSizes()
				end)

				HeaderBtn.MouseEnter:Connect(function()
					Utility:Tween(headerStroke, {Transparency = 0.88}, 0.1)
					Utility:Tween(HeaderLbl, {TextColor3 = Color3.fromRGB(187,187,187)}, 0.1)
				end)
				HeaderBtn.MouseLeave:Connect(function()
					Utility:Tween(headerStroke, {Transparency = 0.94}, 0.1)
					Utility:Tween(HeaderLbl, {TextColor3 = T.SubText}, 0.1)
				end)

				UpdateSizes()

				local Funcs = {}
				function Funcs:Refresh(newList)
					BuildOptions(newList)
					opened = false
					OptionsFrame.Size = UDim2.new(1, 0, 0, 0)
					Arrow.Rotation = 0
					Container.Size = UDim2.new(1, 0, 0, 40)
					UpdateSizes()
				end
				return Funcs
			end

			UpdateSizes()
			return Elements
		end

		return Sections
	end

	return Tabs
end

return ChimiUI
