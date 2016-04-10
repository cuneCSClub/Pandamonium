function load_animals()

    spawnRate = 3

	-- default values for each animal
		animalDefaults = {
			speed = 3,
			bounce = 3,
			width = 30,
			height = 30,
			color = {r=128,g=255,b=128}
		}
		animalDefaults.__index = animalDefaults

		-- unique traits of different animals
		kitten = {
			color = {r=232, g=175, b=57}
		}

		bunny = {
			bounce = 6,
			color = {r=200, g=255, b=255}
		}

		chick = {
			speed = 1,
			bounce = 1,
			width = 20,
			height = 20,
			color = {r=255, g=255, b=100}
		}

		spider = {
			speed = 1,
			bounce = 1,
			width = 20,
			height = 20,
			color = {r=128, g=128, b=128}
		}

		snake = {
			color = {r=90, g=132, b=4}
		}

		elephant = {
			bounce = 0,
			width = 100,
			height = 75,
			color = {r=160, g=160, b=160}
		}

		-- table holding metatables for animal "objects"
		-- 1 = chick, 2 = kitten, 3 = bunny, 4 = spider, 5 = snake, 6 = elephant
		animal_types = {
			chick, kitten, bunny, spider, snake, elephant
		}

		-- give each animal type the metatable of the defaults
		for i=1, #animal_types do
			-- JMA, I know this line is needed, but what does it do?
			animal_types[i].__index = animal_types[i] 
			setmetatable(animal_types[i], animalDefaults)
		end

		-- table that contain animal data
		animals = {}
		number_of_animals = 0
		love.spawn()

end

function love.spawn()

	number_of_animals = number_of_animals + 1
	animals[number_of_animals] = {}
    animals[number_of_animals].animal_id = math.random(1,6)

    -- Change their attributes depending on what animal they are
    setmetatable(animals[number_of_animals], animal_types[animals[number_of_animals].animal_id])

    animals[number_of_animals].x = math.random(1, love.graphics.getWidth() - animals[number_of_animals].width)
	animals[number_of_animals].y = 0

	timer = 0
	
end