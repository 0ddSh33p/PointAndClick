local cursorSizex = 0.1
local cursorSizey = 0.1
local cursor = nil
local scaler = 0.01
local scene = require("Scene1")

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

    if cursorSizex < 0.01 then
        cursorSizex = 0.01
    end
    if cursorSizey < 0.01 then
        cursorSizey = 0.01
    end
    if cursorSizex > 1 then
        cursorSizex = 1
    end
    if cursorSizey > 1 then
        cursorSizey = 1
    end
end

function love.update(dt)

end


function love.draw()
    love.graphics.setBackgroundColor(1, 1, 1, 1)

    -- The reason you have to use pairs is that in Lua, for loops work on a specific data format - pairs turns a table into that data format
    for _, content in pairs(scene.data) do
        love.graphics.draw(content.img, content.x, content.y, 0, content.sx, content.sy)
    end

    love.graphics.draw(cursor, love.mouse.getX(), love.mouse.getY(), 0, cursorSizex, cursorSizey)
end
