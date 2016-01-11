%This has not been implemented into the main program yet

setscreen ("position:center;center;graphics:600;600;nobuttonbar")
drawfillbox (0, 0, maxx, maxy, black)
drawfillbox (75, 140, 525, 590, white)

var locked : boolean := false

process lock
    locked := true
    delay (300)
    locked := false
end lock

process drawBackground
    var hue, s, l, c, x, m, r, g, b : real
    var c2 : int

    hue := Rand.Int (0, 360)
    s := 1
    l := 0.8

    loop
	hue := (hue + 1) mod 360

	c := (1 - abs (2 * l - 1)) * s
	x := c * (1 - abs (((hue / 60) mod 2) - 1))
	m := l - (c / 2)

	if hue <= 60 then
	    r := c
	    g := x
	    b := 0
	elsif hue <= 120 then
	    r := x
	    g := c
	    b := 0
	elsif hue <= 180 then
	    r := 0
	    g := c
	    b := x
	elsif hue <= 240 then
	    r := 0
	    g := x
	    b := c
	elsif hue <= 300 then
	    r := x
	    g := 0
	    b := c
	elsif hue <= 360 then
	    r := c
	    g := 0
	    b := x
	end if

	r += m
	g += m
	b += m

	c2 := RGB.AddColor (r, g, b)

	for i : 0 .. 600
	    drawline (i, 0, i, 140, c2)
	end for

	for i : 140 .. 600
	    drawline (0, i, 75, i, c2)
	end for

	for i : 75 .. 525
	    drawline (i, 590, i, 600, c2)
	end for

	for i : 525 .. 600
	    drawline (i, 0, i, 600, c2)
	end for

	delay (968)
    end loop
end drawBackground

proc drawTempSearch
    var font := Font.New ("Comic Sans MS:15")

    for x : 75 .. 524 by 30
	for y : 140 .. 589 by 30
	    Font.Draw (chr (Rand.Int (65, 90)), x + 5, y + 5, font, black)
	    drawbox (x, y, x + 30, y + 30, yellow)
	end for
    end for
end drawTempSearch

fcn userInput () : array 1 .. 4 of int
    %drawTempSearch

    var xCoord, yCoord, button : int
    var xRange, yRange : int
    var firstClick : boolean := true
    var click1X, click1Y, click2X, click2Y : int := -50
    var rise, run : int
    var coordinates : array 1 .. 4 of int

    loop
	mousewhere (xCoord, yCoord, button)
	xRange := xCoord - ((xCoord - 75) mod 30)
	yRange := yCoord - ((yCoord - 140) mod 30)

	if button = 1 and locked = false then
	    fork lock

	    if xCoord >= 75 and xCoord <= 525 and yCoord >= 140 and yCoord <= 590 then
		%Begin complicated control flow
		if firstClick then %If first click
		    click1X := xRange
		    click1Y := yRange
		    drawbox (xRange, yRange, xRange + 30, yRange + 30, green)
		    %Select box
		    firstClick := false
		else %If second click
		    if xRange = click1X and yRange = click1Y then %If clicked on same box as first click
			drawbox (xRange, yRange, xRange + 30, yRange + 30, yellow)
			firstClick := true
			%Deselect box
		    else %Otherwise
			click2X := xRange
			click2Y := yRange
			rise := click2Y - click1Y
			run := click2X - click1X

			if rise = 0 or run = 0 or rise / run = 1 or rise / run = -1 then
			    %If is a valid line (horizontal, vertical, or slope is 1 or -1)
			    coordinates (1) := (click1X - 75) div 30
			    coordinates (2) := (click1Y - 140) div 30
			    coordinates (3) := (click2X - 75) div 30
			    coordinates (4) := (click2Y - 140) div 30
			    %Add click coordinates to return array

			    drawbox (xRange, yRange, xRange + 30, yRange + 30, green)
			    %Select box

			    delay (500)

			    drawbox (click1X, click1Y, click1X + 30, click1Y + 30, yellow)
			    drawbox (xRange, yRange, xRange + 30, yRange + 30, yellow)

			    result coordinates
			else
			    drawbox (xRange, yRange, xRange + 30, yRange + 30, red)
			    %Error highlight
			    delay (500)
			    drawbox (click1X, click1Y, click1X + 30, click1Y + 30, yellow)
			    drawbox (xRange, yRange, xRange + 30, yRange + 30, yellow)
			    firstClick := true
			    %Deselect both clicks
			end if
		    end if
		end if
	    end if
	end if
    end loop
end userInput

fork drawBackground

drawTempSearch

loop
    var a : array 1 .. 4 of int

    a := userInput ()

    locate (1, 1)
    put "(", a (1), ", ", a (2), ")"
    put "(", a (3), ", ", a (4), ")"
end loop

