--!strict
local Main = {}

function Main.Initialize(Settings, AutomationManager, Interface, SafeLoad)
	print("[Main] Registrando módulos de automação...")

	-- Carregamento dinâmico dos módulos remotos
	local AutoKaido = SafeLoad("Modules/AutoKaido.lua")
	local AutoJuzo = SafeLoad("Modules/AutoJuzo.lua")
	local AutoBounty = SafeLoad("Modules/AutoBounty.lua")
	local AutoFish = SafeLoad("Modules/AutoFish.lua")
	local AutoMerchant = SafeLoad("Modules/AutoMerchant.lua")
	local AutoHalloween = SafeLoad("Modules/AutoHalloween.lua")
	local AutoBaal = SafeLoad("Modules/AutoBaal.lua")
	local AutoHaki = SafeLoad("Modules/AutoHaki.lua")
	local AutoBuso = SafeLoad("Modules/AutoBuso.lua")
	local AutoKraken = SafeLoad("Modules/AutoKraken.lua")
	local AutoSeaBeast = SafeLoad("Modules/AutoSeaBeast.lua")
	local AutoMihawk = SafeLoad("Modules/AutoMihawk.lua")
	local AutoRoger = SafeLoad("Modules/AutoRoger.lua")

	-- Registro de Tarefas
	AutomationManager.RegisterTask("AutoKaido", AutoKaido.Execute)
	AutomationManager.RegisterTask("AutoJuzo", AutoJuzo.Execute)
	AutomationManager.RegisterTask("AutoBounty", AutoBounty.Execute)
	AutomationManager.RegisterTask("AutoFish", AutoFish.Execute)
	AutomationManager.RegisterTask("AutoMerchant", AutoMerchant.Execute)
	AutomationManager.RegisterTask("AutoHalloween", AutoHalloween.Execute)
	AutomationManager.RegisterTask("AutoBaal", AutoBaal.Execute)
	AutomationManager.RegisterTask("AutoHaki", AutoHaki.Execute)
	AutomationManager.RegisterTask("AutoBuso", AutoBuso.Execute)
	AutomationManager.RegisterTask("AutoKraken", AutoKraken.Execute)
	AutomationManager.RegisterTask("AutoSeaBeast", AutoSeaBeast.Execute)
	AutomationManager.RegisterTask("AutoMihawk", AutoMihawk.Execute)
	AutomationManager.RegisterTask("AutoRoger", AutoRoger.Execute)

	-- Construir Interface
	Interface.Build(Settings, AutomationManager, {})
end

return Main
