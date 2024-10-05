local M = {}
-- Misc. functions useful throughout the code

function M.clamp(v, a, b)
    local res = v
    if v < a then
        res = a
    elseif v > b then
        res = b
    end
    return res
end

-- AABB collision
function M.aabbColliding(a, b) -- assume a and b are AABBs with x, y, w, h (PLEASE)
    -- stolen from LOVE2D wiki
    return a.x < b.x+b.w and
           b.x < a.x+a.w and
           a.y < b.y+b.h and
           b.y < a.y+a.h

end

function M.pointRectColliding(x, y, rect)
    return x > rect.x and
           x < rect.x + rect.w and
           y > rect.y and
           y < rect.y + rect.h
end

function M.length(x, y)

    return math.sqrt(x*x + y*y)
end

function M.distance(x1, y1, x2, y2)
    return M.length(x2-x1, y2-y1)
end

function M.pointRhombusColliding(px, py, cx, cy, dx, dy)
    local xabs = math.abs(px - cx)
    local yabs = math.abs(py - cy)
    return xabs/dx + yabs/dy <= 1
end

-- point 'a' == the TOP point on the parallelogram
-- point 'c' is the BOTTOM point
function M.pointParallelogramColliding(px, py, ax, ay, bx, by, cx, cy, dx, dy)
    local halfColliding =  function (x1,y1,x2,y2,x3,y3)
        -- I stole this code and I **think** it uses the barycentric coordinate method of detection for triangle-pt collision
        local alpha = ((y2 - y3)*(px - x3) + (x3 - x2)*(py - y3)) /
                    ((y2 - y3)*(x1 - x3) + (x3 - x2)*(y1 - y3))
        local beta = ((y3 - y1)*(px - x3) + (x1 - x3)*(py - y3)) /
                    ((y2 - y3)*(x1 - x3) + (x3 - x2)*(y1 - y3))
        local gamma = 1.0 - alpha - beta
        return ((alpha > 0) and (beta > 0) and (gamma > 0))
    end

    return halfColliding(ax,ay,bx,by,cx,cy) or halfColliding(cx,cy,dx,dy,ax,ay)
end

function M.checkPoint (fifeX, fifeY, vectX, vectY, ignoreObj, sceneObjs)
    local distFromOrigin = 34
    local checkX = fifeX + (vectX*distFromOrigin)
    local checkY = fifeY + (vectY*distFromOrigin)
    local object = nil

    for _, o in pairs(sceneObjs) do
        if o.interact and o ~= ignoreObj and M.pointParallelogramColliding(checkX,checkY, o.hitbox.x + o.parallelogram.ax, o.hitbox.y + o.parallelogram.ay, o.hitbox.x + o.parallelogram.bx, o.hitbox.y + o.parallelogram.by, o.hitbox.x + o.parallelogram.cx, o.hitbox.y + o.parallelogram.cy, o.hitbox.x + o.parallelogram.dx, o.hitbox.y + o.parallelogram.dy) then
            object = o
        end
    end
    return object
end

function M.lerp(a,b,t) return a * (1-t) + b * t end

return M
