local cursorSizex = 0.1
local cursorSizey = 0.1
local cursor = nil
local scaler = 0.01
local scene = require("Scene1")


local minCursorSize = 0.01
local maxCursorSize = 1.0

function love.load()
    love.window.setFullscreen(true, "desktop")
    cursor = love.graphics.newImage("/arts/pointer.png")
    cursorSizex = 0.1
    cursorSizey = 0.1
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
end

function love.update(dt)

end


function love.draw()
    love.graphics.setBackgroundColor(0, 0, 0, 1)

    local a = 1
    -- changed keys to indicies because the draw order was randomized with the way it was before
    for index, content in pairs(scene.data) do
        love.graphics.draw(content.img, content.x, content.y, 0, content.sx, content.sy)
    end

    love.graphics.draw(cursor, love.mouse.getX(), love.mouse.getY(), 0, cursorSizex, cursorSizey)
    
end
