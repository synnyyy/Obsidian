local cloneref = (cloneref or clonereference or function(instance: any)
	return instance
end)
local getgenv = getgenv or function()
	return {}
end
local setclipboard = setclipboard or nil

--// Services
local CoreGui: CoreGui = cloneref(game:GetService("CoreGui"))
local Players: Players = cloneref(game:GetService("Players"))
local RunService: RunService = cloneref(game:GetService("RunService"))
local SoundService: SoundService = cloneref(game:GetService("SoundService"))
local UserInputService: UserInputService = cloneref(game:GetService("UserInputService"))
local TextService: TextService = cloneref(game:GetService("TextService"))
local Teams: Teams = cloneref(game:GetService("Teams"))
local TweenService: TweenService = cloneref(game:GetService("TweenService"))

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

local Labels = {}
local Buttons = {}
local Toggles = {}
local Options = {}

--// Modules
local IconManager

--// Icons
local CheckIcon
local ArrowIcon
local ResizeIcon
local KeyIcon 

--// Module
local Library = {
	--// Web interface
	ModulesUrl = "",
	AssetsUrl = "",

	--// Files
	AssetsFolder = "BozoAssets",

	LocalPlayer = LocalPlayer,
	DevicePlatform = nil,
	IsMobile = false,
	IsStudio = RunService:IsStudio(),

	ScreenGui = nil,
	WatermarksFrame = nil,

	ActiveTab = nil,
	Tabs = {},

	--// Keybinds
	KeybindFrame = nil,
	KeybindContainer = nil,
	KeybindToggles = {},

	Notifications = {},

	ToggleKeybind = Enum.KeyCode.RightControl,

	--// Tween styles
	TweenInfo = TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
	NotifyTweenInfo = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),

	Toggled = true,
	Unloaded = false,

	Labels = Labels,
	Buttons = Buttons,
	Toggles = Toggles,
	Options = Options,

	NotifySide = "Left",
	ShowCustomCursor = true,
	ForceCheckbox = isfile("RiftAssets/ForceCheckboxes.txt"),
	ShowToggleFrameInKeybinds = true,
	NotifyOnError = true,

	CantDragForced = false,

	Signals = {},
	UnloadSignals = {},

	MinSize = Vector2.new(480, 360),
	DPIScale = 1,
	CornerRadius = 4,

	IsLightTheme = false,
	Scheme = {
		BackgroundColor = Color3.fromRGB(18, 12, 12),  
		MainColor = Color3.fromRGB(23, 17, 17),  
		AccentColor = Color3.fromRGB(220, 85, 30),  
		OutlineColor = Color3.fromRGB(35, 25, 25),  
		FontColor = Color3.new(0.92, 0.92, 0.92),  
		Font = Font.fromEnum(Enum.Font.Code),  
		SecondaryColor = Color3.fromRGB(40, 30, 30),  
		TertiaryColor = Color3.fromRGB(55, 40, 40),         

		Red = Color3.fromRGB(255, 50, 50),
		Dark = Color3.new(0, 0, 0),
		White = Color3.new(1, 1, 1),
	},

	Registry = {},
	DPIRegistry = {},
}

local Templates = {
	--// UI \\-
	Frame = {
		BorderSizePixel = 0,
	},
	ImageLabel = {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
	},
	ImageButton = {
		AutoButtonColor = false,
		BorderSizePixel = 0,
	},
	ScrollingFrame = {
		BorderSizePixel = 0,
	},
	TextLabel = {
		BorderSizePixel = 0,
		FontFace = "Font",
		RichText = true,
		TextColor3 = "FontColor",
	},
	TextButton = {
		AutoButtonColor = false,
		BorderSizePixel = 0,
		FontFace = "Font",
		RichText = true,
		TextColor3 = "FontColor",
	},
	TextBox = {
		BorderSizePixel = 0,
		FontFace = "Font",
		PlaceholderColor3 = function()
			local H, S, V = Library.Scheme.FontColor:ToHSV()
			return Color3.fromHSV(H, S, V / 2)
		end,
		Text = "",
		TextColor3 = "FontColor",
	},
	UIListLayout = {
		SortOrder = Enum.SortOrder.LayoutOrder,
	},
	UIStroke = {
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
	},

	--// Library \\--
	Content = {
		FillDirection = Enum.FillDirection.Vertical,
		HorizontalAlignment = Enum.HorizontalAlignment.Center,
		VerticalAlignment = Enum.VerticalAlignment.Center,
		Padding = UDim.new(0, 6),
		Lines = {}
	},
	Window = {
		Title = "No Title",
		Footer = "No Footer",
		Position = UDim2.fromOffset(6, 6),
		Size = UDim2.fromOffset(720, 600),
		IconSize = UDim2.fromOffset(30, 30),
		AutoShow = true,
		Center = true,
		Resizable = true,
		CornerRadius = 4,
		NotifySide = "Left",
		ShowCustomCursor = true,
		Font = Enum.Font.Code,
		ToggleKeybind = Enum.KeyCode.RightControl,
		ZIndex = 1,
	},
	LoaderWindow = {
		Title = "No Title",
		Footer = "No Footer",
		Position = UDim2.fromScale(0.5, 0.5),
		AnchorPoint = Vector2.new(0.5, 0.5),
		Size = UDim2.fromOffset(450, 230),
		IconSize = UDim2.fromOffset(30, 30),
		AutoShow = true,
		Center = true,
		Resizable = true,
		FillScreen = true,
		CornerRadius = 4,
		NotifySide = "Left",
		ShowCustomCursor = true,
		Font = Enum.Font.Code,
		ToggleKeybind = Enum.KeyCode.RightControl,
		ZIndex = 2,
	},
	WarningBox = {
		BackgroundColor = Color3.fromRGB(127, 0, 0),
		BorderColor = Color3.fromRGB(255, 50, 50),
	},
	Toggle = {
		Text = "Toggle",
		Default = false,

		Callback = function() end,
		Changed = function() end,

		Risky = false,
		Disabled = false,
		Visible = true,
	},
	Input = {
		Text = "Input",
		Default = "",
		Finished = false,
		Numeric = false,
		ClearTextOnFocus = true,
		Placeholder = "",
		AllowEmpty = true,
		EmptyReset = "---",

		Callback = function() end,
		Changed = function() end,

		Disabled = false,
		Visible = true,
	},
	Slider = {
		Text = "Slider",
		Default = 0,
		Min = 0,
		Max = 100,
		Rounding = 0,

		Prefix = "",
		Suffix = "",

		Callback = function() end,
		Changed = function() end,

		Disabled = false,
		Visible = true,
	},
	Image = {
		Image = 0,
		Size = UDim2.fromScale(1, 1),
		AspectType = Enum.AspectType.ScaleWithParentSize,
	},
	Dropdown = {
		Values = {},
		DisabledValues = {},
		Multi = false,
		AllowNull = false,
		MaxVisibleDropdownItems = 8,

		Callback = function() end,
		Changed = function() end,

		Disabled = false,
		Visible = true,
	},

	--// Addons \\-
	KeyPicker = {
		Text = "KeyPicker",
		Default = "None",
		Mode = "Toggle",
		Modes = { "Always", "Toggle", "Hold" },
		SyncToggleState = false,

		Callback = function() end,
		ChangedCallback = function() end,
		Changed = function() end,
		Clicked = function() end,
	},
	ColorPicker = {
		Default = Color3.new(1, 1, 1),

		Callback = function() end,
		Changed = function() end,
	},
}

local Places = {
	Bottom = { 0, 1 },
	Right = { 1, 0 },
}
local Sizes = {
	Left = { 0.5, 1 },
	Right = { 0.5, 1 },
}

if Library.IsStudio then 
	if UserInputService.TouchEnabled and not UserInputService.MouseEnabled then
		Library.IsMobile = true
		Library.MinSize = Vector2.new(480, 240)
	else
		Library.IsMobile = false
		Library.MinSize = Vector2.new(480, 360)
	end
else
	pcall(function()
		Library.DevicePlatform = UserInputService:GetPlatform()
	end)
	Library.IsMobile = (Library.DevicePlatform == Enum.Platform.Android or Library.DevicePlatform == Enum.Platform.IOS)
	Library.MinSize = Library.IsMobile and Vector2.new(480, 240) or Vector2.new(480, 360)
end

function Library:GetUserThumbnailAsync(UserId, ThumbnailType)
	local ThumbnailSize = Enum.ThumbnailSize.Size180x180
	return Players:GetUserThumbnailAsync(UserId, ThumbnailType, ThumbnailSize)
end

function Library:ReportError(Message: string)
	if not self.NotifyOnError then return end
	self:Notify(Message)
end

--// Asset interface
function Library:SetAssetsFolder(Path)
	self.AssetsFolder = Path
end
function Library:SetAssetsUrl(Url)
	self.AssetsUrl = Url
end
function Library:SetModulesUrl(Url)
	self.ModulesUrl = Url
end

function Library:GetAssetContent(Name)
	local Path = `{self.AssetsUrl}/{Name}`
	return game:HttpGet(Path)
end

function Library:CheckAssetsFolder()
	--// Ignore check for Studio
	if self.IsStudio then return end

	local FolderName = self.AssetsFolder
	if isfolder(FolderName) then return end

	makefolder(FolderName)
end

function Library:DownloadAsset(Name)
	local FolderName = self.AssetsFolder
	local Path = `{FolderName}/{Name}`

	local Content = self:GetAssetContent(Name)
	writefile(Path, Content)
end

function Library:GetAsset(Name)
	--// Return empty content for Studio
	if self.IsStudio then
		return "rbxassetid://0"
	end

	local FolderName = self.AssetsFolder
	local Path = `{FolderName}/{Name}`

	--// Download asset
	if not isfile(Path) then
		self:DownloadAsset(Name)
	end
	
	--// getcustomasset
	local Success, Response = pcall(getcustomasset, Path)
	
	--// Error reporter
	if not Success then
		self:ReportError(`Unable to read: {Path}\n{Response}`)
		return "rbxassetid://0" 
	end
	
	return Response
end

function Library:GetModule(Name)
	if self.IsStudio then
		return require(script[Name])
	end

	--// Download from Repo
	local Path = `{self.ModulesUrl}/{Name}.lua`
	local Content = game:HttpGet(Path)

	return loadstring(Content, Name)()
end

function Library:LoadIconManager()
	IconManager = Library:GetModule("IconManager")

	--// Import custom Icon Sprit sheet into the IconManger
	if not Library.IsStudio then
		IconManager:SetIconSpriteSheet(
			Library:GetAsset("IconSprite.png")
		)
	end
	
	--// Fetch icons
	CheckIcon = Library:GetIcon("check")
	ArrowIcon = Library:GetIcon("chevron-up")
	ResizeIcon = Library:GetIcon("move-diagonal-2")
	KeyIcon = Library:GetIcon("key")
end

function Library:GetIcon(IconName: string)
	return IconManager:GetAsset(IconName)
end

function Library:LoadModules()
	self:LoadIconManager()
end

--// Basic Functions \\--
local function ApplyDPIScale(Dimension, ExtraOffset)
	local DPIScale = Library.DPIScale
	if not Dimension then return end
	
	if typeof(Dimension) == "UDim" then
		return UDim.new(Dimension.Scale, Dimension.Offset * DPIScale)
	end

	if ExtraOffset then
		return UDim2.new(
			Dimension.X.Scale,
			(Dimension.X.Offset * DPIScale) + (ExtraOffset[1] * DPIScale),
			Dimension.Y.Scale,
			(Dimension.Y.Offset * DPIScale) + (ExtraOffset[2] * DPIScale)
		)
	end

	return UDim2.new(
		Dimension.X.Scale,
		Dimension.X.Offset * DPIScale,
		Dimension.Y.Scale,
		Dimension.Y.Offset * DPIScale
	)
end

local function MultiDisconnect(Signals)
	for Index = #Signals, 1, -1 do
		local Connection = table.remove(Signals, Index)
		Connection:Disconnect()
	end
end

local function ApplyTextScale(TextSize)
	return TextSize * Library.DPIScale
end

local function ApplyRichTextTheme(Text: string): string
	local Scheme = Library.Scheme
		
	for Key, Color: Color3 in next, Scheme do
		if typeof(Color) ~= "Color3" then continue end
		local Hex = Color:ToHex()
		Text = Text:gsub(`%%{Key}%%`, `#{Hex}`)
	end
	
	return Text
end

local function WaitForEvent(Event, Timeout, Condition)
	local Bindable = Instance.new("BindableEvent")
	local Connection = Event:Once(function(...)
		local Check = not Condition
		if typeof(Condition) == "function" then
			Check = Condition(...) 
		end
		
		Bindable:Fire(Check)
	end)
	
	task.delay(Timeout, function()
		Connection:Disconnect()
		Bindable:Fire(false)
	end)
	
	return Bindable.Event:Wait()
end

local function IsClickInput(Input: InputObject, IncludeM2: boolean?)
	local Types = {
		Enum.UserInputType.MouseButton1,
		Enum.UserInputType.MouseButton2,
		Enum.UserInputType.Touch,
	} 
	
	--// Only allow begin events
	if Input.UserInputState ~= Enum.UserInputState.Begin then
		return
	end
	
	return table.find(Types, Input.UserInputType)
end

local function IsHoverInput(Input: InputObject)
	local Types = {
		Enum.UserInputType.MouseMovement,
		Enum.UserInputType.Touch,
	}
	
	if Input.UserInputState ~= Enum.UserInputState.Change then
		return
	end
	
	return table.find(Types, Input.UserInputType)
end

local function GetTableSize(Table: { [any]: any })
	local Size = 0
	for _ in next, Table do
		Size += 1
	end

	return Size
end

local function StopTween(Tween: TweenBase)
	if not (Tween and Tween.PlaybackState == Enum.PlaybackState.Playing) then
		return
	end

	Tween:Cancel()
end

local function GetPlayers(ExcludeLocalPlayer: boolean?)
	local PlayerList = Players:GetPlayers()

	if ExcludeLocalPlayer then
		local Idx = table.find(PlayerList, LocalPlayer)
		if Idx then
			table.remove(PlayerList, Idx)
		end
	end

	table.sort(PlayerList, function(Player1, Player2)
		return Player1.Name:lower() < Player2.Name:lower()
	end)

	return PlayerList
end

local function GetTeams()
	local TeamList = Teams:GetTeams()

	table.sort(TeamList, function(Team1, Team2)
		return Team1.Name:lower() < Team2.Name:lower()
	end)

	return TeamList
end

function Library:UpdateKeybindFrame()
	local KeybindFrame = Library.KeybindFrame
	local KeybindToggles = Library.KeybindToggles
	
	--// Check if the Keybind frame exists
	if not Library.KeybindFrame then return end
	
	local XSize = 0
	for _, KeybindToggle in next, KeybindToggles do
		if not KeybindToggle.Holder.Visible then
			continue
		end

		local FullSize = KeybindToggle.Label.Size.X.Offset + KeybindToggle.Label.Position.X.Offset
		if FullSize > XSize then
			XSize = FullSize
		end
	end

	Library.KeybindFrame.Size = UDim2.fromOffset(XSize + 18 * Library.DPIScale, 0)
end

function Library:AddToRegistry(Instance, Properties)
	Library.Registry[Instance] = Properties
end

function Library:RemoveFromRegistry(Instance)
	Library.Registry[Instance] = nil
end

function Library:UpdateColorsUsingRegistry()
	local Registry = Library.Registry
	local Scheme = Library.Scheme
	
	for Object: Instance, Properties in next, Registry do
		for Property, ColorIdx in next, Properties do
			if typeof(ColorIdx) == "string" then
				Object[Property] = Scheme[ColorIdx]
			elseif typeof(ColorIdx) == "function" then
				Object[Property] = ColorIdx()
			end
		end
	end
end

function Library:UpdateDPI(Object: Instance, Properties)
	local DPIRegistry = Library.DPIRegistry
	local Info = DPIRegistry[Object]
	
	if not Info then return end

	for Property, Value in next, Properties do
		Info[Property] = Value
	end
end

function Library:SetDPIScale(DPIScale: number)
	local DPIRegistry = Library.DPIRegistry
	
	Library.DPIScale = DPIScale / 100
	Library.MinSize *= Library.DPIScale

	for Object: Instance, Properties in next, DPIRegistry do
		for Property, Value in next, Properties do
			if Property == "DPIExclude" or Property == "DPIOffset" then
				continue
			end
			
			local Scaled
			if Property == "TextSize" then
				Scaled = ApplyTextScale(Value)
			else
				Scaled = ApplyDPIScale(Value, Properties["DPIOffset"][Property])
			end
			
			if not Scaled then continue end
			Object[Property] = Scaled 
		end
	end

	for _, Option in next, Options do
		if Option.Type == "Dropdown" then
			Option:RecalculateListSize()
		elseif Option.Type == "KeyPicker" then
			Option:Update()
		end
	end

	Library:UpdateKeybindFrame()
	for _, Notification in pairs(Library.Notifications) do
		Notification:Resize()
	end
end

function Library:GiveSignal(Connection: RBXScriptConnection)
	table.insert(Library.Signals, Connection)
	return Connection
end

function Library:Validate(Table: { [string]: any }, Template: { [string]: any }): { [string]: any }
	if typeof(Table) ~= "table" then
		return Template
	end

	for k, v in pairs(Template) do
		if typeof(v) == "table" then
			Table[k] = Library:Validate(Table[k], v)
		elseif Table[k] == nil then
			Table[k] = v
		end
	end

	return Table
end

--// Creator Functions \\--
local function FillInstance(Table: { [string]: any }, Object: GuiObject)
	local Scheme = Library.Scheme
	local Registry = Library.Registry
	local DPIRegistry  = Library.DPIRegistry
	
	--// Object registry data
	local ThemeProperties = Registry[Object] or {}
	local DPIProperties = DPIRegistry[Object] or {}

	local DPIExclude = DPIProperties["DPIExclude"] or Table["DPIExclude"] or {}
	local DPIOffset = DPIProperties["DPIOffset"] or Table["DPIOffset"] or {}

	for Key, Value in next, Table do
		--// Exclude DPI
		if Key == "DPIExclude" or Key == "DPIOffset" then
			continue
		end
		
		if ThemeProperties[Key] then
			ThemeProperties[Key] = nil
		end
		
		--// Scheme or Value function
		local SchemeValue = Scheme[Value]
		if SchemeValue or typeof(Value) == "function" then
			ThemeProperties[Key] = Value
			Object[Key] = Scheme[Value] or Value()
			continue
		end

		if not DPIExclude[Key] then
			if Key == "Position" or Key == "Size" or Key:match("Padding") then
				DPIProperties[Key] = Value
				Value = ApplyDPIScale(Value, DPIOffset[Key])
			elseif Key == "TextSize" then
				DPIProperties[Key] = Value
				Value = ApplyTextScale(Value)
			elseif Key == "Text"and Object.RichText then
				Value = ApplyRichTextTheme(Value)
			end
		end

		Object[Key] = Value
	end

	if GetTableSize(ThemeProperties) > 0 then
		Registry[Object] = ThemeProperties
	end
	if GetTableSize(DPIProperties) > 0 then
		DPIProperties["DPIExclude"] = DPIExclude
		DPIProperties["DPIOffset"] = DPIOffset
		DPIRegistry[Object] = DPIProperties
	end
end

local function New(ClassName: string, Properties: { [string]: any }): Instance
	local Object = Instance.new(ClassName)

	if Templates[ClassName] then
		FillInstance(Templates[ClassName], Object)
	end
	FillInstance(Properties, Object)
	
	--// ZIndex fix
	if Properties["Parent"] and not Properties["ZIndex"] then
		pcall(function()
			Object.ZIndex = Properties.Parent.ZIndex
		end)
	end

	return Object
end

function Library:CreateWatermarkContainer()
	local ScreenGui = self.ScreenGui

	local WatermarksFrame = New("Frame", {
		Parent = ScreenGui,
		Position = UDim2.new(0, 6, 1, -6),
		Size = UDim2.new(1, 0, 0, 50),
		AnchorPoint = Vector2.new(0,1),
		BackgroundTransparency = 1,
		Visible = not self.IsMobile
	})
	New("UIListLayout", {
		Parent = WatermarksFrame,
		Padding = UDim.new(0, 6),
		FillDirection = Enum.FillDirection.Horizontal,
		HorizontalAlignment = Enum.HorizontalAlignment.Left,
		VerticalAlignment = Enum.VerticalAlignment.Bottom,
	})

	return WatermarksFrame
end

function Library:SetWatermarksVisible(Visible)
	local Container = Library.WatermarksFrame 
	Container.Visible = Visible
end

local function ParentUI(UI: Instance)
	if not pcall(function()
			UI.Parent = CoreGui
		end) then
		UI.Parent = Library.LocalPlayer:WaitForChild("PlayerGui")
	end
end

--// Main instances
local ScreenGui = New("ScreenGui", {
	DisplayOrder = 999,
	ResetOnSpawn = false,
	SafeAreaCompatibility = Enum.SafeAreaCompatibility.None,
	ScreenInsets = Enum.ScreenInsets.None
})
ParentUI(ScreenGui)
ScreenGui.DescendantRemoving:Connect(function(Instance)
	Library:RemoveFromRegistry(Instance)
	Library.DPIRegistry[Instance] = nil
end)

Library.ScreenGui = ScreenGui
Library.WatermarksFrame = Library:CreateWatermarkContainer()

local ModalElement = New("TextButton", {
	BackgroundTransparency = 1,
	Modal = false,
	Size = UDim2.fromScale(0, 0),
	Text = "",
	ZIndex = -999,
	Parent = ScreenGui,
})

--// Cursor
local Cursor = New("Frame", {
	AnchorPoint = Vector2.new(0.5, 0.5),
	BackgroundColor3 = "White",
	Size = UDim2.fromOffset(9, 1),
	Visible = false,
	ZIndex = 999,
	Parent = ScreenGui,
})
New("Frame", {
	AnchorPoint = Vector2.new(0.5, 0.5),
	BackgroundColor3 = "Dark",
	Position = UDim2.fromScale(0.5, 0.5),
	Size = UDim2.new(1, 2, 1, 2),
	ZIndex = 998,
	Parent = Cursor,
})

local CursorV = New("Frame", {
	AnchorPoint = Vector2.new(0.5, 0.5),
	BackgroundColor3 = "White",
	Position = UDim2.fromScale(0.5, 0.5),
	Size = UDim2.fromOffset(1, 9),
	Parent = Cursor,
})
New("Frame", {
	AnchorPoint = Vector2.new(0.5, 0.5),
	BackgroundColor3 = "Dark",
	Position = UDim2.fromScale(0.5, 0.5),
	Size = UDim2.new(1, 2, 1, 2),
	ZIndex = 998,
	Parent = CursorV,
})

--// Notification
local NotificationArea = New("Frame", {
	AnchorPoint = Vector2.new(1, 0),
	BackgroundTransparency = 1,
	Position = UDim2.new(1, -6, 0, 6),
	Size = UDim2.new(0, 300, 1, -6),
	Parent = ScreenGui,
})
local NotificationList = New("UIListLayout", {
	HorizontalAlignment = Enum.HorizontalAlignment.Right,
	Padding = UDim.new(0, 6),
	Parent = NotificationArea,
})

--// Lib Functions \\--
function Library:GetBetterColor(Color: Color3, Add: number): Color3
	Add = Add * (Library.IsLightTheme and -4 or 2)
	return Color3.fromRGB(
		math.clamp(Color.R * 255 + Add, 0, 255),
		math.clamp(Color.G * 255 + Add, 0, 255),
		math.clamp(Color.B * 255 + Add, 0, 255)
	)
end

function Library:GetDarkerColor(Color: Color3): Color3
	local H, S, V = Color:ToHSV()
	return Color3.fromHSV(H, S, V / 2)
end

function Library:GetKeyString(KeyCode: Enum.KeyCode)
	if KeyCode.EnumType == Enum.KeyCode and KeyCode.Value > 33 and KeyCode.Value < 127 then
		return string.char(KeyCode.Value)
	end

	return KeyCode.Name
end

function Library:GetTextBounds(Text: string, Font: Font, Size: number, Width: number?): (number, number)
	local Params = Instance.new("GetTextBoundsParams")
	Params.Text = Text
	Params.RichText = true
	Params.Font = Font
	Params.Size = Size
	Params.Width = Width or workspace.CurrentCamera.ViewportSize.X - 32

	local Bounds = TextService:GetTextBoundsAsync(Params)
	return Bounds.X, Bounds.Y
end

function Library:MouseIsOverFrame(Frame: GuiObject, Mouse: Vector2): boolean
	local AbsPos, AbsSize = Frame.AbsolutePosition, Frame.AbsoluteSize
	return Mouse.X >= AbsPos.X
		and Mouse.X <= AbsPos.X + AbsSize.X
		and Mouse.Y >= AbsPos.Y
		and Mouse.Y <= AbsPos.Y + AbsSize.Y
end

function Library:SafeCallback(Func: (...any) -> ...any, ...: any)
	if not Func then return end
	if typeof(Func) ~= "function" then return end
	
	if Library.IsStudio then
		return Func(...)
	end
	
	--// Pcall
	local Success, Response = pcall(Func, ...)
	if Success then
		return Response
	end

	local Traceback = debug.traceback():gsub("\n", " ")
	local _, i = Traceback:find(":%d+ ")
	Traceback = Traceback:sub(i + 1):gsub(" :", ":")
	
	--// Print error
	task.defer(error, Response .. " - " .. Traceback)
	
	self:ReportError(Response)
end

function Library:MakeDraggable(UI: GuiObject, DragFrame: GuiObject, IgnoreToggled: boolean?, IsMainWindow: boolean?)
	local StartPos
	local FramePos
	local Dragging = false
	local Changed
	DragFrame.InputBegan:Connect(function(Input: InputObject)
		if not IsClickInput(Input) or IsMainWindow and Library.CantDragForced then
			return
		end

		StartPos = Input.Position
		FramePos = UI.Position
		Dragging = true

		Changed = Input.Changed:Connect(function()
			if Input.UserInputState ~= Enum.UserInputState.End then
				return
			end

			Dragging = false
			if Changed and Changed.Connected then
				Changed:Disconnect()
				Changed = nil
			end
		end)
	end)
	Library:GiveSignal(UserInputService.InputChanged:Connect(function(Input: InputObject)
		if
			(not IgnoreToggled and not Library.Toggled)
			or (IsMainWindow and Library.CantDragForced)
			or not (ScreenGui and ScreenGui.Parent)
		then
			Dragging = false
			if Changed and Changed.Connected then
				Changed:Disconnect()
				Changed = nil
			end

			return
		end

		if Dragging and IsHoverInput(Input) then
			local Delta = Input.Position - StartPos
			UI.Position =
				UDim2.new(FramePos.X.Scale, FramePos.X.Offset + Delta.X, FramePos.Y.Scale, FramePos.Y.Offset + Delta.Y)
		end
	end))
end

function Library:MakeResizable(UI: GuiObject, DragFrame: GuiObject, Callback: () -> ()?)
	local StartPos
	local FrameSize
	local Dragging = false
	local Changed
	DragFrame.InputBegan:Connect(function(Input: InputObject)
		if not IsClickInput(Input) then
			return
		end

		StartPos = Input.Position
		FrameSize = UI.Size
		Dragging = true

		Changed = Input.Changed:Connect(function()
			if Input.UserInputState ~= Enum.UserInputState.End then
				return
			end

			Dragging = false
			if Changed and Changed.Connected then
				Changed:Disconnect()
				Changed = nil
			end
		end)
	end)
	Library:GiveSignal(UserInputService.InputChanged:Connect(function(Input: InputObject)
		if not UI.Visible or not (ScreenGui and ScreenGui.Parent) then
			Dragging = false
			if Changed and Changed.Connected then
				Changed:Disconnect()
				Changed = nil
			end

			return
		end

		if Dragging and IsHoverInput(Input) then
			local Delta = Input.Position - StartPos
			UI.Size = UDim2.new(
				FrameSize.X.Scale,
				math.clamp(FrameSize.X.Offset + Delta.X, Library.MinSize.X, math.huge),
				FrameSize.Y.Scale,
				math.clamp(FrameSize.Y.Offset + Delta.Y, Library.MinSize.Y, math.huge)
			)
			if Callback then
				Library:SafeCallback(Callback)
			end
		end
	end))
end

function Library:MakeCover(Holder: GuiObject, Place: string)
	local Pos = Places[Place] or { 0, 0 }
	local Size = Sizes[Place] or { 1, 0.5 }

	local Cover = New("Frame", {
		AnchorPoint = Vector2.new(Pos[1], Pos[2]),
		BackgroundColor3 = Holder.BackgroundColor3,
		Position = UDim2.fromScale(Pos[1], Pos[2]),
		Size = UDim2.fromScale(Size[1], Size[2]),
		Parent = Holder,
	})

	return Cover
end

function Library:MakeLine(Frame: GuiObject, Info)
	local Line = New("Frame", {
		AnchorPoint = Info.AnchorPoint or Vector2.zero,
		BackgroundColor3 = "OutlineColor",
		Position = Info.Position,
		Size = Info.Size,
		Parent = Frame,
	})

	return Line
end

function Library:MakeOutline(Frame: GuiObject, Corner: number?, ZIndex: number?, AutomaticSize)
	local Holder = New("Frame", {
		BackgroundColor3 = "Dark",
		Position = UDim2.fromOffset(-2, -2),
		Size = UDim2.new(1, 4, 1, 4),
		ZIndex = ZIndex,
		Parent = Frame,
		AutomaticSize = AutomaticSize and Enum.AutomaticSize.Y or Enum.AutomaticSize.None
	})

	local Outline = New("Frame", {
		BackgroundColor3 = "OutlineColor",
		Size = UDim2.new(1, 0, 1, 0),
		ZIndex = ZIndex,
		Parent = Holder,
	})

	New("UIPadding", {
		Parent = Holder,
		PaddingBottom = UDim.new(0, 1),
		PaddingTop = UDim.new(0, 1),
		PaddingRight = UDim.new(0, 1),
		PaddingLeft = UDim.new(0, 1),
	})

	New("UIPadding", {
		Parent = Outline,
		PaddingBottom = UDim.new(0, 1),
		PaddingTop = UDim.new(0, 1),
		PaddingRight = UDim.new(0, 1),
		PaddingLeft = UDim.new(0, 1),
	})

	if Corner and Corner > 0 then
		New("UICorner", {
			CornerRadius = UDim.new(0, Corner + 1),
			Parent = Holder,
		})
		New("UICorner", {
			CornerRadius = UDim.new(0, Corner),
			Parent = Outline,
		})
	end

	return Holder, Outline
end

function Library:AddDraggableButton(Text: string, Func)
	local Table = {}

	local Button = New("TextButton", {
		BackgroundColor3 = "BackgroundColor",
		Position = UDim2.fromOffset(6, 6),
		TextSize = 16,
		ZIndex = 10,
		Parent = ScreenGui,

		DPIExclude = {
			Position = true,
		},
	})
	
	Library:MakeOutline(Button, Library.CornerRadius, 9)
	Library:MakeDraggable(Button, Button, true)
	
	New("UICorner", {
		CornerRadius = UDim.new(0, Library.CornerRadius - 1),
		Parent = Button,
	})

	function Table:SetText(NewText: string)
		local X, Y = Library:GetTextBounds(NewText, Library.Scheme.Font, 16)

		Button.Text = NewText
		Button.Size = UDim2.fromOffset(X * Library.DPIScale * 2, Y * Library.DPIScale * 2)
		Library:UpdateDPI(Button, {
			Size = UDim2.fromOffset(X * 2, Y * 2),
		})
	end
	
	Table.Button = Button
	Table:SetText(Text)
	
	Button.MouseButton1Click:Connect(function()
		Library:SafeCallback(Func, Table)
	end)

	return Table
end

function Library:AddDraggableMenu(Name: string)
	local Background = Library:MakeOutline(ScreenGui, Library.CornerRadius, 10)
	Background.AutomaticSize = Enum.AutomaticSize.Y
	Background.Position = UDim2.fromOffset(6, 6)
	Background.Size = UDim2.fromOffset(0, 0)
	Library:UpdateDPI(Background, {
		Position = false,
		Size = false,
	})

	local Holder = New("Frame", {
		BackgroundColor3 = "BackgroundColor",
		Position = UDim2.fromOffset(1, 1),
		Size = UDim2.new(1, -2, 1, -2),
		Parent = Background,
	})
	New("UICorner", {
		CornerRadius = UDim.new(0, Library.CornerRadius - 1),
		Parent = Holder,
	})
	Library:MakeLine(Holder, {
		Position = UDim2.fromOffset(0, 34),
		Size = UDim2.new(1, 0, 0, 1),
	})

	local Label = New("TextLabel", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 34),
		Text = Name,
		TextSize = 15,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = Holder,
	})
	New("UIPadding", {
		PaddingLeft = UDim.new(0, 12),
		PaddingRight = UDim.new(0, 12),
		Parent = Label,
	})

	local Container = New("Frame", {
		BackgroundTransparency = 1,
		Position = UDim2.fromOffset(0, 35),
		Size = UDim2.new(1, 0, 1, -35),
		Parent = Holder,
	})
	New("UIListLayout", {
		Padding = UDim.new(0, 7),
		Parent = Container,
	})
	New("UIPadding", {
		PaddingBottom = UDim.new(0, 7),
		PaddingLeft = UDim.new(0, 7),
		PaddingRight = UDim.new(0, 7),
		PaddingTop = UDim.new(0, 7),
		Parent = Container,
	})

	Library:MakeDraggable(Background, Label, true)
	return Background, Container
end

--// Context Menu \\--
local CurrentMenu
function Library:AddContextMenu(
	Holder: GuiObject,
	Size: UDim2 | () -> (),
	Offset: { [number]: number } | () -> {},
	List: number?,
	ActiveCallback: (Active: boolean) -> ()?
)
	
	local Relative = ScreenGui.AbsolutePosition
	
	local Menu
	if List then
		Menu = New("ScrollingFrame", {
			AutomaticCanvasSize = List == 2 and Enum.AutomaticSize.Y or Enum.AutomaticSize.None,
			AutomaticSize = List == 1 and Enum.AutomaticSize.Y or Enum.AutomaticSize.None,
			BackgroundColor3 = "BackgroundColor",
			BorderColor3 = "OutlineColor",
			BorderSizePixel = 1,
			BottomImage = "rbxasset://textures/ui/Scroll/scroll-middle.png",
			TopImage = "rbxasset://textures/ui/Scroll/scroll-middle.png",
			CanvasSize = UDim2.fromOffset(0, 0),
			ScrollBarImageColor3 = "OutlineColor",
			ScrollBarThickness = List == 2 and 2 or 0,
			Size = typeof(Size) == "function" and Size() or Size,
			Visible = false,
			ZIndex = 10,
			Parent = ScreenGui,

			DPIExclude = {
				Position = true,
			},
		})
	else
		Menu = New("Frame", {
			BackgroundColor3 = "BackgroundColor",
			BorderColor3 = "OutlineColor",
			BorderSizePixel = 1,
			Size = typeof(Size) == "function" and Size() or Size,
			Visible = false,
			ZIndex = 10,
			Parent = ScreenGui,

			DPIExclude = {
				Position = true,
			},
		})
	end

	local Table = {
		Active = false,
		Holder = Holder,
		Menu = Menu,
		List = nil,
		Signal = nil,

		Size = Size,
	}

	if List then
		Table.List = New("UIListLayout", {
			Parent = Menu,
		})
	end
	
	function Table:Position()
		local BaseX = Holder.AbsolutePosition.X - Relative.X
		local BaseY = Holder.AbsolutePosition.Y - Relative.Y

		if typeof(Offset) == "function" then
			Menu.Position = UDim2.fromOffset(
				math.floor(BaseX + Offset()[1]),
				math.floor(BaseY + Offset()[2])
			)
		else
			Menu.Position = UDim2.fromOffset(
				math.floor(BaseX + Offset[1]),
				math.floor(BaseY + Offset[2])
			)
		end
	end

	function Table:Open()
		if CurrentMenu == Table then
			return
		elseif CurrentMenu then
			CurrentMenu:Close()
		end

		CurrentMenu = Table
		Table.Active = true
		
		Table:Position()
		if typeof(Table.Size) == "function" then
			Menu.Size = Table.Size()
		else
			Menu.Size = ApplyDPIScale(Table.Size)
		end
		if typeof(ActiveCallback) == "function" then
			Library:SafeCallback(ActiveCallback, true)
		end

		Menu.Visible = true

		Table.Signal = Holder:GetPropertyChangedSignal("AbsolutePosition"):Connect(function()
			Table:Position()
		end)
	end

	function Table:Close()
		if CurrentMenu ~= Table then
			return
		end
		Menu.Visible = false

		if Table.Signal then
			Table.Signal:Disconnect()
			Table.Signal = nil
		end
		Table.Active = false
		CurrentMenu = nil
		if typeof(ActiveCallback) == "function" then
			Library:SafeCallback(ActiveCallback, false)
		end
	end

	function Table:Toggle()
		if Table.Active then
			Table:Close()
		else
			Table:Open()
		end
	end

	function Table:SetSize(Size)
		Table.Size = Size
		Menu.Size = typeof(Size) == "function" and Size() or Size
	end

	return Table
end

Library:GiveSignal(UserInputService.InputBegan:Connect(function(Input: InputObject)
	if IsClickInput(Input, true) then
		local Location = Input.Position

		if
			CurrentMenu
			and not (
				Library:MouseIsOverFrame(CurrentMenu.Menu, Location)
					or Library:MouseIsOverFrame(CurrentMenu.Holder, Location)
			)
		then
			CurrentMenu:Close()
		end
	end
end))

--// Tooltip \\--
local TooltipLabel = New("TextLabel", {
	BackgroundColor3 = "BackgroundColor",
	BorderColor3 = "OutlineColor",
	BorderSizePixel = 1,
	TextSize = 14,
	TextWrapped = true,
	Visible = false,
	ZIndex = 20,
	Parent = ScreenGui,
})
TooltipLabel:GetPropertyChangedSignal("AbsolutePosition"):Connect(function()
	local X, Y = Library:GetTextBounds(
		TooltipLabel.Text,
		TooltipLabel.FontFace,
		TooltipLabel.TextSize,
		workspace.CurrentCamera.ViewportSize.X - TooltipLabel.AbsolutePosition.X - 4
	)

	TooltipLabel.Size = UDim2.fromOffset(X + 8 * Library.DPIScale, Y + 4 * Library.DPIScale)
	Library:UpdateDPI(TooltipLabel, {
		Size = UDim2.fromOffset(X, Y),
		DPIOffset = {
			Size = { 8, 4 },
		},
	})
end)

local CurrentHoverInstance
function Library:AddTooltip(InfoStr: string, DisabledInfoStr: string, HoverInstance: GuiObject)
	local TooltipTable = {
		Disabled = false,
		Hovering = false,
		Signals = {},
	}

	local function DoHover()
		if
			CurrentHoverInstance == HoverInstance
			or (CurrentMenu and Library:MouseIsOverFrame(CurrentMenu.Menu, Mouse))
			or (TooltipTable.Disabled and typeof(DisabledInfoStr) ~= "string")
			or (not TooltipTable.Disabled and typeof(InfoStr) ~= "string")
		then
			return
		end
		CurrentHoverInstance = HoverInstance

		TooltipLabel.Text = TooltipTable.Disabled and DisabledInfoStr or InfoStr
		TooltipLabel.Visible = true
	end

	local StepConnection = RunService.RenderStepped:Connect(function()
		if not Library.Toggled then return end
		if not TooltipLabel.Parent then return end
		if not Library:MouseIsOverFrame(HoverInstance, Mouse) then return end
		if (CurrentMenu and Library:MouseIsOverFrame(CurrentMenu.Menu, Mouse)) then return end
		
		local X, Y = Mouse.X, Mouse.Y 
		local Position = TooltipLabel.Parent.AbsolutePosition
		local Offset = Library.ShowCustomCursor and 8 or 14

		TooltipLabel.Position = UDim2.fromOffset(
			X - Position.X + Offset, 
			Y - Position.Y + Offset
		)
	end)
	
	table.insert(TooltipTable.Signals, StepConnection)
	table.insert(TooltipTable.Signals, HoverInstance.MouseEnter:Connect(DoHover))
	table.insert(TooltipTable.Signals, HoverInstance.MouseMoved:Connect(DoHover))
	table.insert(
		TooltipTable.Signals,
		HoverInstance.MouseLeave:Connect(function()
			if CurrentHoverInstance ~= HoverInstance then
				return
			end

			TooltipLabel.Visible = false
			CurrentHoverInstance = nil
		end)
	)

	function TooltipTable:Destroy()
		local Signals = TooltipTable.Signals
		MultiDisconnect(Signals)
		
		if  CurrentHoverInstance ~= HoverInstance then return end
		TooltipLabel.Visible = false
		CurrentHoverInstance = nil
	end

	return TooltipTable
end

function Library:OnUnload(Callback)
	table.insert(Library.UnloadSignals, Callback)
end

function Library:Unload()
	--// Disconnect connections
	local Signals = Library.Signals
	MultiDisconnect(Signals)
	
	--// Call unload events
	for _, Callback in pairs(Library.UnloadSignals) do
		Library:SafeCallback(Callback)
	end

	Library.Unloaded = true
	Library.Toggled = false
	
	ScreenGui:Destroy()
end

local BaseAddons = {}
local Funcs = {}
function Funcs:AddKeyPicker(Idx, Info)
	Info = Library:Validate(Info, Templates.KeyPicker)

	local ParentObj = self
	local ToggleLabel = ParentObj.TextLabel

	local KeyPicker = {
		Text = Info.Text,
		Value = Info.Default,
		Toggled = false,
		Mode = Info.Mode,
		SyncToggleState = Info.SyncToggleState,

		Callback = Info.Callback,
		ChangedCallback = Info.ChangedCallback,
		Changed = Info.Changed,
		Clicked = Info.Clicked,

		Type = "KeyPicker",
	}

	if KeyPicker.SyncToggleState then
		Info.Modes = { "Toggle" }
		Info.Mode = "Toggle"
	end

	local Picker = New("TextButton", {
		BackgroundColor3 = "MainColor",
		BorderColor3 = "OutlineColor",
		BorderSizePixel = 1,
		Size = UDim2.fromOffset(18, 18),
		Text = KeyPicker.Value,
		TextSize = 14,
		Parent = ToggleLabel,
	})

	local KeybindsToggle = {
		Normal = KeyPicker.Mode ~= "Toggle",
	}
	do
		local Holder = New("TextButton", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 16),
			Text = "",
			Visible = not Info.NoUI,
			Parent = Library.KeybindContainer,
		})

		local Label = New("TextLabel", {
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 1),
			Text = "",
			TextSize = 14,
			TextTransparency = 0.5,
			Parent = Holder,

			DPIExclude = {
				Size = true,
			},
		})

		local Checkbox = New("Frame", {
			BackgroundColor3 = "MainColor",
			Size = UDim2.fromOffset(14, 14),
			SizeConstraint = Enum.SizeConstraint.RelativeYY,
			Parent = Holder,
		})
		New("UICorner", {
			CornerRadius = UDim.new(0, Library.CornerRadius / 2),
			Parent = Checkbox,
		})
		New("UIStroke", {
			Color = "OutlineColor",
			Parent = Checkbox,
		})

		local CheckImage = New("ImageLabel", {
			Image = CheckIcon and CheckIcon.Url or "",
			ImageColor3 = "FontColor",
			ImageRectOffset = CheckIcon and CheckIcon.ImageRectOffset or Vector2.zero,
			ImageRectSize = CheckIcon and CheckIcon.ImageRectSize or Vector2.zero,
			ImageTransparency = 1,
			Position = UDim2.fromOffset(2, 2),
			Size = UDim2.new(1, -4, 1, -4),
			Parent = Checkbox,
		})

		function KeybindsToggle:Display(State)
			Label.TextTransparency = State and 0 or 0.5
			CheckImage.ImageTransparency = State and 0 or 1
		end

		function KeybindsToggle:SetText(Text)
			local X = Library:GetTextBounds(Text, Label.FontFace, Label.TextSize)
			Label.Text = Text
			Label.Size = UDim2.new(0, X, 1, 0)
		end

		function KeybindsToggle:SetVisibility(Visibility)
			Holder.Visible = Visibility
		end

		function KeybindsToggle:SetNormal(Normal)
			KeybindsToggle.Normal = Normal

			Holder.Active = not Normal
			Label.Position = Normal and UDim2.fromOffset(0, 0) or UDim2.fromOffset(22 * Library.DPIScale, 0)
			Checkbox.Visible = not Normal
		end

		Holder.MouseButton1Click:Connect(function()
			if KeybindsToggle.Normal then
				return
			end

			KeyPicker.Toggled = not KeyPicker.Toggled
			KeyPicker:DoClick()
		end)

		KeybindsToggle.Holder = Holder
		KeybindsToggle.Label = Label
		KeybindsToggle.Checkbox = Checkbox
		KeybindsToggle.Loaded = true
		table.insert(Library.KeybindToggles, KeybindsToggle)
	end

	local MenuTable = Library:AddContextMenu(Picker, UDim2.fromOffset(62, 0), function()
		return { Picker.AbsoluteSize.X + 1.5, 0.5 }
	end, 1)
	KeyPicker.Menu = MenuTable

	local ModeButtons = {}
	for _, Mode in pairs(Info.Modes) do
		local ModeButton = {}

		local Button = New("TextButton", {
			BackgroundColor3 = "MainColor",
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 21),
			Text = Mode,
			TextSize = 14,
			TextTransparency = 0.5,
			Parent = MenuTable.Menu,
		})

		function ModeButton:Select()
			for _, Button in pairs(ModeButtons) do
				Button:Deselect()
			end

			KeyPicker.Mode = Mode

			Button.BackgroundTransparency = 0
			Button.TextTransparency = 0

			MenuTable:Close()
		end

		function ModeButton:Deselect()
			KeyPicker.Mode = nil

			Button.BackgroundTransparency = 1
			Button.TextTransparency = 0.5
		end

		Button.MouseButton1Click:Connect(function()
			ModeButton:Select()
		end)

		if KeyPicker.Mode == Mode then
			ModeButton:Select()
		end

		ModeButtons[Mode] = ModeButton
	end

	function KeyPicker:Display()
		local X, Y =
			Library:GetTextBounds(KeyPicker.Value, Picker.FontFace, Picker.TextSize, ToggleLabel.AbsoluteSize.X)
		Picker.Text = KeyPicker.Value
		Picker.Size = UDim2.fromOffset(X + 9 * Library.DPIScale, Y + 4 * Library.DPIScale)
	end

	function KeyPicker:Update()
		KeyPicker:Display()

		if Info.NoUI then
			return
		end

		if KeyPicker.Mode == "Toggle" and ParentObj.Type == "Toggle" and ParentObj.Disabled then
			KeybindsToggle:SetVisibility(false)
			return
		end

		local State = KeyPicker:GetState()
		local ShowToggle = Library.ShowToggleFrameInKeybinds and KeyPicker.Mode == "Toggle"

		if KeybindsToggle.Loaded then
			if ShowToggle then
				KeybindsToggle:SetNormal(false)
			else
				KeybindsToggle:SetNormal(true)
			end

			KeybindsToggle:SetText(("[%s] %s (%s)"):format(KeyPicker.Value, KeyPicker.Text, KeyPicker.Mode))
			KeybindsToggle:SetVisibility(true)
			KeybindsToggle:Display(State)
		end

		Library:UpdateKeybindFrame()
	end

	function KeyPicker:GetState()
		if KeyPicker.Mode == "Always" then
			return true
		elseif KeyPicker.Mode == "Hold" then
			local Key = KeyPicker.Value
			if Key == "None" then
				return false
			end

			if Key == "MB1" or Key == "MB2" then
				return Key == "MB1" and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1)
					or Key == "MB2" and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2)
			end

			return UserInputService:IsKeyDown(Enum.KeyCode[KeyPicker.Value])
				and not UserInputService:GetFocusedTextBox()
		else
			return KeyPicker.Toggled
		end
	end

	function KeyPicker:OnChanged(Func)
		KeyPicker.Changed = Func
	end

	function KeyPicker:OnClick(Func)
		KeyPicker.Clicked = Func
	end

	function KeyPicker:DoClick()
		if ParentObj.Type == "Toggle" and KeyPicker.SyncToggleState then
			ParentObj:SetValue(KeyPicker.Toggled)
		end

		Library:SafeCallback(KeyPicker.Callback, KeyPicker.Toggled)
		Library:SafeCallback(KeyPicker.Changed, KeyPicker.Toggled)
	end

	function KeyPicker:SetValue(Data)
		local Key, Mode = Data[1], Data[2]

		KeyPicker.Value = Key
		if ModeButtons[Mode] then
			ModeButtons[Mode]:Select()
		end

		KeyPicker:Update()
	end

	function KeyPicker:SetText(Text)
		KeybindsToggle:SetText(Text)
		KeyPicker:Update()
	end

	local Picking = false
	Picker.MouseButton1Click:Connect(function()
		if Picking then
			return
		end

		Picking = true

		Picker.Text = "..."
		Picker.Size = UDim2.fromOffset(29 * Library.DPIScale, 18 * Library.DPIScale)

		local Input = UserInputService.InputBegan:Wait()
		local Key = "Unknown"

		if Input.UserInputType == Enum.UserInputType.Keyboard then
			Key = Input.KeyCode == Enum.KeyCode.Escape and "None" or Input.KeyCode.Name
		elseif Input.UserInputType == Enum.UserInputType.MouseButton1 then
			Key = "MB1"
		elseif Input.UserInputType == Enum.UserInputType.MouseButton2 then
			Key = "MB2"
		end

		KeyPicker.Value = Key
		KeyPicker:Update()

		Library:SafeCallback(
			KeyPicker.ChangedCallback,
			Input.KeyCode == Enum.KeyCode.Unknown and Input.UserInputType or Input.KeyCode
		)
		Library:SafeCallback(
			KeyPicker.Changed,
			Input.KeyCode == Enum.KeyCode.Unknown and Input.UserInputType or Input.KeyCode
		)

		RunService.RenderStepped:Wait()
		Picking = false
	end)
	Picker.MouseButton2Click:Connect(MenuTable.Toggle)

	Library:GiveSignal(UserInputService.InputBegan:Connect(function(Input: InputObject)
		if
			KeyPicker.Mode == "Always"
			or KeyPicker.Value == "Unknown"
			or KeyPicker.Value == "None"
			or Picking
			or UserInputService:GetFocusedTextBox()
		then
			return
		end

		if KeyPicker.Mode == "Toggle" then
			local Key = KeyPicker.Value

			if Key == "MB1" or Key == "MB2" then
				if
					Key == "MB1" and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1)
					or Key == "MB2" and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2)
				then
					KeyPicker.Toggled = not KeyPicker.Toggled
					KeyPicker:DoClick()
				end
			elseif Input.UserInputType == Enum.UserInputType.Keyboard and Input.KeyCode.Name == Key then
				KeyPicker.Toggled = not KeyPicker.Toggled
				KeyPicker:DoClick()
			end
		end

		KeyPicker:Update()
	end))

	Library:GiveSignal(UserInputService.InputEnded:Connect(function()
		if
			KeyPicker.Value == "Unknown"
			or KeyPicker.Value == "None"
			or Picking
			or UserInputService:GetFocusedTextBox()
		then
			return
		end

		KeyPicker:Update()
	end))

	KeyPicker:Update()

	if ParentObj.Addons then
		table.insert(ParentObj.Addons, KeyPicker)
	end

	Options[Idx] = KeyPicker

	return self
end

local HueSequenceTable = {}
for Hue = 0, 1, 0.1 do
	table.insert(HueSequenceTable, ColorSequenceKeypoint.new(Hue, Color3.fromHSV(Hue, 1, 1)))
end
function Funcs:AddColorPicker(Idx, Info)
	Info = Library:Validate(Info, Templates.ColorPicker)

	local ParentObj = self
	local ToggleLabel = ParentObj.TextLabel

	local ColorPicker = {
		Value = Info.Default,
		Transparency = Info.Transparency or 0,

		Callback = Info.Callback,
		Changed = Info.Changed,

		Type = "ColorPicker",
	}
	ColorPicker.Hue, ColorPicker.Sat, ColorPicker.Vib = ColorPicker.Value:ToHSV()

	local Holder = New("TextButton", {
		BackgroundColor3 = ColorPicker.Value,
		BorderColor3 = Library:GetDarkerColor(ColorPicker.Value),
		BorderSizePixel = 1,
		Size = UDim2.fromOffset(18, 18),
		Text = "",
		Parent = ToggleLabel,
	})

	local HolderTransparency = New("ImageLabel", {
		Image = Library:GetAsset("Tiles.png"),
		ImageTransparency = (1 - ColorPicker.Transparency),
		ScaleType = Enum.ScaleType.Tile,
		Size = UDim2.fromScale(1, 1),
		TileSize = UDim2.fromOffset(9, 9),
		Parent = Holder,
	})

	--// Color Menu \\--
	local ColorMenu = Library:AddContextMenu(
		Holder,
		UDim2.fromOffset(Info.Transparency and 256 or 234, 0),
		function()
			return { 0.5, Holder.AbsoluteSize.Y + 1.5 }
		end,
		1
	)
	ColorMenu.List.Padding = UDim.new(0, 8)
	ColorPicker.ColorMenu = ColorMenu

	New("UIPadding", {
		PaddingBottom = UDim.new(0, 6),
		PaddingLeft = UDim.new(0, 6),
		PaddingRight = UDim.new(0, 6),
		PaddingTop = UDim.new(0, 6),
		Parent = ColorMenu.Menu,
	})

	if typeof(Info.Title) == "string" then
		New("TextLabel", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 8),
			Text = Info.Title,
			TextSize = 14,
			TextXAlignment = Enum.TextXAlignment.Left,
			Parent = ColorMenu.Menu,
		})
	end

	local ColorHolder = New("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 200),
		Parent = ColorMenu.Menu,
	})
	New("UIListLayout", {
		FillDirection = Enum.FillDirection.Horizontal,
		Padding = UDim.new(0, 6),
		Parent = ColorHolder,
	})

	--// Sat Map
	local SatVipMap = New("ImageButton", {
		BackgroundColor3 = ColorPicker.Value,
		Image = Library:GetAsset("Gradient.png"),
		Size = UDim2.fromOffset(200, 200),
		Parent = ColorHolder,
	})

	local SatVibCursor = New("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = "White",
		Size = UDim2.fromOffset(6, 6),
		Parent = SatVipMap,
	})
	New("UICorner", {
		CornerRadius = UDim.new(1, 0),
		Parent = SatVibCursor,
	})
	New("UIStroke", {
		Color = "Dark",
		Parent = SatVibCursor,
	})

	--// Hue
	local HueSelector = New("TextButton", {
		Size = UDim2.fromOffset(16, 200),
		Text = "",
		Parent = ColorHolder,
	})
	New("UIGradient", {
		Color = ColorSequence.new(HueSequenceTable),
		Rotation = 90,
		Parent = HueSelector,
	})

	local HueCursor = New("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = "White",
		BorderColor3 = "Dark",
		BorderSizePixel = 1,
		Position = UDim2.fromScale(0.5, ColorPicker.Hue),
		Size = UDim2.new(1, 2, 0, 1),
		Parent = HueSelector,
	})

	--// Alpha
	local TransparencySelector, TransparencyColor, TransparencyCursor
	if Info.Transparency then
		TransparencySelector = New("ImageButton", {
			Image = Library:GetAsset("Tiles.png"),
			ScaleType = Enum.ScaleType.Tile,
			Size = UDim2.fromOffset(16, 200),
			TileSize = UDim2.fromOffset(8, 8),
			Parent = ColorHolder,
		})

		TransparencyColor = New("Frame", {
			BackgroundColor3 = ColorPicker.Value,
			Size = UDim2.fromScale(1, 1),
			Parent = TransparencySelector,
		})
		New("UIGradient", {
			Rotation = 90,
			Transparency = NumberSequence.new({
				NumberSequenceKeypoint.new(0, 0),
				NumberSequenceKeypoint.new(1, 1),
			}),
			Parent = TransparencyColor,
		})

		TransparencyCursor = New("Frame", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundColor3 = "White",
			BorderColor3 = "Dark",
			BorderSizePixel = 1,
			Position = UDim2.fromScale(0.5, ColorPicker.Transparency),
			Size = UDim2.new(1, 2, 0, 1),
			Parent = TransparencySelector,
		})
	end

	local InfoHolder = New("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 20),
		Parent = ColorMenu.Menu,
	})
	New("UIListLayout", {
		FillDirection = Enum.FillDirection.Horizontal,
		HorizontalFlex = Enum.UIFlexAlignment.Fill,
		Padding = UDim.new(0, 8),
		Parent = InfoHolder,
	})

	local HueBox = New("TextBox", {
		BackgroundColor3 = "MainColor",
		BorderColor3 = "OutlineColor",
		BorderSizePixel = 1,
		ClearTextOnFocus = false,
		Size = UDim2.fromScale(1, 1),
		Text = "#??????",
		TextSize = 14,
		Parent = InfoHolder,
	})

	local RgbBox = New("TextBox", {
		BackgroundColor3 = "MainColor",
		BorderColor3 = "OutlineColor",
		BorderSizePixel = 1,
		ClearTextOnFocus = false,
		Size = UDim2.fromScale(1, 1),
		Text = "?, ?, ?",
		TextSize = 14,
		Parent = InfoHolder,
	})

	--// Context Menu \\--
	local ContextMenu = Library:AddContextMenu(Holder, UDim2.fromOffset(93, 0), function()
		return { Holder.AbsoluteSize.X + 1.5, 0.5 }
	end, 1)
	ColorPicker.ContextMenu = ContextMenu
	do
		local function CreateButton(Text, Func)
			local Button = New("TextButton", {
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, 21),
				Text = Text,
				TextSize = 14,
				Parent = ContextMenu.Menu,
			})

			Button.MouseButton1Click:Connect(function()
				Library:SafeCallback(Func)
				ContextMenu:Close()
			end)
		end

		CreateButton("Copy color", function()
			Library.CopiedColor = { ColorPicker.Value, ColorPicker.Transparency }
		end)

		CreateButton("Paste color", function()
			ColorPicker:SetValueRGB(Library.CopiedColor[1], Library.CopiedColor[2])
		end)

		if setclipboard then
			CreateButton("Copy Hex", function()
				setclipboard(tostring(ColorPicker.Value:ToHex()))
			end)
			CreateButton("Copy RGB", function()
				setclipboard(table.concat({
					math.floor(ColorPicker.Value.R * 255),
					math.floor(ColorPicker.Value.G * 255),
					math.floor(ColorPicker.Value.B * 255),
				}, ", "))
			end)
		end
	end

	--// End \\--

	function ColorPicker:SetHSVFromRGB(Color)
		ColorPicker.Hue, ColorPicker.Sat, ColorPicker.Vib = Color:ToHSV()
	end

	function ColorPicker:Display()
		ColorPicker.Value = Color3.fromHSV(ColorPicker.Hue, ColorPicker.Sat, ColorPicker.Vib)

		Holder.BackgroundColor3 = ColorPicker.Value
		Holder.BorderColor3 = Library:GetDarkerColor(ColorPicker.Value)
		HolderTransparency.ImageTransparency = (1 - ColorPicker.Transparency)

		SatVipMap.BackgroundColor3 = Color3.fromHSV(ColorPicker.Hue, 1, 1)
		if TransparencyColor then
			TransparencyColor.BackgroundColor3 = ColorPicker.Value
		end

		SatVibCursor.Position = UDim2.fromScale(ColorPicker.Sat, 1 - ColorPicker.Vib)
		HueCursor.Position = UDim2.fromScale(0.5, ColorPicker.Hue)
		if TransparencyCursor then
			TransparencyCursor.Position = UDim2.fromScale(0.5, ColorPicker.Transparency)
		end

		HueBox.Text = "#" .. ColorPicker.Value:ToHex()
		RgbBox.Text = table.concat({
			math.floor(ColorPicker.Value.R * 255),
			math.floor(ColorPicker.Value.G * 255),
			math.floor(ColorPicker.Value.B * 255),
		}, ", ")
	end

	function ColorPicker:Update()
		ColorPicker:Display()

		Library:SafeCallback(ColorPicker.Callback, ColorPicker.Value)
		Library:SafeCallback(ColorPicker.Changed, ColorPicker.Value)
	end

	function ColorPicker:OnChanged(Func)
		ColorPicker.Changed = Func
	end

	function ColorPicker:SetValue(HSV, Transparency)
		local Color = Color3.fromHSV(HSV[1], HSV[2], HSV[3])

		ColorPicker.Transparency = Info.Transparency and Transparency or 0
		ColorPicker:SetHSVFromRGB(Color)
		ColorPicker:Display()
	end

	function ColorPicker:SetValueRGB(Color, Transparency)
		ColorPicker.Transparency = Info.Transparency and Transparency or 0
		ColorPicker:SetHSVFromRGB(Color)
		ColorPicker:Display()
	end

	Holder.MouseButton1Click:Connect(ColorMenu.Toggle)
	Holder.MouseButton2Click:Connect(ContextMenu.Toggle)

	SatVipMap.MouseButton1Down:Connect(function()
		while UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1 or Enum.UserInputType.Touch) do
			local MinX = SatVipMap.AbsolutePosition.X
			local MaxX = MinX + SatVipMap.AbsoluteSize.X
			local LocationX = math.clamp(Mouse.X, MinX, MaxX)

			local MinY = SatVipMap.AbsolutePosition.Y
			local MaxY = MinY + SatVipMap.AbsoluteSize.Y
			local LocationY = math.clamp(Mouse.Y, MinY, MaxY)

			local OldSat = ColorPicker.Sat
			local OldVib = ColorPicker.Vib
			ColorPicker.Sat = (LocationX - MinX) / (MaxX - MinX)
			ColorPicker.Vib = 1 - ((LocationY - MinY) / (MaxY - MinY))

			if ColorPicker.Sat ~= OldSat or ColorPicker.Vib ~= OldVib then
				ColorPicker:Update()
			end

			RunService.RenderStepped:Wait()
		end
	end)
	HueSelector.MouseButton1Down:Connect(function()
		while UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1 or Enum.UserInputType.Touch) do
			local Min = HueSelector.AbsolutePosition.Y
			local Max = Min + HueSelector.AbsoluteSize.Y
			local Location = math.clamp(Mouse.Y, Min, Max)

			local OldHue = ColorPicker.Hue
			ColorPicker.Hue = (Location - Min) / (Max - Min)

			if ColorPicker.Hue ~= OldHue then
				ColorPicker:Update()
			end

			RunService.RenderStepped:Wait()
		end
	end)
	if TransparencySelector then
		TransparencySelector.MouseButton1Down:Connect(function()
			while
				UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1 or Enum.UserInputType.Touch)
			do
				local Min = TransparencySelector.AbsolutePosition.Y
				local Max = TransparencySelector.AbsolutePosition.Y + TransparencySelector.AbsoluteSize.Y
				local Location = math.clamp(Mouse.Y, Min, Max)

				local OldTransparency = ColorPicker.Transparency
				ColorPicker.Transparency = (Location - Min) / (Max - Min)

				if ColorPicker.Transparency ~= OldTransparency then
					ColorPicker:Update()
				end

				RunService.RenderStepped:Wait()
			end
		end)
	end

	HueBox.FocusLost:Connect(function(Enter)
		if not Enter then
			return
		end

		local Success, Color = pcall(Color3.fromHex, HueBox.Text)
		if Success and typeof(Color) == "Color3" then
			ColorPicker.Hue, ColorPicker.Sat, ColorPicker.Vib = Color:ToHSV()
		end

		ColorPicker:Update()
	end)
	RgbBox.FocusLost:Connect(function(Enter)
		if not Enter then
			return
		end

		local R, G, B = RgbBox.Text:match("(%d+),%s*(%d+),%s*(%d+)")
		if R and G and B then
			ColorPicker:SetHSVFromRGB(Color3.fromRGB(R, G, B))
		end

		ColorPicker:Update()
	end)

	ColorPicker:Display()

	if ParentObj.Addons then
		table.insert(ParentObj.Addons, ColorPicker)
	end

	Options[Idx] = ColorPicker

	return self
end

BaseAddons.__index = Funcs
BaseAddons.__namecall = function(_, Key, ...)
	return Funcs[Key](...)
end


local BaseGroupbox = {}
do
	local Funcs = {}
	function Funcs:AddDivider()
		local Groupbox = self
		local Container = Groupbox.Container

		local Holder = New("Frame", {
			BackgroundColor3 = "MainColor",
			BorderColor3 = "OutlineColor",
			BorderSizePixel = 1,
			Size = UDim2.new(1, 0, 0, 2),
			Parent = Container,
		})

		table.insert(Groupbox.Elements, {
			Holder = Holder,
			Type = "Divider",
		})
	end

	function Funcs:AddSplit(Info)
		Info = Info or {}

		local Container = New("Frame", {
			BackgroundTransparency = 1,
			BorderSizePixel = 1,
			Size = Info.Size or UDim2.fromScale(0.5, 1),
			AutomaticSize = Enum.AutomaticSize.Y,
			Parent = self.Container,
		})

		New("UIFlexItem", {
			FlexMode = Enum.UIFlexMode.Fill,
			Parent = Container
		})

		New("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			Padding = UDim.new(0, 6),
			Parent = Container,
		})

		local Canvas = {
			Holder = Container,
			Elements = self.Elements,
			Container = Container
		}
		setmetatable(Canvas, BaseGroupbox)

		return Canvas
	end

	function Funcs:AddScrollingFrame()
		local Container = New("ScrollingFrame", {
			BackgroundTransparency = 1,
			AutomaticCanvasSize = Enum.AutomaticSize.Y,
			CanvasSize = UDim2.fromOffset(0,0),
			BorderSizePixel = 0,
			Size = UDim2.fromScale(1,1),
			Parent = self.Container,
			ScrollBarImageColor3 = "OutlineColor",
			ScrollBarThickness = 2,
		})

		New("UIFlexItem", {
			FlexMode = Enum.UIFlexMode.Fill,
			Parent = Container
		})

		New("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			Padding = UDim.new(0, 6),
			Parent = Container,
		})

		local Canvas = {
			Holder = Container,
			Elements = self.Elements,
			Container = Container
		}
		setmetatable(Canvas, BaseGroupbox)

		return Canvas
	end

	function Funcs:AddKeyBox(...)
		local Container = self.Container
		local Data = {
			Success = false
		}

		local First = select(1, ...)

		if typeof(First) == "function" then
			Data.Callback = First
		else
			Data.ExpectedKey = First
			Data.Callback = select(2, ...)
		end

		local Holder = New("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(0.75, 0, 0, 21),
			Parent = Container,
		})

		local Box = New("TextBox", {
			BackgroundColor3 = "MainColor",
			BorderColor3 = "OutlineColor",
			BorderSizePixel = 1,
			PlaceholderText = "Key",
			Size = UDim2.new(1, -71, 1, 0),
			TextSize = 14,
			TextXAlignment = Enum.TextXAlignment.Left,
			Parent = Holder,
		})
		New("UIPadding", {
			PaddingLeft = UDim.new(0, 8),
			PaddingRight = UDim.new(0, 8),
			Parent = Box,
		})

		local Button = New("TextButton", {
			AnchorPoint = Vector2.new(1, 0),
			BackgroundColor3 = "MainColor",
			BorderColor3 = "OutlineColor",
			BorderSizePixel = 1,
			Position = UDim2.fromScale(1, 0),
			Size = UDim2.new(0, 63, 1, 0),
			Text = "Execute",
			TextSize = 14,
			Parent = Holder,
		})

		function Data:WaitForSuccess()
			repeat wait() until self.Success
		end

		function Data:CheckKey()
			return Box.Text == Data.ExpectedKey
		end

		Button.MouseButton1Click:Connect(function()
			local Success = Data:CheckKey()
			Data.Success = Success

			--// Invoke callback
			Data.Callback(Success, Box.Text)
		end)

		return Data
	end

	function Funcs:AddLabel(...)
		local Data = {
			AutomaticSize = Enum.AutomaticSize.Y,
			Size = UDim2.new(1, 0, 0, 18),
		}

		local First = select(1, ...)
		local Second = select(2, ...)
		
		local Groupbox = self
		local NoExpanding = self.NoExpanding
		local Container = Groupbox.Container
		local UpdateSizeFuncRequired = false

		if typeof(First) == "table" or typeof(Second) == "table" then
			local Params = typeof(First) == "table" and First or Second

			Data.Text = Params.Text or ""
			Data.AutomaticSize = Params.AutomaticSize or Data.AutomaticSize
			Data.DoesWrap = Params.DoesWrap or false
			Data.TextSize = Params.TextSize or 14
			Data.Visible = Params.Visible or true
			Data.RichText = Params.RichText
			Data.Idx = typeof(Second) == "table" and First or nil
		else
			Data.Text = First or ""
			Data.DoesWrap = Second or false
			Data.TextSize = 14
			Data.Visible = true
			Data.Idx = select(3, ...) or nil
		end

		local Label = {
			Text = Data.Text,
			DoesWrap = Data.DoesWrap,
			Visible = Data.Visible,
			RichText = Data.RichText,
			Type = "Label",
		}

		if NoExpanding or Data.AutomaticSize == Enum.AutomaticSize.XY then
			Data.Size = UDim2.new(0, 0, 0, 18)
			Data.AutomaticSize = Enum.AutomaticSize.XY
			UpdateSizeFuncRequired = true
		end

		local TextLabel = New("TextLabel", {
			BackgroundTransparency = 1,
			Size = Data.Size,
			Text = Label.Text,
			TextSize = Data.TextSize,
			TextWrapped = Label.DoesWrap,
			AutomaticSize = Data.AutomaticSize,
			TextXAlignment = Groupbox.IsKeyTab and Enum.TextXAlignment.Center or Enum.TextXAlignment.Left,
			Parent = Container,
			DPIExclude = {
				Size = true,
			},
		})

		if UpdateSizeFuncRequired then
			TextLabel:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
				local _, Y =
					Library:GetTextBounds(Label.Text, TextLabel.FontFace, TextLabel.TextSize, TextLabel.AbsoluteSize.X)
				TextLabel.Size = UDim2.fromOffset(0, Y + 4 * Library.DPIScale)
			end)
		end

		if not Label.DoesWrap and not NoExpanding then
			New("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalAlignment = Enum.HorizontalAlignment.Right,
				Padding = UDim.new(0, 6),
				Parent = TextLabel,
			})
		end

		function Label:SetVisible(Visible: boolean)
			Label.Visible = Visible
			TextLabel.Visible = Label.Visible
		end

		function Label:SetText(Text: string)
			Label.Text = Text
			TextLabel.Text = Text
		end

		Label.TextLabel = TextLabel
		Label.Container = Container
		Label.Holder = TextLabel
		
		--// RichText themeing
		if Label.RichText then
			Library:AddToRegistry(TextLabel, {
				Text = function()
					local Value = Label.Text
					return ApplyRichTextTheme(Value)
				end,
			})
		end
		
		if not Data.DoesWrap then
			setmetatable(Label, BaseAddons)
		end
		table.insert(Groupbox.Elements, Label)

		if Data.Idx then
			Labels[Data.Idx] = Label
		else
			table.insert(Labels, Label)
		end

		return Label
	end

	function Funcs:AddButton(...)
		local function GetInfo(...)
			local Info = {}

			local First = select(1, ...)
			local Second = select(2, ...)

			if typeof(First) == "table" or typeof(Second) == "table" then
				local Params = typeof(First) == "table" and First or Second

				Info.Text = Params.Text or ""
				Info.Func = Params.Func or function() end
				Info.DoubleClick = Params.DoubleClick

				Info.Tooltip = Params.Tooltip
				Info.DisabledTooltip = Params.DisabledTooltip

				Info.Risky = Params.Risky or false
				Info.Disabled = Params.Disabled or false
				Info.Visible = Params.Visible or true
				Info.Idx = typeof(Second) == "table" and First or nil
			else
				Info.Text = First or ""
				Info.Func = Second or function() end
				Info.DoubleClick = false

				Info.Tooltip = nil
				Info.DisabledTooltip = nil

				Info.Risky = false
				Info.Disabled = false
				Info.Visible = true
				Info.Idx = select(3, ...) or nil
			end

			return Info
		end
		local Info = GetInfo(...)

		local Groupbox = self
		local Container = Groupbox.Container

		local Button = {
			Text = Info.Text,
			Func = Info.Func,
			DoubleClick = Info.DoubleClick,

			Tooltip = Info.Tooltip,
			DisabledTooltip = Info.DisabledTooltip,
			TooltipTable = nil,

			Risky = Info.Risky,
			Disabled = Info.Disabled,
			Visible = Info.Visible,

			Tween = nil,
			Type = "Button",
		}

		local Holder = New("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 21),
			Parent = Container,
		})

		New("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalFlex = Enum.UIFlexAlignment.Fill,
			Padding = UDim.new(0, 9),
			Parent = Holder,
		})

		local function CreateButton(Button)
			local Base = New("TextButton", {
				Active = not Button.Disabled,
				BackgroundColor3 = Button.Disabled and "BackgroundColor" or "MainColor",
				Size = UDim2.fromScale(1, 1),
				Text = Button.Text,
				TextSize = 14,
				TextTransparency = 0.4,
				Visible = Button.Visible,
				Parent = Holder,
			})

			local Stroke = New("UIStroke", {
				Color = "OutlineColor",
				Transparency = Button.Disabled and 0.5 or 0,
				Parent = Base,
			})

			return Base, Stroke
		end

		local function InitEvents(Button)
			Button.Base.MouseEnter:Connect(function()
				if Button.Disabled then
					return
				end

				Button.Tween = TweenService:Create(Button.Base, Library.TweenInfo, {
					TextTransparency = 0,
				})
				Button.Tween:Play()
			end)
			Button.Base.MouseLeave:Connect(function()
				if Button.Disabled then
					return
				end

				Button.Tween = TweenService:Create(Button.Base, Library.TweenInfo, {
					TextTransparency = 0.4,
				})
				Button.Tween:Play()
			end)

			Button.Base.MouseButton1Click:Connect(function()
				if Button.Disabled or Button.Locked then
					return
				end

				if Button.DoubleClick then
					Button.Locked = true

					Button.Base.Text = "Are you sure?"
					Button.Base.TextColor3 = Library.Scheme.AccentColor
					Library.Registry[Button.Base].TextColor3 = "AccentColor"

					local Clicked = WaitForEvent(Button.Base.MouseButton1Click, 0.5)

					Button.Base.Text = Button.Text
					Button.Base.TextColor3 = Button.Risky and Library.Scheme.Red or Library.Scheme.FontColor
					Library.Registry[Button.Base].TextColor3 = Button.Risky and "Red" or "FontColor"

					if Clicked then
						Library:SafeCallback(Button.Func)
					end

					RunService.RenderStepped:Wait() --// Mouse Button fires without waiting (i hate roblox)
					Button.Locked = false
					return
				end

				Library:SafeCallback(Button.Func)
			end)
		end

		Button.Base, Button.Stroke = CreateButton(Button)
		InitEvents(Button)

		function Button:AddButton(...)
			local Info = GetInfo(...)

			local SubButton = {
				Text = Info.Text,
				Func = Info.Func,
				DoubleClick = Info.DoubleClick,

				Tooltip = Info.Tooltip,
				DisabledTooltip = Info.DisabledTooltip,
				TooltipTable = nil,

				Risky = Info.Risky,
				Disabled = Info.Disabled,
				Visible = Info.Visible,

				Tween = nil,
				Type = "SubButton",
			}

			Button.SubButton = SubButton
			SubButton.Base, SubButton.Stroke = CreateButton(SubButton)
			InitEvents(SubButton)

			function SubButton:UpdateColors()
				StopTween(SubButton.Tween)

				SubButton.Base.BackgroundColor3 = SubButton.Disabled and Library.Scheme.BackgroundColor
					or Library.Scheme.MainColor
				SubButton.Base.TextTransparency = SubButton.Disabled and 0.8 or 0.4
				SubButton.Stroke.Transparency = SubButton.Disabled and 0.5 or 0

				Library.Registry[SubButton.Base].BackgroundColor3 = SubButton.Disabled and "BackgroundColor"
					or "MainColor"
			end

			function SubButton:SetDisabled(Disabled: boolean)
				SubButton.Disabled = Disabled

				if SubButton.TooltipTable then
					SubButton.TooltipTable.Disabled = SubButton.Disabled
				end

				SubButton.Base.Active = not SubButton.Disabled
				SubButton:UpdateColors()
			end

			function SubButton:SetVisible(Visible: boolean)
				SubButton.Visible = Visible
				SubButton.Base.Visible = SubButton.Visible
			end

			function SubButton:SetText(Text: string)
				SubButton.Text = Text
				SubButton.Base.Text = Text
			end

			if typeof(SubButton.Tooltip) == "string" or typeof(SubButton.DisabledTooltip) == "string" then
				SubButton.TooltipTable =
					Library:AddTooltip(SubButton.Tooltip, SubButton.DisabledTooltip, SubButton.Base)
				SubButton.TooltipTable.Disabled = SubButton.Disabled
			end

			if SubButton.Risky then
				SubButton.Base.TextColor3 = Library.Scheme.Red
				Library.Registry[SubButton.Base].TextColor3 = "Red"
			end

			SubButton:UpdateColors()

			if Info.Idx then
				Buttons[Info.Idx] = SubButton
			else
				table.insert(Buttons, SubButton)
			end

			return SubButton
		end

		function Button:UpdateColors()
			StopTween(Button.Tween)

			Button.Base.BackgroundColor3 = Button.Disabled and Library.Scheme.BackgroundColor
				or Library.Scheme.MainColor
			Button.Base.TextTransparency = Button.Disabled and 0.8 or 0.4
			Button.Stroke.Transparency = Button.Disabled and 0.5 or 0

			Library.Registry[Button.Base].BackgroundColor3 = Button.Disabled and "BackgroundColor" or "MainColor"
		end

		function Button:SetDisabled(Disabled: boolean)
			Button.Disabled = Disabled

			if Button.TooltipTable then
				Button.TooltipTable.Disabled = Button.Disabled
			end

			Button.Base.Active = not Button.Disabled
			Button:UpdateColors()
		end

		function Button:SetVisible(Visible: boolean)
			Button.Visible = Visible
			Holder.Visible = Button.Visible
		end

		function Button:SetText(Text: string)
			Button.Text = Text
			Button.Base.Text = Text
		end

		if typeof(Button.Tooltip) == "string" or typeof(Button.DisabledTooltip) == "string" then
			Button.TooltipTable = Library:AddTooltip(Button.Tooltip, Button.DisabledTooltip, Button.Base)
			Button.TooltipTable.Disabled = Button.Disabled
		end

		if Button.Risky then
			Button.Base.TextColor3 = Library.Scheme.Red
			Library.Registry[Button.Base].TextColor3 = "Red"
		end

		Button:UpdateColors()

		Button.Holder = Holder
		table.insert(Groupbox.Elements, Button)

		if Info.Idx then
			Buttons[Info.Idx] = Button
		else
			table.insert(Buttons, Button)
		end

		return Button
	end

	function Funcs:AddCheckbox(Idx, Info)
		Info = Library:Validate(Info, Templates.Toggle)

		local Container = self.Container

		local Toggle = {
			Text = Info.Text,
			Value = Info.Default,

			Tooltip = Info.Tooltip,
			DisabledTooltip = Info.DisabledTooltip,
			TooltipTable = nil,

			Callback = Info.Callback,
			Changed = Info.Changed,

			Risky = Info.Risky,
			Disabled = Info.Disabled,
			Visible = Info.Visible,
			Addons = {},

			Type = "Toggle",
		}

		local Button = New("TextButton", {
			Active = not Toggle.Disabled,
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 18),
			Text = "",
			Visible = Toggle.Visible,
			Parent = Container,
		})

		local Label = New("TextLabel", {
			BackgroundTransparency = 1,
			Position = UDim2.fromOffset(26, 0),
			Size = UDim2.new(1, -26, 1, 0),
			Text = Toggle.Text,
			TextSize = 14,
			TextTransparency = 0.4,
			TextXAlignment = Enum.TextXAlignment.Left,
			Parent = Button,
		})

		New("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = Enum.HorizontalAlignment.Right,
			Padding = UDim.new(0, 6),
			Parent = Label,
		})

		local Checkbox = New("Frame", {
			BackgroundColor3 = "MainColor",
			Size = UDim2.fromScale(1, 1),
			SizeConstraint = Enum.SizeConstraint.RelativeYY,
			Parent = Button,
		})
		New("UICorner", {
			CornerRadius = UDim.new(0, Library.CornerRadius / 2),
			Parent = Checkbox,
		})

		local CheckboxStroke = New("UIStroke", {
			Color = "OutlineColor",
			Parent = Checkbox,
		})

		local CheckImage = New("ImageLabel", {
			Image = CheckIcon and CheckIcon.Url or "",
			ImageColor3 = "FontColor",
			ImageRectOffset = CheckIcon and CheckIcon.ImageRectOffset or Vector2.zero,
			ImageRectSize = CheckIcon and CheckIcon.ImageRectSize or Vector2.zero,
			ImageTransparency = 1,
			Position = UDim2.fromOffset(2, 2),
			Size = UDim2.new(1, -4, 1, -4),
			Parent = Checkbox,
		})

		function Toggle:UpdateColors()
			Toggle:Display()
		end

		function Toggle:Display()
			CheckboxStroke.Transparency = Toggle.Disabled and 0.5 or 0

			if Toggle.Disabled then
				Label.TextTransparency = 0.8
				CheckImage.ImageTransparency = Toggle.Value and 0.8 or 1

				Checkbox.BackgroundColor3 = Library.Scheme.BackgroundColor
				Library.Registry[Checkbox].BackgroundColor3 = "BackgroundColor"

				return
			end

			TweenService:Create(Label, Library.TweenInfo, {
				TextTransparency = Toggle.Value and 0 or 0.4,
			}):Play()
			TweenService:Create(CheckImage, Library.TweenInfo, {
				ImageTransparency = Toggle.Value and 0 or 1,
			}):Play()

			Checkbox.BackgroundColor3 = Library.Scheme.MainColor
			Library.Registry[Checkbox].BackgroundColor3 = "MainColor"
		end

		function Toggle:OnChanged(Func)
			Toggle.Changed = Func
		end

		function Toggle:SetValue(Value)
			if Toggle.Disabled then
				return
			end

			Toggle.Value = Value
			Toggle:Display()

			for _, Addon in pairs(Toggle.Addons) do
				if Addon.Type == "KeyPicker" and Addon.SyncToggleState then
					Addon.Toggled = Toggle.Value
					Addon:Update()
				end
			end

			Library:SafeCallback(Toggle.Callback, Toggle.Value)
			Library:SafeCallback(Toggle.Changed, Toggle.Value)
		end

		function Toggle:SetDisabled(Disabled: boolean)
			Toggle.Disabled = Disabled

			if Toggle.TooltipTable then
				Toggle.TooltipTable.Disabled = Toggle.Disabled
			end

			for _, Addon in pairs(Toggle.Addons) do
				if Addon.Type == "KeyPicker" and Addon.SyncToggleState then
					Addon:Update()
				end
			end

			Button.Active = not Toggle.Disabled
			Toggle:Display()
		end

		function Toggle:SetVisible(Visible: boolean)
			Toggle.Visible = Visible
			Button.Visible = Toggle.Visible
		end

		function Toggle:SetText(Text: string)
			Toggle.Text = Text
			Label.Text = Text
		end

		Button.MouseButton1Click:Connect(function()
			if Toggle.Disabled then
				return
			end

			Toggle:SetValue(not Toggle.Value)
		end)

		if typeof(Toggle.Tooltip) == "string" or typeof(Toggle.DisabledTooltip) == "string" then
			Toggle.TooltipTable = Library:AddTooltip(Toggle.Tooltip, Toggle.DisabledTooltip, Button)
			Toggle.TooltipTable.Disabled = Toggle.Disabled
		end

		if Toggle.Risky then
			Label.TextColor3 = Library.Scheme.Red
			Library.Registry[Label].TextColor3 = "Red"
		end

		Toggle:Display()

		Toggle.TextLabel = Label
		Toggle.Container = Container
		setmetatable(Toggle, BaseAddons)

		Toggle.Holder = Button
		table.insert(self.Elements, Toggle)

		Toggles[Idx] = Toggle

		return Toggle
	end

	function Funcs:AddImage(Idx, Info)
		Info = Library:Validate(Info, Templates.Image)

		local Container = self.Container

		local ImageUrl = Info.Image
		local AspectType = Info.AspectType
		local Size = Info.Size

		--// Convert Image url into a string
		if typeof(ImageUrl) == "number" then
			ImageUrl = `rbxassetid://{ImageUrl}`
		end

		local Image = New("ImageLabel", {
			Image = ImageUrl,
			Size = Size,
			Parent = Container
		})

		local ImageData = {
			Type = "Image",
			Container = Container,
			Holder = Image
		}

		New("UIStroke", {
			Color = "OutlineColor",
			Transparency = 0,
			Parent = Image,
		})
		New("UICorner", {
			CornerRadius = UDim.new(0, Library.CornerRadius / 2),
			Parent = Image,
		})
		New("UIAspectRatioConstraint", {
			Parent = Image,
			AspectType = AspectType,
			AspectRatio = 1
		})

		table.insert(self.Elements, ImageData)

		return Image
	end

	function Funcs:AddViewport(Idx, Info)
		local Container = self.Container

		local Model = Info.Model
		local Clone = Info.Clone

		local Camera = New("Camera", {
			CFrame = CFrame.new(0,0,0)
		})

		local Viewport = New("ViewportFrame", {
			CurrentCamera = Camera,
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 1,
			Parent = Container
		})

		local ViewportData = {
			Type = "Viewport",
			Container = Container,
			Holder = Viewport
		}

		New("UIStroke", {
			Color = "OutlineColor",
			Transparency = 0,
			Parent = Viewport,
		})

		New("UICorner", {
			CornerRadius = UDim.new(0, Library.CornerRadius / 2),
			Parent = Viewport,
		})

		New("UIAspectRatioConstraint", {
			Parent = Viewport,
			AspectType = Enum.AspectType.ScaleWithParentSize,
			AspectRatio = 1
		})

		local Original = Model
		local Archivable = Original.Archivable
		Original.Archivable = true

		--// Clone model
		if Clone then
			Model = Original:Clone()
		end

		Original.Archivable = Archivable
		Model.Parent = Viewport

		Info.Model = Model
		Info.Camera = Camera

		table.insert(self.Elements, ViewportData)

		return Info
	end

	function Funcs:AddToggle(Idx, Info)
		if Library.ForceCheckbox then
			return Funcs.AddCheckbox(self, Idx, Info)
		end

		Info = Library:Validate(Info, Templates.Toggle)

		local Groupbox = self
		local Container = Groupbox.Container

		local Toggle = {
			Text = Info.Text,
			Value = Info.Default,

			Tooltip = Info.Tooltip,
			DisabledTooltip = Info.DisabledTooltip,
			TooltipTable = nil,

			Callback = Info.Callback,
			Changed = Info.Changed,

			Risky = Info.Risky,
			Disabled = Info.Disabled,
			Visible = Info.Visible,
			Addons = {},

			Type = "Toggle",
		}

		local Button = New("TextButton", {
			Active = not Toggle.Disabled,
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 18),
			Text = "",
			Visible = Toggle.Visible,
			Parent = Container,
		})

		local Label = New("TextLabel", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, -40, 1, 0),
			Text = Toggle.Text,
			TextSize = 14,
			TextTransparency = 0.4,
			TextXAlignment = Enum.TextXAlignment.Left,
			Parent = Button,
		})

		New("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = Enum.HorizontalAlignment.Right,
			Padding = UDim.new(0, 6),
			Parent = Label,
		})

		local Switch = New("Frame", {
			AnchorPoint = Vector2.new(1, 0),
			BackgroundColor3 = "MainColor",
			Position = UDim2.fromScale(1, 0),
			Size = UDim2.fromOffset(32, 18),
			Parent = Button,
		})
		New("UICorner", {
			CornerRadius = UDim.new(1, 0),
			Parent = Switch,
		})
		New("UIPadding", {
			PaddingBottom = UDim.new(0, 2),
			PaddingLeft = UDim.new(0, 2),
			PaddingRight = UDim.new(0, 2),
			PaddingTop = UDim.new(0, 2),
			Parent = Switch,
		})
		local SwitchStroke = New("UIStroke", {
			Color = "OutlineColor",
			Parent = Switch,
		})

		local Ball = New("Frame", {
			BackgroundColor3 = "FontColor",
			Size = UDim2.fromScale(1, 1),
			SizeConstraint = Enum.SizeConstraint.RelativeYY,
			Parent = Switch,
		})
		New("UICorner", {
			CornerRadius = UDim.new(1, 0),
			Parent = Ball,
		})

		function Toggle:UpdateColors()
			Toggle:Display()
		end

		function Toggle:Display()
			local Offset = Toggle.Value and 1 or 0

			Switch.BackgroundTransparency = Toggle.Disabled and 0.75 or 0
			SwitchStroke.Transparency = Toggle.Disabled and 0.75 or 0

			Switch.BackgroundColor3 = Toggle.Value and Library.Scheme.AccentColor or Library.Scheme.MainColor
			SwitchStroke.Color = Toggle.Value and Library.Scheme.AccentColor or Library.Scheme.OutlineColor

			Library.Registry[Switch].BackgroundColor3 = Toggle.Value and "AccentColor" or "MainColor"
			Library.Registry[SwitchStroke].Color = Toggle.Value and "AccentColor" or "OutlineColor"

			if Toggle.Disabled then
				Label.TextTransparency = 0.8
				Ball.AnchorPoint = Vector2.new(Offset, 0)
				Ball.Position = UDim2.fromScale(Offset, 0)

				Ball.BackgroundColor3 = Library:GetDarkerColor(Library.Scheme.FontColor)
				Library.Registry[Ball].BackgroundColor3 = function()
					return Library:GetDarkerColor(Library.Scheme.FontColor)
				end

				return
			end

			TweenService:Create(Label, Library.TweenInfo, {
				TextTransparency = Toggle.Value and 0 or 0.4,
			}):Play()
			TweenService:Create(Ball, Library.TweenInfo, {
				AnchorPoint = Vector2.new(Offset, 0),
				Position = UDim2.fromScale(Offset, 0),
			}):Play()

			Ball.BackgroundColor3 = Library.Scheme.FontColor
			Library.Registry[Ball].BackgroundColor3 = "FontColor"
		end

		function Toggle:OnChanged(Func)
			Toggle.Changed = Func
		end

		function Toggle:SetValue(Value)
			if Toggle.Disabled then
				return
			end

			Toggle.Value = Value
			Toggle:Display()

			for _, Addon in pairs(Toggle.Addons) do
				if Addon.Type == "KeyPicker" and Addon.SyncToggleState then
					Addon.Toggled = Toggle.Value
					Addon:Update()
				end
			end

			Library:SafeCallback(Toggle.Callback, Toggle.Value)
			Library:SafeCallback(Toggle.Changed, Toggle.Value)
		end

		function Toggle:SetDisabled(Disabled: boolean)
			Toggle.Disabled = Disabled

			if Toggle.TooltipTable then
				Toggle.TooltipTable.Disabled = Toggle.Disabled
			end

			for _, Addon in pairs(Toggle.Addons) do
				if Addon.Type == "KeyPicker" and Addon.SyncToggleState then
					Addon:Update()
				end
			end

			Button.Active = not Toggle.Disabled
			Toggle:Display()
		end

		function Toggle:SetVisible(Visible: boolean)
			Toggle.Visible = Visible
			Button.Visible = Toggle.Visible
		end

		function Toggle:SetText(Text: string)
			Toggle.Text = Text
			Label.Text = Text
		end

		Button.MouseButton1Click:Connect(function()
			if Toggle.Disabled then
				return
			end

			Toggle:SetValue(not Toggle.Value)
		end)

		if typeof(Toggle.Tooltip) == "string" or typeof(Toggle.DisabledTooltip) == "string" then
			Toggle.TooltipTable = Library:AddTooltip(Toggle.Tooltip, Toggle.DisabledTooltip, Button)
			Toggle.TooltipTable.Disabled = Toggle.Disabled
		end

		if Toggle.Risky then
			Label.TextColor3 = Library.Scheme.Red
			Library.Registry[Label].TextColor3 = "Red"
		end

		Toggle:Display()

		Toggle.TextLabel = Label
		Toggle.Container = Container
		setmetatable(Toggle, BaseAddons)

		Toggle.Holder = Button
		table.insert(Groupbox.Elements, Toggle)

		Toggles[Idx] = Toggle

		return Toggle
	end

	function Funcs:AddInput(Idx, Info)
		Info = Library:Validate(Info, Templates.Input)

		local Groupbox = self
		local Container = Groupbox.Container

		local Input = {
			Text = Info.Text,
			Value = Info.Default,
			Finished = Info.Finished,
			Numeric = Info.Numeric,
			ClearTextOnFocus = Info.ClearTextOnFocus,
			Placeholder = Info.Placeholder,
			AllowEmpty = Info.AllowEmpty,
			EmptyReset = Info.EmptyReset,

			Tooltip = Info.Tooltip,
			DisabledTooltip = Info.DisabledTooltip,
			TooltipTable = nil,

			Callback = Info.Callback,
			Changed = Info.Changed,

			Disabled = Info.Disabled,
			Visible = Info.Visible,

			Type = "Input",
		}

		local Holder = New("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 39),
			Visible = Input.Visible,
			Parent = Container,
		})

		local Label = New("TextLabel", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 14),
			Text = Input.Text,
			TextSize = 14,
			TextXAlignment = Enum.TextXAlignment.Left,
			Parent = Holder,
		})

		local Box = New("TextBox", {
			AnchorPoint = Vector2.new(0, 1),
			BackgroundColor3 = "MainColor",
			BorderColor3 = "OutlineColor",
			BorderSizePixel = 1,
			ClearTextOnFocus = not Input.Disabled and Input.ClearTextOnFocus,
			PlaceholderText = Input.Placeholder,
			Position = UDim2.fromScale(0, 1),
			Size = UDim2.new(1, 0, 0, 21),
			Text = Input.Value,
			TextEditable = not Input.Disabled,
			TextScaled = true,
			TextXAlignment = Enum.TextXAlignment.Left,
			Parent = Holder,
		})

		New("UIPadding", {
			PaddingBottom = UDim.new(0, 3),
			PaddingLeft = UDim.new(0, 8),
			PaddingRight = UDim.new(0, 8),
			PaddingTop = UDim.new(0, 4),
			Parent = Box,
		})

		function Input:UpdateColors()
			Label.TextTransparency = Input.Disabled and 0.8 or 0
			Box.TextTransparency = Input.Disabled and 0.8 or 0
		end

		function Input:OnChanged(Func)
			Input.Changed = Func
		end

		function Input:SetValue(Text)
			if not Input.AllowEmpty and Trim(Text) == "" then
				Text = Input.EmptyReset
			end

			if Info.MaxLength and #Text > Info.MaxLength then
				Text = Text:sub(1, Info.MaxLength)
			end

			if Input.Numeric then
				if #Text > 0 and not tonumber(Text) then
					Text = Input.Value
				end
			end

			Input.Value = Text
			Box.Text = Text

			if not Input.Disabled then
				Library:SafeCallback(Input.Callback, Input.Value)
				Library:SafeCallback(Input.Changed, Input.Value)
			end
		end

		function Input:SetDisabled(Disabled: boolean)
			Input.Disabled = Disabled

			if Input.TooltipTable then
				Input.TooltipTable.Disabled = Input.Disabled
			end

			Box.ClearTextOnFocus = not Input.Disabled and Input.ClearTextOnFocus
			Box.TextEditable = not Input.Disabled
			Input:UpdateColors()
		end

		function Input:SetVisible(Visible: boolean)
			Input.Visible = Visible
			Holder.Visible = Input.Visible
		end

		function Input:SetText(Text: string)
			Input.Text = Text
			Label.Text = Text
		end

		if Input.Finished then
			Box.FocusLost:Connect(function(Enter)
				if not Enter then
					return
				end

				Input:SetValue(Box.Text)
			end)
		else
			Box:GetPropertyChangedSignal("Text"):Connect(function()
				Input:SetValue(Box.Text)
			end)
		end

		if typeof(Input.Tooltip) == "string" or typeof(Input.DisabledTooltip) == "string" then
			Input.TooltipTable = Library:AddTooltip(Input.Tooltip, Input.DisabledTooltip, Box)
			Input.TooltipTable.Disabled = Input.Disabled
		end

		Input.Holder = Holder
		table.insert(Groupbox.Elements, Input)

		Options[Idx] = Input

		return Input
	end

	function Funcs:AddSlider(Idx, Info)
		Info = Library:Validate(Info, Templates.Slider)

		local Groupbox = self
		local Container = Groupbox.Container

		local Slider = {
			Text = Info.Text,
			Value = Info.Default,
			Min = Info.Min,
			Max = Info.Max,

			Prefix = Info.Prefix,
			Suffix = Info.Suffix,

			Tooltip = Info.Tooltip,
			DisabledTooltip = Info.DisabledTooltip,
			TooltipTable = nil,

			Callback = Info.Callback,
			Changed = Info.Changed,

			Disabled = Info.Disabled,
			Visible = Info.Visible,

			Type = "Slider",
		}

		local Holder = New("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, Info.Compact and 13 or 31),
			Visible = Slider.Visible,
			Parent = Container,
		})

		local SliderLabel
		if not Info.Compact then
			SliderLabel = New("TextLabel", {
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, 14),
				Text = Slider.Text,
				TextSize = 14,
				TextXAlignment = Enum.TextXAlignment.Left,
				Parent = Holder,
			})
		end

		local Bar = New("TextButton", {
			Active = not Slider.Disabled,
			AnchorPoint = Vector2.new(0, 1),
			BackgroundColor3 = "MainColor",
			BorderColor3 = "OutlineColor",
			BorderSizePixel = 1,
			Position = UDim2.fromScale(0, 1),
			Size = UDim2.new(1, 0, 0, 13),
			Text = "",
			Parent = Holder,
		})

		local DisplayLabel = New("TextLabel", {
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 1),
			Text = "",
			TextSize = 14,
			ZIndex = 2,
			Parent = Bar,
		})
		New("UIStroke", {
			ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual,
			Color = "Dark",
			LineJoinMode = Enum.LineJoinMode.Miter,
			Parent = DisplayLabel,
		})

		local Fill = New("Frame", {
			BackgroundColor3 = "AccentColor",
			Size = UDim2.fromScale(0.5, 1),
			Parent = Bar,

			DPIExclude = {
				Size = true,
			},
		})

		function Slider:UpdateColors()
			if SliderLabel then
				SliderLabel.TextTransparency = Slider.Disabled and 0.8 or 0
			end
			DisplayLabel.TextTransparency = Slider.Disabled and 0.8 or 0

			Fill.BackgroundColor3 = Slider.Disabled and Library.Scheme.OutlineColor or Library.Scheme.AccentColor
			Library.Registry[Fill].BackgroundColor3 = Slider.Disabled and "OutlineColor" or "AccentColor"
		end

		function Slider:Display()
			if Info.Compact then
				DisplayLabel.Text = string.format("%s: %s%s%s", Slider.Text, Slider.Prefix, Slider.Value, Slider.Suffix)
			elseif Info.HideMax then
				DisplayLabel.Text = string.format("%s%s%s", Slider.Prefix, Slider.Value, Slider.Suffix)
			else
				DisplayLabel.Text = string.format(
					"%s%s%s/%s%s%s",
					Slider.Prefix,
					Slider.Value,
					Slider.Suffix,
					Slider.Prefix,
					Slider.Max,
					Slider.Suffix
				)
			end

			local X = (Slider.Value - Slider.Min) / (Slider.Max - Slider.Min)
			Fill.Size = UDim2.fromScale(X, 1)
		end

		function Slider:OnChanged(Func)
			Slider.Changed = Func
		end

		local function Round(Value)
			if Info.Rounding == 0 then
				return math.floor(Value)
			end

			return tonumber(string.format("%." .. Info.Rounding .. "f", Value))
		end

		function Slider:SetMax(Value)
			assert(Value > Slider.Min, "Max value cannot be less than the current min value.")

			Slider.Value = math.clamp(Slider.Value, Slider.Min, Value)
			Slider.Max = Value
			Slider:Display()
		end

		function Slider:SetMin(Value)
			assert(Value < Slider.Max, "Min value cannot be greater than the current max value.")

			Slider.Value = math.clamp(Slider.Value, Value, Slider.Max)
			Slider.Min = Value
			Slider:Display()
		end

		function Slider:SetValue(Str)
			if Slider.Disabled then
				return
			end

			local Num = tonumber(Str)
			if not Num then
				return
			end

			Num = math.clamp(Num, Slider.Min, Slider.Max)

			Slider.Value = Num
			Slider:Display()

			Library:SafeCallback(Slider.Callback, Slider.Value)
			Library:SafeCallback(Slider.Changed, Slider.Value)
		end

		function Slider:SetDisabled(Disabled: boolean)
			Slider.Disabled = Disabled

			if Slider.TooltipTable then
				Slider.TooltipTable.Disabled = Slider.Disabled
			end

			Bar.Active = not Slider.Disabled
			Slider:UpdateColors()
		end

		function Slider:SetVisible(Visible: boolean)
			Slider.Visible = Visible
			Holder.Visible = Slider.Visible
		end

		function Slider:SetText(Text: string)
			Slider.Text = Text
			if SliderLabel then
				SliderLabel.Text = Text
				return
			end
			Slider:Display()
		end

		function Slider:SetPrefix(Prefix: string)
			Slider.Prefix = Prefix
			Slider:Display()
		end

		function Slider:SetSuffix(Suffix: string)
			Slider.Suffix = Suffix
			Slider:Display()
		end

		Bar.MouseButton1Down:Connect(function()
			if Slider.Disabled then
				return
			end

			for _, Side in pairs(Library.ActiveTab.Sides) do
				Side.ScrollingEnabled = false
			end

			while UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1 or Enum.UserInputType.Touch) do
				local Location = Mouse.X
				local Scale = math.clamp((Location - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)

				local OldValue = Slider.Value
				Slider.Value = Round(Slider.Min + ((Slider.Max - Slider.Min) * Scale))

				Slider:Display()
				if Slider.Value ~= OldValue then
					Library:SafeCallback(Slider.Callback, Slider.Value)
					Library:SafeCallback(Slider.Changed, Slider.Value)
				end

				RunService.RenderStepped:Wait()
			end

			for _, Side in pairs(Library.ActiveTab.Sides) do
				Side.ScrollingEnabled = true
			end
		end)

		if typeof(Slider.Tooltip) == "string" or typeof(Slider.DisabledTooltip) == "string" then
			Slider.TooltipTable = Library:AddTooltip(Slider.Tooltip, Slider.DisabledTooltip, Bar)
			Slider.TooltipTable.Disabled = Slider.Disabled
		end

		Slider:UpdateColors()
		Slider:Display()

		Slider.Holder = Holder
		table.insert(Groupbox.Elements, Slider)

		Options[Idx] = Slider

		return Slider
	end

	function Funcs:AddDropdown(Idx, Info)
		Info = Library:Validate(Info, Templates.Dropdown)

		local Groupbox = self
		local Container = Groupbox.Container

		if Info.SpecialType == "Player" then
			Info.Values = GetPlayers(Info.ExcludeLocalPlayer)
			Info.AllowNull = true
		elseif Info.SpecialType == "Team" then
			Info.Values = GetTeams()
			Info.AllowNull = true
		end
		local Dropdown = {
			Text = typeof(Info.Text) == "string" and Info.Text or nil,
			Value = Info.Multi and {},
			Values = Info.Values,
			DisabledValues = Info.DisabledValues,

			SpecialType = Info.SpecialType,
			ExcludeLocalPlayer = Info.ExcludeLocalPlayer,

			Tooltip = Info.Tooltip,
			DisabledTooltip = Info.DisabledTooltip,
			TooltipTable = nil,

			Callback = Info.Callback,
			Changed = Info.Changed,

			Disabled = Info.Disabled,
			Visible = Info.Visible,

			Type = "Dropdown",
		}

		local Holder = New("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, Dropdown.Text and 39 or 21),
			Visible = Dropdown.Visible,
			Parent = Container,
		})

		local Label = New("TextLabel", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 14),
			Text = Dropdown.Text,
			TextSize = 14,
			TextXAlignment = Enum.TextXAlignment.Left,
			Visible = not not Info.Text,
			Parent = Holder,
		})

		local Display = New("TextButton", {
			Active = not Dropdown.Disabled,
			AnchorPoint = Vector2.new(0, 1),
			BackgroundColor3 = "MainColor",
			BorderColor3 = "OutlineColor",
			BorderSizePixel = 1,
			Position = UDim2.fromScale(0, 1),
			Size = UDim2.new(1, 0, 0, 21),
			Text = "---",
			TextSize = 14,
			TextXAlignment = Enum.TextXAlignment.Left,
			Parent = Holder,
		})

		New("UIPadding", {
			PaddingLeft = UDim.new(0, 8),
			PaddingRight = UDim.new(0, 4),
			Parent = Display,
		})

		local ArrowImage = New("ImageLabel", {
			AnchorPoint = Vector2.new(1, 0.5),
			Image = ArrowIcon and ArrowIcon.Url or "",
			ImageColor3 = "FontColor",
			ImageRectOffset = ArrowIcon and ArrowIcon.ImageRectOffset or Vector2.zero,
			ImageRectSize = ArrowIcon and ArrowIcon.ImageRectSize or Vector2.zero,
			ImageTransparency = 0.5,
			Position = UDim2.fromScale(1, 0.5),
			Size = UDim2.fromOffset(16, 16),
			Parent = Display,
		})

		local SearchBox
		if Info.Searchable then
			SearchBox = New("TextBox", {
				BackgroundTransparency = 1,
				PlaceholderText = "Search...",
				Position = UDim2.fromOffset(-8, 0),
				Size = UDim2.new(1, -12, 1, 0),
				TextSize = 14,
				TextXAlignment = Enum.TextXAlignment.Left,
				Visible = false,
				Parent = Display,
			})
			New("UIPadding", {
				PaddingLeft = UDim.new(0, 8),
				Parent = SearchBox,
			})
		end

		local MenuTable = Library:AddContextMenu(
			Display,
			function()
				return UDim2.fromOffset(Display.AbsoluteSize.X, 0)
			end,
			function()
				return { 0.5, Display.AbsoluteSize.Y + 1.5 }
			end,
			2,
			function(Active: boolean)
				Display.TextTransparency = (Active and SearchBox) and 1 or 0
				ArrowImage.ImageTransparency = Active and 0 or 0.5
				ArrowImage.Rotation = Active and 180 or 0
				if SearchBox then
					SearchBox.Text = ""
					SearchBox.Visible = Active
				end
			end
		)
		Dropdown.Menu = MenuTable
		Library:UpdateDPI(MenuTable.Menu, {
			Position = false,
			Size = false,
		})

		function Dropdown:RecalculateListSize(Count)
			local Y = math.clamp(
				(Count or GetTableSize(Dropdown.Values)) * (21 * Library.DPIScale),
				0,
				Info.MaxVisibleDropdownItems * (21 * Library.DPIScale)
			)

			MenuTable:SetSize(function()
				return UDim2.fromOffset(Display.AbsoluteSize.X, Y)
			end)
		end

		function Dropdown:UpdateColors()
			Label.TextTransparency = Dropdown.Disabled and 0.8 or 0
			Display.TextTransparency = Dropdown.Disabled and 0.8 or 0
			ArrowImage.ImageTransparency = Dropdown.Disabled and 0.8 or MenuTable.Active and 0 or 0.5
		end

		function Dropdown:Display()
			local Str = ""

			if Info.Multi then
				for _, Value in pairs(Dropdown.Values) do
					if Dropdown.Value[Value] then
						Str = Str
							.. (Info.FormatDisplayValue and tostring(Info.FormatDisplayValue(Value)) or tostring(Value))
							.. ", "
					end
				end

				Str = Str:sub(1, #Str - 2)
			else
				Str = Dropdown.Value and tostring(Dropdown.Value) or ""
				if Str ~= "" and Info.FormatDisplayValue then
					Str = tostring(Info.FormatDisplayValue(Str))
				end
			end

			if #Str > 25 then
				Str = Str:sub(1, 22) .. "..."
			end

			Display.Text = (Str == "" and "---" or Str)
		end

		function Dropdown:OnChanged(Func)
			Dropdown.Changed = Func
		end

		function Dropdown:GetActiveValues()
			if Info.Multi then
				local Table = {}

				for Value, _ in pairs(Dropdown.Value) do
					table.insert(Table, Value)
				end

				return Table
			end

			return Dropdown.Value and 1 or 0
		end

		local Buttons = {}
		function Dropdown:BuildDropdownList()
			local Values = Dropdown.Values
			local DisabledValues = Dropdown.DisabledValues

			for Button, _ in pairs(Buttons) do
				Button:Destroy()
			end
			table.clear(Buttons)

			local Count = 0
			for _, Value in pairs(Values) do
				if SearchBox and not tostring(Value):lower():match(SearchBox.Text:lower()) then
					continue
				end

				Count += 1
				local IsDisabled = table.find(DisabledValues, Value)
				local Table = {}

				local Button = New("TextButton", {
					BackgroundColor3 = "MainColor",
					BackgroundTransparency = 1,
					LayoutOrder = IsDisabled and 1 or 0,
					Size = UDim2.new(1, 0, 0, 21),
					Text = tostring(Value),
					TextSize = 14,
					TextTransparency = 0.5,
					TextXAlignment = Enum.TextXAlignment.Left,
					Parent = MenuTable.Menu,
				})
				New("UIPadding", {
					PaddingLeft = UDim.new(0, 7),
					PaddingRight = UDim.new(0, 7),
					Parent = Button,
				})

				local Selected
				if Info.Multi then
					Selected = Dropdown.Value[Value]
				else
					Selected = Dropdown.Value == Value
				end

				function Table:UpdateButton()
					if Info.Multi then
						Selected = Dropdown.Value[Value]
					else
						Selected = Dropdown.Value == Value
					end

					Button.BackgroundTransparency = Selected and 0 or 1
					Button.TextTransparency = IsDisabled and 0.8 or Selected and 0 or 0.5
				end

				if not IsDisabled then
					Button.MouseButton1Click:Connect(function()
						local Try = not Selected

						if not (Dropdown:GetActiveValues() == 1 and not Try and not Info.AllowNull) then
							Selected = Try
							if Info.Multi then
								Dropdown.Value[Value] = Selected and true or nil
							else
								Dropdown.Value = Selected and Value or nil
							end

							for _, OtherButton in pairs(Buttons) do
								OtherButton:UpdateButton()
							end
						end

						Table:UpdateButton()
						Dropdown:Display()

						Library:SafeCallback(Dropdown.Callback, Dropdown.Value)
						Library:SafeCallback(Dropdown.Changed, Dropdown.Value)
					end)
				end

				Table:UpdateButton()
				Dropdown:Display()

				Buttons[Button] = Table
			end

			Dropdown:RecalculateListSize(Count)
		end

		function Dropdown:SetValue(Value)
			if Info.Multi then
				local Table = {}

				for Val, Active in pairs(Value or {}) do
					if Active and table.find(Dropdown.Values, Val) then
						Table[Val] = true
					end
				end

				Dropdown.Value = Table
			else
				if table.find(Dropdown.Values, Value) then
					Dropdown.Value = Value
				elseif not Value then
					Dropdown.Value = nil
				end
			end

			Dropdown:Display()
			for _, Button in pairs(Buttons) do
				Button:UpdateButton()
			end

			if not Dropdown.Disabled then
				Library:SafeCallback(Dropdown.Callback, Dropdown.Value)
				Library:SafeCallback(Dropdown.Changed, Dropdown.Value)
			end
		end

		function Dropdown:SetValues(Values)
			Dropdown.Values = Values
			Dropdown:BuildDropdownList()
		end

		function Dropdown:AddValues(Values)
			if typeof(Values) == "table" then
				for _, val in pairs(Values) do
					table.insert(Dropdown.Values, val)
				end
			elseif typeof(Values) == "string" then
				table.insert(Dropdown.Values, Values)
			else
				return
			end

			Dropdown:BuildDropdownList()
		end

		function Dropdown:SetDisabledValues(DisabledValues)
			Dropdown.DisabledValues = DisabledValues
			Dropdown:BuildDropdownList()
		end

		function Dropdown:AddDisabledValues(DisabledValues)
			if typeof(DisabledValues) == "table" then
				for _, val in pairs(DisabledValues) do
					table.insert(Dropdown.DisabledValues, val)
				end
			elseif typeof(DisabledValues) == "string" then
				table.insert(Dropdown.DisabledValues, DisabledValues)
			else
				return
			end

			Dropdown:BuildDropdownList()
		end

		function Dropdown:SetDisabled(Disabled: boolean)
			Dropdown.Disabled = Disabled

			if Dropdown.TooltipTable then
				Dropdown.TooltipTable.Disabled = Dropdown.Disabled
			end

			MenuTable:Close()
			Display.Active = not Dropdown.Disabled
			Dropdown:UpdateColors()
		end

		function Dropdown:SetVisible(Visible: boolean)
			Dropdown.Visible = Visible
			Holder.Visible = Dropdown.Visible
		end

		function Dropdown:SetText(Text: string)
			Dropdown.Text = Text
			Holder.Size = UDim2.new(1, 0, 0, (Text and 39 or 21) * Library.DPIScale)

			Label.Text = Text and Text or ""
			Label.Visible = not not Text
		end

		Display.MouseButton1Click:Connect(function()
			if Dropdown.Disabled then
				return
			end

			MenuTable:Toggle()
		end)

		if SearchBox then
			SearchBox:GetPropertyChangedSignal("Text"):Connect(Dropdown.BuildDropdownList)
		end

		local Defaults = {}
		if typeof(Info.Default) == "string" then
			local Index = table.find(Dropdown.Values, Info.Default)
			if Index then
				table.insert(Defaults, Index)
			end
		elseif typeof(Info.Default) == "table" then
			for _, Value in next, Info.Default do
				local Index = table.find(Dropdown.Values, Value)
				if Index then
					table.insert(Defaults, Index)
				end
			end
		elseif Dropdown.Values[Info.Default] ~= nil then
			table.insert(Defaults, Info.Default)
		end
		if next(Defaults) then
			for i = 1, #Defaults do
				local Index = Defaults[i]
				if Info.Multi then
					Dropdown.Value[Dropdown.Values[Index]] = true
				else
					Dropdown.Value = Dropdown.Values[Index]
				end

				if not Info.Multi then
					break
				end
			end
		end

		if typeof(Dropdown.Tooltip) == "string" or typeof(Dropdown.DisabledTooltip) == "string" then
			Dropdown.TooltipTable = Library:AddTooltip(Dropdown.Tooltip, Dropdown.DisabledTooltip, Display)
			Dropdown.TooltipTable.Disabled = Dropdown.Disabled
		end

		Dropdown:UpdateColors()
		Dropdown:Display()
		Dropdown:BuildDropdownList()
		Dropdown.Holder = Holder
		table.insert(Groupbox.Elements, Dropdown)

		Options[Idx] = Dropdown

		return Dropdown
	end

	BaseGroupbox.__index = Funcs
	BaseGroupbox.__namecall = function(_, Key, ...)
		return Funcs[Key](...)
	end
end

function Library:SetFont(FontFace)
	if typeof(FontFace) == "EnumItem" then
		FontFace = Font.fromEnum(FontFace)
	end

	Library.Scheme.Font = FontFace
	Library:UpdateColorsUsingRegistry()
end

function Library:SetNotifySide(Side: string)
	Library.NotifySide = Side

	if Side:lower() == "left" then
		NotificationArea.AnchorPoint = Vector2.new(0, 0)
		NotificationArea.Position = UDim2.fromOffset(6, 6)
		NotificationList.HorizontalAlignment = Enum.HorizontalAlignment.Left
	else
		NotificationArea.AnchorPoint = Vector2.new(1, 0)
		NotificationArea.Position = UDim2.new(1, -6, 0, 6)
		NotificationList.HorizontalAlignment = Enum.HorizontalAlignment.Right
	end
end

function Library:Watermark(...)
	local Container = self.WatermarksFrame

	local Background, Outline = Library:MakeOutline(Container, Library.CornerRadius, 5)
	Background.AutomaticSize = Enum.AutomaticSize.XY
	Background.Size = UDim2.fromOffset(0, 0)
	Outline.Size = UDim2.new(1, 0, 1, 0)
	Library:UpdateDPI(Background, {
		Position = false,
		Size = false,
	})

	local Holder = New("Frame", {
		BackgroundColor3 = "BackgroundColor",
		Position = UDim2.fromOffset(0,0),
		Size = UDim2.new(1, 0, 1, 0),
		Parent = Outline,
	})
	New("UICorner", {
		CornerRadius = UDim.new(0, Library.CornerRadius - 1),
		Parent = Holder,
	})
	New("UIListLayout", {
		Padding = UDim.new(0, 4),
		Parent = Holder,
	})
	New("UIPadding", {
		PaddingBottom = UDim.new(0, 8),
		PaddingLeft = UDim.new(0, 8),
		PaddingRight = UDim.new(0, 8),
		PaddingTop = UDim.new(0, 8),
		Parent = Holder,
	})

	local Canvas = {
		Holder = Background,
		Elements = {},
		Container = Holder,
		NoExpanding = true
	}
	setmetatable(Canvas, BaseGroupbox)
	
	function Canvas:Remove()
		Background:Destroy()
	end
	function Canvas:SetVisible(Visible)
		Background.Visible = Visible
	end

	return Canvas
end

function Library:Notify(...)
	local Data = {}
	local Info = select(1, ...)

	if typeof(Info) == "table" then
		Data.Title = tostring(Info.Title)
		Data.Description = tostring(Info.Description)
		Data.Time = Info.Time or 5
		Data.SoundId = Info.SoundId
		Data.Steps = Info.Steps
	else
		Data.Description = tostring(Info)
		Data.Time = select(2, ...) or 5
		Data.SoundId = select(3, ...)
	end

	local FakeBackground = New("Frame", {
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 0),
		Visible = false,
		Parent = NotificationArea,

		DPIExclude = {
			Size = true,
		},
	})

	local Background = Library:MakeOutline(FakeBackground, Library.CornerRadius, 5)
	Background.AutomaticSize = Enum.AutomaticSize.Y
	Background.Position = Library.NotifySide:lower() == "left" and UDim2.new(-1, -6, 0, -2) or UDim2.new(1, 6, 0, -2)
	Background.Size = UDim2.fromScale(1, 0)
	Library:UpdateDPI(Background, {
		Position = false,
		Size = false,
	})

	local Holder = New("Frame", {
		BackgroundColor3 = "BackgroundColor",
		Position = UDim2.fromOffset(1, 1),
		Size = UDim2.new(1, -2, 1, -2),
		Parent = Background,
	})
	New("UICorner", {
		CornerRadius = UDim.new(0, Library.CornerRadius - 1),
		Parent = Holder,
	})
	New("UIListLayout", {
		Padding = UDim.new(0, 4),
		Parent = Holder,
	})
	New("UIPadding", {
		PaddingBottom = UDim.new(0, 8),
		PaddingLeft = UDim.new(0, 8),
		PaddingRight = UDim.new(0, 8),
		PaddingTop = UDim.new(0, 8),
		Parent = Holder,
	})

	local Title
	local Desc
	local TitleX = 0
	local DescX = 0

	local TimerFill

	if Data.Title then
		Title = New("TextLabel", {
			BackgroundTransparency = 1,
			Text = `◆ {Data.Title}`,
			TextSize = 15,
			TextColor3 = "AccentColor",
			TextXAlignment = Enum.TextXAlignment.Left,
			TextWrapped = true,
			Parent = Holder,

			DPIExclude = {
				Size = true,
			},
		})
	end
	if Data.Description then
		Desc = New("TextLabel", {
			BackgroundTransparency = 1,
			Text = Data.Description,
			TextSize = 14,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextWrapped = true,
			Parent = Holder,

			DPIExclude = {
				Size = true,
			},
		})
	end

	function Data:Resize()
		if Title then
			local X, Y = Library:GetTextBounds(
				Title.Text,
				Title.FontFace,
				Title.TextSize,
				NotificationArea.AbsoluteSize.X - (24 * Library.DPIScale)
			)
			Title.Size = UDim2.fromOffset(math.ceil(X), Y)
			TitleX = X
		end

		if Desc then
			local X, Y = Library:GetTextBounds(
				Desc.Text,
				Desc.FontFace,
				Desc.TextSize,
				NotificationArea.AbsoluteSize.X - (24 * Library.DPIScale)
			)
			Desc.Size = UDim2.fromOffset(math.ceil(X), Y)
			DescX = X
		end

		FakeBackground.Size = UDim2.fromOffset((TitleX > DescX and TitleX or DescX) + (24 * Library.DPIScale), 0)
	end

	function Data:ChangeTitle(NewText)
		if Title then
			Data.Title = tostring(NewText)
			Title.Text = Data.Title
			Data:Resize()
		end
	end

	function Data:ChangeDescription(NewText)
		if Desc then
			Data.Description = tostring(NewText)
			Desc.Text = Data.Description
			Data:Resize()
		end
	end

	function Data:ChangeStep(NewStep)
		if TimerFill and Data.Steps then
			NewStep = math.clamp(NewStep or 0, 0, Data.Steps)
			TimerFill.Size = UDim2.fromScale(NewStep / Data.Steps, 1)
		end
	end

	Data:Resize()

	local TimerHolder = New("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 7),
		Visible = typeof(Data.Time) ~= "Instance" or typeof(Data.Steps) == "number",
		Parent = Holder,
	})
	local TimerBar = New("Frame", {
		BackgroundColor3 = "BackgroundColor",
		BorderColor3 = "OutlineColor",
		BorderSizePixel = 1,
		Position = UDim2.fromOffset(0, 3),
		Size = UDim2.new(1, 0, 0, 2),
		Parent = TimerHolder,
	})
	TimerFill = New("Frame", {
		BackgroundColor3 = "AccentColor",
		Size = UDim2.fromScale(1, 1),
		Parent = TimerBar,
	})

	if typeof(Data.Time) == "Instance" then
		TimerFill.Size = UDim2.fromScale(0, 1)
	end
	if Data.SoundId then
		New("Sound", {
			SoundId = "rbxassetid://" .. tostring(Data.SoundId):gsub("rbxassetid://", ""),
			Volume = 3,
			PlayOnRemove = true,
			Parent = SoundService,
		}):Destroy()
	end

	Library.Notifications[FakeBackground] = Data

	FakeBackground.Visible = true
	TweenService:Create(Background, Library.NotifyTweenInfo, {
		Position = UDim2.fromOffset(-2, -2),
	}):Play()

	task.delay(Library.NotifyTweenInfo.Time, function()
		if typeof(Data.Time) == "Instance" then
			Data.Time.Destroying:Wait()
		else
			TweenService
				:Create(TimerFill, TweenInfo.new(Data.Time, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), {
					Size = UDim2.fromScale(0, 1),
				})
				:Play()
			task.wait(Data.Time)
		end

		TweenService:Create(Background, Library.NotifyTweenInfo, {
			Position = Library.NotifySide:lower() == "left" and UDim2.new(-1, -6, 0, -2) or UDim2.new(1, 6, 0, -2),
		}):Play()
		task.delay(Library.NotifyTweenInfo.Time, function()
			Library.Notifications[FakeBackground] = nil
			FakeBackground:Destroy()
		end)
	end)

	return Data
end

function Library:CreateChangableWindow(WindowInfo)
	WindowInfo = Library:Validate(WindowInfo, Templates.LoaderWindow)

	local Icon = WindowInfo.Icon
	local FillScreen = WindowInfo.FillScreen
	local Parent = ScreenGui
	
	--// Modal style
	if WindowInfo.Modal then
		Parent = New("Frame", {
			BackgroundColor3 = "BackgroundColor",
			BackgroundTransparency = 0.3,
			Name = "Modal",
			Size = UDim2.fromScale(1, 1),
			Parent = ScreenGui,
			ZIndex = 5,
		})
	end

	local Background, Outline = Library:MakeOutline(Parent, Library.CornerRadius, 5)
	Background.AutomaticSize = Enum.AutomaticSize.XY
	Background.Size = FillScreen and UDim2.fromScale(1,1) or UDim2.fromOffset(0, 0)
	Outline.Size = UDim2.new(1, 0, 1, 0)

	FillInstance({
		Position = WindowInfo.Position,
		AnchorPoint = WindowInfo.AnchorPoint,
		ZIndex = WindowInfo.ZIndex,
	}, Background)

	local MainFrame = New("Frame", {
		BackgroundColor3 = function()
			return Library:GetBetterColor(Library.Scheme.BackgroundColor, -1)
		end,
		Name = "ChangableWindow",
		Size = FillScreen and UDim2.fromScale(1,1) or WindowInfo.Size,
		Parent = Outline,
		DPIExclude = {
			Position = true,
		},
	})
	
	Library:MakeLine(MainFrame, {
		Position = UDim2.fromOffset(0, 48),
		Size = UDim2.new(1, 0, 0, 1),
	})

	--// Window class
	local Window = {
		Holder = MainFrame,
		Elements = {},
		Containers = {}
	}

	New("UICorner", {
		CornerRadius = UDim.new(0, WindowInfo.CornerRadius - 1),
		Parent = MainFrame,
	})

	local TitleHolder = New("Frame", {
		BackgroundTransparency = 1,
		Name = "Main",
		AutomaticSize = Enum.AutomaticSize.Y,
		Position = UDim2.fromOffset(10, 10),
		Size = UDim2.new(1),
		Parent = MainFrame
	})

	New("UIListLayout", {
		FillDirection = Enum.FillDirection.Horizontal,
		HorizontalAlignment = Enum.HorizontalAlignment.Left,
		VerticalAlignment = Enum.VerticalAlignment.Center,
		Padding = UDim.new(0, 6),
		Parent = TitleHolder,
	})

	if Icon then
		New("ImageLabel", {
			Image = tonumber(Icon) and `rbxassetid://{Icon}` or Icon,
			ImageColor3 = "AccentColor",
			Size = WindowInfo.IconSize,
			Parent = TitleHolder,
		})
	end

	local X = Library:GetTextBounds(
		WindowInfo.Title,
		Library.Scheme.Font,
		20,
		TitleHolder.AbsoluteSize.X - (WindowInfo.Icon and WindowInfo.IconSize.X.Offset + 6 or 0) - 12
	)

	New("TextLabel", {
		BackgroundTransparency = 1,
		Size = UDim2.fromOffset(X, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		Text = WindowInfo.Title,
		TextSize = 20,
		Parent = TitleHolder,
	})

	--// Bottom Bar \\--
	local BottomBar = New("Frame", {
		AnchorPoint = Vector2.new(0, 1),
		BackgroundColor3 = function()
			return Library:GetBetterColor(Library.Scheme.BackgroundColor, 4)
		end,
		Position = UDim2.fromScale(0, 1),
		Size = UDim2.new(1, 0, 0, 20),
		Parent = MainFrame,
	})
	do
		local Cover = Library:MakeCover(BottomBar, "Top")
		Library:AddToRegistry(Cover, {
			BackgroundColor3 = function()
				return Library:GetBetterColor(Library.Scheme.BackgroundColor, 4)
			end,
		})
	end
	New("UICorner", {
		CornerRadius = UDim.new(0, WindowInfo.CornerRadius - 1),
		Parent = BottomBar,
	})

	--// Footer
	New("TextLabel", {
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 1),
		Text = WindowInfo.Footer,
		TextSize = 14,
		TextTransparency = 0.5,
		Parent = BottomBar,
	})

	function Window:RemoveWindow()
		MainFrame:Destroy()
	end

	function Window:CreateCanvas(ContentInfo)	
		local Containers = Window.Containers
		ContentInfo = Library:Validate(ContentInfo, Templates.Content)

		local Background = New("Frame", {
			BackgroundTransparency = 1,
			Name = "Canvas",
			Position = UDim2.fromOffset(0, 50),
			Size = UDim2.new(1, 0, 1, -70),
			Parent = MainFrame,
			Visible = #Containers == 0,
		})

		local Container = New("Frame", {
			BackgroundTransparency = 1,
			Name = "Container",
			Position = UDim2.new(0.5, 0, 0, 10),
			Size = UDim2.new(1, -20, 1, -20),
			AnchorPoint = Vector2.new(0.5, 0),
			Parent = Background,
			ClipsDescendants = true
		})

		New("UIPadding", {
			PaddingLeft = UDim.new(0, 1),
			PaddingRight = UDim.new(0, 1),
			Parent = Container,
		})

		New("UIListLayout", {
			FillDirection = ContentInfo.FillDirection,
			HorizontalAlignment = ContentInfo.HorizontalAlignment,
			VerticalAlignment = ContentInfo.VerticalAlignment,
			Padding = ContentInfo.Padding,
			Parent = Container,
		})

		--// Lines
		for _, Info in next, ContentInfo.Lines do
			Library:MakeLine(Background, Info)
		end

		--// Create class
		local Canvas = {
			Holder = Window.Holder,
			Elements = Window.Elements,
			Container = Container
		}
		setmetatable(Canvas, BaseGroupbox)

		function Canvas:SetVisible()
			for _, Other in next, Containers do
				Other.Visible = Other == Background
			end
		end
		table.insert(Containers, Background)

		return Canvas
	end

	return Window
end

function Library:CreateWindow(WindowInfo)
	WindowInfo = Library:Validate(WindowInfo, Templates.Window)
	local ViewportSize: Vector2 = workspace.CurrentCamera.ViewportSize

	workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
		ViewportSize = workspace.CurrentCamera.ViewportSize
	end)

	local MaxX = ViewportSize.X - 64
	local MaxY = ViewportSize.Y - 64

	Library.MinSize = Vector2.new(math.min(Library.MinSize.X, MaxX), math.min(Library.MinSize.Y, MaxY))
	WindowInfo.Size = UDim2.fromOffset(
		math.clamp(WindowInfo.Size.X.Offset, Library.MinSize.X, MaxX),
		math.clamp(WindowInfo.Size.Y.Offset, Library.MinSize.Y, MaxY)
	)
	if typeof(WindowInfo.Font) == "EnumItem" then
		WindowInfo.Font = Font.fromEnum(WindowInfo.Font)
	end

	Library.CornerRadius = WindowInfo.CornerRadius
	Library:SetNotifySide(WindowInfo.NotifySide)
	Library.ShowCustomCursor = WindowInfo.ShowCustomCursor
	Library.Scheme.Font = WindowInfo.Font
	Library.ToggleKeybind = WindowInfo.ToggleKeybind

	local MainFrame
	local SearchBox
	local ResizeButton
	local Tabs
	local Container
	local DescriptionLabel
	local TitleLabel
	do
		Library.KeybindFrame, Library.KeybindContainer = Library:AddDraggableMenu("Keybinds")
		Library.KeybindFrame.AnchorPoint = Vector2.new(0, 0.5)
		Library.KeybindFrame.Position = UDim2.new(0, 6, 0.5, 0)
		Library.KeybindFrame.Visible = false
		Library:UpdateDPI(Library.KeybindFrame, {
			Position = false,
			Size = false,
		})
		MainFrame = New("Frame", {
			BackgroundColor3 = function()
				return Library:GetBetterColor(Library.Scheme.BackgroundColor, -1)
			end,
			Name = "Main",
			Position = WindowInfo.Position,
			Size = WindowInfo.Size,
			Visible = false,
			Parent = ScreenGui,
			ZIndex = WindowInfo.ZIndex,

			DPIExclude = {
				Position = true,
			},
		})
		New("UICorner", {
			CornerRadius = UDim.new(0, WindowInfo.CornerRadius - 1),
			Parent = MainFrame,
		})
		do
			local Lines = {
				{
					Position = UDim2.fromOffset(0, 48),
					Size = UDim2.new(1, 0, 0, 1),
				},
				{
					Position = UDim2.fromScale(0.3, 0),
					Size = UDim2.new(0, 1, 1, -21),
				},
				{
					AnchorPoint = Vector2.new(0, 1),
					Position = UDim2.new(0, 0, 1, -20),
					Size = UDim2.new(1, 0, 0, 1),
				},
			}
			for _, Info in pairs(Lines) do
				Library:MakeLine(MainFrame, Info)
			end
			Library:MakeOutline(MainFrame, WindowInfo.CornerRadius, 0)
		end

		if WindowInfo.Center then
			MainFrame.Position = UDim2.new(0.5, -MainFrame.Size.X.Offset / 2, 0.5, -MainFrame.Size.Y.Offset / 2)
		end

		--// Top Bar \\-
		local TopBar = New("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 48),
			Parent = MainFrame,
		})
		Library:MakeDraggable(MainFrame, TopBar, false, true)

		--// Title
		local TitleHolder = New("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(0.3, 1),
			Parent = TopBar,
		})
		New("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			Padding = UDim.new(0, 6),
			Parent = TitleHolder,
		})

		if WindowInfo.Icon then
			New("ImageLabel", {
				Image = tonumber(WindowInfo.Icon) and "rbxassetid://" .. WindowInfo.Icon or WindowInfo.Icon,
				ImageColor3 = "AccentColor",
				Size = WindowInfo.IconSize,
				Parent = TitleHolder,
			})
		end

		local X = Library:GetTextBounds(
			WindowInfo.Title,
			Library.Scheme.Font,
			20,
			TitleHolder.AbsoluteSize.X - (WindowInfo.Icon and WindowInfo.IconSize.X.Offset + 6 or 0) - 12
		)

		New("TextLabel", {
			BackgroundTransparency = 1,
			Size = UDim2.new(0, X, 1, 0),
			Text = WindowInfo.Title,
			TextSize = 20,
			Parent = TitleHolder,
		})

		--// Search Box
		SearchBox = New("TextBox", {
			AnchorPoint = Vector2.new(1, 0.5),
			BackgroundColor3 = "MainColor",
			PlaceholderText = "Search",
			Position = UDim2.new(1, -48, 0.5, 0),
			Size = UDim2.new(0.2, 0, 1, -16),
			TextSize = 14,
			TextXAlignment = Enum.TextXAlignment.Left,
			Parent = TopBar,
		})
		
		local InfoFrame = New("Frame", {
			AnchorPoint = Vector2.new(0, 0.5),
			Position = UDim2.new(0.3, 8, 0.5, 0),
			Size = UDim2.new(0.4, 0, 1, -16),
			BackgroundTransparency = 1,
			Parent = TopBar,
			ClipsDescendants = true
		})
		New("UIListLayout", {
			Parent = InfoFrame,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			Padding = UDim.new(0, 2),
		})
		TitleLabel = New("TextLabel", {
			Size = UDim2.fromScale(1, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextSize = 16,
			BackgroundTransparency = 1,
			Text = "<b>Title</b>",
			RichText = true,
			Parent = InfoFrame
		})
		DescriptionLabel = New("TextLabel", {
			Size = UDim2.fromScale(1, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextSize = 14,
			BackgroundTransparency = 1,
			Text = "Description",
			RichText = true,
			Parent = InfoFrame
		})
		New("UICorner", {
			CornerRadius = UDim.new(0, WindowInfo.CornerRadius),
			Parent = SearchBox,
		})
		New("UIPadding", {
			PaddingBottom = UDim.new(0, 8),
			PaddingLeft = UDim.new(0, 30),
			PaddingRight = UDim.new(0, 8),
			PaddingTop = UDim.new(0, 8),
			Parent = SearchBox,
		})
		New("UIStroke", {
			Color = "OutlineColor",
			Parent = SearchBox,
		})

		local SearchIcon = Library:GetIcon("search")
		if SearchIcon then
			New("ImageLabel", {
				Image = SearchIcon.Url,
				ImageColor3 = "FontColor",
				ImageRectOffset = SearchIcon.ImageRectOffset,
				ImageRectSize = SearchIcon.ImageRectSize,
				ImageTransparency = 0.5,
				Size = UDim2.fromScale(1, 1),
				Position = UDim2.fromOffset(-22, 0),
				SizeConstraint = Enum.SizeConstraint.RelativeYY,
				Parent = SearchBox,
			})
		end

		local MoveIcon = Library:GetIcon("move")
		if MoveIcon then
			New("ImageLabel", {
				AnchorPoint = Vector2.new(1, 0.5),
				Image = MoveIcon.Url,
				ImageColor3 = "OutlineColor",
				ImageRectOffset = MoveIcon.ImageRectOffset,
				ImageRectSize = MoveIcon.ImageRectSize,
				Position = UDim2.new(1, -10, 0.5, 0),
				Size = UDim2.fromOffset(28, 28),
				SizeConstraint = Enum.SizeConstraint.RelativeYY,
				Parent = TopBar,
			})
		end

		--// Bottom Bar \\--
		local BottomBar = New("Frame", {
			AnchorPoint = Vector2.new(0, 1),
			BackgroundColor3 = function()
				return Library:GetBetterColor(Library.Scheme.BackgroundColor, 4)
			end,
			Position = UDim2.fromScale(0, 1),
			Size = UDim2.new(1, 0, 0, 20),
			Parent = MainFrame,
		})
		do
			local Cover = Library:MakeCover(BottomBar, "Top")
			Library:AddToRegistry(Cover, {
				BackgroundColor3 = function()
					return Library:GetBetterColor(Library.Scheme.BackgroundColor, 4)
				end,
			})
		end
		New("UICorner", {
			CornerRadius = UDim.new(0, WindowInfo.CornerRadius - 1),
			Parent = BottomBar,
		})

		--// Footer
		New("TextLabel", {
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 1),
			Text = WindowInfo.Footer,
			TextSize = 14,
			TextTransparency = 0.5,
			Parent = BottomBar,
		})

		--// Resize Button
		if WindowInfo.Resizable then
			ResizeButton = New("TextButton", {
				AnchorPoint = Vector2.new(1, 0),
				BackgroundTransparency = 1,
				Position = UDim2.fromScale(1, 0),
				Size = UDim2.fromScale(1, 1),
				SizeConstraint = Enum.SizeConstraint.RelativeYY,
				Text = "",
				Parent = BottomBar,
			})

			Library:MakeResizable(MainFrame, ResizeButton, function()
				for _, Tab in pairs(Library.Tabs) do
					Tab:Resize(true)
				end
			end)
		end

		New("ImageLabel", {
			Image = ResizeIcon and ResizeIcon.Url or "",
			ImageColor3 = "FontColor",
			ImageRectOffset = ResizeIcon and ResizeIcon.ImageRectOffset or Vector2.zero,
			ImageRectSize = ResizeIcon and ResizeIcon.ImageRectSize or Vector2.zero,
			ImageTransparency = 0.5,
			Position = UDim2.fromOffset(2, 2),
			Size = UDim2.new(1, -4, 1, -4),
			Parent = ResizeButton,
		})

		--// Tabs \\--
		Tabs = New("ScrollingFrame", {
			AutomaticCanvasSize = Enum.AutomaticSize.Y,
			BackgroundColor3 = "BackgroundColor",
			CanvasSize = UDim2.fromScale(0, 0),
			Position = UDim2.fromOffset(0, 49),
			ScrollBarThickness = 0,
			Size = UDim2.new(0.3, 0, 1, -70),
			Parent = MainFrame,
		})

		New("UIListLayout", {
			Parent = Tabs,
		})

		--// Container \\--
		Container = New("Frame", {
			AnchorPoint = Vector2.new(1, 0),
			BackgroundColor3 = function()
				return Library:GetBetterColor(Library.Scheme.BackgroundColor, 1)
			end,
			Name = "Container",
			Position = UDim2.new(1, 0, 0, 49),
			Size = UDim2.new(0.7, -1, 1, -70),
			Parent = MainFrame,
		})

		New("UIPadding", {
			PaddingBottom = UDim.new(0, 0),
			PaddingLeft = UDim.new(0, 6),
			PaddingRight = UDim.new(0, 6),
			PaddingTop = UDim.new(0, 0),
			Parent = Container,
		})
	end
	
	local function SetTitleAndDescription(Title: string, Description: string)
		TitleLabel.Text = `<b>{Title}</b>`
		DescriptionLabel.Text = Description or "There is no information available."
	end

	--// Window Table \\--
	local Window = {}

	function Window:AddTab(TabConfig)
		local TabButton: TextButton
		local TabLabel
		local TabIcon

		local TabContainer
		local TabLeft
		local TabRight

		local WarningBox
		local WarningTitle
		local WarningText
		
		local Icon = TabConfig.Icon
		local Name = TabConfig.Name
		local Description = TabConfig.Description

		Icon = Library:GetIcon(Icon)
		do
			TabButton = New("TextButton", {
				BackgroundColor3 = "MainColor",
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, 40),
				Text = "",
				Parent = Tabs,
			})

			New("UIPadding", {
				PaddingBottom = UDim.new(0, 11),
				PaddingLeft = UDim.new(0, 12),
				PaddingRight = UDim.new(0, 12),
				PaddingTop = UDim.new(0, 11),
				Parent = TabButton,
			})

			TabLabel = New("TextLabel", {
				BackgroundTransparency = 1,
				Position = UDim2.fromOffset(30, 0),
				Size = UDim2.new(1, -30, 1, 0),
				Text = Name,
				TextSize = 16,
				TextTransparency = 0.5,
				TextXAlignment = Enum.TextXAlignment.Left,
				Parent = TabButton,
			})

			if Icon then
				TabIcon = New("ImageLabel", {
					Image = Icon.Url,
					ImageColor3 = "AccentColor",
					ImageRectOffset = Icon.ImageRectOffset,
					ImageRectSize = Icon.ImageRectSize,
					ImageTransparency = 0.5,
					Size = UDim2.fromScale(1, 1),
					SizeConstraint = Enum.SizeConstraint.RelativeYY,
					Parent = TabButton,
				})
			end

			--// Tab Container \\--
			TabContainer = New("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 1, -6),
				Position = UDim2.fromOffset(0, 6),
				Visible = false,
				ClipsDescendants = true,
				Parent = Container,
			})
			New("UIListLayout", {
				Wraps = true,
				Padding = UDim.new(0, 6),
				HorizontalFlex = Enum.UIFlexAlignment.Fill,
				VerticalFlex = Enum.UIFlexAlignment.Fill,
				FillDirection = Enum.FillDirection.Horizontal,
				Parent = TabContainer,
			})

			TabLeft = New("ScrollingFrame", {
				AutomaticCanvasSize = Enum.AutomaticSize.Y,
				BackgroundTransparency = 1,
				CanvasSize = UDim2.fromScale(0, 0),
				ScrollBarThickness = 0,
				Parent = TabContainer,
				Size = UDim2.fromScale(0.4, 1),
			})
			New("UIListLayout", {
				Padding = UDim.new(0, 6),
				Parent = TabLeft,
			})
			New("UIPadding", {
				PaddingBottom = UDim.new(0, 6),
				Parent = TabLeft,
			})

			TabRight = New("ScrollingFrame", {
				AutomaticCanvasSize = Enum.AutomaticSize.Y,
				BackgroundTransparency = 1,
				CanvasSize = UDim2.fromScale(0, 0),
				ScrollBarThickness = 0,
				Parent = TabContainer,
				Size = UDim2.fromScale(0.4, 1),
			})
			New("UIListLayout", {
				Padding = UDim.new(0, 6),
				Parent = TabRight,
			})
			New("UIPadding", {
				PaddingBottom = UDim.new(0, 6),
				Parent = TabRight,
			})

			WarningBox = New("Frame", {
				AutomaticSize = Enum.AutomaticSize.Y,
				BackgroundColor3 = Color3.fromRGB(127, 0, 0),
				BorderColor3 = Color3.fromRGB(255, 50, 50),
				BorderMode = Enum.BorderMode.Inset,
				BorderSizePixel = 1,
				LayoutOrder = -2,
				Position = UDim2.fromOffset(0, 6),
				Size = UDim2.fromScale(1, 0),
				Visible = false,
				Parent = TabContainer,
			})
			New("UIFlexItem", {
				ItemLineAlignment = Enum.ItemLineAlignment.Start,
				Parent = WarningBox
			})
			New("UIPadding", {
				PaddingBottom = UDim.new(0, 4),
				PaddingLeft = UDim.new(0, 6),
				PaddingRight = UDim.new(0, 6),
				PaddingTop = UDim.new(0, 4),
				Parent = WarningBox,
			})
			New("UIListLayout", {
				Parent = WarningBox,
			})

			WarningTitle = New("TextLabel", {
				BackgroundTransparency = 1,
				Size = UDim2.fromScale(1, 0),
				Text = "",
				TextColor3 = Color3.fromRGB(255, 50, 50),
				TextSize = 14,
				TextXAlignment = Enum.TextXAlignment.Left,
				Parent = WarningBox,
				AutomaticSize = Enum.AutomaticSize.Y
			})
			New("UIStroke", {
				ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual,
				Color = Color3.fromRGB(169, 0, 0),
				LineJoinMode = Enum.LineJoinMode.Miter,
				Parent = WarningTitle,
			})

			WarningText = New("TextLabel", {
				BackgroundTransparency = 1,
				Position = UDim2.fromOffset(0, 16),
				Size = UDim2.fromScale(1, 0),
				Text = "",
				TextSize = 14,
				TextXAlignment = Enum.TextXAlignment.Left,
				AutomaticSize = Enum.AutomaticSize.Y,
				TextWrapped = true,
				Parent = WarningBox,
			})
			New("UIStroke", {
				ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual,
				Color = "Dark",
				LineJoinMode = Enum.LineJoinMode.Miter,
				Parent = WarningText,
			})
		end

		--// Tab Table \\--
		local Tab = {
			Groupboxes = {},
			Tabboxes = {},
			Sides = {
				TabLeft,
				TabRight,
			},
		}

		function Tab:AddCard(Info)
			local Background, OutLine = Library:MakeOutline(TabContainer, Library.CornerRadius)
			Background.AutomaticSize = Enum.AutomaticSize.Y
			Background.Position = UDim2.fromOffset(0, 6)
			Background.Size = UDim2.fromScale(1, 0)
			Background.LayoutOrder = -2

			New("UIFlexItem", {
				ItemLineAlignment = Enum.ItemLineAlignment.Start,
				Parent = Background
			})

			local Holder = New("Frame", {
				BackgroundColor3 = "BackgroundColor",
				AutomaticSize = Enum.AutomaticSize.Y,
				Size = UDim2.fromScale(1, 1),
				Parent = OutLine,
			})
			New("UICorner", {
				CornerRadius = UDim.new(0, Library.CornerRadius - 1),
				Parent = Holder,
			})
			New("UIListLayout", {
				Padding = UDim.new(0, 4),
				FillDirection = Enum.FillDirection.Horizontal,
				Parent = Holder,
			})
			New("UIPadding", {
				PaddingBottom = UDim.new(0, 8),
				PaddingLeft = UDim.new(0, 8),
				PaddingRight = UDim.new(0, 8),
				PaddingTop = UDim.new(0, 8),
				Parent = Holder,
			})

			local Canvas = {
				Holder = TabContainer,
				Elements = {},
				Container = Holder
			}
			setmetatable(Canvas, BaseGroupbox)

			Tab:Resize()
			return Canvas
		end

		function Tab:UpdateWarningBox(Info)
			Info = Library:Validate(Info, Templates.WarningBox)

			FillInstance({
				BackgroundColor3 = Info.BackgroundColor,
				BorderColor3 = Info.BorderColor,
			}, WarningBox)

			--// Warning Title
			local Title = Info.Title
			WarningTitle.Visible = Title ~= nil
			WarningTitle.Text = Title or ""
			
			--// Warning Text
			local Text = Info.Text
			WarningText.Visible = Text ~= nil
			WarningText.Text = Text or ""

			--// Warning box
			local Visible = Info.Visible
			if Visible ~= nil then 
				WarningBox.Visible = Visible
			end

			--// Resize tab content
			Tab:Resize()
		end

		function Tab:Resize(ResizeWarningBox: boolean?)

		end

		function Tab:AddGroupbox(Info)
			local Background, Outline = Library:MakeOutline(Info.Side == 1 and TabLeft or TabRight, WindowInfo.CornerRadius, nil, true)
			Background.Size = UDim2.fromScale(1, 0)
			Library:UpdateDPI(Background, {
				Size = false,
			})

			local GroupboxHolder = New("Frame", {
				BackgroundColor3 = "BackgroundColor",
				Size = UDim2.new(1, 0, 1, 0),
				Parent = Outline,
				AutomaticSize = Enum.AutomaticSize.Y
			})

			local GroupboxLabel

			local GroupboxContainer
			local GroupboxList

			New("UIPadding", {
				Parent = Background,
				PaddingBottom = UDim.new(0, 1),
				PaddingTop = UDim.new(0, 1),
				PaddingRight = UDim.new(0, 1),
				PaddingLeft = UDim.new(0, 1),
			})

			New("UICorner", {
				CornerRadius = UDim.new(0, WindowInfo.CornerRadius - 1),
				Parent = GroupboxHolder,
			})
			Library:MakeLine(GroupboxHolder, {
				Position = UDim2.fromOffset(0, 34),
				Size = UDim2.new(1, 0, 0, 1),
			})

			GroupboxLabel = New("TextLabel", {
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, 34),
				Text = Info.Name,
				TextSize = 15,
				TextXAlignment = Enum.TextXAlignment.Left,
				Parent = GroupboxHolder,
			})
			New("UIPadding", {
				PaddingLeft = UDim.new(0, 12),
				PaddingRight = UDim.new(0, 12),
				Parent = GroupboxLabel,
			})

			GroupboxContainer = New("Frame", {
				BackgroundTransparency = 1,
				Position = UDim2.fromOffset(0, 35),
				Size = UDim2.new(1, 0, 1, -35),
				Parent = GroupboxHolder,
			})

			GroupboxList = New("UIListLayout", {
				Padding = UDim.new(0, 8),
				Parent = GroupboxContainer,
			})
			New("UIPadding", {
				PaddingBottom = UDim.new(0, 7),
				PaddingLeft = UDim.new(0, 7),
				PaddingRight = UDim.new(0, 7),
				PaddingTop = UDim.new(0, 7),
				Parent = GroupboxContainer,
			})

			local Groupbox = {
				Holder = Background,
				Container = GroupboxContainer,
				Elements = {},
			}

			setmetatable(Groupbox, BaseGroupbox)

			Tab.Groupboxes[Info.Name] = Groupbox

			return Groupbox
		end

		function Tab:AddLeftGroupbox(Name)
			return Tab:AddGroupbox({ Side = 1, Name = Name })
		end

		function Tab:AddRightGroupbox(Name)
			return Tab:AddGroupbox({ Side = 2, Name = Name })
		end

		function Tab:AddTabbox(Info)
			local Background, Outline = Library:MakeOutline(Info.Side == 1 and TabLeft or TabRight, WindowInfo.CornerRadius)
			Background.Size = UDim2.fromScale(1, 0)
			Background.AutomaticSize = Enum.AutomaticSize.Y
			Outline.Size = UDim2.new(1, 0, 1, 0)
			Library:UpdateDPI(Background, {
				Size = false,
			})

			local TabboxHolder = New("Frame", {
				BackgroundColor3 = "BackgroundColor",
				Position = UDim2.fromOffset(0, 0),
				Size = UDim2.fromScale(1, 1),
				Parent = Outline,
				AutomaticSize = Enum.AutomaticSize.Y
			})
			New("UICorner", {
				CornerRadius = UDim.new(0, WindowInfo.CornerRadius - 1),
				Parent = TabboxHolder,
			})

			local TabboxButtons = New("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, 34),
				Parent = TabboxHolder,
			})
			New("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalFlex = Enum.UIFlexAlignment.Fill,
				Parent = TabboxButtons,
			})

			local Tabbox = {
				ActiveTab = nil,

				Holder = Background,
				Tabs = {},
			}

			function Tabbox:AddTab(Name)
				local Button = New("TextButton", {
					BackgroundColor3 = "MainColor",
					BackgroundTransparency = 0,
					Size = UDim2.fromOffset(0, 34),
					Text = Name,
					TextSize = 15,
					TextTransparency = 0.5,
					Parent = TabboxButtons,
				})

				local Line = Library:MakeLine(Button, {
					AnchorPoint = Vector2.new(0, 1),
					Position = UDim2.new(0, 0, 1, 1),
					Size = UDim2.new(1, 0, 0, 1),
				})

				local Container = New("Frame", {
					BackgroundTransparency = 1,
					Position = UDim2.fromOffset(0, 35),
					Size = UDim2.new(1, 0, 1, -35),
					Visible = false,
					Parent = TabboxHolder,
				})
				local List = New("UIListLayout", {
					Padding = UDim.new(0, 8),
					Parent = Container,
				})
				New("UIPadding", {
					PaddingBottom = UDim.new(0, 7),
					PaddingLeft = UDim.new(0, 7),
					PaddingRight = UDim.new(0, 7),
					PaddingTop = UDim.new(0, 7),
					Parent = Container,
				})

				local Tab = {
					ButtonHolder = Button,
					Container = Container,

					Elements = {},
				}

				function Tab:Show()
					if Tabbox.ActiveTab then
						Tabbox.ActiveTab:Hide()
					end

					Button.BackgroundTransparency = 1
					Button.TextTransparency = 0
					Line.Visible = false

					Container.Visible = true

					Tabbox.ActiveTab = Tab
				end

				function Tab:Hide()
					Button.BackgroundTransparency = 0
					Button.TextTransparency = 0.5
					Line.Visible = true
					Container.Visible = false

					Tabbox.ActiveTab = nil
				end

				--// Execution \\--
				if not Tabbox.ActiveTab then
					Tab:Show()
				end

				Button.MouseButton1Click:Connect(Tab.Show)

				setmetatable(Tab, BaseGroupbox)

				Tabbox.Tabs[Name] = Tab

				return Tab
			end

			if Info.Name then
				Tab.Tabboxes[Info.Name] = Tabbox
			else
				table.insert(Tab.Tabboxes, Tabbox)
			end

			return Tabbox
		end

		function Tab:AddLeftTabbox(Name)
			return Tab:AddTabbox({ Side = 1, Name = Name })
		end

		function Tab:AddRightTabbox(Name)
			return Tab:AddTabbox({ Side = 2, Name = Name })
		end

		function Tab:Hover(Hovering)
			if Library.ActiveTab == Tab then
				return
			end

			TweenService:Create(TabLabel, Library.TweenInfo, {
				TextTransparency = Hovering and 0.25 or 0.5,
			}):Play()
			if TabIcon then
				TweenService:Create(TabIcon, Library.TweenInfo, {
					ImageTransparency = Hovering and 0.25 or 0.5,
				}):Play()
			end
		end

		function Tab:Show()
			if Library.ActiveTab then
				Library.ActiveTab:Hide()
			end

			TweenService:Create(TabButton, Library.TweenInfo, {
				BackgroundTransparency = 0,
			}):Play()
			TweenService:Create(TabLabel, Library.TweenInfo, {
				TextTransparency = 0,
			}):Play()
			if TabIcon then
				TweenService:Create(TabIcon, Library.TweenInfo, {
					ImageTransparency = 0,
				}):Play()
			end
			TabContainer.Visible = true
			Library.ActiveTab = Tab
			
			SetTitleAndDescription(Name, Description)
		end

		function Tab:Hide()
			TweenService:Create(TabButton, Library.TweenInfo, {
				BackgroundTransparency = 1,
			}):Play()
			TweenService:Create(TabLabel, Library.TweenInfo, {
				TextTransparency = 0.5,
			}):Play()
			if TabIcon then
				TweenService:Create(TabIcon, Library.TweenInfo, {
					ImageTransparency = 0.5,
				}):Play()
			end
			TabContainer.Visible = false

			Library.ActiveTab = nil
		end

		--// Execution \\--
		if not Library.ActiveTab then
			Tab:Show()
		end

		TabButton.MouseEnter:Connect(function()
			Tab:Hover(true)
		end)
		TabButton.MouseLeave:Connect(function()
			Tab:Hover(false)
		end)
		TabButton.MouseButton1Click:Connect(Tab.Show)

		Library.Tabs[Name] = Tab

		return Tab
	end

	function Window:AddKeyTab(Name)
		local TabButton: TextButton
		local TabLabel
		local TabIcon

		local TabContainer

		do
			TabButton = New("TextButton", {
				BackgroundColor3 = "MainColor",
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, 40),
				Text = "",
				Parent = Tabs,
			})
			New("UIPadding", {
				PaddingBottom = UDim.new(0, 11),
				PaddingLeft = UDim.new(0, 12),
				PaddingRight = UDim.new(0, 12),
				PaddingTop = UDim.new(0, 11),
				Parent = TabButton,
			})

			TabLabel = New("TextLabel", {
				BackgroundTransparency = 1,
				Position = UDim2.fromOffset(30, 0),
				Size = UDim2.new(1, -30, 1, 0),
				Text = Name,
				TextSize = 16,
				TextTransparency = 0.5,
				TextXAlignment = Enum.TextXAlignment.Left,
				Parent = TabButton,
			})

			if KeyIcon then
				TabIcon = New("ImageLabel", {
					Image = KeyIcon.Url,
					ImageColor3 = "AccentColor",
					ImageRectOffset = KeyIcon.ImageRectOffset,
					ImageRectSize = KeyIcon.ImageRectSize,
					ImageTransparency = 0.5,
					Size = UDim2.fromScale(1, 1),
					SizeConstraint = Enum.SizeConstraint.RelativeYY,
					Parent = TabButton,
				})
			end

			--// Tab Container \\--
			TabContainer = New("ScrollingFrame", {
				AutomaticCanvasSize = Enum.AutomaticSize.Y,
				BackgroundTransparency = 1,
				CanvasSize = UDim2.fromScale(0, 0),
				ScrollBarThickness = 0,
				Size = UDim2.fromScale(1, 1),
				Visible = false,
				Parent = Container,
			})
			New("UIListLayout", {
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				Padding = UDim.new(0, 8),
				VerticalAlignment = Enum.VerticalAlignment.Center,
				Parent = TabContainer,
			})
			New("UIPadding", {
				PaddingLeft = UDim.new(0, 1),
				PaddingRight = UDim.new(0, 1),
				Parent = TabContainer,
			})
		end

		--// Tab Table \\--
		local Tab = {
			Elements = {},
			IsKeyTab = true,
		}

		function Tab:Resize() end

		function Tab:Hover(Hovering)
			if Library.ActiveTab == Tab then
				return
			end

			TweenService:Create(TabLabel, Library.TweenInfo, {
				TextTransparency = Hovering and 0.25 or 0.5,
			}):Play()
			if TabIcon then
				TweenService:Create(TabIcon, Library.TweenInfo, {
					ImageTransparency = Hovering and 0.25 or 0.5,
				}):Play()
			end
		end

		function Tab:Show()
			if Library.ActiveTab then
				Library.ActiveTab:Hide()
			end

			TweenService:Create(TabButton, Library.TweenInfo, {
				BackgroundTransparency = 0,
			}):Play()
			TweenService:Create(TabLabel, Library.TweenInfo, {
				TextTransparency = 0,
			}):Play()
			if TabIcon then
				TweenService:Create(TabIcon, Library.TweenInfo, {
					ImageTransparency = 0,
				}):Play()
			end
			
			TabContainer.Visible = true
			Library.ActiveTab = Tab
			SetTitleAndDescription(Name, "Enter your key")
		end

		function Tab:Hide()
			TweenService:Create(TabButton, Library.TweenInfo, {
				BackgroundTransparency = 1,
			}):Play()
			TweenService:Create(TabLabel, Library.TweenInfo, {
				TextTransparency = 0.5,
			}):Play()
			if TabIcon then
				TweenService:Create(TabIcon, Library.TweenInfo, {
					ImageTransparency = 0.5,
				}):Play()
			end
			TabContainer.Visible = false

			Library.ActiveTab = nil
		end

		--// Execution \\--
		if not Library.ActiveTab then
			Tab:Show()
		end

		TabButton.MouseEnter:Connect(function()
			Tab:Hover(true)
		end)
		TabButton.MouseLeave:Connect(function()
			Tab:Hover(false)
		end)
		TabButton.MouseButton1Click:Connect(Tab.Show)

		Tab.Container = TabContainer
		setmetatable(Tab, BaseGroupbox)

		Library.Tabs[Name] = Tab

		return Tab
	end

	function Library:SetToggled(Value: boolean?)
		Library.Toggled = Value

		MainFrame.Visible = Value
		ModalElement.Modal = Value

		if Value then return end

		TooltipLabel.Visible = false
		for _, Option in next, Library.Options do
			local Type = Option.Type
			if Type == "ColorPicker" then
				Option.ColorMenu:Close()
				Option.ContextMenu:Close()
			elseif Type == "Dropdown" or Type == "KeyPicker" then
				Option.Menu:Close()
			end
		end
	end

	function Library:Toggle(Value: boolean?)
		local Toggled = Value
		if typeof(Value) ~= "boolean" then
			Toggled = not Library.Toggled
		end

		return Library:SetToggled(Toggled)
	end

	if WindowInfo.AutoShow then
		Library:SetToggled(true)
	end

	if Library.IsMobile then
		Library:AddDraggableButton("Toggle", function()
			Library:Toggle()
		end)

		local LockButton = Library:AddDraggableButton("Lock", function(self)
			Library.CantDragForced = not Library.CantDragForced
			self:SetText(Library.CantDragForced and "Unlock" or "Lock")
		end)
		LockButton.Button.Position = UDim2.fromOffset(6, 46)
	end

	--// Execution \\--
	local LastTab
	SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
		--// Reset Elements Visibility in Last Tab Searched
		if LastTab then
			for _, Groupbox in pairs(LastTab.Groupboxes) do
				for _, ElementInfo in pairs(Groupbox.Elements) do
					ElementInfo.Holder.Visible = typeof(ElementInfo.Visible) == "boolean" and ElementInfo.Visible
						or true

					if ElementInfo.SubButton then
						ElementInfo.Base.Visible = ElementInfo.Visible
						ElementInfo.SubButton.Base.Visible = ElementInfo.SubButton.Visible
					end
				end

				Groupbox.Holder.Visible = true
			end

			for _, Tabbox in pairs(LastTab.Tabboxes) do
				for _, Tab in pairs(Tabbox.Tabs) do
					for _, ElementInfo in pairs(Tab.Elements) do
						ElementInfo.Holder.Visible = typeof(ElementInfo.Visible) == "boolean" and ElementInfo.Visible
							or true

						if ElementInfo.SubButton then
							ElementInfo.Base.Visible = ElementInfo.Visible
							ElementInfo.SubButton.Base.Visible = ElementInfo.SubButton.Visible
						end
					end

					Tab.ButtonHolder.Visible = true
				end

				pcall(Tabbox.ActiveTab.Resize, Tabbox.ActiveTab)
				Tabbox.Holder.Visible = true
			end
		end

		--// Cancel Search if Search Text is empty
		local Search = SearchBox.Text:lower()
		if Search:gsub(" ", "") == "" or Library.ActiveTab.IsKeyTab then
			LastTab = nil
			return
		end

		--// Loop through Groupboxes to get Elements Info
		for _, Groupbox in pairs(Library.ActiveTab.Groupboxes) do
			local VisibleElements = 0

			for _, ElementInfo in pairs(Groupbox.Elements) do
				if ElementInfo.Type == "Divider" then
					ElementInfo.Holder.Visible = false
					continue
				elseif ElementInfo.SubButton then
					--// Check if any of the Buttons Name matches with Search
					local Visible = false

					--// Check if Search matches Element's Name and if Element is Visible
					if ElementInfo.Text:lower():match(Search) and ElementInfo.Visible then
						Visible = true
					else
						ElementInfo.Base.Visible = false
					end
					if ElementInfo.SubButton.Text:lower():match(Search) and ElementInfo.SubButton.Visible then
						Visible = true
					else
						ElementInfo.SubButton.Base.Visible = false
					end
					ElementInfo.Holder.Visible = Visible
					if Visible then
						VisibleElements += 1
					end

					continue
				end

				--// Check if Search matches Element's Name and if Element is Visible
				if ElementInfo.Text and ElementInfo.Text:lower():match(Search) and ElementInfo.Visible then
					ElementInfo.Holder.Visible = true
					VisibleElements += 1
				else
					ElementInfo.Holder.Visible = false
				end
			end

			--// Update Groupbox Size and Visibility if found any element
			Groupbox.Holder.Visible = VisibleElements > 0
		end

		for _, Tabbox in pairs(Library.ActiveTab.Tabboxes) do
			local VisibleTabs = 0
			local VisibleElements = {}

			for _, Tab in pairs(Tabbox.Tabs) do
				VisibleElements[Tab] = 0

				for _, ElementInfo in pairs(Tab.Elements) do
					if ElementInfo.Type == "Divider" then
						ElementInfo.Holder.Visible = false
						continue
					elseif ElementInfo.SubButton then
						--// Check if any of the Buttons Name matches with Search
						local Visible = false

						--// Check if Search matches Element's Name and if Element is Visible
						if ElementInfo.Text:lower():match(Search) and ElementInfo.Visible then
							Visible = true
						else
							ElementInfo.Base.Visible = false
						end
						if ElementInfo.SubButton.Text:lower():match(Search) and ElementInfo.SubButton.Visible then
							Visible = true
						else
							ElementInfo.SubButton.Base.Visible = false
						end
						ElementInfo.Holder.Visible = Visible
						if Visible then
							VisibleElements[Tab] += 1
						end

						continue
					end

					--// Check if Search matches Element's Name and if Element is Visible
					if ElementInfo.Text and ElementInfo.Text:lower():match(Search) and ElementInfo.Visible then
						ElementInfo.Holder.Visible = true
						VisibleElements[Tab] += 1
					else
						ElementInfo.Holder.Visible = false
					end
				end
			end

			for Tab, Visible in pairs(VisibleElements) do
				Tab.ButtonHolder.Visible = Visible > 0
				if Visible > 0 then
					VisibleTabs += 1

					if Tabbox.ActiveTab == Tab then
						pcall(Tab.Resize, Tab)
					elseif VisibleElements[Tabbox.ActiveTab] == 0 then
						Tab:Show()
					end
				end
			end

			--// Update Tabbox Visibility if any visible
			Tabbox.Holder.Visible = VisibleTabs > 0
		end

		--// Set Last Tab to Current One
		LastTab = Library.ActiveTab
	end)

	Library:GiveSignal(UserInputService.InputBegan:Connect(function(Input: InputObject)
		if UserInputService:GetFocusedTextBox() then
			return
		end

		if
			(
				typeof(Library.ToggleKeybind) == "table"
					and Library.ToggleKeybind.Type == "KeyPicker"
					and Input.KeyCode.Name == Library.ToggleKeybind.Value
			) or Input.KeyCode == Library.ToggleKeybind
		then
			Library.Toggle()
		end
	end))

	return Window
end

local function OnPlayerChange()
	local PlayerList, ExcludedPlayerList = GetPlayers(), GetPlayers(true)

	for _, Dropdown in pairs(Options) do
		if Dropdown.Type == "Dropdown" and Dropdown.SpecialType == "Player" then
			Dropdown:SetValues(Dropdown.ExcludeLocalPlayer and ExcludedPlayerList or PlayerList)
		end
	end
end
local function OnTeamChange()
	local TeamList = GetTeams()

	for _, Dropdown in pairs(Options) do
		if Dropdown.Type == "Dropdown" and Dropdown.SpecialType == "Team" then
			Dropdown:SetValues(TeamList)
		end
	end
end

--// Custom cursor
local OldMouseIconEnabled = UserInputService.MouseIconEnabled

local function SetCursorVisible(Visible: boolean?)
	Cursor.Visible = Visible
	UserInputService.MouseIconEnabled = not Visible and OldMouseIconEnabled or false
end

local function CustomCursorAvailable(): boolean?
	if Library.IsMobile then return end
	if Library.Unloaded then return end
	if not Library.Toggled then return end
	if not Library.ShowCustomCursor then return end

	return true
end

RunService:BindToRenderStep("ShowCursor", Enum.RenderPriority.Last.Value, function()
	local Visible = CustomCursorAvailable()
	SetCursorVisible(Visible)

	if not Visible then return end
	
	local Relative = Cursor.Parent
	if not Relative then return end
	
	local X, Y = Mouse.X, Mouse.Y 
	local Position = Relative.AbsolutePosition
	Cursor.Position = UDim2.fromOffset(
		X - Position.X, 
		Y - Position.Y
	)
end)

Library:GiveSignal(Players.PlayerAdded:Connect(OnPlayerChange))
Library:GiveSignal(Players.PlayerRemoving:Connect(OnPlayerChange))

Library:GiveSignal(Teams.ChildAdded:Connect(OnTeamChange))
Library:GiveSignal(Teams.ChildRemoved:Connect(OnTeamChange))

getgenv().Library = Library
return Library
