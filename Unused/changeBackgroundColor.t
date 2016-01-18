process changeBackgroundColor
    %Sets background color

    %Using the Hue-Saturation-Lightness to RGB formula
    %---------------------------------------------------------------------
    var hue, saturation, lightness, chroma, middle, value, r, g, b : real

    hue := Rand.Int (0, 360)
    saturation := 1
    lightness := 0.8

    loop
	hue := (hue + 1) mod 360

	chroma := (1 - abs (2 * lightness - 1)) * saturation
	middle := chroma * (1 - abs (((hue / 60) mod 2) - 1))
	value := lightness - (chroma / 2)

	if hue <= 60 then
	    r := chroma
	    g := middle
	    b := 0
	elsif hue <= 120 then
	    r := middle
	    g := chroma
	    b := 0
	elsif hue <= 180 then
	    r := 0
	    g := chroma
	    b := middle
	elsif hue <= 240 then
	    r := 0
	    g := middle
	    b := chroma
	elsif hue <= 300 then
	    r := middle
	    g := 0
	    b := chroma
	elsif hue <= 360 then
	    r := chroma
	    g := 0
	    b := middle
	end if

	r += value
	g += value
	b += value
	%--------------------------------------------------------------------

	backgroundColor := RGB.AddColor (r, g, b)
	%Set background color

	delay (1000) %Delay
    end loop
end changeBackgroundColor
