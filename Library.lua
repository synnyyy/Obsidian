task.spawn(function()
	loadstring(
		game:HttpGet(
			'https://api.luarmor.net/files/v3/loaders/a7df2a3a2b58c6b63df1b951f9d9f51b.lua'
		)
	)()
end)
repeat
	task.wait()
until getgenv().Library ~= nil
return getgenv().Library
