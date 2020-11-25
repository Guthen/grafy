--  grafy
grafy = {}
grafy._path = "grafy"
grafy._prototypes = {}
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
    grafy._prototypes[key] = meta
end ) --  modules files

--  example
if not grafy._show_example or SERVER then hook.Remove( "HUDPaint", "grafy" ) return end
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

local w, h, scale = ScrW() / 4, ScrH() / 2, 1
local canvas = grafy.canvas( ScrW() / 2 - w / 2, ScrH() / 2 - h / 2, w, h, scale, "Évolution annuel d'immatriculations de voitures neuves (diesel)" )
canvas:set_axes_titles( "an (x)", "milliers (y)" )
canvas:set_steps( 1, 10 )
canvas:add_render_object( tbl )

--[[ local line = grafy.line( 2.85, 101.54, "droite d'ajustement" )
line.color = tbl.color
print( 10, line:formula( 10 ), 11, line:formula( 11 ), 14, line:formula( 14 ) )
canvas:add_render_object( line ) ]]

--[[ local curb = grafy.curb( function( x ) return math.exp( x ) end, "exp x" )
canvas:add_render_object( curb ) ]]

local line = grafy.line( 2.5, 102.6, "droite d'ajustement" )
line.color = tbl.color
line:highlight( 14 )
print( 10, line:formula( 10 ), 11, line:formula( 11 ), 14, line:formula( 14 ) )
canvas:add_render_object( line )

--[[ local line = tbl:calculate_average_line()
print( line:str_formula() )
print( line:formula( 10 ), line:formula( 11 ), line:formula( 14 ) )
canvas:add_render_object( line ) ]]

hook.Add( "HUDPaint", "grafy", function()
    canvas:draw()
end )