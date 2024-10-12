local M = {}
local width = 0
local height = 0
M.data = {}

function M.load()
    local box = love.graphics.newImage("/arts/box.png")
    local bgimg = love.graphics.newImage("/arts/placeholderBG.png")

    M.data = {
        {
            name = "bg",
            img = bgimg,
            distanceBuffer = 0,
            hitbox = {
            x = 0,
            y = 0,
            w = bgimg:getWidth(),
            h = bgimg:getHeight()
            },
        },

        {
            name = "box",
            img = box,
            distanceBuffer = 250,
            floorLine = 240,

            hitbox = {
            x = 780,
            y = 540,
            w = box:getWidth(),
            h = box:getHeight(),
            },

            parallelogram = {
                ax = 170,
                ay = 162,
                bx = 340,
                by = 240,
                cx = 170,
                cy = 322,
                dx = 0,
                dy = 240
            },
            
            interactOrigin = {
            [1] = box:getWidth()/2,
            [2] = box:getHeight()/2
            },

            interact = function(self, player)
                -- ADD STUFF TO INTERACT
            end
        },
    }
    M.floors = {
        parallelogram = {
        pax = 0,
        pay = 0,
        pbx = 0,
        pby = 1080,
        pcx = 1920,
        pcy = 1080,
        pdx = 1920,
        pdy = 0
        }
    }
end

return M
