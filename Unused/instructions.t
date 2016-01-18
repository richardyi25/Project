setscreen ("graphics:1000;600;position:center;center")

Font.Draw ("The purpose of the game is to find all the hidden words in the grid", 45, 570, Font.New ("Verdana:20"), black)
Font.Draw ("Words can appear horizontally, vertically, or diagonally", 126, 530, Font.New ("Verdana:20"), black)


for x : 440 .. 530 by 30
    for y : 240 .. 330 by 30
	drawbox (x, y, x + 30, y + 30, yellow)
	drawbox (x + 1, y + 1, x + 29, y + 29, yellow)     %Draw empty boxes
    end for
end for

for i : 1 .. 4
    Font.Draw ("WORD" (i), 447, i * 30 + 218, Font.New ("Comic Sans MS:15"), black)     %Draw "WORD"
    Font.Draw ("WORD" (i), i * 30 + 417, 248, Font.New ("Comic Sans MS:15"), black)
    Font.Draw ("WORD" (i), i * 30 + 417, i * 30 + 218, Font.New ("Comic Sans MS:15"), black)
end for

delay (2000)

Font.Draw ("To select a word, just click its first letter and last letter", 124, 460, Font.New ("Verdana:20"), black)


delay(2000)

drawbox (440, 240, 470, 270, green) %Draw green frame
drawbox (441, 241, 469, 269, green)

delay (500)

drawbox (530, 330, 560, 360, green)%Draw green frame
drawbox (531, 329, 561, 359, green)

delay (500)

Draw.ThickLine (455, 255, 545, 345, 2, black) %Draw line connecting
