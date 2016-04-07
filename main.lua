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
	p_press = false

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
		colortouch = {r=128,g=128,b=128},
	}

	-- table that contain animal data
	animals = {}
	for i = 1, 2000 do
		animals[i] = {}
		animals[i].x = 0
	end

	timer = 0
	objects = {}
	j = 1
	for i = 1, 2000 do
		objects[i] = {}
		objects[i].x = 0
		objects[i].y = 0 - (trampoline.width / 3)
	end
	objects[1].x = math.random(1,
		love.graphics.getWidth() - (trampoline.width / 3))


  -- traits of different animals
  kitten = {
		speed = 3,
		bounce = 3,
		width = 30,
		height = 30
	}

	bunny = {
		speed = 3,
		bounce = 6
		width = 30,
		height = 30
	}

	chick = {
		speed = 1,
		bounce = 1,
		width = 20,
		height = 20
	}

	spider = {
		speed = 1,
		bounce = 1
		width = 20,
		height = 20
	}

	snake = {
		speed = 3,
		bounce = 3
		width = 30,
		height = 30
	}

	elephant = {
		speed = 3,
		bounce = 0
		width = 100,
		height = 75
	}



end


function love.update(dt)
	if pause == false then	--checks to see if the game has been paused
		timer = timer + dt
		if timer > math.random(3, 20) then
			j = j + 1
			random_x_position = math.random(1,
				love.graphics.getWidth() -
				(trampoline.width / 3))
			objects[j].x = random_x_position
			timer = 0
		end

		for i = 1, j do
			objects[i].y = objects[i].y + 1
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

function love.keypressed(key, _, rep)
	if key == 'p' and not rep then
		pause = not pause
	end
end

local function drawRect(obj)
	love.graphics.setColor(obj.color.r, obj.color.g, obj.color.b)
	love.graphics.rectangle("fill", obj.x, obj.y, obj.width, obj.height)
end


function love.draw()

	if pause == false then	--when game is paused, the animals are invisible
		for i = 1, j do
			love.graphics.rectangle("fill",
				objects[i].x, objects[i].y, 20, 20)
		end
	else
		love.graphics.print('PAUSED', 50, 50)
	end

	--Draw trampoline
	drawRect(trampoline)
	drawRect(square)
end
