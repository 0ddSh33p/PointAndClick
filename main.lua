local cursorSizex = 0.1
local cursorSizey = 0.1
local cursor = nil
local scaler = 0.01
scene = nil

function love.load()
    love.window.setFullscreen(true, "desktop")
    cursor = love.graphics.newImage("/arts/pointer.png")
    cursorSizex = 0.1
    cursorSizey = 0.1
    --this is the wrong way to do what I want below :(
    scene = require "Scene1"

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
    love.graphics.draw(cursor, love.mouse.getX(), love.mouse.getY(), 0, cursorSizex, cursorSizey)

    --this doesnt work yet because i don't know how to assign a script refrance to a variable
    for content in scene.data do
        love.graphics.draw(content.img, content.x, content.y, 0, content.sx, content.sy)
    end
end
