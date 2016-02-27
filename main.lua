coll = require 'collisions'

--Screen Configuration
function love.conf(t)
	t.title = "Pandamonium" --Title in the window
	t.version = "0.10.0"    --LOVE version this game was made for
	
	t.window.width = 480    --screen width
	t.window.height = 700   --screen height
	
	-- For Windows debugging
	t.console = true
end

function love.load()
	
	--Initialize trampoline object
	tramp_w = 100
	tramp_h = 20
	trampoline =   {x = (love.graphics.getWidth())/2 - tramp_w/2, --x position of top left corner
					y = love.graphics.getHeight() - tramp_h,      --y postition of top left corner
					width = tramp_w,                              --width of trampoline
					height = tramp_h,                             --height of trampoline
					u = 1,                                        --u vector (x axis)
					v = 0,                                        --v vector (y axis)
					speed = 250,                                  --vector magnitude (movement speed)
					color = {r=255,g=255,b=255}}                  --color of trampoline

	square = {
		x = love.graphics.getWidth() - 100,
		y = love.graphics.getHeight() - 2*tramp_h,
		width=50,
		height=50,
		color = {r=128,g=255,b=128},
		colornottouch = {r=128,g=255,b=128},
		colortouch = {r=128,g=128,b=128},
	}

end


function love.update(dt)

	--Set controls for trampoline
	if love.keyboard.isDown('a', 'left') then
		if trampoline.x > 0 then --set left side of screen as boundary
			trampoline.x = trampoline.x - (trampoline.u * trampoline.speed * dt)
		end
	elseif love.keyboard.isDown('right', 'd') then
		if trampoline.x < (love.graphics.getWidth() - trampoline.width) then --set right side of screen as boundary
			trampoline.x = trampoline.x + (trampoline.u * trampoline.speed * dt)
		end
	end

	if coll.collides(square, tramp) then
		square.color = square.colortouch
	else square.color = square.colornottouch end

	--Quit game when escape key is pressed
	if love.keyboard.isDown('escape') then
		love.event.push('quit')
	end

end


function love.draw()
	--Draw trampoline
	love.graphics.setColor(trampoline.color.r, trampoline.color.g, trampoline.color.b)
	love.graphics.rectangle("fill", trampoline.x, trampoline.y, trampoline.width, trampoline.height)
	love.graphics.rectangle("fill", square.x, square.y, square.width, square.height)
end
