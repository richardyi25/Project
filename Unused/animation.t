setscreen ("graphics:1000;600")

proc animation
    for i : 0 .. 120
	/*
	 drawbox (i - 1, i - 1, 181 + i, 181 + i, white)
	 drawbox (i + 1, i + 1, 179 + i, 179 + i, white)

	 drawbox (i, i, 180 + i, 180 + i, black)
	 delay (10)
	 */
	Draw.ThickLine (i, i - 2, i, 181 + i, 6, white)
	Draw.ThickLine (i, i - 2, 180 + i, i + 1, 8, white)
	Draw.ThickLine (180 + i, i - 2, 180 + i, 181 + i, 6, white)
	Draw.ThickLine (i, 178 + i, 180 + i, 181 + i, 8, white)

	Draw.ThickLine (i, i, i, 180 + i, 5, black)
	Draw.ThickLine (i, i, 180 + i, i, 5, black)
	Draw.ThickLine (180 + i, i, 180 + i, 180 + i, 5, black)
	Draw.ThickLine (i, 180 + i, 180 + i, 180 + i, 5, black)
	delay (10)
    end for
end animation

animation
