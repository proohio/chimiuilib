local ChimiUI = {}

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

local function Tween(obj, props, t)
	TweenService:Create(obj, TweenInfo.new(t or 0.15, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), props):Play()
end

local function Corner(parent, r)
	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, r or 10)
	c.Parent = parent
	return c
end

local function Stroke(parent, col, alpha, thick)
	local s = Instance.new("UIStroke")
	s.Color = col or Color3.fromRGB(255,255,255)
	s.Transparency = alpha or 0.93
	s.Thickness = thick or 1
	s.Parent = parent
	return s
end

local function Frame(props)
	local f = Instance.new("Frame")
	f.BackgroundTransparency = props.Alpha or 0
	f.BackgroundColor3 = props.Color or Color3.fromRGB(0,0,0)
	f.BorderSizePixel = 0
	if props.Size then f.Size = props.Size end
	if props.Pos then f.Position = props.Pos end
	if props.Anchor then f.AnchorPoint = props.Anchor end
	if props.ZIndex then f.ZIndex = props.ZIndex end
	if props.Clip then f.ClipsDescendants = true end
	if props.Parent then f.Parent = props.Parent end
	return f
end

local THEMES = {
	Chimi = {
		Bg      = Color3.fromRGB(14,14,14),
		Header  = Color3.fromRGB(10,10,10),
		Sidebar = Color3.fromRGB(10,10,10),
		El      = Color3.fromRGB(22,22,22),
		Text    = Color3.fromRGB(255,255,255),
		Sub     = Color3.fromRGB(136,136,136),
		Muted   = Color3.fromRGB(51,51,51),
	},
	DarkTheme = {
		Bg      = Color3.fromRGB(5,5,5),
		Header  = Color3.fromRGB(0,0,0),
		Sidebar = Color3.fromRGB(0,0,0),
		El      = Color3.fromRGB(18,18,18),
		Text    = Color3.fromRGB(255,255,255),
		Sub     = Color3.fromRGB(100,100,100),
		Muted   = Color3.fromRGB(40,40,40),
	},
	LightTheme = {
		Bg      = Color3.fromRGB(242,242,242),
		Header  = Color3.fromRGB(228,228,228),
		Sidebar = Color3.fromRGB(228,228,228),
		El      = Color3.fromRGB(255,255,255),
		Text    = Color3.fromRGB(20,20,20),
		Sub     = Color3.fromRGB(120,120,120),
		Muted   = Color3.fromRGB(200,200,200),
	},
	Ocean = {
		Bg      = Color3.fromRGB(18,22,40),
		Header  = Color3.fromRGB(14,18,34),
		Sidebar = Color3.fromRGB(14,18,34),
		El      = Color3.fromRGB(24,30,52),
		Text    = Color3.fromRGB(210,210,255),
		Sub     = Color3.fromRGB(100,110,180),
		Muted   = Color3.fromRGB(50,55,100),
	},
}

local LibName = tostring(math.random(100000,999999))

function ChimiUI:ToggleUI()
	local g = game.CoreGui:FindFirstChild(LibName)
	if g then g.Enabled = not g.Enabled end
end

function ChimiUI.CreateLib(libName, themeChoice)
	local T = THEMES.Chimi
	if type(themeChoice) == "string" and THEMES[themeChoice] then
		T = THEMES[themeChoice]
	elseif type(themeChoice) == "table" then
		T = themeChoice
	end
	libName = libName or "Chimi UI"

	for _, v in ipairs(game.CoreGui:GetChildren()) do
		if v.Name == LibName then v:Destroy() end
	end

	local ScreenGui = Instance.new("ScreenGui")
	ScreenGui.Name = LibName
	ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	ScreenGui.ResetOnSpawn = false
	ScreenGui.Parent = game.CoreGui

	local Main = Frame({
		Color = T.Bg,
		Size = UDim2.new(0,720,0,520),
		Pos = UDim2.new(0.5,-360,0.5,-260),
		Clip = true,
		Parent = ScreenGui,
	})
	Corner(Main, 14)
	Stroke(Main, Color3.fromRGB(255,255,255), 0.93)

	local TitleBar = Frame({
		Color = T.Header,
		Size = UDim2.new(1,0,0,44),
		ZIndex = 2,
		Parent = Main,
	})

	Frame({
		Color = Color3.fromRGB(255,255,255),
		Alpha = 0.95,
		Size = UDim2.new(1,0,0,1),
		Pos = UDim2.new(0,0,1,-1),
		Parent = TitleBar,
	})

	local TitleLbl = Instance.new("TextLabel")
	TitleLbl.BackgroundTransparency = 1
	TitleLbl.Position = UDim2.new(0,20,0,0)
	TitleLbl.Size = UDim2.new(1,-100,1,0)
	TitleLbl.Font = Enum.Font.GothamBold
	TitleLbl.Text = libName
	TitleLbl.TextColor3 = T.Sub
	TitleLbl.TextSize = 13
	TitleLbl.TextXAlignment = Enum.TextXAlignment.Left
	TitleLbl.ZIndex = 2
	TitleLbl.Parent = TitleBar

	local function MakeWinBtn(xOff, isClose)
		local Btn = Instance.new("TextButton")
		Btn.BackgroundColor3 = Color3.fromRGB(28,28,28)
		Btn.BorderSizePixel = 0
		Btn.Position = UDim2.new(1, xOff, 0.5, -13)
		Btn.Size = UDim2.new(0,26,0,26)
		Btn.Text = ""
		Btn.AutoButtonColor = false
		Btn.ZIndex = 3
		Btn.Parent = TitleBar
		Corner(Btn, 7)
		Stroke(Btn, Color3.fromRGB(255,255,255), 0.94)

		local L1 = Frame({
			Color = Color3.fromRGB(136,136,136),
			Alpha = 0.3,
			Size = UDim2.new(0,10,0,1),
			Pos = UDim2.new(0.5,-5,0.5,0),
			ZIndex = 4,
			Parent = Btn,
		})
		Corner(L1, 2)

		if isClose then
			L1.Size = UDim2.new(0,9,0,1)
			L1.Position = UDim2.new(0.5,-4.5,0.5,0)
			L1.Rotation = 45
			local L2 = Frame({
				Color = Color3.fromRGB(136,136,136),
				Alpha = 0.3,
				Size = UDim2.new(0,9,0,1),
				Pos = UDim2.new(0.5,-4.5,0.5,0),
				ZIndex = 4,
				Parent = Btn,
			})
			L2.Rotation = -45
			Corner(L2, 2)
			Btn.MouseEnter:Connect(function()
				Tween(Btn, {BackgroundColor3=Color3.fromRGB(195,35,35)}, 0.12)
				Tween(L1, {BackgroundTransparency=0}, 0.12)
				Tween(L2, {BackgroundTransparency=0}, 0.12)
			end)
			Btn.MouseLeave:Connect(function()
				Tween(Btn, {BackgroundColor3=Color3.fromRGB(28,28,28)}, 0.12)
				Tween(L1, {BackgroundTransparency=0.3}, 0.12)
				Tween(L2, {BackgroundTransparency=0.3}, 0.12)
			end)
		else
			Btn.MouseEnter:Connect(function()
				Tween(Btn, {BackgroundColor3=Color3.fromRGB(42,42,42)}, 0.12)
				Tween(L1, {BackgroundTransparency=0}, 0.12)
			end)
			Btn.MouseLeave:Connect(function()
				Tween(Btn, {BackgroundColor3=Color3.fromRGB(28,28,28)}, 0.12)
				Tween(L1, {BackgroundTransparency=0.3}, 0.12)
			end)
		end
		return Btn
	end

	local MinBtn   = MakeWinBtn(-64, false)
	local CloseBtn = MakeWinBtn(-32, true)

	do
		local drag = false
		local dInput, dStart, dPos
		TitleBar.InputBegan:Connect(function(inp)
			if inp.UserInputType == Enum.UserInputType.MouseButton1 then
				drag = true
				dStart = inp.Position
				dPos = Main.Position
				inp.Changed:Connect(function()
					if inp.UserInputState == Enum.UserInputState.End then drag = false end
				end)
			end
		end)
		TitleBar.InputChanged:Connect(function(inp)
			if inp.UserInputType == Enum.UserInputType.MouseMovement then dInput = inp end
		end)
		UserInputService.InputChanged:Connect(function(inp)
			if inp == dInput and drag then
				local d = inp.Position - dStart
				Main.Position = UDim2.new(dPos.X.Scale, dPos.X.Offset+d.X, dPos.Y.Scale, dPos.Y.Offset+d.Y)
			end
		end)
	end

	local Sidebar = Frame({
		Color = T.Sidebar,
		Size = UDim2.new(0,155,1,-44),
		Pos = UDim2.new(0,0,0,44),
		Parent = Main,
	})

	Frame({
		Color = Color3.fromRGB(255,255,255),
		Alpha = 0.95,
		Size = UDim2.new(0,1,1,0),
		Pos = UDim2.new(1,-1,0,0),
		Parent = Sidebar,
	})

	local TabScroll = Instance.new("ScrollingFrame")
	TabScroll.BackgroundTransparency = 1
	TabScroll.BorderSizePixel = 0
	TabScroll.Size = UDim2.new(1,0,1,-60)
	TabScroll.ScrollBarThickness = 0
	TabScroll.CanvasSize = UDim2.new(0,0,0,0)
	TabScroll.Parent = Sidebar

	local TabLL = Instance.new("UIListLayout")
	TabLL.SortOrder = Enum.SortOrder.LayoutOrder
	TabLL.Padding = UDim.new(0,2)
	TabLL.Parent = TabScroll

	local TabPad = Instance.new("UIPadding")
	TabPad.PaddingTop = UDim.new(0,8)
	TabPad.PaddingLeft = UDim.new(0,8)
	TabPad.PaddingRight = UDim.new(0,8)
	TabPad.Parent = TabScroll

	TabLL:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		TabScroll.CanvasSize = UDim2.new(0,0,0,TabLL.AbsoluteContentSize.Y+16)
	end)

	local ProfileArea = Frame({
		Alpha = 1,
		Size = UDim2.new(1,0,0,60),
		Pos = UDim2.new(0,0,1,-60),
		Parent = Sidebar,
	})

	Frame({
		Color = Color3.fromRGB(255,255,255),
		Alpha = 0.95,
		Size = UDim2.new(1,0,0,1),
		Parent = ProfileArea,
	})

	local AvatarHolder = Frame({
		Color = Color3.fromRGB(26,26,26),
		Size = UDim2.new(0,34,0,34),
		Pos = UDim2.new(0,10,0.5,-17),
		Parent = ProfileArea,
	})
	Corner(AvatarHolder, 100)
	Stroke(AvatarHolder, Color3.fromRGB(255,255,255), 0.92)

	local AvatarImg = Instance.new("ImageLabel")
	AvatarImg.BackgroundTransparency = 1
	AvatarImg.Size = UDim2.new(1,0,1,0)
	AvatarImg.ScaleType = Enum.ScaleType.Crop
	AvatarImg.Parent = AvatarHolder
	Corner(AvatarImg, 100)

	local DispNameLbl = Instance.new("TextLabel")
	DispNameLbl.BackgroundTransparency = 1
	DispNameLbl.Position = UDim2.new(0,52,0,12)
	DispNameLbl.Size = UDim2.new(1,-68,0,16)
	DispNameLbl.Font = Enum.Font.GothamBold
	DispNameLbl.Text = "..."
	DispNameLbl.TextColor3 = Color3.fromRGB(200,200,200)
	DispNameLbl.TextSize = 12
	DispNameLbl.TextXAlignment = Enum.TextXAlignment.Left
	DispNameLbl.TextTruncate = Enum.TextTruncate.AtEnd
	DispNameLbl.Parent = ProfileArea

	local UserNameLbl = Instance.new("TextLabel")
	UserNameLbl.BackgroundTransparency = 1
	UserNameLbl.Position = UDim2.new(0,52,0,30)
	UserNameLbl.Size = UDim2.new(1,-68,0,13)
	UserNameLbl.Font = Enum.Font.Gotham
	UserNameLbl.Text = "@..."
	UserNameLbl.TextColor3 = Color3.fromRGB(68,68,68)
	UserNameLbl.TextSize = 10
	UserNameLbl.TextXAlignment = Enum.TextXAlignment.Left
	UserNameLbl.TextTruncate = Enum.TextTruncate.AtEnd
	UserNameLbl.Parent = ProfileArea

	Frame({
		Color = Color3.fromRGB(34,197,94),
		Size = UDim2.new(0,6,0,6),
		Pos = UDim2.new(1,-14,0.5,-3),
		Parent = ProfileArea,
	})
	Corner(ProfileArea:FindFirstChildWhichIsA("Frame", true), 100)

	local lp = Players.LocalPlayer
	DispNameLbl.Text = lp.DisplayName
	UserNameLbl.Text = "@"..lp.Name
	pcall(function()
		local img = Players:GetUserThumbnailAsync(lp.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48)
		AvatarImg.Image = img
	end)

	local ContentArea = Frame({
		Alpha = 1,
		Size = UDim2.new(1,-155,1,-44),
		Pos = UDim2.new(0,155,0,44),
		Parent = Main,
	})

	local Pages = Instance.new("Folder")
	Pages.Parent = ContentArea

	local minimized = false
	MinBtn.MouseButton1Click:Connect(function()
		minimized = not minimized
		Tween(Main, {Size = minimized and UDim2.new(0,720,0,44) or UDim2.new(0,720,0,520)}, 0.25)
	end)
	CloseBtn.MouseButton1Click:Connect(function()
		Tween(Main, {Size=UDim2.new(0,720,0,0)}, 0.2)
		task.delay(0.21, function() ScreenGui:Destroy() end)
	end)

	function ChimiUI:ChangeColor(prop, col)
		T[prop] = col
	end

	local Tabs = {}
	local allTabData = {}
	local firstTab = true

	function Tabs:NewTab(tabName)
		tabName = tabName or "Tab"
		local isFirst = firstTab
		firstTab = false

		local TabBtn = Instance.new("TextButton")
		TabBtn.BackgroundColor3 = Color3.fromRGB(255,255,255)
		TabBtn.BackgroundTransparency = isFirst and 0.93 or 1
		TabBtn.BorderSizePixel = 0
		TabBtn.Size = UDim2.new(1,0,0,34)
		TabBtn.AutoButtonColor = false
		TabBtn.Font = Enum.Font.GothamMedium
		TabBtn.Text = tabName
		TabBtn.TextColor3 = isFirst and T.Text or T.Sub
		TabBtn.TextSize = 12
		TabBtn.ZIndex = 2
		TabBtn.Parent = TabScroll
		Corner(TabBtn, 8)
		local tabStroke = Stroke(TabBtn, Color3.fromRGB(255,255,255), isFirst and 0.92 or 1)

		local ActiveBar = Frame({
			Color = Color3.fromRGB(255,255,255),
			Alpha = isFirst and 0.5 or 1,
			Size = UDim2.new(0,3,0,18),
			Pos = UDim2.new(0,0,0.5,-9),
			ZIndex = 3,
			Parent = TabBtn,
		})
		Corner(ActiveBar, 4)

		local Page = Instance.new("ScrollingFrame")
		Page.BackgroundTransparency = 1
		Page.BorderSizePixel = 0
		Page.Size = UDim2.new(1,0,1,0)
		Page.ScrollBarThickness = 3
		Page.ScrollBarImageColor3 = Color3.fromRGB(255,255,255)
		Page.ScrollBarImageTransparency = 0.93
		Page.CanvasSize = UDim2.new(0,0,0,0)
		Page.Visible = isFirst
		Page.Parent = ContentArea

		local PageLL = Instance.new("UIListLayout")
		PageLL.SortOrder = Enum.SortOrder.LayoutOrder
		PageLL.Padding = UDim.new(0,14)
		PageLL.Parent = Page

		local PagePad = Instance.new("UIPadding")
		PagePad.PaddingTop = UDim.new(0,14)
		PagePad.PaddingLeft = UDim.new(0,14)
		PagePad.PaddingRight = UDim.new(0,14)
		PagePad.PaddingBottom = UDim.new(0,14)
		PagePad.Parent = Page

		local function RefreshCanvas()
			Page.CanvasSize = UDim2.new(0,0,0,PageLL.AbsoluteContentSize.Y+28)
		end
		PageLL:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(RefreshCanvas)

		local entry = {btn=TabBtn, bar=ActiveBar, stroke=tabStroke, page=Page}
		table.insert(allTabData, entry)

		TabBtn.MouseButton1Click:Connect(function()
			for _, d in ipairs(allTabData) do
				d.page.Visible = false
				Tween(d.btn, {BackgroundTransparency=1, TextColor3=T.Sub}, 0.15)
				Tween(d.bar, {BackgroundTransparency=1}, 0.15)
				Tween(d.stroke, {Transparency=1}, 0.15)
			end
			Page.Visible = true
			Tween(TabBtn, {BackgroundTransparency=0.93, TextColor3=T.Text}, 0.15)
			Tween(ActiveBar, {BackgroundTransparency=0.5}, 0.15)
			Tween(tabStroke, {Transparency=0.92}, 0.15)
			RefreshCanvas()
		end)

		TabBtn.MouseEnter:Connect(function()
			if not Page.Visible then Tween(TabBtn, {TextColor3=Color3.fromRGB(170,170,170)}, 0.1) end
		end)
		TabBtn.MouseLeave:Connect(function()
			if not Page.Visible then Tween(TabBtn, {TextColor3=T.Sub}, 0.1) end
		end)

		local Sections = {}

		function Sections:NewSection(secName, hidden)
			secName = secName or "Section"
			hidden = hidden or false

			local SecFrame = Frame({
				Alpha = 1,
				Size = UDim2.new(1,0,0,10),
				Parent = Page,
			})

			local SecLL = Instance.new("UIListLayout")
			SecLL.SortOrder = Enum.SortOrder.LayoutOrder
			SecLL.Padding = UDim.new(0,6)
			SecLL.Parent = SecFrame

			if not hidden then
				local HRow = Frame({
					Alpha = 1,
					Size = UDim2.new(1,0,0,18),
					Parent = SecFrame,
				})
				HRow.LayoutOrder = 0

				local HRowLL = Instance.new("UIListLayout")
				HRowLL.FillDirection = Enum.FillDirection.Horizontal
				HRowLL.VerticalAlignment = Enum.VerticalAlignment.Center
				HRowLL.Padding = UDim.new(0,8)
				HRowLL.Parent = HRow

				local SecTitleLbl = Instance.new("TextLabel")
				SecTitleLbl.BackgroundTransparency = 1
				SecTitleLbl.AutomaticSize = Enum.AutomaticSize.X
				SecTitleLbl.Size = UDim2.new(0,0,1,0)
				SecTitleLbl.Font = Enum.Font.GothamBold
				SecTitleLbl.Text = string.upper(secName)
				SecTitleLbl.TextColor3 = T.Muted
				SecTitleLbl.TextSize = 9
				SecTitleLbl.TextXAlignment = Enum.TextXAlignment.Left
				SecTitleLbl.LayoutOrder = 0
				SecTitleLbl.Parent = HRow

				local DivLine = Frame({
					Color = Color3.fromRGB(255,255,255),
					Alpha = 0.95,
					Size = UDim2.new(1,0,0,1),
					Parent = HRow,
				})
				DivLine.LayoutOrder = 1
			end

			local ContentHolder = Frame({
				Alpha = 1,
				Size = UDim2.new(1,0,0,0),
				Parent = SecFrame,
			})
			ContentHolder.LayoutOrder = 2

			local ContentLL = Instance.new("UIListLayout")
			ContentLL.SortOrder = Enum.SortOrder.LayoutOrder
			ContentLL.Padding = UDim.new(0,6)
			ContentLL.Parent = ContentHolder

			local function Resize()
				ContentHolder.Size = UDim2.new(1,0,0,ContentLL.AbsoluteContentSize.Y)
				SecFrame.Size = UDim2.new(1,0,0,SecLL.AbsoluteContentSize.Y)
				RefreshCanvas()
			end
			ContentLL:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(Resize)
			SecLL:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(Resize)

			local function El(h)
				local f = Frame({
					Color = T.El,
					Size = UDim2.new(1,0,0,h or 44),
					Parent = ContentHolder,
				})
				Corner(f, 12)
				local s = Stroke(f, Color3.fromRGB(255,255,255), 0.94)
				return f, s
			end

			local Elements = {}

			function Elements:NewButton(btnName, btnInfo, callback)
				btnName = btnName or "Button"
				callback = callback or function() end
				local f, s = El(40)

				local Lbl = Instance.new("TextLabel")
				Lbl.BackgroundTransparency = 1
				Lbl.Position = UDim2.new(0,14,0,0)
				Lbl.Size = UDim2.new(1,-14,1,0)
				Lbl.Font = Enum.Font.GothamMedium
				Lbl.Text = btnName
				Lbl.TextColor3 = T.Sub
				Lbl.TextSize = 12
				Lbl.TextXAlignment = Enum.TextXAlignment.Left
				Lbl.Parent = f

				local HitBtn = Instance.new("TextButton")
				HitBtn.BackgroundTransparency = 1
				HitBtn.BorderSizePixel = 0
				HitBtn.Size = UDim2.new(1,0,1,0)
				HitBtn.Text = ""
				HitBtn.AutoButtonColor = false
				HitBtn.ZIndex = 2
				HitBtn.Parent = f

				HitBtn.MouseButton1Click:Connect(function()
					Tween(f, {BackgroundColor3=Color3.fromRGB(255,255,255)}, 0.08)
					Tween(Lbl, {TextColor3=Color3.fromRGB(0,0,0)}, 0.08)
					task.delay(0.18, function()
						Tween(f, {BackgroundColor3=T.El}, 0.15)
						Tween(Lbl, {TextColor3=T.Sub}, 0.15)
					end)
					callback()
				end)
				HitBtn.MouseEnter:Connect(function()
					Tween(s, {Transparency=0.87}, 0.1)
					Tween(Lbl, {TextColor3=Color3.fromRGB(190,190,190)}, 0.1)
				end)
				HitBtn.MouseLeave:Connect(function()
					Tween(s, {Transparency=0.94}, 0.1)
					Tween(Lbl, {TextColor3=T.Sub}, 0.1)
				end)

				Resize()
				local Funcs = {}
				function Funcs:UpdateButton(t) Lbl.Text = t end
				return Funcs
			end

			function Elements:NewToggle(togName, togInfo, callback)
				togName = togName or "Toggle"
				callback = callback or function() end
				local on = false
				local f, s = El(44)

				local Lbl = Instance.new("TextLabel")
				Lbl.BackgroundTransparency = 1
				Lbl.Position = UDim2.new(0,14,0,0)
				Lbl.Size = UDim2.new(1,-60,1,0)
				Lbl.Font = Enum.Font.GothamMedium
				Lbl.Text = togName
				Lbl.TextColor3 = T.Sub
				Lbl.TextSize = 12
				Lbl.TextXAlignment = Enum.TextXAlignment.Left
				Lbl.Parent = f

				local Pill = Frame({
					Color = Color3.fromRGB(42,42,42),
					Size = UDim2.new(0,38,0,22),
					Pos = UDim2.new(1,-52,0.5,-11),
					Parent = f,
				})
				Corner(Pill, 100)

				local Circle = Frame({
					Color = Color3.fromRGB(85,85,85),
					Size = UDim2.new(0,16,0,16),
					Pos = UDim2.new(0,3,0.5,-8),
					Parent = Pill,
				})
				Corner(Circle, 100)

				local HitBtn = Instance.new("TextButton")
				HitBtn.BackgroundTransparency = 1
				HitBtn.BorderSizePixel = 0
				HitBtn.Size = UDim2.new(1,0,1,0)
				HitBtn.Text = ""
				HitBtn.AutoButtonColor = false
				HitBtn.ZIndex = 2
				HitBtn.Parent = f

				local function SetOn(state)
					on = state
					if on then
						Tween(Pill, {BackgroundColor3=Color3.fromRGB(255,255,255)}, 0.2)
						Tween(Circle, {Position=UDim2.new(1,-19,0.5,-8), BackgroundColor3=Color3.fromRGB(17,17,17)}, 0.2)
					else
						Tween(Pill, {BackgroundColor3=Color3.fromRGB(42,42,42)}, 0.2)
						Tween(Circle, {Position=UDim2.new(0,3,0.5,-8), BackgroundColor3=Color3.fromRGB(85,85,85)}, 0.2)
					end
				end

				HitBtn.MouseButton1Click:Connect(function()
					SetOn(not on)
					callback(on)
				end)
				HitBtn.MouseEnter:Connect(function()
					Tween(s, {Transparency=0.87}, 0.1)
					Tween(Lbl, {TextColor3=Color3.fromRGB(190,190,190)}, 0.1)
				end)
				HitBtn.MouseLeave:Connect(function()
					Tween(s, {Transparency=0.94}, 0.1)
					Tween(Lbl, {TextColor3=T.Sub}, 0.1)
				end)

				Resize()
				local Funcs = {}
				function Funcs:UpdateToggle(newText, state)
					if newText then Lbl.Text = newText end
					if state ~= nil then SetOn(state) callback(on) end
				end
				return Funcs
			end

			function Elements:NewSlider(sliderName, sliderInfo, maxVal, minVal, callback)
				sliderName = sliderName or "Slider"
				maxVal = maxVal or 100
				minVal = minVal or 0
				callback = callback or function() end
				local f, s = El(62)

				local Lbl = Instance.new("TextLabel")
				Lbl.BackgroundTransparency = 1
				Lbl.Position = UDim2.new(0,14,0,9)
				Lbl.Size = UDim2.new(1,-70,0,16)
				Lbl.Font = Enum.Font.GothamMedium
				Lbl.Text = sliderName
				Lbl.TextColor3 = T.Sub
				Lbl.TextSize = 12
				Lbl.TextXAlignment = Enum.TextXAlignment.Left
				Lbl.Parent = f

				local ValBox = Frame({
					Color = Color3.fromRGB(31,31,31),
					Size = UDim2.new(0,38,0,20),
					Pos = UDim2.new(1,-52,0,8),
					Parent = f,
				})
				Corner(ValBox, 7)
				Stroke(ValBox, Color3.fromRGB(255,255,255), 0.93)

				local ValLbl = Instance.new("TextLabel")
				ValLbl.BackgroundTransparency = 1
				ValLbl.Size = UDim2.new(1,0,1,0)
				ValLbl.Font = Enum.Font.GothamBold
				ValLbl.Text = tostring(minVal)
				ValLbl.TextColor3 = T.Text
				ValLbl.TextSize = 11
				ValLbl.Parent = ValBox

				local Track = Frame({
					Color = Color3.fromRGB(255,255,255),
					Alpha = 0.92,
					Size = UDim2.new(1,-28,0,4),
					Pos = UDim2.new(0,14,1,-16),
					Parent = f,
				})
				Corner(Track, 100)

				local Fill = Frame({
					Color = Color3.fromRGB(255,255,255),
					Alpha = 0.3,
					Size = UDim2.new(0,0,1,0),
					Parent = Track,
				})
				Corner(Fill, 100)

				local Knob = Frame({
					Color = Color3.fromRGB(255,255,255),
					Size = UDim2.new(0,14,0,14),
					Pos = UDim2.new(0,-7,0.5,-7),
					ZIndex = 3,
					Parent = Track,
				})
				Corner(Knob, 100)

				local HitArea = Instance.new("TextButton")
				HitArea.BackgroundTransparency = 1
				HitArea.BorderSizePixel = 0
				HitArea.Position = UDim2.new(0,-6,0,-10)
				HitArea.Size = UDim2.new(1,12,1,20)
				HitArea.Text = ""
				HitArea.AutoButtonColor = false
				HitArea.ZIndex = 4
				HitArea.Parent = Track

				local curVal = minVal
				local sliding = false

				local function SetVal(px)
					local tw = Track.AbsoluteSize.X
					local tx = Track.AbsolutePosition.X
					local pct = math.clamp((px - tx) / tw, 0, 1)
					curVal = math.floor(minVal + (maxVal - minVal) * pct)
					Fill.Size = UDim2.new(pct,0,1,0)
					Knob.Position = UDim2.new(pct,-7,0.5,-7)
					ValLbl.Text = tostring(curVal)
					callback(curVal)
				end

				HitArea.MouseButton1Down:Connect(function()
					sliding = true
					SetVal(UserInputService:GetMouseLocation().X)
				end)
				UserInputService.InputEnded:Connect(function(inp)
					if inp.UserInputType == Enum.UserInputType.MouseButton1 then sliding = false end
				end)
				UserInputService.InputChanged:Connect(function(inp)
					if sliding and inp.UserInputType == Enum.UserInputType.MouseMovement then
						SetVal(inp.Position.X)
					end
				end)

				f.MouseEnter:Connect(function()
					Tween(s, {Transparency=0.87}, 0.1)
					Tween(Lbl, {TextColor3=Color3.fromRGB(190,190,190)}, 0.1)
				end)
				f.MouseLeave:Connect(function()
					Tween(s, {Transparency=0.94}, 0.1)
					Tween(Lbl, {TextColor3=T.Sub}, 0.1)
				end)

				Resize()
			end

			function Elements:NewTextBox(tbName, tbInfo, callback)
				tbName = tbName or "TextBox"
				callback = callback or function() end
				local f, s = El(40)

				local Lbl = Instance.new("TextLabel")
				Lbl.BackgroundTransparency = 1
				Lbl.Position = UDim2.new(0,14,0,0)
				Lbl.Size = UDim2.new(0,110,1,0)
				Lbl.Font = Enum.Font.GothamMedium
				Lbl.Text = tbName
				Lbl.TextColor3 = T.Sub
				Lbl.TextSize = 12
				Lbl.TextXAlignment = Enum.TextXAlignment.Left
				Lbl.Parent = f

				local InputBg = Frame({
					Color = Color3.fromRGB(15,15,15),
					Size = UDim2.new(1,-132,0,24),
					Pos = UDim2.new(0,128,0.5,-12),
					Parent = f,
				})
				Corner(InputBg, 8)
				local iStroke = Stroke(InputBg, Color3.fromRGB(255,255,255), 0.93)

				local Box = Instance.new("TextBox")
				Box.BackgroundTransparency = 1
				Box.BorderSizePixel = 0
				Box.Position = UDim2.new(0,8,0,0)
				Box.Size = UDim2.new(1,-16,1,0)
				Box.Font = Enum.Font.Gotham
				Box.PlaceholderText = "Enter value.."
				Box.PlaceholderColor3 = Color3.fromRGB(68,68,68)
				Box.Text = ""
				Box.TextColor3 = T.Text
				Box.TextSize = 11
				Box.TextXAlignment = Enum.TextXAlignment.Left
				Box.ClearTextOnFocus = false
				Box.Parent = InputBg

				Box.Focused:Connect(function() Tween(iStroke, {Transparency=0.80}, 0.1) end)
				Box.FocusLost:Connect(function(enter)
					Tween(iStroke, {Transparency=0.93}, 0.1)
					if enter then callback(Box.Text) end
				end)
				f.MouseEnter:Connect(function() Tween(s, {Transparency=0.87}, 0.1) end)
				f.MouseLeave:Connect(function() Tween(s, {Transparency=0.94}, 0.1) end)

				Resize()
			end

			function Elements:NewLabel(labelText)
				labelText = labelText or "Label"

				local f = Frame({
					Color = Color3.fromRGB(17,17,17),
					Size = UDim2.new(1,0,0,36),
					Parent = ContentHolder,
				})
				Corner(f, 12)
				Stroke(f, Color3.fromRGB(255,255,255), 0.96)

				local Lbl = Instance.new("TextLabel")
				Lbl.BackgroundTransparency = 1
				Lbl.Position = UDim2.new(0,14,0,0)
				Lbl.Size = UDim2.new(1,-14,1,0)
				Lbl.Font = Enum.Font.Gotham
				Lbl.Text = labelText
				Lbl.TextColor3 = Color3.fromRGB(68,68,68)
				Lbl.TextSize = 11
				Lbl.TextXAlignment = Enum.TextXAlignment.Left
				Lbl.Parent = f

				Resize()
				local Funcs = {}
				function Funcs:UpdateLabel(t) Lbl.Text = t end
				return Funcs
			end

			function Elements:NewDropdown(dropName, dropInfo, list, callback)
				dropName = dropName or "Dropdown"
				list = list or {}
				callback = callback or function() end
				local opened = false

				local Wrap = Frame({
					Alpha = 1,
					Size = UDim2.new(1,0,0,40),
					Clip = true,
					Parent = ContentHolder,
				})

				local WrapLL = Instance.new("UIListLayout")
				WrapLL.SortOrder = Enum.SortOrder.LayoutOrder
				WrapLL.Padding = UDim.new(0,4)
				WrapLL.Parent = Wrap

				local Header = Frame({
					Color = T.El,
					Size = UDim2.new(1,0,0,40),
					Parent = Wrap,
				})
				Header.LayoutOrder = 0
				Corner(Header, 12)
				local hStroke = Stroke(Header, Color3.fromRGB(255,255,255), 0.94)

				local HLbl = Instance.new("TextLabel")
				HLbl.BackgroundTransparency = 1
				HLbl.Position = UDim2.new(0,14,0,0)
				HLbl.Size = UDim2.new(1,-40,1,0)
				HLbl.Font = Enum.Font.GothamMedium
				HLbl.Text = dropName
				HLbl.TextColor3 = T.Sub
				HLbl.TextSize = 12
				HLbl.TextXAlignment = Enum.TextXAlignment.Left
				HLbl.Parent = Header

				local Arrow = Instance.new("TextLabel")
				Arrow.BackgroundTransparency = 1
				Arrow.AnchorPoint = Vector2.new(1,0.5)
				Arrow.Position = UDim2.new(1,-14,0.5,0)
				Arrow.Size = UDim2.new(0,16,0,16)
				Arrow.Font = Enum.Font.GothamBold
				Arrow.Text = "v"
				Arrow.TextColor3 = Color3.fromRGB(68,68,68)
				Arrow.TextSize = 10
				Arrow.Parent = Header

				local HBtn = Instance.new("TextButton")
				HBtn.BackgroundTransparency = 1
				HBtn.BorderSizePixel = 0
				HBtn.Size = UDim2.new(1,0,1,0)
				HBtn.Text = ""
				HBtn.AutoButtonColor = false
				HBtn.ZIndex = 2
				HBtn.Parent = Header

				local OptsBox = Frame({
					Color = Color3.fromRGB(17,17,17),
					Size = UDim2.new(1,0,0,0),
					Clip = true,
					Parent = Wrap,
				})
				OptsBox.LayoutOrder = 1
				Corner(OptsBox, 12)
				Stroke(OptsBox, Color3.fromRGB(255,255,255), 0.90)

				local OptsLL = Instance.new("UIListLayout")
				OptsLL.SortOrder = Enum.SortOrder.LayoutOrder
				OptsLL.Parent = OptsBox

				local OptsPad = Instance.new("UIPadding")
				OptsPad.PaddingTop = UDim.new(0,4)
				OptsPad.PaddingBottom = UDim.new(0,4)
				OptsPad.Parent = OptsBox

				local function BuildOpts(opts)
					for _, c in ipairs(OptsBox:GetChildren()) do
						if c:IsA("TextButton") then c:Destroy() end
					end
					for _, opt in ipairs(opts) do
						local OBtn = Instance.new("TextButton")
						OBtn.BackgroundTransparency = 1
						OBtn.BackgroundColor3 = Color3.fromRGB(255,255,255)
						OBtn.BorderSizePixel = 0
						OBtn.Size = UDim2.new(1,0,0,30)
						OBtn.AutoButtonColor = false
						OBtn.Font = Enum.Font.Gotham
						OBtn.Text = opt
						OBtn.TextColor3 = Color3.fromRGB(102,102,102)
						OBtn.TextSize = 11
						OBtn.TextXAlignment = Enum.TextXAlignment.Left
						OBtn.ZIndex = 3
						OBtn.Parent = OptsBox

						local OP = Instance.new("UIPadding")
						OP.PaddingLeft = UDim.new(0,14)
						OP.Parent = OBtn

						OBtn.MouseEnter:Connect(function()
							Tween(OBtn, {BackgroundTransparency=0.95, TextColor3=T.Text}, 0.1)
						end)
						OBtn.MouseLeave:Connect(function()
							Tween(OBtn, {BackgroundTransparency=1, TextColor3=Color3.fromRGB(102,102,102)}, 0.1)
						end)
						OBtn.MouseButton1Click:Connect(function()
							HLbl.Text = opt
							callback(opt)
							opened = false
							Tween(OptsBox, {Size=UDim2.new(1,0,0,0)}, 0.16)
							Tween(Arrow, {Rotation=0}, 0.16)
							Wrap.Size = UDim2.new(1,0,0,40)
							Resize()
						end)
					end
				end

				BuildOpts(list)

				HBtn.MouseButton1Click:Connect(function()
					opened = not opened
					local oh = OptsLL.AbsoluteContentSize.Y + 8
					if opened then
						Tween(OptsBox, {Size=UDim2.new(1,0,0,oh)}, 0.18)
						Tween(Arrow, {Rotation=180}, 0.16)
						Wrap.Size = UDim2.new(1,0,0,40+4+oh)
					else
						Tween(OptsBox, {Size=UDim2.new(1,0,0,0)}, 0.15)
						Tween(Arrow, {Rotation=0}, 0.15)
						Wrap.Size = UDim2.new(1,0,0,40)
					end
					Resize()
				end)

				HBtn.MouseEnter:Connect(function()
					Tween(hStroke, {Transparency=0.87}, 0.1)
					Tween(HLbl, {TextColor3=Color3.fromRGB(190,190,190)}, 0.1)
				end)
				HBtn.MouseLeave:Connect(function()
					Tween(hStroke, {Transparency=0.94}, 0.1)
					Tween(HLbl, {TextColor3=T.Sub}, 0.1)
				end)

				Resize()
				local Funcs = {}
				function Funcs:Refresh(newList)
					BuildOpts(newList)
					opened = false
					OptsBox.Size = UDim2.new(1,0,0,0)
					Arrow.Rotation = 0
					Wrap.Size = UDim2.new(1,0,0,40)
					Resize()
				end
				return Funcs
			end

			Resize()
			return Elements
		end

		return Sections
	end

	return Tabs
end

return ChimiUI
