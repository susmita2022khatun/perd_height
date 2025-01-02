require 'class'
require 'ball'
require 'obstacle'
require 'ground'
push = require 'push'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

RADIUS_OBS = 30
CENTRE_X = VIRTUAL_WIDTH/2
CENTRE_Y = VIRTUAL_HEIGHT/2


GRAVITY = 25

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')
    main_font = love.graphics.newFont('Pixellettersfull-BnJ5.ttf', 16)

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = false,
        vsync = true
    })

    obs = obstacle(RADIUS_OBS, CENTRE_X, CENTRE_Y)
    ball = ball(20, CENTRE_Y +  RADIUS_OBS-4, 4,4, -1*math.pi/3, 80)
    ground = ground(0, CENTRE_Y + RADIUS_OBS, VIRTUAL_WIDTH, 10)

    traject_path = {}

    height_provided = 2*RADIUS_OBS
    gameState = 'start'
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end

    if key == 'enter' or key == 'return' then
        if gameState == 'start' then
            gameState = 'play'
            traject_path = {}
        else
            gameState = 'start'
            --reset envo
            ball:reset()
        end
    end
end

function love.update(dt)
    --function for updating ball in play state
    if gameState == 'play' then

        ball:update(dt)

        if obs:collide(ball) then
            local dx = ball.x - obs.centre_x
            local dy = ball.y - obs.centre_y

            local distance = math.sqrt(dx * dx + dy * dy)

            local nx = dx / distance
            local ny = dy / distance

            local dotProduct = ball.dx * nx + ball.dy * ny

            ball.dx = ball.dx - 2 * dotProduct * nx
            ball.dy = ball.dy - 2 * dotProduct * ny
            
        end

        if ground:collide(ball) then
            ball.dy = -1*ball.dy
        end

        table.insert(traject_path, {x = ball.x, y = ball.y})

        if #traject_path > 500 then
            table.remove(traject_path, 1)
        end

    end

end

function love.draw()
    push:apply('start')

    love.graphics.setColor(0, 1, 0)
    if #traject_path > 1 then
        for i = 1, #traject_path - 1 do
            love.graphics.line(traject_path[i].x, traject_path[i].y, traject_path[i + 1].x, traject_path[i + 1].y)
        end
    end

    love.graphics.setColor(0,255,0,255)
    love.graphics.setFont(main_font)
    love.graphics.print('target_radius: '..tostring(height_provided/2), VIRTUAL_WIDTH/2 - 40, VIRTUAL_HEIGHT/5)
    ground:render()
    obs:render()
    ball:render()
    push:apply('end')
end

