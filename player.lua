local M = {}

M.inventory = {} -- hotbar-style inventory
M.currentState = 'idle'
M.hitbox = { x = 0, y = 0, w = 0, h = 0 } -- for EXTERNAL stuff -collision checks (top left corner origin)

M.minSize = 0.01
M.maxSize = 1.0
M.size = 0.3
M.currentTarget = nil
M.facing = 7 --number like a clock, 1 is straight up, each number higher movers 45 degrees clockwise

local utils = require('utils')
local spritesheet = require('spritesheet')
local animTable

local fifeSS

local speed = 400
local targetX, targetY = 0, 0
local fifeX, fifeY = 0,0 -- internal x and y - where fife's feet are
local fVeloX, fVeloY = 0,0

local sqrt2 = 0
local inFront = false
local vectX = 0
local vectY = 0

function M.load()
    animTable = {
        ['idle'] = {1, 7}
    }
    fifeSS = spritesheet.load("arts/lizardIdle.png", 7, animTable)
    spritesheet.setAnimation(fifeSS, 'idle')
    M.hitbox.w = fifeSS.spriteWidth*M.size
    M.hitbox.h = fifeSS.spriteHeight*M.size
    fifeX = 400
    fifeY = 400
    targetX = fifeX
    targetY = fifeY
    sqrt2 = math.sqrt(2)
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

local function goToPt(mX,mY, sceneData, dt)
    local x, y
    local errorMargin
    if M.currentTarget ~= nil then
        x = M.currentTarget.hitbox.x+M.currentTarget.interactOrigin[1]
        y = M.currentTarget.hitbox.y+M.currentTarget.interactOrigin[2]
        errorMargin = M.currentTarget.distanceBuffer
    else
        x, y = mX, mY
        errorMargin = 5
    end

    local dist = utils.distance(fifeX, fifeY, x, y)
    if dist > errorMargin then

        if vectX == 0 then vectX = (x - fifeX)/dist end
        if vectY == 0 then vectY = (y - fifeY)/dist end

        local objInFront = utils.checkPoint(fifeX,fifeY, vectX,vectY , M.currentTarget, sceneData)
        --local objBehind = utils.checkPoint(fifeX,fifeY, -vectX,-vectY, M.currentTarget, sceneData)
        local objRight = utils.checkPoint(fifeX,fifeY, vectY, -vectX, M.currentTarget, sceneData)
        local objLeft = utils.checkPoint(fifeX,fifeY, -vectY, vectX, M.currentTarget, sceneData)

        --local objFrontRight = utils.checkPoint(fifeX,fifeY, (vectX*sqrt2/2)+(vectY*sqrt2/2), -(vectX*sqrt2/2)+(vectY*sqrt2/2), M.currentTarget, sceneData)
        --local objFrontLeft = utils.checkPoint(fifeX,fifeY, (vectX*sqrt2/2)-(vectY*sqrt2/2), (vectX*sqrt2/2)+(vectY*sqrt2/2), M.currentTarget, sceneData)
        --local objBackRight = utils.checkPoint(fifeX,fifeY, -(vectX*sqrt2/2)+(vectY*sqrt2/2), -(vectX*sqrt2/2)-(vectY*sqrt2/2), M.currentTarget, sceneData)
        --local objBackLeft = utils.checkPoint(fifeX,fifeY, -(vectX*sqrt2/2)-(vectY*sqrt2/2), (vectX*sqrt2/2)-(vectY*sqrt2/2), M.currentTarget, sceneData)

        debugText = "x: "..fifeX.." y: "..fifeY
        if objInFront ~= nil then
            inFront = true
            local screenX, screenY = love.graphics.getDimensions()

            if math.abs(vectX) < math.abs(vectY)then
                if vectY < 0 then
                    if fifeX < screenX/2 then
                        vectX = (vectX*sqrt2/2)+(vectY*sqrt2/2)
                        vectY = -(vectX*sqrt2/2)+(vectY*sqrt2/2)
                    else
                        vectX = (vectX*sqrt2/2)-(vectY*sqrt2/2)
                        vectY = (vectX*sqrt2/2)+(vectY*sqrt2/2)
                    end
                else
                    if fifeX > screenX/2 then
                        vectX = (vectX*sqrt2/2)+(vectY*sqrt2/2)
                        vectY = -(vectX*sqrt2/2)+(vectY*sqrt2/2)
                    else
                        vectX = (vectX*sqrt2/2)-(vectY*sqrt2/2)
                        vectY = (vectX*sqrt2/2)+(vectY*sqrt2/2)
                    end
                end
            else
                if vectX > 0 then
                    if fifeX < screenY/2 then
                        vectX = (vectX*sqrt2/2)-(vectY*sqrt2/2)
                        vectY = (vectX*sqrt2/2)+(vectY*sqrt2/2)
                    else
                        vectX = (vectX*sqrt2/2)+(vectY*sqrt2/2)
                        vectY = -(vectX*sqrt2/2)+(vectY*sqrt2/2)
                    end
                else
                    if fifeX > screenY/2 then
                        vectX = (vectX*sqrt2/2)-(vectY*sqrt2/2)
                        vectY = (vectX*sqrt2/2)+(vectY*sqrt2/2)
                    else
                        vectX = (vectX*sqrt2/2)+(vectY*sqrt2/2)
                        vectY = -(vectX*sqrt2/2)+(vectY*sqrt2/2)
                    end
                end
            end
            fVeloX = vectX *speed*dt
            fVeloY = vectY *speed*dt
        else
            if objLeft ~= nil or objRight ~= nil then
                fVeloX = vectX *speed*dt
                fVeloY = vectY *speed*dt
            else
                inFront = false
                vectX = (x - fifeX)/dist
                vectY = (y - fifeY)/dist
                fVeloX = vectX *speed*dt
                fVeloY = vectY *speed*dt
            end
        end
    else
        fVeloX = 0
        fVeloY = 0
    end
end

function M.setClicked(object)
    M.currentTarget = object
end

function M.update(sceneData, resRatioX, resRatioY, dt)
    -- animation code updating
    spritesheet.update(fifeSS, dt)


    -- does work
    if love.mouse.isDown(1) then
        targetX, targetY = love.mouse.getX() / resRatioX, love.mouse.getY() / resRatioY
    end
    goToPt(targetX, targetY, sceneData, dt)

    fifeX = fifeX + fVeloX
    fifeY = fifeY + fVeloY
    M.hitbox.x = fifeX - ((fifeSS.spriteWidth/2)*getScale())
    M.hitbox.y = fifeY - (fifeSS.spriteHeight*getScale())

end


function M.draw(resRatioX, resRatioY)
    spritesheet.draw(fifeSS, fifeX * resRatioX, fifeY * resRatioY, getScale(), fifeSS.spriteWidth/2, fifeSS.spriteHeight)
end

return M
