coll = require 'collisions'
require 'animals'

function love.load()

	background = love.graphics.newImage('assets/building.png')   -- Set background image

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
	
	-- Function belonging to animals.lua
	load_animals()

end

function love.update(dt)

    for i = 1, number_of_animals do
		animals[i].delta_time = animals[i].delta_time + dt 	                      -- Keeps track of how long each animal has been in the air
		animals[i].rotation = animals[i].rotation + animals[i].rotationSpeed      -- Keeps track of how much each animal should be rotated when falling
	end

	if pause == false then	--checks to see if the game has been paused
	
		timer = timer + dt
		
		-- Spawn an animal every 2-8 seconds
		if timer > math.random(spawnRate, spawnRate * 4) then
			love.spawn()
		end

		-- Exert force of gravity on each animal (falling at different rates, unrealistic but gives variety)
		for i = 1, number_of_animals do
			animals[i].y = (animals[i].fall_rate * (animals[i].delta_time ^ 2)
                 			+ (30 * animals[i].delta_time)) -- similar to an equation y = -at^2 + bt
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

	-- Default bacground for now 
	love.graphics.setColor(255, 255, 255, 150) -- Transparency of 150 slighty transparent
	love.graphics.draw(background, 0, 0)

	if pause == false then	--when game is paused, the animals are invisible
		for i = 1, number_of_animals do
			love.graphics.setColor(255,255,255, 255) -- Get rid of the transparency
			
			-- Draw the animal pictures in the (x,y) location of each animal
			love.graphics.draw(animals[i].image, animals[i].x + animals[i].width / 2, animals[i].y + animals[i].height / 2, animals[i].rotation,
                       		   1, 1, animals[i].width/2, animals[i].height/2)
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
