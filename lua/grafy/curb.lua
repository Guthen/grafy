---   line
local meta = {}
meta.__index = meta
meta.label = nil
meta.color = color_white
meta.step = { x = .01, y = .01 }
meta.draw_method = GRAFY_LINE
meta.draws = {
    [GRAFY_DOT] = function( self, canvas )
        for x = 0, canvas.w / canvas.grid_size * canvas.step.x, self.step.x do
            local line_y = self:formula( x )
            draw.RoundedBox( 0, canvas:get_absolute_x( x ) - canvas.dot_size / 2 + 1, canvas:get_absolute_y( line_y ) - canvas.dot_size / 2 + 1, canvas.dot_size, canvas.dot_size, self.color )
        end
    end,
    [GRAFY_LINE] = function( self, canvas )
        surface.SetDrawColor( self.color )

        local last_line_y
        for x = 0, canvas.w / canvas.grid_size, self.step.x do
            local line_y = canvas:get_absolute_y( self:formula( x ) )
            if last_line_y then
                surface.DrawLine( canvas:get_absolute_x( x ), line_y, canvas:get_absolute_x( last_line_y and x - self.step.x or x ), last_line_y or line_y )
            end
            last_line_y = line_y
        end
    end,
}

function meta:construct( formula, label )
    return setmetatable( {
        _formula = formula,
        label = label,
        color = ColorRand(),
    }, self )
end

function meta:set_label( label )
    self.label = label
end

function meta:formula( x )
    return self._formula( x )
end

function meta:draw( canvas )
    self.draws[self.draw_method]( self, canvas )
end

return meta