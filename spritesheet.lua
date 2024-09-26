local M = {}

local fps = 12

 function M.load(texturePath, frameCount, animTable)
    local result = {}
    result.texture = love.graphics.newImage(texturePath)
    result.frameCount = frameCount
    result.animTable = animTable
    result.spriteWidth = result.texture:getWidth()/frameCount
    result.spriteHeight = result.texture:getHeight()
    result.currentFrame = 1
    result.animTimer = 0
    result.startFrame = 1;
    result.endFrame = 1;
    result.spriteQuads = {}
    for i = 0, frameCount-1, 1 do
        table.insert(result.spriteQuads,love.graphics.newQuad(
        i*result.spriteWidth, 0, result.spriteWidth, result.texture:getHeight(), result.texture:getDimensions()))
    end
    return result;
end

 function M.setAnimation(ss, animName)
    ss.startFrame = ss.animTable[animName][1]
    ss.endFrame = ss.animTable[animName][2]
end

function M.update(ss, dt)
    ss.animTimer = ss.animTimer + dt
    if ss.animTimer > (1/fps) then
        ss.animTimer = 0
        if ss.currentFrame >= ss.endFrame then
            ss.currentFrame = ss.startFrame
        else
            ss.currentFrame = ss.currentFrame + 1
        end
    end
end

function M.draw(ss, x, y, scale, ox, oy)
    love.graphics.draw(ss.texture, ss.spriteQuads[ss.currentFrame], x, y, 0, scale, scale, ox, oy, 0, 0)
end

return M
