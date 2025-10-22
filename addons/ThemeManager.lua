local cloneref = (cloneref or clonereference or function(instance: any)
	return instance
end)
local getgenv = getgenv or function()
	return {}
end
local setclipboard = setclipboard or nil

--// Services
local HttpService: HttpService = cloneref(game:GetService("HttpService"))
local RunService: RunService = cloneref(game:GetService("RunService"))

--// Module
local ThemeManager = {
	Folder = "Rift",
	Library = nil,
	CurrentThemeScheme = nil,
	IsStudio = RunService:IsStudio(),
	BuiltInThemes = {
		["Default"] 		= { 1, HttpService:JSONDecode([[{"FontColor":"ffffff","MainColor":"191919","AccentColor":"DC551E","BackgroundColor":"0f0f0f","OutlineColor":"282828", "AfterImageTransparency":0.8}]]) },
		["BBot"] 			= { 2, HttpService:JSONDecode([[{"FontColor":"ffffff","MainColor":"1e1e1e","AccentColor":"7e48a3","BackgroundColor":"232323","OutlineColor":"141414", "AfterImageTransparency":0.8}]]) },
		["Fatality"]		= { 3, HttpService:JSONDecode([[{"FontColor":"ffffff","MainColor":"1e1842","AccentColor":"c50754","BackgroundColor":"191335","OutlineColor":"3c355d", "AfterImageTransparency":0.8}]]) },
		["Jester"] 			= { 4, HttpService:JSONDecode([[{"FontColor":"ffffff","MainColor":"242424","AccentColor":"db4467","BackgroundColor":"1c1c1c","OutlineColor":"373737", "AfterImageTransparency":0.8}]]) },
		["Mint"] 			= { 5, HttpService:JSONDecode([[{"FontColor":"ffffff","MainColor":"242424","AccentColor":"3db488","BackgroundColor":"1c1c1c","OutlineColor":"373737", "AfterImageTransparency":0.8}]]) },
		["Tokyo Night"] 	= { 6, HttpService:JSONDecode([[{"FontColor":"ffffff","MainColor":"191925","AccentColor":"6759b3","BackgroundColor":"16161f","OutlineColor":"323232", "AfterImageTransparency":0.8}]]) },
		["Ubuntu"] 			= { 7, HttpService:JSONDecode([[{"FontColor":"ffffff","MainColor":"3e3e3e","AccentColor":"e2581e","BackgroundColor":"323232","OutlineColor":"191919", "AfterImageTransparency":0.8}]]) },
		["Quartz"] 			= { 8, HttpService:JSONDecode([[{"FontColor":"ffffff","MainColor":"232330","AccentColor":"426e87","BackgroundColor":"1d1b26","OutlineColor":"27232f", "AfterImageTransparency":0.8}]]) },
		["Nord"] 			= { 9, HttpService:JSONDecode([[{"FontColor":"eceff4","MainColor":"3b4252","AccentColor":"88c0d0","BackgroundColor":"2e3440","OutlineColor":"4c566a", "AfterImageTransparency":0.8}]]) },
		["Dracula"] 		= { 10, HttpService:JSONDecode([[{"FontColor":"f8f8f2","MainColor":"44475a","AccentColor":"ff79c6","BackgroundColor":"282a36","OutlineColor":"6272a4", "AfterImageTransparency":0.8}]]) },
		["Monokai"] 		= { 11, HttpService:JSONDecode([[{"FontColor":"f8f8f2","MainColor":"272822","AccentColor":"f92672","BackgroundColor":"1e1f1c","OutlineColor":"49483e", "AfterImageTransparency":0.8}]]) },
		["Gruvbox"] 		= { 12, HttpService:JSONDecode([[{"FontColor":"ebdbb2","MainColor":"3c3836","AccentColor":"fb4934","BackgroundColor":"282828","OutlineColor":"504945", "AfterImageTransparency":0.8}]]) },
		["Solarized"] 		= { 13, HttpService:JSONDecode([[{"FontColor":"839496","MainColor":"073642","AccentColor":"cb4b16","BackgroundColor":"002b36","OutlineColor":"586e75", "AfterImageTransparency":0.8}]]) },
		["Catppuccin"] 		= { 14, HttpService:JSONDecode([[{"FontColor":"d9e0ee","MainColor":"302d41","AccentColor":"f5c2e7","BackgroundColor":"1e1e2e","OutlineColor":"575268", "AfterImageTransparency":0.8}]]) },
		["One Dark"] 		= { 15, HttpService:JSONDecode([[{"FontColor":"abb2bf","MainColor":"282c34","AccentColor":"c678dd","BackgroundColor":"21252b","OutlineColor":"5c6370", "AfterImageTransparency":0.8}]]) },
		["Cyberpunk"] 		= { 16, HttpService:JSONDecode([[{"FontColor":"f9f9f9","MainColor":"262335","AccentColor":"00ff9f","BackgroundColor":"1a1a2e","OutlineColor":"413c5e", "AfterImageTransparency":0.8}]]) },
		["Oceanic Next"] 	= { 17, HttpService:JSONDecode([[{"FontColor":"d8dee9","MainColor":"1b2b34","AccentColor":"6699cc","BackgroundColor":"16232a","OutlineColor":"343d46", "AfterImageTransparency":0.8}]]) },
		["Material"] 		= { 18, HttpService:JSONDecode([[{"FontColor":"eeffff","MainColor":"212121","AccentColor":"82aaff","BackgroundColor":"151515","OutlineColor":"424242", "AfterImageTransparency":0.8}]]) },
		["sUNC"] 	        = { 19, HttpService:JSONDecode([[{"MainColor":"161622","FontFace":"Code","AccentColor":"a98ef4","OutlineColor":"28283b","BackgroundColor":"0e0e16","FontColor":"ffffff", "AfterImageTransparency":0.8}]]) },
		["Discord Dark"]	= { 20, HttpService:JSONDecode([[{"FontColor":"ffffff","MainColor":"1a1a1e","AccentColor":"5865f2","BackgroundColor":"1a1a1e","OutlineColor":"292a2d","FontFace":"Code", "AfterImageTransparency":0.8}]]) },
	},
	Fonts = {
		"Antique",
		"Arcade",
		"Arial",
		"ArialBold",
		"Bodoni",
		"BuilderSans",
		"Cartoon",
		"Code",
		"Fantasy",
		"Garamond",
		"Gotham",
		"GothamBlack",
		"GothamBold",
		"GothamMedium",
		"Highway",
		"JosefinSans",
		"Jura",
		"Legacy",
		"LuckiestGuy",
		"Merriweather",
		"Nunito",
		"Roboto",
		"RobotoCondensed",
		"RobotoMono",
		"SciFi",
		"SourceSans",
		"SourceSansBold",
		"SourceSansItalic",
		"Ubuntu"
	}
}

--// Compatability
function ThemeManager:IsFile(FilePath)
	if self.IsStudio then return end
	return isfile(FilePath)
end

function ThemeManager:SetLibrary(library)
	self.Library = library
end

function ThemeManager:SetFolder(folder)
	self.Folder = folder
	self:BuildFolderTree()
end

--// Folders \\--
function ThemeManager:GetPaths()
	local paths = {}
	local Folder = self.Folder

	local parts = Folder:split("/")
	for idx = 1, #parts do
		paths[#paths + 1] = table.concat(parts, "/", 1, idx)
	end

	paths[#paths + 1] =  `{Folder}/themes`

	return paths
end

function ThemeManager:BuildFolderTree()
	if self.IsStudio then return end

	local paths = self:GetPaths()
	for i = 1, #paths do
		local str = paths[i]
		if isfolder(str) then continue end
		makefolder(str)
	end
end

function ThemeManager:CheckFolderTree()
	if self.IsStudio then return end
	if isfolder(self.Folder) then return end
	self:BuildFolderTree()

	task.wait(0.1)
end

--// Apply, Update theme \\--
function ThemeManager:ApplyTheme(theme)
	local customThemeData = self:GetCustomTheme(theme)
	local data = customThemeData or self.BuiltInThemes[theme]
	local Library = self.Library

	if not data then return end

	local scheme = data[2] or customThemeData
	self.CurrentThemeScheme = scheme

	for idx, val in scheme do
        if idx == "VideoLink" then
            continue
        elseif idx == "FontFace" then
            Library:SetFont(Enum.Font[val])

            if Library.Options[idx] then
                Library.Options[idx]:SetValue(val)
            end
        elseif typeof(val) == "string" then
            local Success = pcall(function()
                val = Color3.fromHex(val)
                if Library.Options[idx] then
                    Library.Options[idx]:SetValueRGB(val)
                end
            end)
            
            Library.Scheme[idx] = val
            if not Success then
                pcall(function()
                    Library.Options[idx]:SetValue(val)
                end)
            end
        else
            Library.Scheme[idx] = val
            if Library.Options[idx] then
                Library.Options[idx]:SetValue(val) 
            end
        end
    end
	task.wait()
	self:ThemeUpdate()
end

function ThemeManager:ThemeUpdate()
	local Library = self.Library
	local ThemeScheme = self.CurrentThemeScheme
	local Scheme = Library.Scheme
	local Options = Library.Options

	local Fields = { 
		"FontColor", 
		"MainColor", 
		"AccentColor", 
		"BackgroundColor", 
		"OutlineColor", 
		"BackgroundImageEnabled", 
		"BackgroundImage",
		"WindowGlow",
	}

	for _, field in pairs(Fields) do
		if Options and Options[field] then
			Scheme[field] = Options[field].Value
		end
	end

	local Trans = 0.95
	local BackgroundImage = Scheme.BackgroundImageEnabled
	Scheme.AfterImageTransparency = BackgroundImage and Trans or 0
	Scheme.BorderSizePixel = BackgroundImage and 0 or 1

	Library:UpdateColorsUsingRegistry()
end

--// Get, Load, Save, Delete, Refresh \\--
function ThemeManager:GetCustomTheme(file)
	if self.IsStudio then return end

	local path = `{self.Folder}/themes/{file}.json`
	if not isfile(path) then
		return nil
	end

	local data = readfile(path)
	local success, decoded = pcall(HttpService.JSONDecode, HttpService, data)

	if not success then
		return nil
	end

	return decoded
end

function ThemeManager:LoadDefault()
	local Library = self.Library
	local BuiltInThemes = self.BuiltInThemes
	local Options = Library.Options

	local theme = "Default"
	local content = self:IsFile(`{self.Folder}/themes/default.txt`) and readfile(`{self.Folder}/themes/default.txt`)

	local isDefault = true
	if content then
		if BuiltInThemes[content] then
			theme = content
		elseif self:GetCustomTheme(content) then
			theme = content
			isDefault = false
		end
	elseif BuiltInThemes[self.DefaultTheme] then
		theme = self.DefaultTheme
	end

	self:ApplyTheme(theme)

	local ThemeList = Options.ThemeManager_ThemeList
	if ThemeList then
		ThemeList:SetValue(theme)
	end
end

function ThemeManager:SaveDefault(theme)
	writefile(self.Folder .. "/themes/default.txt", theme)
end

function ThemeManager:SaveCustomTheme(file)
	local Library = self.Library
	local Options = Library.Options
	
	if #file:gsub(" ", "") <= 0 then
		Library:Notify("Invalid File Name For Theme (Empty)", 3)
		return
	end

	local theme = {}
	local fields = { 
		"WindowGlow", 
		"BackgroundImageEnabled", 
		"BackgroundImage", 
		"FontColor", 
		"MainColor", 
		"AccentColor", 
		"BackgroundColor",
		"OutlineColor" 
	}

	for _, field in pairs(fields) do
		local Value = Options[field].Value
		if typeof(Value) == "Color3" then
			Value = Value:ToHex()
		end
		theme[field] = Value
	end
	theme["FontFace"] = Library.Options["FontFace"].Value

	writefile(`{self.Folder}/themes/{file}.json`, HttpService:JSONEncode(theme))
	return
end

function ThemeManager:Delete(name)
	if (not name) then
		return false, "No Config File Is Selected"
	end

	local file = self.Folder .. "/themes/" .. name .. ".json"
	if not isfile(file) then return false, "Invalid File" end

	local success = pcall(delfile, file)
	if not success then return false, "Delete File Error" end

	return true
end

function ThemeManager:ReloadCustomThemes()
	if self.IsStudio then return end

	local list = listfiles(`{self.Folder}/themes`)

	local out = {}
	for i = 1, #list do
		local file = list[i]
		if file:sub(-5) == ".json" then
			-- i hate this but it has to be done ...

			local pos = file:find(".json", 1, true)
			local start = pos

			local char = file:sub(pos, pos)
			while char ~= "/" and char ~= "\\" and char ~= "" do
				pos = pos - 1
				char = file:sub(pos, pos)
			end

			if char == "/" or char == "\\" then
				table.insert(out, file:sub(pos + 1, start - 1))
			end
		end
	end

	return out
end

function ThemeManager:CreateOptions(groupbox)
	local Themes = self.BuiltInThemes
	local Fonts = self.Fonts
	local Library = self.Library
	local Scheme = Library.Scheme
	local Options = Library.Options

	local ThemesArray = {}
	for Name, Theme in next, Themes do
		table.insert(ThemesArray, Name)
	end
	table.sort(ThemesArray, function(a, b) return Themes[a][1] < Themes[b][1] end)

	groupbox:AddLabel("Background Colour"):AddColorPicker("BackgroundColor", { Default = Scheme.BackgroundColor })
	groupbox:AddLabel("Main Colour"):AddColorPicker("MainColor", { Default = Scheme.MainColor })
	groupbox:AddLabel("Accent Colour"):AddColorPicker("AccentColor", { Default = Scheme.AccentColor })
	groupbox:AddLabel("Outline Colour"):AddColorPicker("OutlineColor", { Default = Scheme.OutlineColor })
	groupbox:AddLabel("Font Colour"):AddColorPicker("FontColor", { Default = Scheme.FontColor })
	groupbox:AddToggle("BackgroundImageEnabled", { Text = "Background Image",  Default = false})
	groupbox:AddInput("BackgroundImage", { Text = "Background Image:", Default = ""})
	groupbox:AddToggle("WindowGlow", { Text = "Window Glow",  Default = true})
	groupbox:AddDropdown("FontFace", {
		Text = "Font Face:",
		Default = "Code",
		Values = Fonts
	})

	--// Themes list
	groupbox:AddDivider()
	groupbox:AddDropdown("ThemeManager_ThemeList", { Text = "Theme:", Values = ThemesArray, Default = 1 })
	groupbox:AddButton("Set as Default", function()
		self:SaveDefault(Options.ThemeManager_ThemeList.Value)
		Library:Notify(string.format("Set Default Theme To %q", Options.ThemeManager_ThemeList.Value))
	end)

	Options.ThemeManager_ThemeList:OnChanged(function()
		self:ApplyTheme(Options.ThemeManager_ThemeList.Value)
	end)

	--// Create theme
	groupbox:AddDivider()
	groupbox:AddInput("ThemeManager_CustomThemeName", { Text = "Custom Theme Name:" })
	groupbox:AddButton("Create Theme", function() 
		self:SaveCustomTheme(Options.ThemeManager_CustomThemeName.Value)

		Options.ThemeManager_CustomThemeList:SetValues(self:ReloadCustomThemes())
		Options.ThemeManager_CustomThemeList:SetValue(nil)
	end)

	--// Theme manager
	groupbox:AddDivider()
	groupbox:AddDropdown("ThemeManager_CustomThemeList", { Text = "Custom Themes:", Values = self:ReloadCustomThemes(), AllowNull = true, Default = 1 })
	groupbox:AddButton("Load Theme", function()
		local name = Options.ThemeManager_CustomThemeList.Value

		self:ApplyTheme(name)
		Library:Notify(string.format("Loaded Theme %q", name))
	end)
	groupbox:AddButton("Overwrite Theme", function()
		local name = Options.ThemeManager_CustomThemeList.Value

		self:SaveCustomTheme(name)
		Library:Notify(string.format("Overwrote Config %q", name))
	end)
	groupbox:AddButton("Delete Theme", function()
		local name = Options.ThemeManager_CustomThemeList.Value

		local success, err = self:Delete(name)
		if not success then
			Library:Notify("Failed To Delete Theme: " .. err)
			return 
		end

		Library:Notify(string.format("Deleted Theme %q", name))
		Options.ThemeManager_CustomThemeList:SetValues(self:ReloadCustomThemes())
		Options.ThemeManager_CustomThemeList:SetValue(nil)
	end)
	groupbox:AddButton("Refresh List", function()
		Options.ThemeManager_CustomThemeList:SetValues(self:ReloadCustomThemes())
		Options.ThemeManager_CustomThemeList:SetValue(nil)
	end)
	groupbox:AddButton("Set as Default", function()
		if Options.ThemeManager_CustomThemeList.Value ~= nil and Options.ThemeManager_CustomThemeList.Value ~= "" then
			self:SaveDefault(Options.ThemeManager_CustomThemeList.Value)
			Library:Notify(string.format("Set Default Theme To %q", Options.ThemeManager_CustomThemeList.Value))
		end
	end)
	groupbox:AddButton("Reset Default", function()
		local success = pcall(delfile, self.Folder .. "/themes/default.txt")
		if not success then 
			Library:Notify("Failed To Reset Default: Delete File Error")
			return 
		end

		Library:Notify("Set Default Theme To Nothing")
		Options.ThemeManager_CustomThemeList:SetValues(self:ReloadCustomThemes())
		Options.ThemeManager_CustomThemeList:SetValue(nil)
	end)

	--// Connect signals
	local function UpdateTheme() self:ThemeUpdate() end
	Options.BackgroundColor:OnChanged(UpdateTheme)
	Options.MainColor:OnChanged(UpdateTheme)
	Options.AccentColor:OnChanged(UpdateTheme)
	Options.OutlineColor:OnChanged(UpdateTheme)
	Options.FontColor:OnChanged(UpdateTheme)
	Toggles.BackgroundImageEnabled:OnChanged(UpdateTheme)
	Toggles.WindowGlow:OnChanged(UpdateTheme)
	Options.BackgroundImage:OnChanged(UpdateTheme)
	Options.FontFace:OnChanged(function(Value)
		Library:SetFont(Enum.Font[Value])
		Library:UpdateColorsUsingRegistry()
	end)
end

function ThemeManager:CreateGroupBox(tab)
	assert(self.Library, "Must Set ThemeManager.Library First!")
	return tab:AddLeftGroupbox("Themes", "paintbrush")
end

function ThemeManager:AddThemeOptions(tab)
	assert(self.Library, "Must Set ThemeManager.Library First!")
	local groupbox = self:CreateGroupBox(tab)
	self:CreateOptions(groupbox)
end

function ThemeManager:ApplyToGroupbox(groupbox)
	assert(self.Library, "Must Set ThemeManager.Library First!")
	self:CreateOptions(groupbox)
end

ThemeManager:BuildFolderTree()

return ThemeManager
