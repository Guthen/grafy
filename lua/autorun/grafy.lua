--  grafy
grafy = {}
grafy._path = "grafy"
grafy.protoz = {}
grafy._show_example = true
grafy._fonts = {
    normal = "DermaDefault",
    bold = "DermaDefaultBold",
}

--  loader
function grafy.init( path, callback )
    local path = grafy._path .. ( path or "" )
    print( ( "grafy: %s %q" ):format( SERVER and "send" or "init", path ) )

    for i, v in ipairs( file.Find( path .. "/*", "LUA" ) ) do
        if SERVER then 
            AddCSLuaFile( path .. "/" .. v ) 
        else
            local meta = include( path .. "/" .. v )
            if callback and meta then
                callback( v, meta )
            end
        end
        print( "   : " .. v )
    end
end

--  init
grafy.init( "/keter" ) --  important files
grafy.init( nil, function( file, meta )
    local key = file:gsub( "%.lua$", "" )

    --  constructor
    grafy[key] = function( ... )
        return meta:construct( ... )
    end

    --  save prototype
    grafy.protoz[key] = meta
end ) --  modules files

--  example
if not grafy._show_example or SERVER then hook.Remove( "HUDPaint", "grafy" ) return end

local w, h, scale = ScrW() / 4, ScrH() / 2, 1.1
local x, y = ScrW() / 2 - w / 2, ScrH() / 2 - h / 2
local canvas = grafy.canvas( x, y, w, h, scale, "Évolution annuel d'immatriculations de voitures neuves (diesel)" )
canvas:set_axes_titles( "an (x)", "milliers (y)" )
canvas:set_steps( 1, 10 )
canvas.color = Color( 242, 97, 184 )

local tbl = grafy.table( { --  cc le dm d'enseignement scientifique
    100,
    106.8,
    106.8,
    109.9,
    112.7,
    112.6,
    120.3,
    124.9,
    126,
    122.7,
}, GRAFY_Y, "série" )
tbl.draw_method = GRAFY_CIRCLE
tbl.color = canvas.color
canvas:add_render_object( tbl )
--[[ local canvas = grafy.canvas( x, y, w, h, scale, "sample text" )
canvas:set_steps( 1, 3 )

local tbl = grafy.table( {
    1, 2,
    2, 6,
    4, 8,
    8, 12,
    10, 15,
}, GRAFY_XY, "example table" )
canvas:add_render_object( tbl )

local line = tbl:calculate_average_line()
line.label = "eq: " .. line:str_formula()
canvas:add_render_object( line ) ]]

--[[ local line = grafy.line( 2.85, 101.54, "droite d'ajustement" )
line.color = tbl.color
print( 10, line:formula( 10 ), 11, line:formula( 11 ), 14, line:formula( 14 ) )
canvas:add_render_object( line ) ]]

--[[ local curb = grafy.curb( function( x ) return math.exp( x ) end, "exp x" )
canvas:add_render_object( curb ) ]]

local line = grafy.line( 2.5, 102.6, "y=2.5x+102.6" )
--line.color = tbl.color
line.draw_method = GRAFY_CIRCLE
--line:highlight( 14 )
--print( 10, line:formula( 10 ), 11, line:formula( 11 ), 14, line:formula( 14 ) )
canvas:add_render_object( line )

--[[ --  very basic canvas
local canvas = grafy.canvas( x, y, w, h, scale, "curb your maths" )

--  exponential curve
local curb = grafy.curb( function( x )
    return math.exp( x - 10 ) --  -10 cuz too close from origin else
end, "exp x" )
canvas:add_render_object( curb )

--  sine curve
local curb = grafy.curb( function( x )
    return math.sin( x ) * 2.5 + 10
end, "sine curve" )
canvas:add_render_object( curb )

--  cosine curve
local curb = grafy.curb( function( x )
    return math.cos( x ) + 5
end )
canvas:add_render_object( curb ) ]]

hook.Add( "HUDPaint", "grafy", function()
    canvas:draw()
end )
