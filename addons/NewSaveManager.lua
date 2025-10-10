local cloneref = (cloneref or clonereference or function(instance: any) return instance end)
local httpService = cloneref(game:GetService("HttpService"))
local isfolder, isfile, listfiles = isfolder, isfile, listfiles

if typeof(copyfunction) == "function" then
    -- Fix is_____ functions for shitsploits, those functions should never error, only return a boolean.

    local
        isfolder_copy,
        isfile_copy,
        listfiles_copy = copyfunction(isfolder), copyfunction(isfile), copyfunction(listfiles)

    local isfolder_success, isfolder_error = pcall(function()
        return isfolder_copy("test" .. tostring(math.random(1000000, 9999999)))
    end)

    if isfolder_success == false or typeof(isfolder_error) ~= "boolean" then
        isfolder = function(folder)
            local success, data = pcall(isfolder_copy, folder)
            return (if success then data else false)
        end

        isfile = function(file)
            local success, data = pcall(isfile_copy, file)
            return (if success then data else false)
        end

        listfiles = function(folder)
            local success, data = pcall(listfiles_copy, folder)
            return (if success then data else {})
        end
    end
end

local SaveManager = {} do
    SaveManager.Folder = "Rift"
    SaveManager.SubFolder = ""
    SaveManager.Ignore = {}
    SaveManager.Library = nil
    SaveManager.Parser = {
        Toggle = {
            Save = function(idx, object)
                return { type = "Toggle", idx = idx, value = object.Value }
            end,
            Load = function(idx, data)
                local object = SaveManager.Library.Toggles[idx]
                if object and object.Value ~= data.value then
                    object:SetValue(data.value)
                end
            end,
        },
        Slider = {
            Save = function(idx, object)
                return { type = "Slider", idx = idx, value = tostring(object.Value) }
            end,
            Load = function(idx, data)
                local object = SaveManager.Library.Options[idx]
                if object and object.Value ~= data.value then
                    object:SetValue(data.value)
                end
            end,
        },
        Dropdown = {
            Save = function(idx, object)
                return { type = "Dropdown", idx = idx, value = object.Value, mutli = object.Multi }
            end,
            Load = function(idx, data)
                local object = SaveManager.Library.Options[idx]
                if object and object.Value ~= data.value then
                    object:SetValue(data.value)
                end
            end,
        },
        ColorPicker = {
            Save = function(idx, object)
                return { type = "ColorPicker", idx = idx, value = object.Value:ToHex(), transparency = object.Transparency }
            end,
            Load = function(idx, data)
                if SaveManager.Library.Options[idx] then
                    SaveManager.Library.Options[idx]:SetValueRGB(Color3.fromHex(data.value), data.transparency)
                end
            end,
        },
        KeyPicker = {
            Save = function(idx, object)
                return { type = "KeyPicker", idx = idx, mode = object.Mode, key = object.Value }
            end,
            Load = function(idx, data)
                if SaveManager.Library.Options[idx] then
                    SaveManager.Library.Options[idx]:SetValue({ data.key, data.mode })
                end
            end,
        },
        Input = {
            Save = function(idx, object)
                return { type = "Input", idx = idx, text = object.Value }
            end,
            Load = function(idx, data)
                local object = SaveManager.Library.Options[idx]
                if object and object.Value ~= data.text and type(data.text) == "string" then
                    SaveManager.Library.Options[idx]:SetValue(data.text)
                end
            end,
        },
    }

    function SaveManager:SetLibrary(library)
        self.Library = library
    end

    function SaveManager:IgnoreThemeSettings()
        self:SetIgnoreIndexes({
            "BackgroundColor", 
            "MainColor", 
            "AccentColor", 
            "OutlineColor", 
            "FontColor", 
            "FontFace",           
            "BackgroundImageEnabled",
            "BackgroundImage",        
            "WindowGlow",              
            "ThemeManager_ThemeList", 
            "ThemeManager_CustomThemeList", 
            "ThemeManager_CustomThemeName"
        })
    end

    --// Folders \\--
    function SaveManager:CheckSubFolder(createFolder)
        if typeof(self.SubFolder) ~= "string" or self.SubFolder == "" then return false end

        if createFolder == true then
            if not isfolder(self.Folder .. "/settings/" .. self.SubFolder) then
                makefolder(self.Folder .. "/settings/" .. self.SubFolder)
            end
        end

        return true
    end

    function SaveManager:GetPaths()
        local paths = {}

        local parts = self.Folder:split("/")
        for idx = 1, #parts do
            local path = table.concat(parts, "/", 1, idx)
            if not table.find(paths, path) then paths[#paths + 1] = path end
        end

        paths[#paths + 1] = self.Folder .. "/themes"
        paths[#paths + 1] = self.Folder .. "/settings"

        if self:CheckSubFolder(false) then
            local subFolder = self.Folder .. "/settings/" .. self.SubFolder
            parts = subFolder:split("/")

            for idx = 1, #parts do
                local path = table.concat(parts, "/", 1, idx)
                if not table.find(paths, path) then paths[#paths + 1] = path end
            end
        end

        return paths
    end

    function SaveManager:BuildFolderTree()
        local paths = self:GetPaths()

        for i = 1, #paths do
            local str = paths[i]
            if isfolder(str) then continue end

            makefolder(str)
        end
    end

    function SaveManager:CheckFolderTree()
        if isfolder(self.Folder) then return end
        SaveManager:BuildFolderTree()

        task.wait(0.1)
    end

    function SaveManager:SetIgnoreIndexes(list)
        for _, key in pairs(list) do
            self.Ignore[key] = true
        end
    end

    function SaveManager:SetFolder(folder)
        self.Folder = folder
        self:BuildFolderTree()
    end

    function SaveManager:SetSubFolder(folder)
        self.SubFolder = folder
        self:BuildFolderTree()
    end

    --// Save, Load, Delete, Refresh \\--
    function SaveManager:Save(name)
        if (not name) then
            return false, "no config file is selected"
        end
        SaveManager:CheckFolderTree()

        local fullPath = self.Folder .. "/settings/" .. name .. ".json"
        if SaveManager:CheckSubFolder(true) then
            fullPath = self.Folder .. "/settings/" .. self.SubFolder .. "/" .. name .. ".json"
        end

        local data = {
            objects = {}
        }

        for idx, toggle in pairs(self.Library.Toggles) do
            if not toggle.Type then continue end
            if not self.Parser[toggle.Type] then continue end
            if self.Ignore[idx] then continue end

            table.insert(data.objects, self.Parser[toggle.Type].Save(idx, toggle))
        end

        for idx, option in pairs(self.Library.Options) do
            if not option.Type then continue end
            if not self.Parser[option.Type] then continue end
            if self.Ignore[idx] then continue end

            table.insert(data.objects, self.Parser[option.Type].Save(idx, option))
        end

        local success, encoded = pcall(httpService.JSONEncode, httpService, data)
        if not success then
            return false, "failed to encode data"
        end

        writefile(fullPath, encoded)
        return true
    end

    function SaveManager:Load(name)
        if not name then
            return false, "no config file is selected"
        end
        SaveManager:CheckFolderTree()

        local file = self.Folder .. "/settings/" .. name .. ".json"
        if SaveManager:CheckSubFolder(true) then
            file = self.Folder .. "/settings/" .. self.SubFolder .. "/" .. name .. ".json"
        end

        if not isfile(file) then return false, "invalid file" end

        local success, decoded = pcall(httpService.JSONDecode, httpService, readfile(file))
        if not success then return false, "decode error" end

        local optionQueue, toggleQueue = {}, {}
        for _, obj in pairs(decoded.objects) do
            if not obj.type or not self.Parser[obj.type] then
                continue
            end
            if obj.type == "Toggle" then
                table.insert(toggleQueue, obj)
            else
                table.insert(optionQueue, obj)
            end
        end

        for _, obj in pairs(optionQueue) do
            task.spawn(self.Parser[obj.type].Load, obj.idx, obj)
        end
        task.wait()
        for _, obj in pairs(toggleQueue) do
            task.spawn(self.Parser[obj.type].Load, obj.idx, obj)
        end

        return true
    end


    function SaveManager:Delete(name)
        if (not name) then
            return false, "no config file is selected"
        end

        local file = self.Folder .. "/settings/" .. name .. ".json"
        if SaveManager:CheckSubFolder(true) then
            file = self.Folder .. "/settings/" .. self.SubFolder .. "/" .. name .. ".json"
        end

        if not isfile(file) then return false, "invalid file" end

        local success = pcall(delfile, file)
        if not success then return false, "delete file error" end

        return true
    end

    function SaveManager:RefreshConfigList()
        local success, data = pcall(function()
            SaveManager:CheckFolderTree()

            local list = {}
            local out = {}

            if SaveManager:CheckSubFolder(true) then
                list = listfiles(self.Folder .. "/settings/" .. self.SubFolder)
            else
                list = listfiles(self.Folder .. "/settings")
            end
            if typeof(list) ~= "table" then list = {} end

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
        end)

        if (not success) then
            if self.Library then
                self.Library:Notify("Failed to load config list: " .. tostring(data))
            else
                warn("Failed to load config list: " .. tostring(data))
            end

            return {}
        end

        return data
    end

    --// Import/Export \\--
    function SaveManager:ExportConfig(name)
        if not name then
            return false, "no config file is selected"
        end
        SaveManager:CheckFolderTree()

        local file = self.Folder .. "/settings/" .. name .. ".json"
        if SaveManager:CheckSubFolder(true) then
            file = self.Folder .. "/settings/" .. self.SubFolder .. "/" .. name .. ".json"
        end

        if not isfile(file) then return false, "invalid file" end

        local success, content = pcall(readfile, file)
        if not success then return false, "failed to read file" end

        return true, content
    end

    function SaveManager:ImportConfig(configData, name)
        if not configData or configData == "" then
            return false, "no config data provided"
        end

        if not name or name == "" then
            return false, "no config name provided"
        end

        -- Validate JSON
        local success, decoded = pcall(httpService.JSONDecode, httpService, configData)
        if not success then
            return false, "invalid JSON data"
        end

        if not decoded.objects or type(decoded.objects) ~= "table" then
            return false, "invalid config format"
        end

        SaveManager:CheckFolderTree()

        local fullPath = self.Folder .. "/settings/" .. name .. ".json"
        if SaveManager:CheckSubFolder(true) then
            fullPath = self.Folder .. "/settings/" .. self.SubFolder .. "/" .. name .. ".json"
        end

        local writeSuccess = pcall(writefile, fullPath, configData)
        if not writeSuccess then
            return false, "failed to write file"
        end

        return true
    end

    --// Auto Load \\--
    function SaveManager:GetAutoloadConfig()
        SaveManager:CheckFolderTree()

        local autoLoadPath = self.Folder .. "/settings/autoload.txt"
        if SaveManager:CheckSubFolder(true) then
            autoLoadPath = self.Folder .. "/settings/" .. self.SubFolder .. "/autoload.txt"
        end

        if isfile(autoLoadPath) then
            local successRead, name = pcall(readfile, autoLoadPath)
            if not successRead then
                return "none"
            end

            name = tostring(name)
            return if name == "" then "none" else name
        end

        return "none"
    end

    function SaveManager:LoadAutoloadConfig()
        SaveManager:CheckFolderTree()

        local autoLoadPath = self.Folder .. "/settings/autoload.txt"
        if SaveManager:CheckSubFolder(true) then
            autoLoadPath = self.Folder .. "/settings/" .. self.SubFolder .. "/autoload.txt"
        end

        if isfile(autoLoadPath) then
            local successRead, name = pcall(readfile, autoLoadPath)
            if not successRead then
                return self.Library:Notify("Failed to load autoload config: write file error")
            end

            local success, err = self:Load(name)
            if not success then
                return self.Library:Notify("Failed to load autoload config: " .. err)
            end

            self.Library:Notify(string.format("Auto loaded config %q", name))
        end
    end

    function SaveManager:SaveAutoloadConfig(name)
        SaveManager:CheckFolderTree()

        local autoLoadPath = self.Folder .. "/settings/autoload.txt"
        if SaveManager:CheckSubFolder(true) then
            autoLoadPath = self.Folder .. "/settings/" .. self.SubFolder .. "/autoload.txt"
        end

        local success = pcall(writefile, autoLoadPath, name)
        if not success then return false, "write file error" end

        return true, ""
    end

    function SaveManager:DeleteAutoLoadConfig()
        SaveManager:CheckFolderTree()

        local autoLoadPath = self.Folder .. "/settings/autoload.txt"
        if SaveManager:CheckSubFolder(true) then
            autoLoadPath = self.Folder .. "/settings/" .. self.SubFolder .. "/autoload.txt"
        end

        local success = pcall(delfile, autoLoadPath)
        if not success then return false, "delete file error" end

        return true, ""
    end

    --// GUI \\--
    function SaveManager:BuildConfigSection(tab)
        assert(self.Library, "Must set SaveManager.Library")

        local section = tab:AddRightGroupbox("Configuration", "folder-cog")

        section:AddInput("SaveManager_ConfigName",    { Text = "Config Name:" })
        section:AddButton("Create Config", function()
            local name = self.Library.Options.SaveManager_ConfigName.Value

            if name:gsub(" ", "") == "" then
                return self.Library:Notify({
                    Title = "Warning",
                    Description = "Invalid config name (empty).",
                    Time = 3,
                    Icon = "triangle-alert"
                })
            end

            local success, err = self:Save(name)
            if not success then
                return self.Library:Notify({
                    Title = "Error",
                    Description = "Failed to create config: " .. err .. ".",
                    Time = 3,
                    Icon = "x-circle"
                })
            end

            self.Library:Notify({
                Title = "Success",
                Description = string.format("Created config %q.", name),
                Time = 3,
                Icon = "circle-check"
            })

            self.Library.Options.SaveManager_ConfigList:SetValues(self:RefreshConfigList())
            self.Library.Options.SaveManager_ConfigList:SetValue(nil)
        end)

        section:AddDivider()

        section:AddDropdown("SaveManager_ConfigList", { Text = "Config List:", Values = self:RefreshConfigList(), AllowNull = true })
        section:AddButton("Load", function()
            local name = self.Library.Options.SaveManager_ConfigList.Value

            local success, err = self:Load(name)
            if not success then
                return self.Library:Notify({
                    Title = "Error",
                    Description = "Failed to load config: " .. err .. ".",
                    Time = 3,
                    Icon = "x-circle"
                })
            end

            self.Library:Notify({
                Title = "Success",
                Description = string.format("Loaded config %q.", name),
                Time = 3,
                Icon = "circle-check"
            })
        end):AddButton("Overwrite", function()
            local name = self.Library.Options.SaveManager_ConfigList.Value

            local success, err = self:Save(name)
            if not success then
                return self.Library:Notify({
                    Title = "Error",
                    Description = "Failed to overwrite config: " .. err .. ".",
                    Time = 3,
                    Icon = "x-circle"
                })
            end

            self.Library:Notify({
                Title = "Success",
                Description = string.format("Overwrote config %q.", name),
                Time = 3,
                Icon = "circle-check"
            })
        end)

        section:AddButton("Delete", function()
            local name = self.Library.Options.SaveManager_ConfigList.Value

            local success, err = self:Delete(name)
            if not success then
                return self.Library:Notify({
                    Title = "Error",
                    Description = "Failed to delete config: " .. err .. ".",
                    Time = 3,
                    Icon = "x-circle"
                })
            end

            self.Library:Notify({
                Title = "Success",
                Description = string.format("Deleted config %q.", name),
                Time = 3,
                Icon = "circle-check"
            })
            self.Library.Options.SaveManager_ConfigList:SetValues(self:RefreshConfigList())
            self.Library.Options.SaveManager_ConfigList:SetValue(nil)
        end):AddButton("Export", function()
            local name = self.Library.Options.SaveManager_ConfigList.Value
            if not name then
                return self.Library:Notify({
                    Title = "Warning",
                    Description = "No config selected.",
                    Time = 3,
                    Icon = "triangle-alert"
                })
            end

            local success, data = self:ExportConfig(name)
            if not success then
                return self.Library:Notify({
                    Title = "Error",
                    Description = "Failed to export config: " .. data .. ".",
                    Time = 3,
                    Icon = "x-circle"
                })
            end

            setclipboard(data)
            self.Library:Notify({
                Title = "Success",
                Description = string.format("Exported config %q to clipboard.", name),
                Time = 3,
                Icon = "circle-check"
            })
        end)

        section:AddButton("Refresh List", function()
            self.Library.Options.SaveManager_ConfigList:SetValues(self:RefreshConfigList())
            self.Library.Options.SaveManager_ConfigList:SetValue(nil)
        end)

        section:AddDivider()

        -- Import functionality
        section:AddButton("Import from Clipboard", function()
            local name = self.Library.Options.SaveManager_ConfigName.Value

            if name:gsub(" ", "") == "" then
                return self.Library:Notify({
                    Title = "Warning",
                    Description = "Invalid config name (empty).",
                    Time = 3,
                    Icon = "triangle-alert"
                })
            end

            local clipboardSuccess, clipboardData = pcall(getclipboard)
            if not clipboardSuccess or not clipboardData then
                return self.Library:Notify({
                    Title = "Error",
                    Description = "Failed to get clipboard data.",
                    Time = 3,
                    Icon = "x-circle"
                })
            end

            local success, err = self:ImportConfig(clipboardData, name)
            if not success then
                return self.Library:Notify({
                    Title = "Error",
                    Description = "Failed to import config: " .. err .. ".",
                    Time = 3,
                    Icon = "x-circle"
                })
            end

            self.Library:Notify({
                Title = "Success",
                Description = string.format("Imported config %q.", name),
                Time = 3,
                Icon = "circle-check"
            })
            self.Library.Options.SaveManager_ConfigList:SetValues(self:RefreshConfigList())
            self.Library.Options.SaveManager_ConfigList:SetValue(nil)
        end)

        section:AddDivider()

        section:AddButton("Set Autoload", function()
            local name = self.Library.Options.SaveManager_ConfigList.Value

            local success, err = self:SaveAutoloadConfig(name)
            if not success then
                return self.Library:Notify({
                    Title = "Error",
                    Description = "Failed to set autoload config: " .. err .. ".",
                    Time = 3,
                    Icon = "x-circle"
                })
            end

            SaveManager.AutoloadLabel:SetText("Current autoload config: " .. name)
            self.Library:Notify({
                Title = "Success",
                Description = string.format("Set %q to auto load.", name),
                Time = 3,
                Icon = "circle-check"
            })
        end):AddButton("Reset", function()
            local success, err = self:DeleteAutoLoadConfig()
            if not success then
                return self.Library:Notify({
                    Title = "Error",
                    Description = "Failed to reset autoload config: " .. err .. ".",
                    Time = 3,
                    Icon = "x-circle"
                })
            end

            self.Library:Notify({
                Title = "Success",
                Description = "Set autoload to none.",
                Time = 3,
                Icon = "circle-check"
            })
            SaveManager.AutoloadLabel:SetText("Current autoload config: none")
        end)

        self.AutoloadLabel = section:AddLabel("Current Autoload Config: " .. self:GetAutoloadConfig(), true)

        -- self:LoadAutoloadConfig()
        self:SetIgnoreIndexes({ "SaveManager_ConfigList", "SaveManager_ConfigName" })
    end

    SaveManager:BuildFolderTree()
end

return SaveManager
