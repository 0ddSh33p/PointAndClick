local M = {}

M.inventory = {} -- hotbar-style inventory
M.currentState = 'idle'
M.hitbox = { x = 0, y = 0, w = 0, h = 0 } -- for EXTERNAL stuff -collision checks (top left corner origin)

M.minSize = 0.01
M.maxSize = 1.0
M.size = 0.3
M.currentTarget = nil

local utils = require('utils')
local spritesheet = require('spritesheet')
local animTable

local fifeSS

local speed = 400
local targetX, targetY = 0, 0
local fifeX, fifeY = 0,0 -- internal x and y - where fife's feet are
local fVeloX, fVeloY = 0,0

function M.load()
    animTable = {
        ['idle'] = {1, 7}
    }
    fifeSS = spritesheet.load("arts/lizardIdle.png", 7, animTable)
    spritesheet.setAnimation(fifeSS, 'idle')
    M.hitbox.w = fifeSS.spriteWidth*M.size
    M.hitbox.h = fifeSS.spriteHeight*M.size
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

    M.hitbox.w = fifeSS.spriteWidth*M.size
    M.hitbox.h = fifeSS.spriteHeight*M.size
end

local function getScale() -- gets the amount the texture should be scaled, depending on the size (e.g. special cases)
    return M.size
end

local function goToPt(x,y, dt)
    local dist = utils.distance(fifeX, fifeY, x, y)
    if dist > 5 then
        fVeloX = ((x - fifeX)/dist)*speed*dt
        fVeloY = ((y - fifeY)/dist)*speed*dt
    else
        fVeloX = 0
        fVeloY = 0
    end
end

local function interact(obj, dt)
    -- unfinished and bad, probably temporary
    --local ox = obj.hitbox.x + obj.interactAnchor[1]
    --local oy = obj.hitbox.y + obj.interactAnchor[2]
    --local tx = obj.hitbox.x + obj.interactAnchor[1]
    --local ty = obj.hitbox.y + obj.interactAnchor[2]
    --local dist = utils.distance(fifeX, fifeY, tx, ty)
    --local away = 0
    --if obj.interactDist then away = obj.interactDist end
    --if dist > away then
    --    fVeloX = ((tx-fifeX)/dist)*speed*dt
    --    fVeloY = ((ty - fifeY)/dist)*speed*dt
    --else
    --    if obj.interact then obj:interact(M) end
    --    M.currentTarget = nil
    --    targetX = fifeX
    --    targetY = fifeY
    --    fVeloX = 0
    --    fVeloY = 0
    --end
end

function M.update(dt)
    -- animation code updating
    spritesheet.update(fifeSS, dt)


    -- doesnt work
    if M.currentTarget == nil then goToPt(targetX, targetY, dt) else interact(M.currentTarget, dt) end

    if love.mouse.isDown(1) and M.currentTarget == nil then
        targetX, targetY = love.mouse.getX(), love.mouse.getY()
    end
    fifeX = fifeX + fVeloX
    fifeY = fifeY + fVeloY
    M.hitbox.x = fifeX - ((fifeSS.spriteWidth/2)*getScale())
    M.hitbox.y = fifeY - (fifeSS.spriteHeight*getScale())
end


function M.draw()
    spritesheet.draw(fifeSS, fifeX, fifeY, getScale(), fifeSS.spriteWidth/2, fifeSS.spriteHeight)
end

return M
