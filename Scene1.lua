M = {}
local width = 0
local height = 0
M.data = {}

function M.load()
    local doorimg = love.graphics.newImage("/arts/LeftDoorA.png")
    local plantNormal = love.graphics.newImage("/arts/plantA.png")
    local bgimg = love.graphics.newImage("/arts/RoomA.png")
    local ratioY = height/bgimg:getHeight()

    M.data = {
        {
            name = "bg",
            img = bgimg,
            hitbox = {
            x = 0,
            y = 0,
            w = bgimg:getWidth(),
            h = bgimg:getHeight()
            },
            sx = 1,
            sy = 1
        },
        {
            name = "leftDoor",
            img = doorimg,
            hitbox = {
            x = 15,
            y = 1080 - doorimg:getHeight() - 20,
            w = doorimg:getWidth(),
            h = doorimg:getHeight()
            },
            sx = 1,
            sy = 1
        },
        {
            name = "plant",
            img = plantNormal,
            hitbox = {
            x = 1200,
            y = 780,
            w = plantNormal:getWidth(),
            h = plantNormal:getHeight()
            },
            sx = 1,
            sy = 1,
            interact = function(self, cursorSizeX, cursorSizeY)
                self.hitbox.x = self.hitbox.x + 50
            end
        },
    }
end

return M
