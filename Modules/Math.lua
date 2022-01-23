local Math = {
    physicsignore = {workspace:FindFirstChild("Players"), workspace.CurrentCamera, workspace:FindFirstChild("Ignore")},
    raycast = workspace.FindPartOnRayWithIgnoreList,
    wraycast = workspace.FindPartOnRayWithWhitelist,
    dot = Vector3.new().Dot,
    v3 = Vector3.new(),
}

function Math.wtvp(p)
    p = workspace.CurrentCamera:WorldToViewportPoint(p)
    return Vector2.new(p.X, p.Y), p.Z
end

local function bulletcheck(o, t, p)
    if p <= 0.01 then
        return false
    end

    local ve = t - o
    local n = ve.Unit
    local h, po = Math.raycast(workspace, Ray.new(o, ve), Math.physicsignore)

    if h then
        if h.CanCollide and h.Transparency == 0 and h.Name ~= "Window" then
            local e = h.Size.Magnitude * n
            local _, dp = Math.wraycast(workspace, Ray.new(po + e, -e), {h})
            local m = (dp - po).Magnitude

            if m >= p then
                return false
            else
                p = p - m
            end
        end

        return bulletcheck(po + n / 100, t, p)
    end

    return true
end

Math.bulletcheck = bulletcheck

function Math.trajectory(o, a, t, s, e)
    local f = -a
    local ld = t - o
    local a = Math.dot(f, f)
    local b = 4 * Math.dot(ld, ld)
    local k = (4 * (Math.dot(f, ld) + s * s)) / (2 * a)
    local v = (k * k - b / a) ^ 0.5
    local t, t0 = k - v, k + v

    if not (t > 0) then
        t = t0
    end

    t = t ^ 0.5
    return f * t / 2 + (e or Math.v3) + ld / t, t
end

function Math.getpartinfo2(cf, s)
    local Top = s.Y / 2
    local Bottom = -s.Y / 2
    local Front = -s.Z / 2
    local Back = s.Z / 2
    local Left = -s.X / 2
    local Right = s.X / 2

    return {
        LeftTopFront = Math.wtvp((cf * CFrame.new(Vector3.new(Left, Top, Front))).Position),
        RightTopFront = Math.wtvp((cf * CFrame.new(Vector3.new(Right, Top, Front))).Position),
        LeftBottomFront = Math.wtvp((cf * CFrame.new(Vector3.new(Left, Bottom, Front))).Position),
        RightBottomFront = Math.wtvp((cf * CFrame.new(Vector3.new(Right, Bottom, Front))).Position),
        LeftTopBack = Math.wtvp((cf * CFrame.new(Vector3.new(Left, Top, Back))).Position),
        RightTopBack = Math.wtvp((cf * CFrame.new(Vector3.new(Right, Top, Back))).Position),
        LeftBottomBack = Math.wtvp((cf * CFrame.new(Vector3.new(Left, Bottom, Back))).Position),
        RightBottomBack = Math.wtvp((cf * CFrame.new(Vector3.new(Right, Bottom, Back))).Position)
    }
end

function Math.getposlist3(l)
    local Top = -math.huge
    local Bottom = math.huge
    local Front = math.huge
    local Back = -math.huge
    local Left = math.huge
    local Right = -math.huge

    for i, v in pairs(l) do
        Top = (v.Y > Top) and v.Y or Top
        Bottom = (v.Y < Bottom) and v.Y or Bottom
        Front = (v.Z < Front) and v.Z or Front
        Back = (v.Z > Back) and v.Z or Back
        Left = (v.X < Left) and v.X or Left
        Right = (v.X > Right) and v.X or Right
    end

    return {
        LeftTopFront = Math.wtvp(Vector3.new(Left, Top, Front)),
        RightTopFront = Math.wtvp(Vector3.new(Right, Top, Front)),
        LeftBottomFront = Math.wtvp(Vector3.new(Left, Bottom, Front)),
        RightBottomFront = Math.wtvp(Vector3.new(Right, Bottom, Front)),
        LeftTopBack = Math.wtvp(Vector3.new(Left, Top, Back)),
        RightTopBack = Math.wtvp(Vector3.new(Right, Top, Back)),
        LeftBottomBack = Math.wtvp(Vector3.new(Left, Bottom, Back)),
        RightBottomBack = Math.wtvp(Vector3.new(Right, Bottom, Back))
    }
end

function Math.getposlist2(l)
    local TopY = math.huge
    local BottomY = -math.huge
    local RightX = -math.huge
    local LeftX = math.huge

    for i, v in pairs(l) do
        TopY = (v.Y < TopY) and v.Y or TopY
        BottomY = (v.Y > BottomY) and v.Y or BottomY
        LeftX = (v.X < LeftX) and v.X or LeftX
        RightX = (v.X > RightX) and v.X or RightX
    end

    return {
        Positions = {
            TopLeft = Vector2.new(LeftX, TopY), 
            TopRight = Vector2.new(RightX, TopY), 
            BottomLeft = Vector2.new(LeftX, BottomY), 
            Middle = Vector2.new((RightX - LeftX) / 2 + LeftX, (BottomY - TopY) / 2 + TopY), 
            BottomRight = Vector2.new(RightX, BottomY)
        },
        Quad = {
            PointB = Vector2.new(LeftX, TopY), 
            PointA = Vector2.new(RightX, TopY), 
            PointC = Vector2.new(LeftX, BottomY), 
            PointD = Vector2.new(RightX, BottomY)
        }
    }
end

return Math
