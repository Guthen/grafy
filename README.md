# grafy
**grafy** is a graphical library for Garry's Mod (yeah pretty useless)

## examples
see [EXAMPLES.md](https://github.com/Guthen/grafy/blob/master/EXAMPLES.md)

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

## file structure
### schema
```lua
grafy/
└── lua/
|    └── autorun/
|         └── grafy.lua  --  init keters and modules
|    └── grafy/
|         └── keter/
|              └── *.lua  --  all important files
|         └── *.lua  --  all modules files
└── README.md. --  hey, it's me!
```

### notes
+ keters are loaded before modules
+ returning value in a module script will add it in the protoz and will create a global constructor (considered as an object)
