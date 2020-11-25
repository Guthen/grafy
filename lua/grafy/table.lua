--  table
local meta = {}
meta.__index = meta
meta.values = {}
meta.color = color_white
meta.draw_method = GRAFY_DOT

--[[
    create a drawable grafy's table:
        table values => { x1, y1, x2, y2, ... }
        nullable number parse_method => [GRAFY_XY; GRAFY_Y]; default GRAFY_XY
        nullable string label
]]
function meta:construct( values, parse_method, label )
    local parse_method = parse_method or GRAFY_XY
    if parse_method == GRAFY_XY then
        assert( #values % 2 == 0, "grafy: values can't be parsed (values must have x;y coordinates filled)" )
    end

    --  parse
    local parsed_values = {}
    local max_x, max_y = -math.huge, -math.huge
    for i, v in ipairs( values ) do
        if parse_method == GRAFY_XY then
            if ( i + 1 ) % 2 == 0 then
                parsed_values[#parsed_values + 1] = {
                    x = v,
                    y = nil,
                }
                max_x = math.max( v, max_x )
            else
                parsed_values[#parsed_values].y = v
                max_y = math.max( v, max_y )
            end
        elseif parse_method == GRAFY_Y then
            parsed_values[#parsed_values + 1] = {
                x = i,
                y = v,
            }
        end
    end

    --  create table
    return setmetatable( {
        max = {
            x = max_x,
            y = max_y,
        },
        label = label,
        values = parsed_values,
        color = ColorRand(),
    }, self )
end

function meta:calculate_average_dots()
    --  split values in two blocks
    local i = 1
    local n_spliter, blocks = #self.values / 2, {}
    for block_id = 0, 1 do
        blocks[block_id + 1] = {}

        for n = 1, n_spliter do
            blocks[block_id + 1][#blocks[block_id + 1] + 1] = self.values[i]
            i = i + 1
        end
    end

    --  compute average coordinates of two dots
    local dots = {}
    for i, block in ipairs( blocks ) do
        local sum_x, sum_y = 0, 0
        for i, field in ipairs( block ) do
            sum_x = sum_x + field.x
            sum_y = sum_y + field.y
        end

        dots[i] = {
            x = sum_x / n_spliter,
            y = sum_y / n_spliter,
        }
    end

    return unpack( dots )
end

function meta:calculate_average_line()
    local dot_1, dot_2 = self:calculate_average_dots()

    local a = ( dot_2.y - dot_1.y ) / ( dot_2.x - dot_1.x )
    local b = -a * dot_1.x + dot_1.y

    return grafy.line( a, b )
end

function meta:draw( canvas )
    --  draw values
    for i, field in ipairs( self.values ) do
        canvas:draw_dot( field.x, field.y, self.color )
    end
end

return meta