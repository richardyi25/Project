%------------
%Top Comments
%------------
/*
 Jan. 18, 2015
 Richard Yi
 Mrs. Krasteva
 #16 Word Search ISP
 */
%---------------------------
%Procedure/Other Declaration
%---------------------------
import GUI
GUI.SetDisplayWhenCreated (false) %Buttons will only show up when GUI.Show'ed

forward proc title
forward proc intro
forward proc help
forward proc mainMenu
forward proc askTimed
forward proc wordSearch1
forward proc wordSearch2
forward proc wordSearch3
forward proc display (win : boolean)
forward proc goodBye
forward proc goToWordSearch
forward proc giveUp
%---------------------
%Variable Delclatation
%---------------------

%Windows
var window := Window.Open ("position:center;center;graphics:600;600;nobuttonbar")
%Only one screen, centered and max size

%Buttons
var introButton := GUI.CreateButton (248, 0, 0, "Launch Game", mainMenu) % 103
var playButton := GUI.CreateButton (256, 48, 0, "Play Game", askTimed) % 87
var helpButton := GUI.CreateButton (239, 24, 0, "Help/Instructions", help) % 121
var quitButton := GUI.CreateButton (272, 0, 0, "Quit", goodBye) % 55
var backToMenuButton := GUI.CreateButton (226, 0, 0, "Go back to main menu", mainMenu) % 148
var confirmButton := GUI.CreateButton (242, 24, 0, "Confirm Choice", goToWordSearch) % 115
var giveUpButton := GUI.CreateButton (264, 24, 0, "Give Up", giveUp) % 71
%MOVE COORDINATES!

%Values
var inputLocked : boolean := false
var wordSearchOrder : array 1 .. 3 of int
var wordSearchCounter : int := 1
var timeLimit, timeLeft : int

%Fonts
var titleFont := Font.New ("Cambria:30")
%--------------------------------------
%Procedure/Function/Process Delcaration
%--------------------------------------

%Utility Procedures/Functions

process lockInput (howLong : int) %sets inputLocked to true for a certain amount of time
    inputLocked := true
    delay (howLong)
    inputLocked := false
end lockInput

process playMusic (file : string)
    Music.PlayFileStop
    Music.PlayFileLoop (file)
end playMusic

process countTime
    %decrement time variable
    if /*time is up*/ 1 = 1 then
	display (false) %User loses
    end if
end countTime

proc randomizeOrder
    var numbers : array 1 .. 3 of int := init (1, 2, 3) %numbers 1 to 3
    var pos1, pos2, num1, num2 : int

    for i : 1 .. Rand.Int (1, 6) %Switch between 1-6 times
	%Switch 2 random places
	pos1 := Rand.Int (1, 3)
	pos2 := Rand.Int (1, 3) %Choose 2 random positions

	num1 := numbers (pos1)
	num2 := numbers (pos2) %Get values

	numbers (pos1) := num2
	numbers (pos2) := num1 %Switch positions
    end for

    for i : 1 .. 3
	wordSearchOrder (i) := numbers (i) %Copy to wordSearchOrder
    end for
end randomizeOrder

proc nextWordSearch
    if wordSearchCounter = 3 then
	wordSearchCounter := 1
    else
	wordSearchCounter += 1
    end if
end nextWordSearch

body proc goToWordSearch
    %Redirects to cuurent word search
    case wordSearchOrder (wordSearchCounter) of
	label 1 :
	    wordSearch1
	label 2 :
	    wordSearch2
	label 3 :
	    wordSearch3
    end case
end goToWordSearch

body proc title
    cls %Clear Screen

    Font.Draw ("Word Search", 189, 560, titleFont, black)

    GUI.Hide (introButton)
    GUI.Hide (playButton)
    GUI.Hide (helpButton)
    GUI.Hide (quitButton)
    GUI.Hide (giveUpButton)
    GUI.Hide (backToMenuButton)
    GUI.Hide (confirmButton)
    %Hide all buttons
end title

function userInput () : array 1 .. 4 of int

end userInput

body proc giveUp
    nextWordSearch % Skip current word search
    display (false) % Go to display and tell it that user lost the game
end giveUp
%Program Screens Procedures


body proc intro
    %Fancy Animation
    GUI.Show (introButton)
end intro

body proc mainMenu
    title

    GUI.Show (playButton)
    GUI.Show (helpButton)
    GUI.Show (quitButton)
end mainMenu

body proc help
    title

    put "This is a very helpful help page." %Font.Draw!

    GUI.Show (backToMenuButton)
end help

body proc askTimed
    title
    locate (10, 1)
    put "Do you want it to be timed?" %Font.Draw!
    put "Type y/n"

    GUI.Show (confirmButton)
    GUI.Show (backToMenuButton)
end askTimed

body proc wordSearch1
    title
    put "Word Search 1"
    GUI.Show (giveUpButton)
    GUI.Show (backToMenuButton)
end wordSearch1

body proc wordSearch2
    title
    put "Word Search 2"
    GUI.Show (giveUpButton)
    GUI.Show (backToMenuButton)
end wordSearch2

body proc wordSearch3
    title
    put "Word Search 3"
    GUI.Show (giveUpButton)
    GUI.Show (backToMenuButton)
end wordSearch3

body proc display (win : boolean)
    title
    if win = true then
	put "You win!"
    else
	put "You lose!"
    end if
    GUI.Show (backToMenuButton)
end display

body proc goodBye
    title
    put "Thank you for using my program, etc, etc."
    delay (1000)
    GUI.Quit
    Window.Close (window)
end goodBye


%------------
%Main Program
%------------

randomizeOrder
intro
loop
    exit when GUI.ProcessEvent
end loop
