# grafy
**grafy** is a graphical library for Garry's Mod (yeah pretty useless)

## images
![graphical1](https://media.discordapp.net/attachments/608325399687987240/781112632379441182/unknown.png)

## objects
+ `grafy.protoz.canvas`: drawable graphic, renders others objects
    + `grafy.protoz.canvas` `grafy.canvas( number x, number y, number w, number h, number scale default 1, nullable string title )`: create a canvas
    + void `canvas:set_axes_titles( nullable string x, nullable string y )`: set axes titles
    + void `canvas:set_steps( nullable number x, nullable number y )`: set grid steps
    + number `canvas:get_absolute_x( number x )`: translate to a X absolute coordinate from a X grid coordinate
    + number `canvas:get_absolute_y( number y )`: translate to a Y absolute coordinate from a Y grid coordinate
    + void `canvas:draw_dot( number x, number y, Color color )`: draw a colored dot at X:Y grid coordinates
    + void `canvas:draw()`: draw canvas on current context 
    + void `canvas:add_render_object( grafy.protoz.* object )`: add object to renderer, object will be drawn after canvas is drawn

+ `grafy.protoz.table`: drawable table of X:Y values

+ `grafy.protoz.line`: drawable line expressed by a formula of type `ax + b`

+ `grafy.protoz.curb`: drawable curb expressed by a custom formula

## functions
+ void **internal** `grafy.init()`: init a grafy's folder
