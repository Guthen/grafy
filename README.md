# grafy
**grafy** is a graphical library for Garry's Mod (yeah pretty useless)

## examples
### table and line
#### code
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

--  size and zoom
local w, h, scale = ScrW() / 4, ScrH() / 2, 1
--  create canvas
local canvas = grafy.canvas( ScrW() / 2 - w / 2, ScrH() / 2 - h / 2, w, h, scale, "Évolution annuel d'immatriculations de voitures neuves (diesel)" )
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
#### result
![graphical1](https://media.discordapp.net/attachments/608325399687987240/781112632379441182/unknown.png)

## enums
### draw methods
+ `GRAFY_DOT = 0`: draw dot
+ `GRAFY_LINE = 1`: draw line

### parse methods
+ `GRAFY_XY = 0`: parser will look for pairs of values forming X:Y coordinates
+ `GRAFY_Y = 1`: parser will consider all values as Y coordinates and will attribute an incrementing X value starting from 1

## objects
+ `grafy.protoz.canvas`: drawable graphic, renders others objects
    + `grafy.protoz.canvas` `grafy.canvas( number x, number y, number w, number h, number scale default 1, nullable string title )`: constructor
    + void `canvas:set_axes_titles( nullable string x, nullable string y )`: set axes titles
    + void `canvas:set_steps( nullable number x, nullable number y )`: set grid steps
    + number `canvas:get_absolute_x( number x )`: translate to a X absolute coordinate from a X grid coordinate
    + number `canvas:get_absolute_y( number y )`: translate to a Y absolute coordinate from a Y grid coordinate
    + void `canvas:draw_dot( number x, number y, Color color )`: draw a colored dot at X:Y grid coordinates
    + void `canvas:draw()`: draw canvas on current context 
    + void `canvas:add_render_object( grafy.protoz.* object )`: add object to renderer, object will be drawn after canvas is drawn

+ `grafy.protoz.table`: drawable table of X:Y values
    + `grafy.protoz.table` `grafy.table( table values, nullable number parse_method => [GRAFY_XY, GRAFY_Y] default GRAFY_XY, nullable string label )`: constructor
    + `{ number x = ?, number y = ? }, ^` `table:calculate_average_dots()`: calculate and return positions of two average dots
    + `grafy.protoz.line` `table:calculate_average_line()`: calculate and return average line using average dots
    + void **internal** `table:draw( canvas )`: draw on canvas

+ `grafy.protoz.line`: drawable line expressed by a formula of type `ax + b`

+ `grafy.protoz.curb`: drawable curb expressed by a custom formula

## functions
+ void **internal** `grafy.init()`: init a grafy's folder
