local width = 0
local height = 0
data = nil

function love.load()
    width, height = love.graphics.getDimensions( )
    data = {
        background = {
            img = love.graphics.newImage("/arts/RoomA.png"),
            x = 0,
            y = 0,
            sx = 1,
            sy = 1
        },

        leftdoor = {
            img = love.graphics.newImage("/arts/LeftDoorA.png"),
            x = 0;
            y = height - img:getHeight( ),
            sx = 1,
            sy = 1
        }
    }
end