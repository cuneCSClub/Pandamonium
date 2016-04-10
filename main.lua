coll = require 'collisions'

--Screen Configuration
function love.conf(t)
	t.title = "Pandamonium"	--Title in the window
	t.version = "0.10.0"	--LOVE version this game was made for

	t.window.width = 480	--screen width
	t.window.height = 700	--screen height
	t.window.vsync = true	--Destroy the evil screen tearing!

	-- For Windows debugging
	t.console = true
end

function love.load()
	--boolean for pause screen
	pause = false

	--boolean for sound
	mute = false

	--Initialize trampoline object
	tramp_w = 100
	tramp_h = 20

	trampoline = {
		x = (love.graphics.getWidth())/2 - tramp_w/2,	--x position of top left corner
		y = love.graphics.getHeight() - tramp_h,		--y postition of top left corner
		width = tramp_w,								--width of trampoline
		height = tramp_h,								--height of trampoline
		u = 1,											--u vector (x axis)
		v = 0,											--v vector (y axis)
		speed = 250,									--vector magnitude (movement speed)
		color = {r=255,g=255,b=255},					--color of trampoline
	}

	square = {
		x = love.graphics.getWidth() - 100,
		y = love.graphics.getHeight() - 2*tramp_h,
		width=50,
		height=50,
		color = {r=128,g=255,b=128},
		colornottouch = {r=128,g=255,b=128},
		colortouch = {r=128,g=128,b=128}
	}

	--Pause Button
	butPause = {
		x = love.graphics.getWidth() - 50,
		y = 0,
		width=50,
		height=50,
		color = {r=255,g=0,b=0}
	}

	--Pause Screen
	pauseScreen = {
		width = 500,
		height = 400,
		x = 0,
		y = 0,
		color = {r=0, g=46, b=184}
	}
	pauseScreen.x = love.graphics.getWidth() / 2 - pauseScreen.width / 2	--update x pos
	pauseScreen.y = love.graphics.getHeight() / 2 - pauseScreen.height / 2	--update y pos

	--Resume Button
	butResume = {
		width = 400,
		height = 75,
		x = 0,
		y = 0,
		color = {r=255, g=51, b=102}
	}
	butResume.x = pauseScreen.x + pauseScreen.width / 2 - butResume.width / 2	--update x pos
	butResume.y = pauseScreen.y + pauseScreen.height / 4 - butResume.height / 2	--update y pos

	--Sound Button
	butSound = {
		width = 400,
		height = 75,
		x = 0,
		y = 0,
		color = {r=255, g=51, b=102}
	}
	butSound.x = pauseScreen.x + pauseScreen.width / 2 - butSound.width / 2		--update x pos
	butSound.y = pauseScreen.y + pauseScreen.height / 2 - butSound.height / 2	--update y pos

	--Quit Button
	butQuit = {
		width = 400,
		height = 75,
		x = 0,
		y = 0,
		color = {r=255, g=51, b=102}
	}
	butQuit.x = pauseScreen.x + pauseScreen.width / 2 - butQuit.width / 2		--update x pos
	butQuit.y = pauseScreen.y + pauseScreen.height * .75 - butQuit.height / 2	--update y pos

	-- traits of different animals
	kitten = {
		speed = 3,
		bounce = 3,
		width = 30,
		height = 30
	}
	kitten.__index = kitten

	bunny = {
		speed = 3,
		bounce = 6,
		width = 30,
		height = 30
	}
	bunny.__index = bunny

	chick = {
		speed = 1,
		bounce = 1,
		width = 20,
		height = 20
	}
	chick.__index = chick

	spider = {
		speed = 1,
		bounce = 1,
		width = 20,
		height = 20
	}
	spider.__index = spider

	snake = {
		speed = 3,
		bounce = 3,
		width = 30,
		height = 30
	}
	snake.__index = snake

	elephant = {
		speed = 3,
		bounce = 0,
		width = 100,
		height = 75
	}
	elephant.__index = elephant

	-- table holding metatables for animal "objects"
	-- 1 = chick, 2 = kitten, 3 = bunny, 4 = spider, 5 = snake, 6 = elephant
	animal_types = {
		chick, kitten, bunny, spider, snake, elephant
	}
	-- table that contain animal data
	animals = {}
	number_of_animals = 0
	love.spawn()

end

function love.spawn()

	number_of_animals = number_of_animals + 1
	animals[number_of_animals] = {}
    animals[number_of_animals].x = math.random(1, love.graphics.getWidth() - (trampoline.width/3))
	animals[number_of_animals].y = 0
	animals[number_of_animals].animal_id = math.random(1,6)

	-- Change their attributes depending on what animal they are
	setmetatable(animals[number_of_animals], animal_types[animals[number_of_animals].animal_id])

	timer = 0

end


function love.update(dt)
	if pause == false then	--checks to see if the game has been paused
		timer = timer + dt
		if timer > math.random(3, 20) then
			love.spawn()
		end

		for i = 1, number_of_animals do
			animals[i].y = animals[i].y + animals[i].speed
		end

		--Set controls for trampoline
		if love.keyboard.isDown('a', 'left') then
			if trampoline.x > 0 then	--set left side of screen as boundary
				trampoline.x = trampoline.x -
					(trampoline.u * trampoline.speed * dt)
			end
		elseif love.keyboard.isDown('right', 'd') then
			if trampoline.x <
				(love.graphics.getWidth() - trampoline.width) then --set right side of screen as boundary
				trampoline.x = trampoline.x +
					(trampoline.u * trampoline.speed * dt)
			end
		end
	end

	--When mouse is clicked, mouse square to mouse's location
	if love.mouse.isDown(1) then
		square.x = love.mouse.getX()
		square.y = love.mouse.getY()
	end

	if coll.collides(square, trampoline) then
		square.color = square.colortouch
	else square.color = square.colornottouch end

	--Quit game when escape key is pressed
	if love.keyboard.isDown('escape') then
		love.event.push('quit')
	end
end

--Pause game when 'p' key is pressed
function love.keypressed(key, _, rep)
	if key == 'p' and not rep then
		pause = not pause
	end
end


function love.mousereleased(mouseX, mouseY, click)
	--Click pause button
	if click == 1 and
		mouseX >= butPause.x and mouseX <= (butPause.x + butPause.width) and
		mouseY >= butPause.y and mouseY <= (butPause.y + butPause.height) then
		pause = true
	end

	if pause then	-- Pause screen buttons
		--Click resume button
		if click == 1 and
			mouseX >= butResume.x and mouseX <= (butResume.x + butResume.width) and
			mouseY >= butResume.y and mouseY <= (butResume.y + butResume.height) then
			pause = false
		end

		--Click sound button
		if click == 1 and
			mouseX >= butSound.x and mouseX <= (butSound.x + butSound.width) and
			mouseY >= butSound.y and mouseY <= (butSound.y + butSound.height) then
			mute = not mute
		end

		--Click quit button
		if click == 1 and
			mouseX >= butQuit.x and mouseX <= (butQuit.x + butQuit.width) and
			mouseY >= butQuit.y and mouseY <= (butQuit.y + butQuit.height) then
			love.event.push('quit')
		end
	end
end

--Template rectangle for drawing
local function drawRect(obj)
	love.graphics.setColor(obj.color.r, obj.color.g, obj.color.b)
	love.graphics.rectangle("fill", obj.x, obj.y, obj.width, obj.height)
end

function love.draw()
	if pause == false then	--when game is paused, the animals are invisible
		for i = 1, number_of_animals do
			love.graphics.rectangle("fill",
				animals[i].x, animals[i].y, animals[i].width, animals[i].height)
		end
		--Draw Pause Button
		drawRect(butPause)

	else	-- game is paused
		--Draw Pause Screen
		love.graphics.setColor(pauseScreen.color.r, pauseScreen.color.g, pauseScreen.color.b)
		love.graphics.print('PAUSED', 50, 50)
		drawRect(pauseScreen)

		--Draw Resume Button
		drawRect(butResume)

		--Draw Sound Button
		drawRect(butSound)

		--Draw Quit Button
		drawRect(butQuit)
	end

	--Draw trampoline
	drawRect(trampoline)
	drawRect(square)
end
