local cursorSizex = 0.1
local cursorSizey = 0.1
local cursor = nil
local scaler = 0.01
local utils = require("utils")
local cursorDimensions = { w = 0, h = 0 }
local cursorHitbox = { x = 0, y = 0, w = 0, h = 0}
local scene = require("Scene1")
local minCursorSize = 0.01
local maxCursorSize = 1.0

local resolutionX, resolutionY = 1920,1080

local resRatioX, resRatioY = 1920,1080

function love.load()
    love.window.setFullscreen(true, "desktop")
    cursor = love.graphics.newImage("/arts/pointer.png")
    cursorSizex = 0.1
    cursorSizey = 0.1
    cursorDimensions.w = cursor:getWidth()
    cursorDimensions.h = cursor:getHeight()
    local dimensionX, dimensionY = love.graphics.getDimensions()
    resRatioX = dimensionX/resolutionX
    resRatioY = dimensionY/resolutionY
    scene.load()

    love.mouse.setVisible(false)
    love.mouse.setGrabbed(true)

end

function love.keypressed(key, scancode, isrepeat)
	if key == "escape" then
		love.window.close( )
	end
end

function love.wheelmoved(x, y)
    if y > 0 then
        cursorSizex = cursorSizex + scaler
        cursorSizey = cursorSizey + scaler
    elseif y < 0 then
        cursorSizex = cursorSizex - scaler
        cursorSizey = cursorSizey - scaler
    end

    if cursorSizex < minCursorSize then
        cursorSizex = minCursorSize
    end
    if cursorSizey < minCursorSize then
        cursorSizey = minCursorSize
    end
    if cursorSizex > maxCursorSize then
        cursorSizex = maxCursorSize
    end
    if cursorSizey > maxCursorSize then
        cursorSizey = maxCursorSize
    end

    cursorHitbox.w = cursorDimensions.w * cursorSizex
    cursorHitbox.h = cursorDimensions.h * cursorSizey
end

function love.mousepressed(x, y, button)
    if button == 1 then -- left mouse button
        cursorHitbox.x = x
        cursorHitbox.y = y
        for _, content in pairs(scene.data) do
            if utils.aabbColliding(cursorHitbox, content.hitbox) then
                if content.interact then content:interact() end
            end
        end
    end
end


function love.draw()
    love.graphics.setBackgroundColor(0, 0, 0, 1)
    -- changed keys to indicies because the draw order was randomized with the way it was before
    for _, content in pairs(scene.data) do
        love.graphics.draw(content.img, content.hitbox.x * resRatioX, content.hitbox.y * resRatioY, 0, content.sx*resRatioX, content.sy*resRatioY)
    end

    love.graphics.draw(cursor, love.mouse.getX(), love.mouse.getY(), 0, cursorSizex, cursorSizey)
end
