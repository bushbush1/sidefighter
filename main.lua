local enemy = require "Enemy"
local wf = require "libs.windfield"
local love = require "love"
local worldGravity = 0;
-- player

function love.load ()
    anim8 = require 'libs.anim8'
    love.graphics.setDefaultFilter("nearest", "nearest") -- scales pixles to avoid bluring

    -- camera = require 'libs.camera'
    -- cam1 = camera()
    -- cam1:zoom(2)

    sti = require 'libs/sti'
    starterMap = sti('maps/testMap.lua')

    player1 = {}
    player1.x = 25
    player1.y = 15
    player1.speed = 3
    -- player1.sprite = love.graphics.newImage('sprites/knight/with_outline/IDLE.png')
    player1.spriteSheet = love.graphics.newImage('sprites/knight/with_outline/WALK.png')
    player1.grid = anim8.newGrid(64,64, player1.spriteSheet:getWidth(), player1.spriteSheet:getHeight()) -- splitting sprite sheet into seperate images 5 mins into the anim8 vid

    player1.animations = {}
    player1.animations.left = anim8.newAnimation(player1.grid('1-8',1), 0.2):flipH()
    player1.animations.right = anim8.newAnimation(player1.grid('1-8', 1), 0.2)
    player1.animations.up = anim8.newAnimation(player1.grid('1-1', 1), 1)    -- just frame 1, slow update
    player1.animations.down = anim8.newAnimation(player1.grid('1-1', 1), 1)  -- same frame
    
    player1.anim = player1.animations.right
end

function love.update(dt)  -- runs every frame dt = delta time
    local playerMoving = false

    if love.keyboard.isDown("left") then
        player1.x = player1.x - player1.speed
        player1.anim = player1.animations.left
        playerMoving = true
    end
    if love.keyboard.isDown("right") then
        player1.x = player1.x + player1.speed
        player1.anim = player1.animations.right
        playerMoving = true
    end
     if love.keyboard.isDown("up") then
        player1.y = player1.y  - player1.speed
        player1.anim = player1.animations.up
        playerMoving = true
    end
    if love.keyboard.isDown("down") then
        player1.y = player1.y + player1.speed
        player1.anim = player1.animations.down
        playerMoving = true
    end

    -- if the character isnt move set it to frame 1 
    if playerMoving == false then
        player1.anim:gotoFrame(1)
    end

    player1.anim:update(dt)
    
end

function love.draw()
    --cam1:attach()
     -- drawring the tile map in different levels
        starterMap:drawLayer(starterMap.layers["behind"])
        starterMap:drawLayer(starterMap.layers["Top"]) 
        player1.anim:draw(player1.spriteSheet, player1.x, player1.y, nil)
    --cam1:detach()
end