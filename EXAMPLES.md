# examples
## table and line
### code
```lua
--  create table of values
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

--  size, position and zoom
local w, h, scale = ScrW() / 4, ScrH() / 2, 1
local x, y = ScrW() / 2 - w / 2, ScrH() / 2 - h / 2

--  create canvas
local canvas = grafy.canvas( x, y, w, h, scale, "Évolution annuel d'immatriculations de voitures neuves (diesel)" )
canvas:set_axes_titles( "an (x)", "milliers (y)" )
canvas:set_steps( 1, 10 )
canvas:add_render_object( tbl )

--  create line
local line = grafy.line( 2.5, 102.6, "droite d'ajustement" )
line.color = tbl.color
line:highlight( 14 ) --  a dot will appear on x=14 with texts of X:Y coordinates
print( 10, line:formula( 10 ), 11, line:formula( 11 ), 14, line:formula( 14 ) ) --  print some values
canvas:add_render_object( line )

--  draw canvas and added objects
hook.Add( "HUDPaint", "grafy", function()
    canvas:draw()
end )
```
### result
![graphical1](https://media.discordapp.net/attachments/608325399687987240/781112632379441182/unknown.png)

## table and average line
### code
```lua
--  size, position and zoom
local w, h, scale = ScrW() / 4, ScrH() / 2, 1
local x, y = ScrW() / 2 - w / 2, ScrH() / 2 - h / 2

--  create basic canvas
local canvas = grafy.canvas( x, y, w, h, scale, "sample text" )
canvas:set_steps( 1, 3 )

--  create table
local tbl = grafy.table( {
    1, 2,
    2, 6,
    4, 8,
    8, 12,
    10, 15,
}, GRAFY_XY, "example table" )
canvas:add_render_object( tbl )

--  calculate and create an average line
local line = tbl:calculate_average_line()
line.label = "eq: " .. line:str_formula()
canvas:add_render_object( line )

--  draw canvas and objects
hook.Add( "HUDPaint", "grafy", function()
    canvas:draw()
end )
```
### result
![graphical2](https://media.discordapp.net/attachments/608325399687987240/781215970806726726/unknown.png)

## curb
### code
```lua
--  size, position and zoom
local w, h, scale = ScrW() / 4, ScrH() / 2, 1
local x, y = ScrW() / 2 - w / 2, ScrH() / 2 - h / 2

--  very basic canvas
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
canvas:add_render_object( curb )

--  draw canvas and objects
hook.Add( "HUDPaint", "grafy", function()
    canvas:draw()
end )
```
### result
![curbyourmaths](https://media.discordapp.net/attachments/608325399687987240/781219898458243133/unknown.png)