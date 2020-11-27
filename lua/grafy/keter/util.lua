
function grafy.draw_circle( x, y, radius, color )
    surface.SetDrawColor( color or color_white )

    local verts = {}
    for a = 0, 360 do
        local ang = math.rad( a )
        verts[#verts + 1] = { x = x + math.cos( ang ) * radius, y = y + math.sin( ang ) * radius }
    end

    draw.NoTexture()
    surface.DrawPoly( verts )
end