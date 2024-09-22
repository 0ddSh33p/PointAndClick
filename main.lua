local cursorSizeX = 0.1
local cursorSizeY = 0.1
local cursor = nil
local scaler = 0.01
local utils = require("utils")
local cursorDimensions = { w = 0, h = 0 }
local scene = require("Scene1")
local minCursorSize = 0.01
local maxCursorSize = 1.0

local resolutionX, resolutionY = 1920,1080

local resRatioX, resRatioY = 1920,1080

function love.load()
    love.window.setFullscreen(true, "desktop")
    cursor = love.graphics.newImage("/arts/pointer.png")
    cursorSizeX = 0.1
    cursorSizeY = 0.1
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
        cursorSizeX = cursorSizeX + scaler
        cursorSizeY = cursorSizeY + scaler
    elseif y < 0 then
        cursorSizeX = cursorSizeX - scaler
        cursorSizeY = cursorSizeY - scaler
    end

    if cursorSizeX < minCursorSize then
        cursorSizeX = minCursorSize
    end
    if cursorSizeY < minCursorSize then
        cursorSizeY = minCursorSize
    end
    if cursorSizeX > maxCursorSize then
        cursorSizeX = maxCursorSize
    end
    if cursorSizeY > maxCursorSize then
        cursorSizeY = maxCursorSize
    end

end

function love.mousepressed(x, y, button)
    if button == 1 then -- left mouse button
        for _, content in pairs(scene.data) do
            if utils.pointRectColliding(x / resRatioX, y / resRatioY, content.hitbox) then
                if content.interact then content:interact(cursorSizeX, cursorSizeY) end
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

    love.graphics.draw(cursor, love.mouse.getX(), love.mouse.getY(), 0, cursorSizeX, cursorSizeY)
end
