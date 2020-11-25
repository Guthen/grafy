---   line
local meta = {}
meta.__index = meta
meta.label = nil
meta.a = 0
meta.b = 0
meta._highlight = nil
meta.color = color_white
meta.draw_method = GRAFY_LINE
meta.draws = {
    [GRAFY_DOT] = function( self, canvas )
        for x = 0, canvas.w / canvas.grid_size * canvas.step.x do
            local line_y = self:formula( x )
            draw.RoundedBox( 0, canvas:get_absolute_x( x ) - canvas.dot_size / 2 + 1, canvas:get_absolute_y( line_y ) - canvas.dot_size / 2 + 1, canvas.dot_size, canvas.dot_size, self.color )
        end
    end,
    [GRAFY_LINE] = function( self, canvas )
        surface.SetDrawColor( self.color )

        local last_x = canvas.w / canvas.grid_size * canvas.step.x
        surface.DrawLine( canvas:get_absolute_x( 0 ), canvas:get_absolute_y( self:formula( 0 ) ), canvas:get_absolute_x( last_x ), canvas:get_absolute_y( self:formula( last_x ) ) )
    end,
}

function meta:construct( a, b, label )
    return setmetatable( {
        a = a,
        b = b,
        label = label,
        color = ColorRand(),
    }, self )
end

function meta:highlight( x )
    self._highlight = x
end

function meta:formula( x )
    return self.a * x + self.b
end

function meta:str_formula()
    return ( "%sx + %s" ):format( self.a, self.b )
end

function meta:draw( canvas )
    self.draws[self.draw_method]( self, canvas )

    if self._highlight then
        local x, y = self._highlight, self:formula( self._highlight )
        canvas:draw_dot( x, y, self.color )
        
        local font_height = draw.GetFontHeight( grafy._fonts.normal )
        draw.SimpleText( "x = " .. x, grafy._fonts.normal, canvas:get_absolute_x( x ), canvas:get_absolute_y( y ) + font_height / 2, self.color, TEXT_ALIGN_CENTER )
        draw.SimpleText( "y = " .. y, grafy._fonts.normal, canvas:get_absolute_x( x ), canvas:get_absolute_y( y ) + font_height * 1.5, self.color, TEXT_ALIGN_CENTER )
    end
end

return meta