M = {}
local width = 0
local height = 0
M.data = {}

function M.load()
    width, height = love.graphics.getDimensions( )

    local doorimg = love.graphics.newImage("/arts/LeftDoorA.png")
    local plantNormal = love.graphics.newImage("/arts/plantA.png")

    M.data = {
        {
            name = "bg",
            img = love.graphics.newImage("/arts/RoomA.png"),
            x = 0,
            y = 0,
            sx = 1,
            sy = 1
        },
        {
            name = "leftDoor",
            img = doorimg,
            x = 15,
            y = height - doorimg:getHeight() - 20,
            sx = 1,
            sy = 1
        },
        {
            name = "plant",
            img = plantNormal,
            x = 1200,
            y = 780,
            sx = 1,
            sy = 1
        },
    }
end

return M
