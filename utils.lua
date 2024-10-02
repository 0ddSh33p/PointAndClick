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

function M.raymarchObj(px, py, target, objs)
    local len = M.distance(px, py, target.hitbox.x + target.interactOrigin[1], target.hitbox.y + target.interactOrigin[2])
    local vx = (((target.hitbox.x + target.interactOrigin[1]) - px)/len)
    local vy = (((target.hitbox.y + target.interactOrigin[2]) - py)/len)
    local currentLen = 0
    local advance = 10 -- advances by 10 units per iteration
    local currentX = px
    local currentY = py
    local result = {}
    local matches = 0
    while currentLen < len do
        currentLen = currentLen + advance
        currentX = currentX + math.sqrt(advance - (vx*vx))
        currentY = currentY + math.sqrt(advance - (vy*vy))
        for _, o in pairs(objs) do
            if o ~= target and M.pointRectColliding(currentX, currentY, o.hitbox) and o.interact then
                matches = matches + 1
                table.insert(result, matches, o)
            end
        end
    end
    if matches == 0 then result = nil end
    return result
end

function M.raymarchPt(px, py, tx, ty, objs)
    local len = M.distance(px, py, tx, ty)
    local vx = (tx - px)/len
    local vy = (ty - py)/len
    local currentLen = 0
    local advance = 10 -- advances by 10 units per iteration
    local currentX = px
    local currentY = py
    local result = {}
    local matches = 0
    while currentLen < len do
        currentLen = currentLen + advance
        currentX = currentX + math.sqrt(advance - (vx*vx))
        currentY = currentY + math.sqrt(advance - (vy*vy))
        for _, o in pairs(objs) do
            if M.pointRectColliding(currentX, currentY, o.hitbox) and o.interact then
                matches = matches + 1
                table.insert(result, matches, o)
            end
        end
    end
    if matches == 0 then result = nil end
    print(matches)
    return result
end

return M
