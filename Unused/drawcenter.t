proc drawcenter(text : string, y, fontID, c : int)
    %Draws text centered on the x-axis, using maxx and the width of the text
    var width := Font.Width(text, fontID)
    Font.Draw(text, maxx div 2 - width div 2, y, fontID, c)
end drawcenter

var f : int := Font.New("Comic Sans MS:30")

drawcenter("1234567890", 300, f, black)
drawline(maxx div 2, 0, maxx div 2, 400, black)