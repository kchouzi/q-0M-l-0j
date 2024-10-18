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

Iris:Connect(function()
	Iris.Window({"MM2 AutoFarm - v1.0.0hlw"})
	do
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
