--!strict
-- Loader.lua: Ponto de entrada remoto do GPO Ultimate Hub

if getgenv().GPO_HUB_LOADED then
	warn("[GPO Hub] O Hub já está em execução. Evitando carregamento duplicado.")
	return
end
getgenv().GPO_HUB_LOADED = true

local REPO_URL = "https://raw.githubusercontent.com/SEU_USUARIO/GPO-ULTIMATE-HUB/main/"

local function SafeLoad(path: string)
	local success, response = pcall(function()
		return game:HttpGet(REPO_URL .. path)
	end)
	
	if not success or not response or response == "" or response:find("404: Not Found") then
		error(string.format("[GPO Hub] Falha ao carregar o recurso remoto: %s", path))
	end
	
	local chunk, loadErr = loadstring(response)
	if not chunk then
		error(string.format("[GPO Hub] Erro de sintaxe/compilação em %s: %s", path, tostring(loadErr)))
	end
	
	return chunk()
end

print("[GPO Hub] Iniciando o carregamento remoto dos módulos...")

-- Carregamento sequencial seguro da arquitetura
local Settings = SafeLoad("Settings.lua")
local AutomationManager = SafeLoad("AutomationManager.lua")
local Interface = SafeLoad("Interface.lua")
local Main = SafeLoad("Main.lua")

-- Inicialização do Sistema Principal
if Main and type(Main.Initialize) == "function" then
	Main.Initialize(Settings, AutomationManager, Interface, SafeLoad)
	print("[GPO Hub] Carregado e inicializado com sucesso!")
else
	warn("[GPO Hub] Erro: A função de inicialização principal não foi encontrada.")
end
