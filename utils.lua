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
function M.rectsColliding(x1,y1,w1,h1,x2,y2,w2,h2)
    -- stolen from LOVE2D wiki
    return x1 < x2+w2 and
           x2 < x1+w1 and
           y1 < y2+h2 and
           y2 < y1+h1

end

return M
