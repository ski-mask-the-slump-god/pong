push = require('push')
Class = require('class')
require 'Paddle'
require 'Ball'

PADDLE_SPEED = 100
WINDOW_WIDTH = 1280 
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

PLAYER1_SCORE = 0
PLAYER2_SCORE = 0

PADDLE1_POS = 33
PADDLE2_POS = VIRTUAL_HEIGHT - 56

message = 'Press Enter to start'
-- put the dotted line's start coords
x1, y1 = 214, 33
-- dotted line's end coords
x2, y2 = 214, VIRTUAL_HEIGHT - 46
-- gap length
GAP_LENG = 5
-- line distance
SEG_LENG = 10
-- distance between the x's (dx)
dx = x2 - x1
-- distance between the y's (dy)
dy = y2 - y1
-- general line distance
distance = math.sqrt(dx * dx + dy * dy)
-- number of segments
NUM_SEGS = math.floor(distance / (SEG_LENG + GAP_LENG))

function love.load()
	love.graphics.setDefaultFilter('nearest', 'nearest')
	math.randomseed(os.time())
	push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
	fullscreen = false,
	resizable = false,
	vsync = true
})
	love.window.setTitle('Pong')	
	gameState = 'start'
	player1 = Paddle(33, PADDLE1_POS, 5, 20)
	player2 = Paddle(VIRTUAL_WIDTH - 34, PADDLE2_POS ,5, 20)
	ball = Ball(VIRTUAL_WIDTH / 2 - 2, VIRTUAL_HEIGHT / 2 - 2, 4, 10)

 
end

function love.keypressed(key, scancode, isrepeat)
	if key == "escape" then
		love.event.quit()
	elseif key == 'enter' or key == 'return' then
		if gameState == 'start' then
			gameState = 'serve'
		elseif gameState == 'serve' then
			gameState = 'play'
	
			ball:reset()	
		end
	end
end


function love.update(dt)
	if gameState == 'serve' then
		ball.dy = math.random(-50, 50)
		if servingPlayer == 1 then
			ball.dx = math.random (140, 200)
		else
			ball.dx = -math.random(140, 200)
		end
	end
	if gameState == 'play' then
		if ball:collides(player1) then
			ball.dx = -ball.dx * 1.03
			ball.x = player1.x + 2*ball.radius	
			
			if ball.dy < 0 then
				ball.dy = -math.random(10, 150)
			else
				ball.dy = math.random(10, 150)
			end

		elseif ball:collides(player2) then

			ball.dx = -ball.dx * 1.03
			ball.x = player2.x - 2*ball.radius + 1
			
			if ball.dy < 0 then
				ball.dy = -math.random(10, 150)
			else
				ball.dy = math.random(10, 150)
			end
		end


		if ball.y <= 34 then
			ball.y = 34
			ball.dy = -ball.dy
		end	
		if ball.y >= 204 then 
			ball.y = 204
			ball.dy = -ball.dy
		end
	end
	
	if ball.x < 30 then
		print('player 2 win')
		message = 'Player 2 serve'
		servingPlayer = 2
		PLAYER1_SCORE = PLAYER1_SCORE + 1
		ball:reset()
		gameState = 'serve'
	end
	
	if ball.x > 405 then
		print('player 1 win')
		message = 'Player 1 serve'
		servingPlayer = 1
		PLAYER2_SCORE = PLAYER2_SCORE + 1
		ball:reset()
		gameState = 'serve'
		
	end
	
	if love.keyboard.isDown("w") then
		player1.dy = -PADDLE_SPEED
	elseif love.keyboard.isDown("s") then
		player1.dy = PADDLE_SPEED
	else
		player1.dy = 0
	end

	if love.keyboard.isDown("up") then
		player2.dy = -PADDLE_SPEED
	elseif love.keyboard.isDown("down") then
		player2.dy = PADDLE_SPEED
	else
		player2.dy = 0
	end
	
	if gameState == 'play' then
		ball:update(dt)	
	end

	player1:update(dt)
	player2:update(dt)

end
	 

function love.draw()
	push:apply('start')
	love.graphics.clear(40/255, 45/255, 52/255, 1)

	--border
	love.graphics.rectangle("line", 30, 30, 376, 180)

	--paddle 1
	player1:render()

	--paddle 2
	player2:render()

	-- circular ball
	ball:render()
	-- net
	for i = 0, NUM_SEGS - 1 do
		local t = i / (NUM_SEGS - 1)  -- Lerp factor from 0 to 1
		local startX = x1 + t * dx
		local startY = y1 + t * dy
		local endX = startX + SEG_LENG * (dx / distance)
		local endY = startY + SEG_LENG * (dy / distance)
		
		-- Draw a small line segment (dot)
		love.graphics.line(startX, startY, endX, endY)
	end		 
	-- regula font
	font = love.graphics.newFont("font.ttf", 8)
	love.graphics.setFont(font)
	love.graphics.printf('hello pong', 0, 20, VIRTUAL_WIDTH, 'center')
	love.graphics.printf(message, 0, 5, VIRTUAL_WIDTH, 'center')

	-- score fonts innit
	scoreFont = love.graphics.newFont('font.ttf', 32)
	love.graphics.setFont(scoreFont)

	love.graphics.printf(PLAYER1_SCORE, -40, 100, VIRTUAL_WIDTH, 'center')
	love.graphics.printf(PLAYER2_SCORE, 40, 100, VIRTUAL_WIDTH, 'center')
	displayFPS()

	push:apply('end')
end

function displayFPS()
	
	love.graphics.setFont(font)
	love.graphics.setColor(0, 255, 0, 255)
	love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), 10, 10)
end
