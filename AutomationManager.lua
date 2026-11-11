--!strict
local AutomationManager = {}

type TaskData = {
	IsRunning: boolean,
	Thread: thread?,
	Callback: () -> ()
}

local tasks: { [string]: TaskData } = {}

function AutomationManager.RegisterTask(taskName: string, callback: () -> ())
	tasks[taskName] = {
		IsRunning = false,
		Thread = nil,
		Callback = callback
	}
end

function AutomationManager.StartTask(taskName: string)
	local taskData = tasks[taskName]
	if not taskData or taskData.IsRunning then return end

	taskData.IsRunning = true
	taskData.Thread = task.spawn(function()
		while taskData.IsRunning do
			local success, err = pcall(taskData.Callback)
			if not success then
				warn(string.format("[GPO Hub] Erro na tarefa '%s': %s", taskName, tostring(err)))
				taskData.IsRunning = false
				break
			end
			task.wait(0.5)
		end
	end)
end

function AutomationManager.StopTask(taskName: string)
	local taskData = tasks[taskName]
	if not taskData or not taskData.IsRunning then return end

	taskData.IsRunning = false
	if taskData.Thread then
		task.cancel(taskData.Thread)
		taskData.Thread = nil
	end
end

function AutomationManager.IsRunning(taskName: string): boolean
	local taskData = tasks[taskName]
	return taskData and taskData.IsRunning or false
end

return AutomationManager
