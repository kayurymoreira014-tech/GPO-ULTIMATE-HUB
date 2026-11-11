--!strict
local Settings = {}
local settingsData: { [string]: any } = {}

function Settings.Set(key: string, value: any)
	settingsData[key] = value
end

function Settings.Get(key: string, defaultValue: any): any
	if settingsData[key] == nil then
		return defaultValue
	end
	return settingsData[key]
end

function Settings.Toggle(key: string): boolean
	local current = Settings.Get(key, false)
	local newState = not current
	Settings.Set(key, newState)
	return newState
end

return Settings
