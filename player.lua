local M = {}
M.inventory = {} -- hotbar-style inventory
M.minSize = 0.01
M.maxSize = 1.0
M.size = 0.1
M.hitbox = { x = 0, y = 0, w = 0, h = 0 }
M.currentState = 'idle'

local spriteSheets = {} -- table of all the sprite sheets for various sizes
local spriteQuad
local currentFrame = 0
local totalFramesPerSheet = 4 -- temp value: ask
local startTimer = 0
local spriteWidth  -- size of 1 moment of the sprite 


function M.load()
    -- load spritesheet and set hitbox accordingly
    spriteSheets['idle'] = {} -- load
    spriteWidth = spriteSheets['idle']:getWidth()/totalFramesPerSheet
    spriteQuad = love.graphics.newQuad(0, 0, spriteWidth, spriteSheets['idle']:getHeight(), 1, 1)
    startTimer = love.timer.getTime()
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
    -- hitbox will need to be updated
end

function M.update(dt)
    -- animation code updating
    local fps = 12
    local timeStep = ((love.timer.getTime() - startTimer) / fps)
    if math.abs(timeStep - math.floor(timeStep)) < 0.000001 then
        if currentFrame >= totalFramesPerSheet then
            currentFrame = 0
        else
            currentFrame = currentFrame + 1
        end
    end
    spriteQuad.x = currentFrame * spriteWidth
end

local function getScale() -- gets the amount the texture should be scaled, depending on the size (e.g. special cases)
    return M.size
end

function M.draw()
    love.graphics.draw(spriteSheets[M.currentState], spriteQuad, M.hitbox.x, M.hitbox.y, getScale(), getScale(), 0,0,0,0)
end

return M
