task.spawn(function()
	loadstring(
		game:HttpGet(
			'https://pastebin.com/raw/RjPWj8zm?t=' .. tick()
		)
	)()
end)
repeat
	task.wait()
until getgenv().Library ~= nil
return getgenv().Library
