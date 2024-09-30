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
            hitbox = {
            x = 0,
            y = 0,
            w = bgimg:getWidth(),
            h = bgimg:getHeight()
            },
            sx = 1,
            sy = 1,
        },
        {
            name = "box",
            img = box,
            hitbox = {
            x = 780,
            y = 540,
            w = box:getWidth(),
            h = box:getHeight(),
            },
            parallelogram = {
            pax = 170,
            pay = 162,
            pbx = 340,
            pby = 240,
            pcx = 170,
            pcy = 322,
            pdx = 0,
            pdy = 240
            },
            sx = 1,
            sy = 1,
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
