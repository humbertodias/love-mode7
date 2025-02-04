function love.load()
    love.graphics.setDefaultFilter("nearest", "nearest")

    road = love.graphics.newImage("images/road 1.png")
    car = love.graphics.newImage("images/car.png")
    require "libs.class_basic"

    const = {    
        width = 320,
        height = 240,
        widthHalf = 160,
        heightHalf = 120,
        
        strips = 120,
        stripSize = 1,
        
        roadWidth = road:getWidth(),
        roadHeight = road:getHeight(),
        carWidth = car:getWidth(),
        carHeight = car:getHeight(),
        
        minimapScale = 6,
        roadScale = 10,
        
        acceleration = 300,
        turnSpeed = 20
    }
    
    roadQuad = love.graphics.newQuad(0, 0, const.roadWidth, const.roadHeight, road:getDimensions())
    roadMinimap = love.graphics.newQuad(0, 0, const.roadWidth / const.minimapScale, const.roadHeight / const.minimapScale, road:getDimensions())

    time = 0
    rot = 0
    position = { x = const.roadWidth / 2, y = const.roadHeight / 2 }
    velocity = { l = 0, r = 0 }

    love.window.setMode(const.width, const.height)
    love.window.setTitle("LÖVE Racing Game")

    love.graphics.setBackgroundColor(100 / 255, 150 / 255, 245 / 255)
end

function love.update(dt)
    time = time + dt

    if love.keyboard.isDown("w", "up") then
        velocity.l = velocity.l + 400 * dt
    elseif love.keyboard.isDown("s", "down") then
        velocity.l = velocity.l - 400 * dt
    end
    
    if love.keyboard.isDown("a", "left") then
        velocity.r = velocity.r - 20 * dt
    elseif love.keyboard.isDown("d", "right") then
        velocity.r = velocity.r + 20 * dt
    end

    velocity.r = velocity.r / (1 + 5 * dt)
    velocity.l = velocity.l / (1 + 2 * dt)

    rot = rot + velocity.r * dt

    position.x = position.x - velocity.l * math.cos(rot + math.pi / 2) * dt
    position.y = position.y + velocity.l * math.sin(rot + math.pi / 2) * dt
end

function love.draw()
    for i = 1, const.strips do
        love.graphics.stencil(function()
            love.graphics.rectangle("fill", 0, const.heightHalf + i * const.stripSize - const.stripSize, const.width, const.stripSize)
        end, "replace", 1)

        love.graphics.setStencilTest("greater", 0)

        local scale = i / const.roadScale
        local alpha = math.min(i * 20 / 255, 1)

        love.graphics.setColor(1, 1, 1, alpha)
        love.graphics.draw(road, roadQuad, const.widthHalf, 0, rot, scale, scale, position.x, position.y)

        love.graphics.setStencilTest()
    end

    -- Minimap
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(road, roadMinimap, 5, 5)

    -- Car position on minimap
    love.graphics.setColor(1, 0, 0)
    local miniX = position.x / const.minimapScale + 5 - 1
    local miniY = position.y / const.minimapScale + 5 - 1
    love.graphics.circle("fill", miniX, miniY, 2)

    love.graphics.line(miniX, miniY, miniX + math.sin(rot) * 4, miniY + math.cos(rot) * 4)
end

function love.keypressed(key)
    if key == "escape" then love.event.quit() end
end
