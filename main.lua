local enemy = require "Enemy"
local wf = require "libs.windfield"
local love = require "love"


function love.load ()
    anim8 = require 'libs.anim8'
    love.graphics.setDefaultFilter("nearest", "nearest") -- scales pixles to avoid bluring

    camera = require 'libs.camera'
    cam = camera()
    cam:zoom(1)

    sti = require 'libs/sti'
    starterMap = sti('maps/testMap.lua')
    biggerMap = sti('maps/testMap1.lua')

    player = {}
    player.x = 25
    player.y = 15
    player.speed = .5
    player.spriteSheet = love.graphics.newImage('sprites/multiKnight/Spritesheet_with_Shadows.png')
    player.grid = anim8.newGrid(48,48, player.spriteSheet:getWidth(), player.spriteSheet:getHeight())


    player.animations = {}
    player.animations.left = anim8.newAnimation(player.grid('1-6',4), 0.2) -- left animation (first numbers is collums (how many sprites for  animation), second number is which row third number is speed between animation)
    player.animations.right = anim8.newAnimation(player.grid('1-6', 3), 0.2) -- right animation
    player.animations.up = anim8.newAnimation(player.grid('1-6', 6), 0.2)    -- up animation
    player.animations.down = anim8.newAnimation(player.grid('1-6', 5), 0.2)  -- down animation

    -- player.spriteSheet = love.graphics.newImage('sprites/knight/with_outline/WALK.png')
    -- player.grid = anim8.newGrid(64,64, player.spriteSheet:getWidth(), player.spriteSheet:getHeight()) -- splitting sprite sheet into seperate images 5 mins into the anim8 vid
    -- player.animations = {}
    -- player.animations.left = anim8.newAnimation(player.grid('1-8',1), 0.15):flipH()
    -- player.animations.right = anim8.newAnimation(player.grid('1-8', 1), 0.15)
    -- player.animations.up = anim8.newAnimation(player.grid('1-8', 1), 1)  -- just frame 1, slow update
    -- player.animations.down = anim8.newAnimation(player.grid('1-8', 1), 1) -- same frame
    
    player.anim = player.animations.left
end

function love.update(dt)  -- runs every frame dt = delta time
    local playerMoving = false

    if love.keyboard.isDown("left") or love.keyboard.isDown("a") then
        player.x = player.x - player.speed
        player.anim = player.animations.left
        playerMoving = true
    end
    if love.keyboard.isDown("right") or love.keyboard.isDown("d") then
        player.x = player.x + player.speed
        player.anim = player.animations.right
        playerMoving = true
    end
     if love.keyboard.isDown("up") or love.keyboard.isDown("w") then
        player.y = player.y  - player.speed
        player.anim = player.animations.up
        playerMoving = true
    end
    if love.keyboard.isDown("down") or love.keyboard.isDown("s") then
        player.y = player.y + player.speed
        player.anim = player.animations.down
        playerMoving = true
    end

    -- if the character isnt move set it to frame 1 
    if playerMoving == false then
        player.anim:gotoFrame(1)
    end

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
    cam:detach()

    love.graphics.print("FPS: "..tostring(love.timer.getFPS( )), 10, 10)
end