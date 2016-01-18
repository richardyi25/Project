var stream : int
var fontName, fontWeight, fontSize, text : string
var height, width, ascent, descent, leading, winx, winy : int
var centerx, centery : int

open : stream, "font.txt", get

get : stream, fontName : *
%get : stream, fontWeight
get : stream, fontSize
get : stream, text : *
get : stream, winx
get : stream, winy

var f := Font.New (fontName + ":" + fontSize)
Font.Sizes (f, height, ascent, descent, leading)
height := ascent - leading
width := Font.Width (text, f)

centerx := round ((winx / 2) - (width / 2))
centery := round ((winy / 2) - (height / 2))

put skip
put "Font height: ", height
put "Font width: ", width
put skip
put "To be centered on the screen, Font.Draw it at"
put "x = ", centerx
put "y = ", centery

var window := Window.Open ("graphics:" + intstr (winx) + ";" + intstr (winy) + ";position:center;center")
drawfillbox (centerx, centery, centerx + width, centery + height, yellow)
Font.Draw (text, centerx, centery, f, black)
drawline (round (winx / 2), 0, round (winx / 2), winy, black)
drawline (0, round (winy / 2), winx, round (winy / 2), black)


