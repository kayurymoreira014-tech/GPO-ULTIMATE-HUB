--!strict
local Interface = {}

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui") :: PlayerGui

local COLORS = {
	Background = Color3.fromRGB(15, 23, 36),
	Sidebar = Color3.fromRGB(10, 15, 25),
	Header = Color3.fromRGB(8, 12, 20),
	GoldAccent = Color3.fromRGB(212, 175, 55),
	Text = Color3.fromRGB(240, 240, 240),
	ButtonOFF = Color3.fromRGB(180, 50, 50),
	ButtonON = Color3.fromRGB(45, 160, 85),
	ContainerBG = Color3.fromRGB(22, 32, 50)
}

function Interface.Build(Settings, AutomationManager, ModuleCallbacks)
	local existingGui = PlayerGui:FindFirstChild("GPO_Ultimate_Hub")
	if existingGui then existingGui:Destroy() end

	local ScreenGui = Instance.new("ScreenGui")
	ScreenGui.Name = "GPO_Ultimate_Hub"
	ScreenGui.ResetOnSpawn = false
	ScreenGui.Parent = PlayerGui

	local MainFrame = Instance.new("Frame")
	MainFrame.Size = UDim2.new(0, 720, 0, 440)
	MainFrame.Position = UDim2.new(0.5, -360, 0.5, -220)
	MainFrame.BackgroundColor3 = COLORS.Background
	MainFrame.BorderSizePixel = 0
	MainFrame.Active = true
	MainFrame.Draggable = true
	MainFrame.Parent = ScreenGui

	local UICornerMain = Instance.new("UICorner")
	UICornerMain.CornerRadius = UDim.new(0, 8)
	UICornerMain.Parent = MainFrame

	local UIStrokeMain = Instance.new("UIStroke")
	UIStrokeMain.Color = COLORS.GoldAccent
	UIStrokeMain.Thickness = 2
	UIStrokeMain.Parent = MainFrame

	-- Top Bar
	local TopBar = Instance.new("Frame")
	TopBar.Size = UDim2.new(1, 0, 0, 40)
	TopBar.BackgroundColor3 = COLORS.Header
	TopBar.BorderSizePixel = 0
	TopBar.Parent = MainFrame

	local TitleLabel = Instance.new("TextLabel")
	TitleLabel.Size = UDim2.new(0, 300, 1, 0)
	TitleLabel.Position = UDim2.new(0, 15, 0, 0)
	TitleLabel.BackgroundTransparency = 1
	TitleLabel.Text = "⚓ GPO ULTIMATE HUB"
	TitleLabel.TextColor3 = COLORS.GoldAccent
	TitleLabel.TextSize = 18
	TitleLabel.Font = Enum.Font.FredokaOne
	TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
	TitleLabel.Parent = TopBar

	-- Notificações
	local NotificationContainer = Instance.new("Frame")
	NotificationContainer.Size = UDim2.new(0, 250, 0, 150)
	NotificationContainer.Position = UDim2.new(1, -260, 1, -160)
	NotificationContainer.BackgroundTransparency = 1
	NotificationContainer.Parent = ScreenGui

	local function SendNotification(title: string, message: string)
		local Toast = Instance.new("Frame")
		Toast.Size = UDim2.new(1, 0, 0, 45)
		Toast.BackgroundColor3 = COLORS.ContainerBG
		Toast.BorderSizePixel = 0
		Toast.Parent = NotificationContainer

		local ToastCorner = Instance.new("UICorner")
		ToastCorner.CornerRadius = UDim.new(0, 6)
		ToastCorner.Parent = Toast

		local ToastStroke = Instance.new("UIStroke")
		ToastStroke.Color = COLORS.GoldAccent
		ToastStroke.Thickness = 1
		ToastStroke.Parent = Toast

		local ToastText = Instance.new("TextLabel")
		ToastText.Size = UDim2.new(1, -10, 1, 0)
		ToastText.Position = UDim2.new(0, 5, 0, 0)
		ToastText.BackgroundTransparency = 1
		ToastText.Text = string.format("[%s]: %s", title, message)
		ToastText.TextColor3 = COLORS.Text
		ToastText.TextSize = 12
		ToastText.Font = Enum.Font.SourceSansBold
		ToastText.TextWrapped = true
		ToastText.Parent = Toast

		task.delay(3, function() Toast:Destroy() end)
	end

	-- Sidebar e Abas
	local Sidebar = Instance.new("Frame")
	Sidebar.Size = UDim2.new(0, 160, 1, -40)
	Sidebar.Position = UDim2.new(0, 0, 0, 40)
	Sidebar.BackgroundColor3 = COLORS.Sidebar
	Sidebar.BorderSizePixel = 0
	Sidebar.Parent = MainFrame

	local UIListLayoutSide = Instance.new("UIListLayout")
	UIListLayoutSide.Padding = UDim.new(0, 5)
	UIListLayoutSide.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayoutSide.Parent = Sidebar

	local ContentFrame = Instance.new("Frame")
	ContentFrame.Size = UDim2.new(1, -160, 1, -40)
	ContentFrame.Position = UDim2.new(0, 160, 0, 40)
	ContentFrame.BackgroundTransparency = 1
	ContentFrame.Parent = MainFrame

	local pages: { [string]: ScrollingFrame } = {}

	local function CreateCategoryPage(categoryName: string): ScrollingFrame
		local Page = Instance.new("ScrollingFrame")
		Page.Name = categoryName .. "Page"
		Page.Size = UDim2.new(1, -20, 1, -20)
		Page.Position = UDim2.new(0, 10, 0, 10)
		Page.BackgroundTransparency = 1
		Page.Visible = false
		Page.ScrollBarThickness = 4
		Page.CanvasSize = UDim2.new(0, 0, 2, 0)
		Page.Parent = ContentFrame

		local Grid = Instance.new("UIGridLayout")
		Grid.CellSize = UDim2.new(0, 250, 0, 50)
		Grid.CellPadding = UDim2.new(0, 10, 0, 10)
		Grid.SortOrder = Enum.SortOrder.LayoutOrder
		Grid.Parent = Page

		pages[categoryName] = Page
		return Page
	end

	local function AddToggleButton(categoryName: string, featureName: string, taskKey: string)
		local Page = pages[categoryName]
		if not Page then return end

		local Card = Instance.new("Frame")
		Card.BackgroundColor3 = COLORS.ContainerBG
		Card.Parent = Page

		local UICornerCard = Instance.new("UICorner")
		UICornerCard.CornerRadius = UDim.new(0, 6)
		UICornerCard.Parent = Card

		local Label = Instance.new("TextLabel")
		Label.Size = UDim2.new(0, 140, 1, 0)
		Label.Position = UDim2.new(0, 10, 0, 0)
		Label.BackgroundTransparency = 1
		Label.Text = featureName
		Label.TextColor3 = COLORS.Text
		Label.TextSize = 14
		Label.Font = Enum.Font.SourceSansBold
		Label.TextXAlignment = Enum.TextXAlignment.Left
		Label.Parent = Card

		local ToggleBtn = Instance.new("TextButton")
		ToggleBtn.Size = UDim2.new(0, 80, 0, 30)
		ToggleBtn.Position = UDim2.new(1, -90, 0.5, -15)
		ToggleBtn.BackgroundColor3 = COLORS.ButtonOFF
		ToggleBtn.Text = "OFF"
		ToggleBtn.TextColor3 = COLORS.Text
		ToggleBtn.Font = Enum.Font.FredokaOne
		ToggleBtn.TextSize = 13
		ToggleBtn.Parent = Card

		local UICornerBtn = Instance.new("UICorner")
		UICornerBtn.CornerRadius = UDim.new(0, 4)
		UICornerBtn.Parent = ToggleBtn

		ToggleBtn.MouseButton1Click:Connect(function()
			local isNowActive = Settings.Toggle(taskKey)
			if isNowActive then
				ToggleBtn.BackgroundColor3 = COLORS.ButtonON
				ToggleBtn.Text = "ON"
				AutomationManager.StartTask(taskKey)
				SendNotification(featureName, "Módulo ATIVADO.")
			else
				ToggleBtn.BackgroundColor3 = COLORS.ButtonOFF
				ToggleBtn.Text = "OFF"
				AutomationManager.StopTask(taskKey)
				SendNotification(featureName, "Módulo DESATIVADO.")
			end
		end)
	end

	local categories = {"Bosses", "Missions", "Activities", "Events", "Abilities", "Sea Events"}
	for _, catName in ipairs(categories) do
		CreateCategoryPage(catName)

		local NavButton = Instance.new("TextButton")
		NavButton.Size = UDim2.new(1, 0, 0, 35)
		NavButton.BackgroundColor3 = COLORS.ContainerBG
		NavButton.Text = catName
		NavButton.TextColor3 = COLORS.Text
		NavButton.Font = Enum.Font.SourceSansBold
		NavButton.TextSize = 14
		NavButton.Parent = Sidebar

		local UICornerNav = Instance.new("UICorner")
		UICornerNav.CornerRadius = UDim.new(0, 6)
		UICornerNav.Parent = NavButton

		NavButton.MouseButton1Click:Connect(function()
			for pageName, pageFrame in pairs(pages) do
				pageFrame.Visible = (pageName == catName)
			end
		end)
	end

	pages["Bosses"].Visible = true

	-- Populando elementos
	AddToggleButton("Bosses", "Auto Kaido", "AutoKaido")
	AddToggleButton("Bosses", "Auto Juzo", "AutoJuzo")
	AddToggleButton("Bosses", "Auto Ba'al", "AutoBaal")
	AddToggleButton("Bosses", "Auto Mihawk", "AutoMihawk")
	AddToggleButton("Bosses", "Auto Roger", "AutoRoger")

	AddToggleButton("Missions", "Auto Bounty", "AutoBounty")

	AddToggleButton("Activities", "Auto Fish", "AutoFish")
	AddToggleButton("Activities", "Auto Merchant", "AutoMerchant")

	AddToggleButton("Events", "Auto Halloween", "AutoHalloween")

	AddToggleButton("Abilities", "Auto Haki", "AutoHaki")
	AddToggleButton("Abilities", "Auto Buso", "AutoBuso")

	AddToggleButton("Sea Events", "Auto Kraken", "AutoKraken")
	AddToggleButton("Sea Events", "Auto Sea Beast", "AutoSeaBeast")

	SendNotification("GPO Hub", "Interface remota carregada com sucesso!")
end

return Interface
