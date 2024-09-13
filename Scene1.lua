M = {}
local width = 0
local height = 0
M.data = {}

function M.load()
    width, height = love.graphics.getDimensions( )

    local doorimg = love.graphics.newImage("/arts/LeftDoorA.png")
    M.data = {
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
            y = height - doorimg:getHeight(),
            sx = 1,
            sy = 1
        }
    }
end

return M
