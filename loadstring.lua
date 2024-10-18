local HttpService = game:GetService("HttpService")

local Iris = loadstring(game:HttpGet("https://raw.githubusercontent.com/kchouzi/Iris-UI-Library-for-Exploits/refs/heads/main/lib/init.lua"))().Init(game.CoreGui)

local Config = {
	AutoFarm = {
		Enabled = false,
		TeleportCooldown = 2,
		TargetCoins = {
			Coin = false,
			Candy = false,
		};
		AntiAFK = true,
	}
}

local GlobalConfig = _G.Config
if GlobalConfig then
	Config = _G.Config
	_G.Config = nil
end

local function UnloadIris()
	local Iris_Root = Iris.Internal._rootInstance

	Iris.Disabled = true
	Iris.Internal._rootInstance = nil

	task.wait(0.2)

	if Iris_Root then
		Iris_Root:Destroy()
	end
end

local function SaveConfig()
	local Success, Result = pcall(function()
		return HttpService:JSONEncode(Config)
	end)

	if Success and Result then
		if not isfolder("MM2-AutoFarm") then
			makefolder("MM2-AutoFarm")
		end

		if isfolder("MM2-AutoFarm") then
			writefile("MM2-AutoFarm/Saves.txt", Result)

			print(Result)
		end
	end
end

local function LoadConfig()
	if isfolder("MM2-AutoFarm") and isfile("MM2-AutoFarm/Saves.txt") then
		local ReadFile = readfile("MM2-AutoFarm/Saves.txt")

		if ReadFile then
			local Success, Result = pcall(function()
				return HttpService:JSONDecode(ReadFile)
			end)

			if Success and Result then
				_G.Config = Result

				print(Result)
			end
		end
	end
end

local function MenuBar()
	Iris.MenuBar()
	do
		Iris.Menu({"File"})
		do 
			local LoadConfig_MenuItem = Iris.MenuItem({"Load Config"})
			if LoadConfig_MenuItem.clicked() then
				task.spawn(function()
					LoadConfig()
					UnloadIris()
					
					loadstring(game:HttpGet("https://raw.githubusercontent.com/kchouzi/q-0M-l-0j/refs/heads/main/loadstring.lua"))()
				end)
			end

			local SaveConfig_MenuItem = Iris.MenuItem({"Save Config"})
			if SaveConfig_MenuItem.clicked() then
				task.spawn(SaveConfig)
			end
		end
		Iris.End()

		Iris.Menu({"View"})
		do 
			Iris.MenuItem({"AutoFarm"})
		end
		Iris.End()
	end
	Iris.End()
end

Iris:Connect(function()
	Iris.Window({"MM2 AutoFarm - v1.0.0hlw"})
	do
		do
			MenuBar()
		end

		Iris.SeparatorText({"Main"})
		do
			local AutoFarmEnabled_Checkbox = Iris.Checkbox({"AutoFarm Enabled"}, {isChecked = Config.AutoFarm.Enabled})
			if AutoFarmEnabled_Checkbox.checked() or AutoFarmEnabled_Checkbox.unchecked() then
				Config.AutoFarm.Enabled = AutoFarmEnabled_Checkbox.state.isChecked.value
			end

			local TeleportCooldown_InputNum = Iris.InputNum({"Teleport Cooldown", 0.01, 0}, {number = Config.AutoFarm.TeleportCooldown})
			local Warning_Text = Iris.TextColored({"You can be kicked", Color3.fromRGB(255, 0 ,0)})
			local Success, Number = pcall(function()
				return TeleportCooldown_InputNum.state.number.value
			end)

			if Success and Number then
				Config.AutoFarm.TeleportCooldown = Number

				if Number < 1.85 then
					Warning_Text.Instance.Visible = true
				else
					Warning_Text.Instance.Visible = false
				end
			end
		end

		Iris.SeparatorText({"Target Coins"})
		do
			local TargetCoins = Config.AutoFarm.TargetCoins

			for i,v in pairs(TargetCoins) do
				local Selectable = Iris.Selectable({i}, {index = v})
				if Selectable.clicked() then
					TargetCoins[i] = Selectable.state.index.value
				end
			end
		end

		Iris.SeparatorText({"Misc"})
		do 
			local AntiAFK_Checkbox = Iris.Checkbox({"Anti AFK"}, {isChecked = Config.AutoFarm.AntiAFK})
			if AntiAFK_Checkbox.checked() or AntiAFK_Checkbox.unchecked() then
				Config.AutoFarm.AntiAFK = AntiAFK_Checkbox.state.isChecked.value
			end
		end
	end
	Iris.End()
end)
