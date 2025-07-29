local enemy = require "Enemy"
local love = require "love"


function love.load ()
    wf = require "libs.windfield"
    world = wf.newWorld(0,0)

    anim8 = require 'libs.anim8'
    love.graphics.setDefaultFilter("nearest", "nearest") -- scales pixles to avoid bluring

    camera = require 'libs.camera'
    cam = camera()
    cam:zoom(1)

    sti = require 'libs/sti'
    starterMap = sti('maps/testMap.lua')
    biggerMap = sti('maps/testMap1.lua')

    player = {}
    player.collider = world:newBSGRectangleCollider(25,15, 15,30,14)
    player.collider:setFixedRotation(true)
    player.x = 25
    player.y = 15
    player.speed = 300
    player.spriteSheet = love.graphics.newImage('sprites/multiKnight/Spritesheet_with_Shadows.png')
    player.grid = anim8.newGrid(48,48, player.spriteSheet:getWidth(), player.spriteSheet:getHeight())


    player.animations = {}
    player.animations.left = anim8.newAnimation(player.grid('1-6',4), 0.2) -- left animation (first numbers is collums (how many sprites for  animation), second number is which row third number is speed between animation)
    player.animations.right = anim8.newAnimation(player.grid('1-6', 3), 0.2) -- right animation
    player.animations.up = anim8.newAnimation(player.grid('1-6', 6), 0.2)    -- up animation
    player.animations.down = anim8.newAnimation(player.grid('1-6', 5), 0.2)  -- down animation
    
    player.anim = player.animations.left
end

function love.update(dt)  -- runs every frame dt = delta time
    local playerMoving = false
    local vx = 0
    local vy = 0

    if love.keyboard.isDown("left") or love.keyboard.isDown("a") then
        vx = player.speed * -1
        player.anim = player.animations.left
        playerMoving = true
    end
    if love.keyboard.isDown("right") or love.keyboard.isDown("d") then
        vx = player.speed 
        player.anim = player.animations.right
        playerMoving = true
    end
     if love.keyboard.isDown("up") or love.keyboard.isDown("w") then
        vy = player.speed * -1
        player.anim = player.animations.up
        playerMoving = true
    end
    if love.keyboard.isDown("down") or love.keyboard.isDown("s") then
        vy = player.speed
        player.anim = player.animations.down
        playerMoving = true
    end

    player.collider:setLinearVelocity(vx,vy)

    -- if the character isnt move set it to frame 1 
    if playerMoving == false then
        player.anim:gotoFrame(1)
    end

    world:update(dt)
    player.x = player.collider:getX()
    player.y = player.collider:getY()

    player.anim:update(dt)

    cam:lookAt(player.x, player.y)

    local w = love.graphics.getWidth()
    local h = love.graphics.getHeight()

    if cam.x < w/2 then
        cam.x = w/2
    end
    if cam.y < h/2 then
        cam.y = h/2
    end

    local mapW = biggerMap.width * biggerMap.tilewidth
    local mapH = biggerMap.height * biggerMap.tileheight

    if cam.x > (mapW - w/2) then
        cam.x = (mapW - w/2)
    end
     if cam.y > (mapH - h/2) then
        cam.y = (mapH - h/2)
    end
end

function love.draw()
    cam:attach()
     -- drawring the tile map in different levels
        biggerMap:drawLayer(biggerMap.layers["behind"])
        biggerMap:drawLayer(biggerMap.layers["Top"])
        player.anim:draw(player.spriteSheet, player.x, player.y, nil, 2,2,32,32)
        world:draw()
    cam:detach()

    love.graphics.print("FPS: "..tostring(love.timer.getFPS( )), 10, 10)
end