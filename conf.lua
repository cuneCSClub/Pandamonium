--Screen Configuration
function love.conf(t)
	t.title = "Pandamonium"	--Title in the window
	t.version = "0.10.0"	--LOVE version this game was made for

	t.window.width = 470	--screen width
	t.window.height = 700	--screen height
	t.window.vsync = true	--Destroy the evil screen tearing!

	-- For Windows debugging (toggle between false/true when needed)
	t.console = false
end