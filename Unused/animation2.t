setscreen ("graphics:1000;600")

proc animation
    var font : int := Font.New ("Comic Sans MS:20")

    for i : 0 .. 120
	drawbox (i - 1, i - 1, 180 + i + 1, 180 + i + 1, white)
	drawbox (i + 1, i + 1, 180 + i - 1, 180 + i - 1, white)  %Erase 1

	drawbox (i - 1, 420 - i - 1, 180 + i + 1, 600 - i + 1, white)
	drawbox (i + 1, 420 - i + 1, 180 + i - 1, 600 - i - 1, white) %Erase 2

	drawbox (420 - i - 1, 420 - i - 1, 600 - i + 1, 600 - i + 1, white)
	drawbox (420 - i + 1, 420 - i + 1, 600 - i - 1, 600 - i - 1, white) %Erase 3

	drawbox (420 - i - 1, i - 1, 600 - i + 1, 180 + i + 1, white)
	drawbox (420 - i + 1, i + 1, 600 - i - 1, 180 + i - 1, white) %Erase 4

	drawbox (i, i, 180 + i, 180 + i, black)
	drawbox (i, 420 - i, 180 + i, 600 - i, black)
	drawbox (420 - i, 420 - i, 600 - i, 600 - i, black)
	drawbox (420 - i, i, 600 - i, 180 + i, black)
	%Draw 4 boxes

	delay (10)
    end for

    delay (200)

    for i : 120 .. 480 by 60
	%Draw grid lines
	drawline (i, 120, i, 480, black)
	drawline (120, i, 480, i, black)
    end for

    for i3 : 1 .. 20 %Draw Random letters in grid
	for i : 120 .. 420 by 60
	    for i2 : 120 .. 420 by 60
		drawfillbox (i + 1, i2 + 1, i + 59, i2 + 59, white)
		Font.Draw (chr (Rand.Int (65, 90)), i + 20, i2 + 20, font, black)
	    end for
	end for
	delay (100)
    end for

    for i : 1 .. 4
	drawfillbox (321, 480 - i * 60 + 1, 359, 480 - i * 60 + 59, white)
	Font.Draw ("WORD" (i), 320, 480 - i * 60 + 20, font, black)
    end for

    for i : 1 .. 6
	drawfillbox (61 + i * 60, 301, 119 + i * 60, 359, white)
	Font.Draw ("SEARCH" (i), 80 + i * 60, 320, font, black)
    end for

    delay (500)

    for i : 1 .. 4
	drawfillbox (301, 480 - i * 60 + 1, 359, 480 - i * 60 + 59, yellow)
	Font.Draw ("WORD" (i), 320, 480 - i * 60 + 20, font, blue)
    end for

    for i : 1 .. 6
	drawfillbox (61 + i * 60, 301, 119 + i * 60, 359, yellow)

	Font.Draw ("SEARCH" (i), 80 + i * 60, 320, font, blue)
    end for
end animation

animation
