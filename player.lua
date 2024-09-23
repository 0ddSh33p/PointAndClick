local M = {}

M.inventory = {} -- hotbar-style inventory
M.currentState = 'idle'
M.hitbox = { x = 0, y = 0, w = 0, h = 0 } -- for EXTERNAL stuff -collision checks (top left corner origin)

M.minSize = 0.01
M.maxSize = 1.0
M.size = 0.3

local spriteSheets = {} -- table of all the sprite sheets for various sizes
local spriteQuads = {}

local currentFrame = 1
local totalFramesPerSheet = 7 -- temp value
local animTimer = 0
local spriteWidth, spriteHeight
local utils = require('utils')

local speed = 400
local targetX, targetY = 0, 0
local fifeX, fifeY = 0,0 -- internal x and y - where fife's feet are
local fVeloX, fVeloY = 0,0

function M.load()
    spriteSheets['idle'] = love.graphics.newImage("/arts/lizardIdle.png")
    spriteWidth = spriteSheets['idle']:getWidth()/totalFramesPerSheet
    spriteHeight = spriteSheets['idle']:getHeight()
    M.hitbox.w = spriteWidth*M.size
    M.hitbox.h = spriteHeight*M.size
    for i = 0, totalFramesPerSheet-1, 1 do
        table.insert(spriteQuads,love.graphics.newQuad(
        i*spriteWidth, 0, spriteWidth, spriteSheets['idle']:getHeight(), spriteSheets['idle']:getDimensions()))
    end
end

function love.wheelmoved(_,y)
    local scaler = 0.01
    if y > 0 then
        M.size = M.size + scaler
    elseif y < 0 then
        M.size = M.size - scaler
    end

    if M.size < M.minSize then
        M.size = M.minSize
    end
    if M.size > M.maxSize then
        M.size = M.maxSize
    end

    M.hitbox.w = spriteWidth*M.size
    M.hitbox.h = spriteHeight*M.size
end

local function getScale() -- gets the amount the texture should be scaled, depending on the size (e.g. special cases)
    return M.size
end

local function goToCursor(x,y, dt)
    local dist = utils.distance(fifeX, fifeY, x, y)
    if dist > 5 then
        fVeloX = ((x - fifeX)/dist)*speed*dt
        fVeloY = ((y - fifeY)/dist)*speed*dt
    else
        fVeloX = 0
        fVeloY = 0
    end
end

function M.update(dt)
    -- animation code updating
    animTimer = animTimer + dt
    local fps = 24
    if animTimer > (1/fps) then
        animTimer = 0
        if currentFrame >= totalFramesPerSheet then
            currentFrame = 1
        else
            currentFrame = currentFrame + 1
        end
    end
    

    if love.mouse.isDown(1) then
        targetX, targetY = love.mouse.getX(), love.mouse.getY()
    end

    goToCursor(targetX, targetY, dt)
    fifeX = fifeX + fVeloX
    fifeY = fifeY + fVeloY
    M.hitbox.x = fifeX - ((spriteWidth/2)*getScale())
    M.hitbox.y = fifeY - (spriteHeight*getScale())
end


function M.draw()
    love.graphics.draw(spriteSheets[M.currentState], spriteQuads[currentFrame], fifeX, fifeY, 0, getScale(), getScale(), spriteWidth/2,spriteHeight, 0, 0)
end

return M
