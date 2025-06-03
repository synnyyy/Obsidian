getgenv().script_key = nil
task.spawn(function()
	loadstring(
		game:HttpGet(
			'https://api.luarmor.net/files/v3/loaders/f054e1fe86804d7a145e12a2ce755505.lua'
		)
	)()
end)
repeat
	task.wait()
until getgenv().Library ~= nil
return getgenv().Library
