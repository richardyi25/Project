import GUI
setscreen ("position:center;center;graphics:640;400")

var input : string
var size : int

loop
    cls
    locate (1, 1)

    put "Enter your button text: " ..
    get input : *

    put "Enter the width of the screen: " ..
    get size

    var b := GUI.CreateButton (-100, -100, 0, input, GUI.Quit)

    put ""

    put "Height: ", GUI.GetHeight (b), " pixels"
    put "Width: ", GUI.GetWidth (b), " pixels"
    put "To center, place at x = ", round (size / 2) - round (GUI.GetWidth (b) / 2)
    put ""

    put "Press any key to continue..."
    Input.Pause
end loop
