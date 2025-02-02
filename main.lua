local cursor = nil
local utils = require("utils")
local player = require("player")
local scene = require("Scene1")

local resolutionX, resolutionY = 1920,1080

local resRatioX, resRatioY = 1,1

debugText = "ground"

function love.load()
    love.window.setFullscreen(true, "desktop")
    cursor = love.graphics.newImage("/arts/mousecursor.png")
    local dimensionX, dimensionY = love.graphics.getDimensions()
    resRatioX = dimensionX/resolutionX
    resRatioY = dimensionY/resolutionY
    scene.load()
    player.load()

    love.mouse.setVisible(false)
    love.mouse.setGrabbed(true)

end

--function love.wheelmoved(_, y)
--    player.scale(y)
--end

function love.keypressed(key, _, _)
	if key == "escape" then
		love.window.close( )
	end
end

function love.update(dt)
    player.update(scene.data, resRatioX, resRatioY, dt)
end

function love.mousepressed(x, y, button)
    if button == 1 then -- left mouse button
        for _, content in pairs(scene.data) do
            if utils.pointRectColliding(x / resRatioX, y / resRatioY, content.hitbox) then
                if content.interact then
                    player.setClicked(content)
                else
                    player.setClicked(nil)
                end
            end
        end
    end
end


function love.draw()
    love.graphics.setBackgroundColor(0, 0, 0, 1)
    -- changed keys to indicies because the draw order was randomized with the way it was before
    for _, content in pairs(scene.data) do
        love.graphics.draw(content.img, content.hitbox.x * resRatioX, content.hitbox.y * resRatioY, 0, resRatioX, resRatioY)
    end
    player.draw(resRatioX, resRatioY)

    love.graphics.setColor({0, 0, 0, 1})
    love.graphics.print(debugText,1,1)
    love.graphics.setColor({1, 1, 1, 1})

    
    love.graphics.draw(cursor, love.mouse.getX(), love.mouse.getY(), 0, 0.75*resRatioX, 0.75*resRatioY)
end
