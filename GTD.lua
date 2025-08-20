game:GetService("StarterGui"):SetCore("SendNotification",{
	Title = "started...!", -- Required
	Text = "Starting  up this!", -- Required
})
--+ SaveManager + InterfaceManagerace Manager
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/StormSKz/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/StormSKz/Fluent/master/Addons/InterfaceManager.lua"))()

game:GetService("StarterGui"):SetCore("SendNotification",{
	Title = "Loaded...", -- Required
	Text = "The game is loading...!", -- Required
})

-- config
local HttpService = game:GetService("HttpService")
local player = game.Players.LocalPlayer

local default = {
	Config = {
		AutoPlayEnabled = false,
		SelectedLobby = false,
		AutoPlay = false,
		AutoSkip = false,
		AutoX2 = false,
		Return = false,
		again = false,
		FPSLow = false,
		AutoWinInsane = false,
		AutoX3 = false,
		AutoVERYFAST = false,
		mode = "Impossible"
	}
}

-- config
local set = default

-- config
local function save()
	
end

-- Fluent
local Window = Fluent:CreateWindow({
	Title = "Garden Tower Defense!",
	SubTitle = "Modified!",
	TabWidth = 160,
	Size = UDim2.fromOffset(580, 460),
	Acrylic = true,
	Theme = "Dark",
	MinimizeKey = Enum.KeyCode.LeftControl
})

game:GetService("StarterGui"):SetCore("SendNotification",{
	Title = "Loaded...", -- Required
	Text = "Created main game UI!" -- Required
})

local Tabs = {
	Main = Window:AddTab({ Title = "Main", Icon = "airplay" }),
	Select = Window:AddTab({ Title = "Select-Mode", Icon = "play-circle" }),
	Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}
local Options = Fluent.Options
Tabs.Main:AddParagraph(
	{
		Title = "Welcome!", 
		Content = "This is modified!"
	}
)

local lastPlacedPositions = {}
local function isPositionOccupiedCompletely(posToCheck, threshold)
	threshold = threshold or 1
	for _, model in ipairs(workspace.Map.Entities:GetChildren()) do
		if model:IsA("Model") and string.find(model.Name, "unit_") and (model:FindFirstChild("HumanoidRootPart") or model:FindFirstChild("Anchor")) then
			local part = model:FindFirstChild("HumanoidRootPart") or model:FindFirstChild("Anchor")
			if (part.Position - posToCheck).Magnitude < threshold then
				return true
			end
		end
	end
	for _, oldPos in ipairs(lastPlacedPositions) do
		if (oldPos - posToCheck).Magnitude < threshold then
			return true
		end
	end
	return false
end

function g8oushafrkhijadewLoop(spacing, delaySeconds)
	spacing = spacing or 8
	delaySeconds = delaySeconds or 3
	local placeUnit = game:GetService("ReplicatedStorage"):WaitForChild("RemoteFunctions"):WaitForChild("PlaceUnit")
	local backpack = game:GetService("Players").LocalPlayer:WaitForChild("Backpack")
	while Options.AutoPlayEnabled.Value do
		lastPlacedPositions = {}
		local mob = nil
		for _, child in ipairs(workspace.Map.Entities:GetChildren()) do
			if child:IsA("Model") == true and string.find(child.Name:lower(), "enemy") and child:FindFirstChild("Anchor") ~= nil then
				mob = child
				break
			end
		end
		if mob ~= nil then task.wait(delaySeconds) continue end
		local pos = mob.Anchor.Position
		local offsetY = pos.Y + 0.91475
		local rotation = 180
		local positions = {}
		for i = 1, 8 do
			local angle = (math.pi * 2) * (i / 8)
			table.insert(positions, Vector3.new(pos.X + math.cos(angle)*spacing, offsetY, pos.Z + math.sin(angle)*spacing))
		end
		local usedTools = {}
		for _, v3 in ipairs(positions) do
			if isPositionOccupiedCompletely(v3, 4.5) then continue end
			for _, tool in ipairs(backpack:GetChildren()) do
				if tool:IsA("Tool") == true and not usedTools[tool] then
					local itemId = tool:GetAttribute("ItemID")
					if typeof(itemId) == "string" and string.sub(itemId, 1, 14) == "tl_unitplacer_" then
						local unitName = string.sub(itemId, 15)
						local cf = CFrame.new(v3.X, v3.Y, v3.Z) * CFrame.Angles(0, math.rad(rotation), 0)
						placeUnit:InvokeServer(unitName, {Valid = true, Rotation = rotation, CF = cf, Position = vector.create(v3.X, v3.Y, v3.Z)})
						table.insert(lastPlacedPositions, v3)
						usedTools[tool] = true
						task.wait(0.1)
						break
					end
				end
			end
		end
		task.wait(delaySeconds)
	end
end

function loopUpgradeUnits(delaySeconds)
	delaySeconds = delaySeconds or 5
	local upgradeRemote = game:GetService("ReplicatedStorage"):WaitForChild("RemoteFunctions"):WaitForChild("UpgradeUnit")
	local entities = workspace:WaitForChild("Map"):WaitForChild("Entities")
	while Options.AutoPlayEnabled.Value do
		for _, model in ipairs(entities:GetChildren()) do
			if model:IsA("Model") == true and string.find(model.Name, "unit_") ~= nil then
				local unitId = model:GetAttribute("ID")
				if typeof(unitId) == "number" then
					while true do
						local success, result = pcall(function()
							return upgradeRemote:InvokeServer(unitId)
						end)
						if success and result then
							task.wait(0.2)
						else
							break
						end
					end
				end
			end
		end
		task.wait(delaySeconds)
	end
end

Tabs.Main:AddToggle("Godmode", {

})

Options.Godmode:OnChanged(function(enabled)
	set.Config.Godmode = enabled
	save()

	if enabled then
		local Players_upvr = game.Players
		local LocalPlayer = Players_upvr.LocalPlayer
		if replicatesignal then
			replicatesignal(LocalPlayer.ConnectDiedSignalBackend)
			task.wait(Players_upvr.RespawnTime - 0.1)
		end
		local Character = LocalPlayer.Character
		local var4 = Character
		if var4 then
			var4 = Character:FindFirstChildWhichIsA("Humanoid")
		end
		local clone = var4:Clone()
		clone.Parent = Character
		LocalPlayer.Character = nil
		clone:SetStateEnabled(15, false)
		clone:SetStateEnabled(1, false)
		clone:SetStateEnabled(0, false)
		clone.BreakJointsOnDeath = true
		LocalPlayer.Character = Character
		clone.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
		local Animate = Character:FindFirstChild("Animate")
		if Animate then
			Animate.Disabled = true
			task.wait()
			Animate.Disabled = false
		end
		clone.Health = clone.MaxHealth
	end
end)

Tabs.Main:AddToggle("AutoPlayEnabled", {
	Title = "Autoplay Game",
	Description = "Let the game place and upgrade units by itself.",
	Default = set.Config.AutoPlayEnabled
})

Options.AutoPlayEnabled:OnChanged(function(enabled)
	set.Config.AutoPlayEnabled = enabled
	save()

	if enabled then
		task.spawn(function() g8oushafrkhijadewLoop(6, 3) end)
		task.spawn(function() loopUpgradeUnits(0.5) end)
	end
end)

Tabs.Main:AddToggle("AutoVERYFAST", {
	Title = "Skip Wave",
	Description = "Just skips the wave normally.",
	Default = set.Config.AutoVERYFAST
})

Options.AutoVERYFAST:OnChanged(function(enabled)
	set.Config.AutoVERYFAST = enabled
	save()

	if enabled then
		task.spawn(function()
			while set.Config.AutoVERYFAST do
				local remoteFunctions = game:GetService("ReplicatedStorage"):FindFirstChild("RemoteFunctions")
				local skipWave = remoteFunctions and remoteFunctions:FindFirstChild("SkipWave")

				if skipWave and typeof(skipWave.InvokeServer) == "function" then
					pcall(function()
						skipWave:InvokeServer("y")
					end)
				end
				task.wait(0.5)
			end
		end)
	end
end)

local palmUpgradeGoals = {}
for i = 1, 20 do
	palmUpgradeGoals[i] = 4
end

local palmLevels = {}
local farmerLevels = {}
local palmIndex = 1
local placedAtPosition = {}
local totalPlaced = 0
local running = false

local upgradeRemote = game:GetService("ReplicatedStorage"):WaitForChild("RemoteFunctions"):WaitForChild("UpgradeUnit")
local placeUnit = game:GetService("ReplicatedStorage"):WaitForChild("RemoteFunctions"):WaitForChild("PlaceUnit")
local sellRemote = game:GetService("ReplicatedStorage"):WaitForChild("RemoteFunctions"):WaitForChild("SellUnit")
local player = game:GetService("Players").LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local unitsTextLabel = playerGui:WaitForChild("GameGui").Screen.Bottom.Units

local vector = vector or {}
if not vector.create then
	function vector.create(x, y, z)
		return Vector3.new(x, y, z)
	end
end

local entities = nil

local function waitForEntities(timeout)
	local start = tick()
	while tick() - start < timeout do
		local map = workspace:FindFirstChild("Map")
		if map then
			local e = map:FindFirstChild("Entities")
			if e then return e end
		end
		task.wait(0.3)
	end
	return nil
end

local towerPositions = {
	Vector3.new(-334.0728759765625, 64.52073669433594, -136.09864807128906),
	Vector3.new(-336.4566345214844, 64.52073669433594, -141.05335998535156),
	Vector3.new(-334.7874450683594, 64.52073669433594, -156.9388427734375),
	Vector3.new(-335.2193908691406, 64.52073669433594, -205.35406494140625),
	Vector3.new(-331.6054382324219, 64.52073669433594, -137.12142944335938),
	Vector3.new(-330.88153076171875, 64.52073669433594, -139.0272216796875),
	Vector3.new(-334.9161071777344, 64.52073669433594, -201.810546875),
}

local function resetPalmState()
	palmLevels = {}
	palmIndex = 1
	placedAtPosition = {}
	totalPlaced = 0
end

local function isPositionOccupied(pos, threshold)
	threshold = threshold or 1.5
	for _, model in pairs(entities:GetChildren()) do
		if model:IsA("Model") and string.find(model.Name, "unit_") then
			local hrp = model:FindFirstChild("HumanoidRootPart") or model:FindFirstChild("Anchor")
			if hrp and (hrp.Position - pos).Magnitude < threshold then
				return true
			end
		end
	end
	return false
end

local function Autofarm()
	local farmerPositions = {
		Vector3.new(-338.39080810546875, 63.38456726074219, -78.99128723144531),
		Vector3.new(-332.1807861328125, 63.38456726074219, -79.68843078613281),
	}

	local placedCount = 0
	for _, pos in ipairs(farmerPositions) do
		if placedCount >= 3 then break end
		if not isPositionOccupied(pos, 2) then
			local cframe = CFrame.new(pos.X, pos.Y, pos.Z, -1, 0, 0, 0, 1, 0, 0, 0, -1)
			local args = {
				"unit_farmer_npc",
				{
					Valid = true,
					Rotation = 180,
					CF = cframe,
					Position = vector.create(pos.X, pos.Y, pos.Z)
				}
			}
			placeUnit:InvokeServer(unpack(args))
			placedCount += 1
			task.wait(0.2)
		end
	end
end

local function loopUpgradeFarmersIfPalmLow()
	while true do
		local palmCount = 0
		for _, model in ipairs(entities:GetChildren()) do
			if model:IsA("Model") and model.Name == "unit_palm_tree" then
				palmCount += 1
			end
		end

		if palmCount < 18 then
			Autofarm()

			for _, model in ipairs(entities:GetChildren()) do
				if model:IsA("Model") and model.Name == "unit_farmer_npc" then
					local unitId = model:GetAttribute("ID")
					if typeof(unitId) == "number" then
						local level = farmerLevels[model] or 0
						while level < 3 do
							local success, result = pcall(function()
								return upgradeRemote:InvokeServer(unitId)
							end)
							if success and result == true then
								level += 1
								farmerLevels[model] = level
								task.wait(0.1)
							else
								break
							end
						end
					end
				end
			end
		end

		task.wait(1)
	end
end

local function Autopalm()
	if totalPlaced >= 20 then return end

	local attempts = 0
	while attempts < #towerPositions do
		local posIndex = palmIndex
		local placed = placedAtPosition[posIndex] or 0
		local pos = towerPositions[posIndex]
		local cframe = CFrame.new(pos.X, pos.Y, pos.Z, -1, 0, 0, 0, 1, 0, 0, 0, -1)

		if (posIndex == 4 or posIndex == 7) then
			for _, model in ipairs(entities:GetChildren()) do
				if model:IsA("Model") and model.Name == "unit_palm_tree" then
					local dist = (model:GetPivot().Position - pos).Magnitude
					if dist < 1.5 then
						palmIndex = (palmIndex % #towerPositions) + 1
						return
					end
				end
			end
		end

		local args = {
			"unit_palm_tree",
			{
				Valid = true,
				Rotation = 180,
				CF = cframe,
				Position = vector.create(pos.X, pos.Y, pos.Z)
			}
		}

		local success = pcall(function()
			placeUnit:InvokeServer(unpack(args))
		end)

		if success then
			task.wait(0.7)

			local stuck = false
			local matchedModel = nil

			for _, model in ipairs(entities:GetChildren()) do
				if model:IsA("Model") and model.Name == "unit_palm_tree" then
					local dist = (model:GetPivot().Position - pos).Magnitude
					if dist < 1.5 then
						stuck = true
						matchedModel = model
						break
					end
				end
			end

			if stuck then
				if matchedModel and not palmLevels[matchedModel] then
					palmLevels[matchedModel] = 0
				end

				placedAtPosition[posIndex] = placed + 1
				totalPlaced += 1
				palmIndex = (palmIndex % #towerPositions) + 1
				return
			else
				task.wait(0.3)
			end
		else
			palmIndex = (palmIndex % #towerPositions) + 1
			attempts += 1
		end
	end
end

local function loopPalmTreeUpgrade()
	running = true
	resetPalmState()

	while running do
		if playerGui.GameGui.Screen.Middle.GameEnd.Visible then
			break
		end

		if unitsTextLabel.Text == "20 / 20 Max units" then
			for _, model in ipairs(entities:GetChildren()) do
				if model:IsA("Model") and model.Name == "unit_farmer_npc" then
					local unitID = model:GetAttribute("ID")
					if unitID then
						local args = { unitID }
						pcall(function()
							sellRemote:InvokeServer(unpack(args))
						end)
					end
				end
			end
		end

		local currentUnits = {}
		for _, model in ipairs(entities:GetChildren()) do
			if model:IsA("Model") and model.Name == "unit_palm_tree" then
				table.insert(currentUnits, model)
			end
		end

		table.sort(currentUnits, function(a, b)
			return a:GetDebugId() < b:GetDebugId()
		end)

		for i, model in ipairs(currentUnits) do
			local goalLevel = palmUpgradeGoals[i]
			if goalLevel then
				local currentLevel = palmLevels[model] or 0
				local unitId = model:GetAttribute("ID")

				while currentLevel < goalLevel do
					local success, result = pcall(function()
						return upgradeRemote:InvokeServer(unitId)
					end)
					if success and result == true then
						currentLevel += 1
						palmLevels[model] = currentLevel
						task.wait(0.3)
					else
						break
					end
				end
			end
		end

		local canPlaceNext = true
		for i, model in ipairs(currentUnits) do
			if (palmUpgradeGoals[i] or 0) > (palmLevels[model] or 0) then
				canPlaceNext = false
				break
			end
		end

		if canPlaceNext and #currentUnits < 20 then
			local cashStr = tostring(player.leaderstats.Cash.Value):gsub(",", "")
			local cash = tonumber(cashStr) or 0
			if cash >= 700 then
				Autopalm()
			end
		end

		task.wait(0.25)
	end

	running = false
end

Tabs.Main:AddToggle("AutoWinInsane", {
	Title = "AutoWin Jungle Map",
	Description = "Auto win the insane Jungle map!",
	Default = set.Config.AutoWinInsane
})

local running = false
local roundStarted = false

Options.AutoWinInsane:OnChanged(function(enabled)
	set.Config.AutoWinInsane = enabled
	save()

	running = enabled

	if enabled then
		task.spawn(function()
			entities = waitForEntities(15)
			if not entities then
				return
			end

			task.spawn(function()
				while running do
					local palmCount = 0
					for _, model in pairs(entities:GetChildren()) do
						if model:IsA("Model") and model.Name == "unit_palm_tree" then
							palmCount += 1
						end
					end

					if palmCount < 18 then
						Autofarm()

						for _, model in ipairs(entities:GetChildren()) do
							if model:IsA("Model") and model.Name == "unit_farmer_npc" then
								local unitId = model:GetAttribute("ID")
								if typeof(unitId) == "number" then
									local level = farmerLevels[model] or 0
									while level < 3 do
										local success, result = pcall(function()
											return upgradeRemote:InvokeServer(unitId)
										end)
										if success and result == true then
											level += 1
											farmerLevels[model] = level
											task.wait(0.1)
										else
											break
										end
									end
								end
							end
						end
					end

					task.wait(1)
				end
			end)

			task.spawn(function()
				while running do
					local diffVote = playerGui.GameGui.Screen.Middle:FindFirstChild("DifficultyVote")

					if diffVote and diffVote.Visible and not roundStarted then
						local char = player.Character
						if char and char:FindFirstChild("HumanoidRootPart") then
							char.HumanoidRootPart.CFrame = CFrame.new(-336, 74, -175)
						end
						roundStarted = true

						palmIndex = 1
						placedAtPosition = {}
						totalPlaced = 0
						farmerLevels = {}
						palmLevels = {}

						task.spawn(loopPalmTreeUpgrade)
					elseif diffVote and not diffVote.Visible and roundStarted then
						roundStarted = false
					end

					task.wait(0.25)
				end
			end)
		end)
	end
end)

local interact = function(path)
	if path then
		game:GetService("GuiService").SelectedObject = path
		task.wait(0.5)
		game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.Return, false, game)
		task.wait(0.5)
		game:GetService("VirtualInputManager"):SendKeyEvent(false, Enum.KeyCode.Return, false, game)
		task.wait(0.5)
		game:GetService("GuiService").SelectedObject = nil
	end
end

-- gle AutoPlay (
Tabs.Main:AddToggle("AutoPlayagain", {
	Title = "AutoPlay again",
	Description = "Play the game again automatically.",
	Default = set.Config.again
})


Options.AutoPlayagain:OnChanged(function(val)
	local AutoPlayagain = val
	set.Config.again = val
	save()

	if not AutoPlayagain then
		return
	end
	task.spawn(function()
		while set.Config.again do
			task.wait(0.2)
			if game:GetService("Players").LocalPlayer.PlayerGui.GameGui.Screen.Middle.GameEnd.Items.Frame.Actions.Items.Again.Visible and game.PlaceId ~= 108533757090220 then
				interact(game:GetService("Players").LocalPlayer.PlayerGui.GameGui.Screen.Middle.GameEnd.Items.Frame.Actions.Items.Again)
			end
		end
	end)
end)

Tabs.Main:AddToggle("AutoReturn", {
	Title = "AutoReturn",
	Description = "Return back to the lobby.",
	Default = set.Config.Return
})


Options.AutoReturn:OnChanged(function(val)
	local  AutoReturn = val
	set.Config.Return = val
	save()

	if not AutoReturn then
		return
	end
	task.spawn(function()
		while set.Config.Return do
			task.wait(0.2)
			if game:GetService("Players").LocalPlayer.PlayerGui.GameGui.Screen.Middle.GameEnd.Visible and game.PlaceId ~= 108533757090220 then
				game:GetService("ReplicatedStorage"):WaitForChild("RemoteFunctions"):WaitForChild("BackToMainLobby"):InvokeServer()
			end
		end
	end)
end)

-- ggle AutoPlay (
Tabs.Main:AddToggle("AutoSkip", {
	Title = "AutoSkip",
	Description = "Auto put Autoskip.",
	Default = set.Config.AutoSkip
})


Options.AutoSkip:OnChanged(function(val)
	local AutoSkip = val
	set.Config.AutoSkip = val
	save()

	if not AutoSkip then
		return
	end
	task.spawn(function()
		while set.Config.AutoSkip do
			task.wait(0.2)
			if game:GetService("Players").LocalPlayer.PlayerGui.GameGuiNoInset.Screen.Top.SkipWave.Visible and game.PlaceId ~= 108533757090220 then
				local args = {
					"y"
				}
				game:GetService("ReplicatedStorage"):WaitForChild("RemoteFunctions"):WaitForChild("SkipWave"):InvokeServer(unpack(args))
			end
		end
	end)
end)

-- ggle AutoPlay (
Tabs.Main:AddToggle("AutoX2", {
	Title = "Auto X2",
	Description = "maticallyasetss2xsspeedpwhenwthe buttontturnsuwhite.ite.",
	Default = set.Config.AutoX2
})

local runningAutoX2 = false

Options.AutoX2:OnChanged(function(val)
	set.Config.AutoX2 = val
	save()

	if not val then
		runningAutoX2 = false
		return
	end

	runningAutoX2 = true

	task.spawn(function()
		while runningAutoX2 do
			task.wait(0.2)
			local button = game:GetService("Players").LocalPlayer.PlayerGui.GameGuiNoInset.Screen.Top.WaveControls.TickSpeed.Items["2"].Title

			if button and button.BackgroundColor3 == Color3.fromRGB(255, 255, 255) and game.PlaceId ~= 108533757090220 then
				local args = {
					2
				}
				game:GetService("ReplicatedStorage"):WaitForChild("RemoteFunctions"):WaitForChild("ChangeTickSpeed"):InvokeServer(unpack(args))
			end
		end
	end)
end)

Tabs.Main:AddToggle("AutoX3", {
	Title = "Auto X3",
	Description = "Automatically sets 3x speed when the button turns white.",
	Default = set.Config.AutoX3
})

local runningAutoX3 = false

Options.AutoX3:OnChanged(function(val)
	set.Config.AutoX3 = val
	save()

	if not val then
		runningAutoX3 = false
		return
	end

	runningAutoX3 = true

	task.spawn(function()
		while runningAutoX3 do
			task.wait(0.2)
			local button = game:GetService("Players").LocalPlayer.PlayerGui.GameGuiNoInset.Screen.Top.WaveControls.TickSpeed.Items["3"].Title

			if button and button.BackgroundColor3 == Color3.fromRGB(255, 255, 255) and game.PlaceId ~= 108533757090220 then
				local args = {
					3
				}
				game:GetService("ReplicatedStorage"):WaitForChild("RemoteFunctions"):WaitForChild("ChangeTickSpeed"):InvokeServer(unpack(args))
			end
		end
	end)
end)

Tabs.Main:AddToggle("AutoFPSLow", {
	Title = "AutoFPS-Low",
	Description = "Enable very low detail mode for high FPS!",
	Default = set.Config.AutoSkip
})

Options.AutoFPSLow:OnChanged(function(val)
	local AutoFPSLow = val
	set.Config.AutoSkip = val
	save()

	if not AutoFPSLow then
		return
	end
	if set.Config.AutoSkip then
		if not game:IsLoaded() then game.Loaded:Wait() end
		repeat task.wait() until game:GetService("Players")
		repeat task.wait() until game:GetService("Players").LocalPlayer
		repeat task.wait() until game:GetService("ReplicatedStorage")
		repeat task.wait() until game:GetService("ReplicatedFirst")
		--- ��?ลิก GUI ---
		local function UltraLowGraphics()
			for _, obj in ipairs(workspace:GetDescendants()) do
				if obj:IsA("ParticleEmitter") or obj:IsA("Smoke") or obj:IsA("Fire") or obj:IsA("Sparkles") then
					obj:Destroy()
				end

				if obj:IsA("PointLight") or obj:IsA("SpotLight") or obj:IsA("SurfaceLight") then
					obj:Destroy()
				end

				if obj:IsA("Decal") or obj:IsA("Texture") then
					obj:Destroy()
				end

				if obj:IsA("Accessory") or obj:IsA("Clothing") or obj:IsA("Shirt") or obj:IsA("Pants") or obj:IsA("ShirtGraphic") then
					obj:Destroy()
				end

				if obj:IsA("BasePart") then
					obj.Material = Enum.Material.Plastic
					obj.Reflectance = 0
					obj.CastShadow = false
				end
			end

			if workspace:FindFirstChildOfClass("Terrain") then
				local terrain = workspace.Terrain
				terrain.WaterWaveSize = 0
				terrain.WaterTransparency = 1
				terrain.WaterReflectance = 0
				terrain.WaterColor = Color3.new(0, 0, 0)
			end

			local lighting = game:GetService("Lighting")
			lighting.GlobalShadows = false
			lighting.FogEnd = 1000000
			lighting.Brightness = 1
		end

		if game:IsLoaded() then
			UltraLowGraphics()
		else
			game.Loaded:Wait()
			UltraLowGraphics()
		end
	end
end)

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

local mapTeleportPositions = {
	["Gardan-Lobby 1"] = CFrame.new(85.0509491, 71.7316, 808.784729) * CFrame.Angles(0, math.rad(45), 0),
	["Gardan-Lobby 2"] = CFrame.new(97.050827, 71.7316, 808.78479) * CFrame.Angles(0, math.rad(45), 0),
	["Gardan-Lobby 3"] = CFrame.new(109.050949, 71.7316, 808.784729) * CFrame.Angles(0, math.rad(45), 0),
	["Gardan-Lobby 4"] = CFrame.new(121.050888, 71.7316, 808.784729) * CFrame.Angles(0, math.rad(45), 0),
	["Island-Lobby 1"] = CFrame.new(-470.644409, 71.7316132, 805.472778) * CFrame.Angles(0, math.rad(45), 0),
	["Island-Lobby 2"] = CFrame.new(-462.159271, 71.7316132, 813.958069) * CFrame.Angles(0, math.rad(45), 0),
	["Island-Lobby 3"] = CFrame.new(-453.67392, 71.7316132, 822.443359) * CFrame.Angles(0, math.rad(45), 0),
	["Island-Lobby 4"] = CFrame.new(-445.188568, 71.7316132, 830.928284) * CFrame.Angles(0, math.rad(45), 0)
}

local lobbyRemoteMap = {
	["Gardan-Lobby 1"] = "StartLobby_1",
	["Gardan-Lobby 2"] = "StartLobby_2",
	["Gardan-Lobby 3"] = "StartLobby_3",
	["Gardan-Lobby 4"] = "StartLobby_4",
	["Island-Lobby 1"] = "StartLobby_1",
	["Island-Lobby 2"] = "StartLobby_2",
	["Island-Lobby 3"] = "StartLobby_3",
	["Island-Lobby 4"] = "StartLobby_4"
}

Tabs.Select:AddDropdown("LobbyChoice", {
	Title = "Selected Lobby ",
	Description = "Choose which lobby to automatically join.",
	Values = { "Gardan-Lobby 1", "Gardan-Lobby 2", "Gardan-Lobby 3", "Gardan-Lobby 4","Island-Lobby 1", "Island-Lobby 2", "Island-Lobby 3", "Island-Lobby 4" },
	Default = set.Config.SelectedLobby,
	Multi = false
})

Options.LobbyChoice:OnChanged(function(val)
	SelectedLobby = val
	set.Config.SelectedLobby = val
	save()
end)

Tabs.Select:AddToggle("AutoPlayToggle", {
	Title = "AutoPlay",
	Description = "Automatically teleport and play the selected lobby.",
	Default = set.Config.AutoPlay
})

Options.AutoPlayToggle:OnChanged(function(state)
	set.Config.AutoPlay = state
	save()
	if game.PlaceId == 108533757090220 then
		if not state then
			return
		end

		local targetCFrame = mapTeleportPositions[SelectedLobby]
		local remoteName = lobbyRemoteMap[SelectedLobby]

		if not (targetCFrame and remoteName) then
			return
		end

		local char = LocalPlayer.Character
		if not (char and char:FindFirstChild("HumanoidRootPart")) then
			return
		end

		char:MoveTo(targetCFrame.Position)
		task.wait(0.1)
		char:SetPrimaryPartCFrame(targetCFrame)

		local remoteFunc = ReplicatedStorage:WaitForChild("RemoteFunctions"):FindFirstChild(remoteName)
		if remoteFunc then
			pcall(function()
				remoteFunc:InvokeServer()
			end)
		end
	end
end)

local difficultyMap = {
	["Easy"] = "dif_easy",
	["Normal"] = "dif_normal",
	["Hard"] = "dif_hard",
	["Insane"] = "dif_insane",
	["impossible"] = "dif_impossible"
}

Tabs.Select:AddDropdown("mode", {
	Title = "Select mode",
	Description = "Select which difficulty you want!",
	Values = { "Easy", "Normal", "Hard", "Insane", "impossible" },
	Default = set.Config.mode,
	Multi = false
})

Options.mode:OnChanged(function(val)
	mode = val
	set.Config.mode = val
	save()
end)

Tabs.Select:AddToggle("AutoPlaymode", {
	Title = "AutoMode",
	Description = "Vote the selected difficulty.",
	Default = set.Config.AutoPlaymode
})

Options.AutoPlaymode:OnChanged(function(state)
	set.Config.AutoPlaymode = state
	save()

	if not state then
		return
	end

	if not mode or mode == "" then
		return
	end

	task.spawn(function()
		local PlayerGui = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
		local voteUI = PlayerGui:WaitForChild("GameGui")
			:WaitForChild("Screen")
			:WaitForChild("Middle")
			:WaitForChild("DifficultyVote")

		while set.Config.AutoPlaymode do
			task.wait(0.2)

			if voteUI.Visible then
				local difficultyArg = difficultyMap[mode]
				local voteRemote = ReplicatedStorage:WaitForChild("RemoteFunctions"):WaitForChild("PlaceDifficultyVote")

				if voteRemote and difficultyArg then
					pcall(function()
						voteRemote:InvokeServer(difficultyArg)
					end)
				end

				repeat task.wait(0.5) until not voteUI.Visible
			end
		end
	end)
end)

-- Floating Button
if game.CoreGui:FindFirstChild("ThunderHub") then
	game.CoreGui.ThunderHub:Destroy()
end

local ThunderGui = Instance.new("ScreenGui")
ThunderGui.Name = "ThunderHub"
ThunderGui.ResetOnSpawn = false
ThunderGui.IgnoreGuiInset = true
ThunderGui.Parent = game.CoreGui

local DragFrame = Instance.new("Frame")
DragFrame.Name = "DragFrame"
DragFrame.Size = UDim2.new(0, 60, 0, 60)
DragFrame.Position = UDim2.new(0.5, -35, 0, 100)
DragFrame.BackgroundTransparency = 1
DragFrame.Active = true
DragFrame.Parent = ThunderGui

local Button = Instance.new("ImageButton")
Button.Name = "ToggleButton"
Button.Size = UDim2.new(1, 0, 1, 0)
Button.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Button.BackgroundTransparency = 0.2
Button.Image = "rbxassetid://106076048327121"
Button.Parent = DragFrame

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 16)
UICorner.Parent = Button

local UserInputService = game:GetService("UserInputService")
local dragging = false
local dragStart = Vector2.new()
local startPos = Vector2.new()

local function updateDrag()
	local mousePos = UserInputService:GetMouseLocation()
	local delta = mousePos - dragStart
	local newPos = startPos + delta
	DragFrame.Position = UDim2.new(0, newPos.X, 0, newPos.Y)
end

Button.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		task.defer(function()
			game:GetService("RunService").RenderStepped:Wait()
			dragging = true
			dragStart = UserInputService:GetMouseLocation()
			startPos = DragFrame.AbsolutePosition
		end)

		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
		updateDrag()
	end
end)

Button.MouseButton1Click:Connect(function()
	local coreGui = game:GetService("CoreGui")
	local target = coreGui:FindFirstChild("ScreenGui")

	if target then
		target.Enabled = not target.Enabled

		local children = target:GetChildren()
		if #children >= 2 then
			local secondChild = children[2]
			if secondChild:IsA("GuiObject") then
				secondChild.Visible = not secondChild.Visible
			end
		end
	end
end)


SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({})
InterfaceManager:SetFolder("GTD")
SaveManager:SetFolder("GTD/Settings")
InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)
Window:SelectTab(1)

print("loading...")

SaveManager:LoadAutoloadConfig()

Fluent:Notify({
	Title = "AutoPlay",
	Content = "Script loaded!",
	Duration = 6
})

-- Anti-AFK
local antiafk = getconnections or get_signal_cons
if antiafk then
	for _, v in next, antiafk(game.Players.LocalPlayer.Idled) do
		if v.Disable then v:Disable() elseif v.Disconnect then v:Disconnect() end
	end
else
	game.Players.LocalPlayer:Kick("Executor doesn't support getconnections()")
end

