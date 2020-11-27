--  canvas
local meta = {}
meta.__index = meta
meta.x = 0
meta.y = 0
meta.w = 0
meta.h = 0
meta.grid_size = 0
meta.dot_size = 0
meta.step = { x = 1, y = 1 }
meta.objects = {}
meta.color = Color( 63, 136, 196 )
meta.title = nil
meta.title_x = "x"
meta.title_y = "y"

function meta:construct( x, y, w, h, scale, title )
    local canvas = {}
    canvas.x = x
    canvas.y = y
    canvas.w = w
    canvas.h = h
    canvas.scale = scale or 1
    --[[ canvas.grid_size = math.min( w / #canvas.values, h / canvas.max.y ) * canvas.scale ]]
    canvas.grid_size = w / 20 * canvas.scale
    canvas.dot_size = canvas.grid_size / 3
    canvas.title = title
    return setmetatable( canvas, self )
end

function meta:set_axes_titles( x, y )
    self.title_x = x or self.title_x
    self.title_y = y or self.title_y
end

function meta:set_steps( x, y )
    self.step.x = x or self.step.x
    self.step.y = y or self.step.y
end

function meta:add_render_object( object )
    self.objects[#self.objects + 1] = object
end

function meta:get_absolute_x( x )
    return self.x + x * self.grid_size * 1 / self.step.x
end

function meta:get_absolute_y( y )
    return self.y + self.h - y * self.grid_size * 1 / self.step.y
end

function meta:draw_dot( x, y, color )
    draw.RoundedBox( 0, self:get_absolute_x( x ) - self.dot_size / 2 + 1, self:get_absolute_y( y ) - self.dot_size / 2 + 1, self.dot_size, self.dot_size, color )
end

function meta:draw_circle( x, y, radius, color )
    local radius = radius or self.dot_size / 2
    grafy.draw_circle( self:get_absolute_x( x ), self:get_absolute_y( y ), radius, color )
end

local axe_tick_tall = 3
local grid_color = Color( 136, 136, 136 )
local color_black = Color( 0, 0, 0 )
local axe_color = ColorAlpha( color_black, 195 )
function meta:draw()
    local x, y, w, h = self.x, self.y, self.w, self.h
    local grid_size, dot_size, step_size = self.grid_size, self.dot_size, self.step_size

    --  background
    draw.RoundedBox( 0, x, y, w, h, color_white )
    local title_gap, title_height = math.max( w * .005, h * .02 ), 0
    if self.title then
        title_height = draw.GetFontHeight( grafy._fonts.bold )
        draw.SimpleText( self.title, grafy._fonts.bold, x + w / 2, y + title_gap * 2, self.color, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP )
    end

    --  center
    local padding = math.max( w * .072, h * .1 )
    x = x + padding
    y = y + padding + title_height
    w = w - padding * 2
    h = h - padding * 2 - title_height

    --  grid
    surface.SetDrawColor( ColorAlpha( grid_color, 125 ) )

    for grid_x = 1, w / grid_size do
        surface.DrawLine( x + grid_x * grid_size, y, x + grid_x * grid_size, y + h )
    end
    for grid_y = 0, h / grid_size do
        surface.DrawLine( x, y + h - grid_y * grid_size, x + w, y + h - grid_y * grid_size )
    end

    --  axes
    surface.SetDrawColor( axe_color )

    ---   y
    for i = 0, 1 do
        surface.DrawLine( x + i, y, x + i, y + h )
    end
    draw.SimpleText( self.title_y, grafy._fonts.bold, x, y - title_gap, axe_color, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM )

    ---   x
    for i = 0, 1 do
        surface.DrawLine( x, y + h + i, x + w, y + h + i )
    end
    draw.SimpleText( self.title_x, grafy._fonts.bold, x + w + title_gap, y + h, axe_color, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )

    --  ticks
    ---   x
    for tick_x = 0, w / grid_size do
        surface.SetDrawColor( axe_color )
        surface.DrawLine( x + tick_x * grid_size, y + h + axe_tick_tall, x + tick_x * grid_size, y + h - axe_tick_tall )
        draw.SimpleText( tick_x * self.step.x, grafy._fonts.normal, x + tick_x * grid_size, y + h + axe_tick_tall * 2, axe_color, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP )
    end

    ---   y
    for tick_y = 0, h / grid_size do
        surface.SetDrawColor( axe_color )
        surface.DrawLine( x - axe_tick_tall, y + h - tick_y * grid_size, x + axe_tick_tall, y + h - tick_y * grid_size )
        draw.SimpleText( tick_y * self.step.y, grafy._fonts.normal, x - axe_tick_tall * 2, y + h - tick_y * grid_size, axe_color, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
    end

    --  setup draw canvas
    local canvas = grafy.canvas( x, y, w, h, self.scale, self.step_size )
    canvas.grid_size = self.grid_size
    canvas.title = self.title

    --  draw objects
    render.SetScissorRect( canvas.x, canvas.y, canvas.x + canvas.w, canvas.y + canvas.h, true )

    local label_i, font_height = 0, draw.GetFontHeight( grafy._fonts.normal )
    for i, object in ipairs( self.objects ) do
        object:draw( canvas )

        if object.label and object.color then
            local label_x, label_y = x + w - axe_tick_tall * 2, y + h - grid_size - font_height * label_i
            local label_w = surface.GetTextSize( object.label )
            local label_symbol_w, label_symbol_h, label_symbol_gap = axe_tick_tall * 5, axe_tick_tall * 2, axe_tick_tall * 2

            draw.SimpleText( object.label, grafy._fonts.normal, label_x, label_y, object.color, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
            
            if object.draw_method == GRAFY_LINE then
                surface.DrawLine( label_x - label_w - label_symbol_w, label_y + 1, label_x - label_w - label_symbol_gap, label_y + 1 )
            elseif object.draw_method == GRAFY_DOT then
                draw.RoundedBox( 0, label_x - label_w - label_symbol_w / 2 - label_symbol_h / 2, label_y - label_symbol_h / 4, label_symbol_h, label_symbol_h, object.color )
            elseif object.draw_method == GRAFY_CIRCLE then
                grafy.draw_circle( label_x - label_w - label_symbol_w / 2, label_y + label_symbol_h / 2 - 1, canvas.dot_size / 2, object.color )
            end

            label_i = label_i + 1
        end
    end

    render.SetScissorRect( 0, 0, 0, 0, false )
end

return meta