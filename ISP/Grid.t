proc grid (x, y, x2, y2, x3, y3, c1, c2, c3 : int)
    var f := Font.New ("sans serif:7")
    var f2 := Font.New ("sans serif:7:bold")

    for i : 0 .. 640 by x
	drawline (i, 0, i, 400, c1)
	Font.Draw (intstr (i), i - 7, 405, f, c1)
    end for
    for i : 0 .. 400 by y
	drawline (0, i, 640, i, c1)
	Font.Draw (intstr (i), 645, i - 3, f, c1)
    end for

    for i : 0 .. 640 by x2
	Draw.ThickLine (i, 0, i, 400, 3, c2)
	Font.Draw (intstr (i), i - 7, 405, f2, c2)
    end for
    for i : 0 .. 400 by y2
	Draw.ThickLine (0, i, 640, i, 3, c2)
	Font.Draw (intstr (i), 645, i - 3, f2, c2)
    end for

    for i : 0 .. 640 by x3
	Draw.ThickLine (i, 0, i, 400, 4, c3)
	Font.Draw (intstr (i), i - 7, 405, f, c3)
    end for
    for i : 0 .. 400 by y3
	Draw.ThickLine (0, i, 640, i, 4, c3)
	Font.Draw (intstr (i), 645, i - 3, f, c3)
    end for
end grid

proc clickGrid (x, y, x2, y2, x3, y3, c1, c2, c3 : int)
    loop
	if buttonmoved ("down")
		then
	    grid (x, y, x2, y2, x3, y3, c1, c2, c3)
	    exit
	end if
    end loop
end clickGrid

proc preGrid
    grid (20, 20, 80, 100, 320, 200, black, blue, red)
end preGrid

proc preClickGrid
    clickGrid (20, 20, 80, 100, 320, 200, black, blue, red)
end preClickGrid
