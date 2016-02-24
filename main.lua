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
					color = {r=255,g=0,b=255}}                  --color of trampoline

 -- table that contain animal data
 animals = {}
 i = 1
 for i = 1, 2000 do
	 animals[i].x = 0
 end
 timer = 0
 -- vsync goes here

end


function love.update(dt)

  timer = timer + dt

  if timer % 5 == 0 then
    random_x_position = math.random(0, love.graphics.getWidth() - trampoline.width / 3)
		animals[i].x = random_x_position
		i = i + 1
	  timer = 0
	end

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

	--Quit game when escape key is pressed
	if love.keyboard.isDown('escape') then
		love.event.push('quit')
	end

end


function love.draw()
	for j = 1, i, 1 do
	   love.graphics.rectangle("fill", animals[j].x, 0, 20, 20)
	end
	--Draw trampoline
	love.graphics.setColor(trampoline.color.r, trampoline.color.g, trampoline.color.b)
	love.graphics.rectangle("fill", trampoline.x, trampoline.y, trampoline.width, trampoline.height)
end
