proc grid (x, y, x2, y2, x3, y3, c1, c2, c3 : int)
    var f := Font.New ("sans serif:6")

    for i : x .. maxx - 15 by x
	drawline (i, 0, i, maxy - 15, c1)
	Font.Draw (intstr (i), i - 7, maxy - 10, f, c1)
    end for
    for i : y .. maxy - 10 by y
	drawline (0, i, maxx - 20, i, c1)
	Font.Draw (intstr (i), maxx - 15, i - 3, f, c1)
    end for

    for i : x2 .. maxx - 15 by x2
	Draw.ThickLine (i, 0, i, maxy - 15, 3, c2)
	Font.Draw (intstr (i), i - 7, maxy - 10, f, c2)
    end for
    for i : y2 .. maxy - 10 by y2
	Draw.ThickLine (0, i, maxx - 20, i, 3, c2)
	Font.Draw (intstr (i), maxx - 15, i - 3, f, c2)
    end for

    for i : x3 .. maxx - 15 by x3
	Draw.ThickLine (i, 0, i, maxy - 15, 4, c3)
	Font.Draw (intstr (i), i - 7, maxy - 10, f, c3)
    end for
    for i : y3 .. maxy - 10 by y3
	Draw.ThickLine (0, i, maxx - 20, i, 4, c3)
	Font.Draw (intstr (i), maxx - 15, i - 3, f, c3)
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
