M = {}
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

return M
