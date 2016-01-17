%------------
%Top Comments
%------------
/*
 Jan. 8th, 2016
 Richard Yi
 Mrs. Krasteva
 #16 Word Search ISP
 */
%===========================
%Procedure/Importing/Settings Declaration
%===========================
import GUI

GUI.SetDisplayWhenCreated (false) %Buttons will only show up when GUI.Show'ed

forward proc title
forward proc intro
forward proc help
forward proc mainMenu
forward proc askTimed
forward proc wordSearch (number : int)
forward proc display (win : boolean)
forward proc goodBye
forward proc goToWordSearch
forward proc giveUp

%=====================
%Variable Delclatation
%=====================

%Windows
var window := Window.Open ("position:center;center;graphics:1000;600;nobuttonbar")
%Only one screen, centered and max size

%Buttons
var introButton := GUI.CreateButton (448, 0, 0, "Launch Game", mainMenu) % 103
var playButton := GUI.CreateButton (256, 48, 0, "Play Game", askTimed) % 87
var helpButton := GUI.CreateButton (239, 24, 0, "Help/Instructions", help) % 121
var quitButton := GUI.CreateButton (272, 0, 0, "Quit", goodBye) % 55
var backToMenuButton := GUI.CreateButton (226, 0, 0, "Go back to main menu", mainMenu) % 148
var confirmButton := GUI.CreateButton (242, 24, 0, "Confirm Choice", goToWordSearch) % 115
var giveUpButton := GUI.CreateButton (264, 24, 0, "Give Up", giveUp) % 71
%MOVE COORDINATES!

%Values
var inputLocked : boolean := false
var wordSearchOrder : array 1 .. 2 of int := init (1, 2)
var wordSearchCounter : int := 1
var timeLimit, timeLeft : int

%Fonts
var titleFont := Font.New ("Verdana:30")
%======================================
%Procedure/Function/Process Delcaration
%======================================

%Utility Procedures/Functions
%----------------------------

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

proc shuffleOrder
    %Shuffles wordSearchOrder array
    %Turing Implementation of the Fisher-Yates shuffle
    var random, temp : int
    for decreasing i : upper (wordSearchOrder) .. 2
	%From length of the array down to 1
	random := Rand.Int (1, i)
	%Pick a random number from 1 to i

	temp := wordSearchOrder (i)
	wordSearchOrder (i) := wordSearchOrder (random)
	wordSearchOrder (random) := temp
	%Swap the indexes with a temporary variable
    end for
end shuffleOrder

proc nextWordSearch
    if wordSearchCounter = 2 then
	wordSearchCounter := 1
    else
	wordSearchCounter += 1
    end if
end nextWordSearch

body proc goToWordSearch
    wordSearch (wordSearchOrder (wordSearchCounter))
end goToWordSearch

body proc title
    cls %Clear Screen

    Font.Draw ("Word Search", 371, 560, titleFont, black)

    GUI.Hide (introButton)
    GUI.Hide (playButton)
    GUI.Hide (helpButton)
    GUI.Hide (quitButton)
    GUI.Hide (giveUpButton)
    GUI.Hide (backToMenuButton)
    GUI.Hide (confirmButton)
    %Hide all buttons
end title

fcn userInput () : array 1 .. 4 of int
    var xCoord, yCoord, button : int
    %Stores mousewhere coordinates

    var xRange, yRange : int
    %Stores coordinate ranges

    var firstClick : boolean := true
    %Whether the user's click is the first

    var click1X, click1Y, click2X, click2Y : int
    var rise, run : int
    var coordinates : array 1 .. 4 of int

    loop
	mousewhere (xCoord, yCoord, button)
	xRange := xCoord - ((xCoord - 75) mod 30)
	yRange := yCoord - ((yCoord - 25) mod 30)
	%Round coordinates to nearest 30 x 30 box
	%e.g. (123, 321) rounds to (120, 300)

	if button = 1 and inputLocked = false then
	    fork lockInput (300)

	    if xCoord >= 75 and xCoord <= 525 and yCoord >= 25 and yCoord <= 475 then
		%If the user clicks in the word search box

		if firstClick then %If first click
		    click1X := xRange
		    click1Y := yRange
		    %Store coordinates

		    drawbox (xRange, yRange, xRange + 30, yRange + 30, green)
		    drawbox (xRange + 1, yRange + 1, xRange + 29, yRange + 29, green)
		    %Select box
		    firstClick := false

		else %If second click
		    if xRange = click1X and yRange = click1Y then %If clicked on same box as first click
			drawbox (xRange, yRange, xRange + 30, yRange + 30, yellow)
			drawbox (xRange + 1, yRange + 1, xRange + 29, yRange + 29, yellow)
			firstClick := true
			%Deselect box
			%No longer first click

		    else %Otherwise
			click2X := xRange
			click2Y := yRange
			%Store coordinates

			rise := click2Y - click1Y
			run := click2X - click1X
			%Calculate rise and run

			if rise = 0 or run = 0 or rise / run = 1 or rise / run = -1 then
			    %If is a valid line (horizontal, vertical, or slope is 1 or -1)
			    coordinates (1) := (click1X - 75) div 30 + 1
			    coordinates (2) := (click1Y - 25) div 30 + 1
			    coordinates (3) := (click2X - 75) div 30 + 1
			    coordinates (4) := (click2Y - 25) div 30 + 1
			    %Add click coordinates to return array

			    drawbox (xRange, yRange, xRange + 30, yRange + 30, green)
			    drawbox (xRange + 1, yRange + 1, xRange + 29, yRange + 29, green)
			    %Select box

			    delay (500)

			    drawbox (click1X, click1Y, click1X + 30, click1Y + 30, yellow)
			    drawbox (click1X + 1, click1Y + 1, click1X + 29, click1Y + 29, yellow)

			    drawbox (xRange + 1, yRange + 1, xRange + 29, yRange + 29, yellow)
			    drawbox (xRange, yRange, xRange + 30, yRange + 30, yellow)
			    %Deselect boxes

			    result coordinates
			    %Return coordinates array

			else %If invalid slope
			    drawbox (xRange, yRange, xRange + 30, yRange + 30, red)
			    drawbox (xRange + 1, yRange + 1, xRange + 29, yRange + 29, red)
			    %Error highlight

			    delay (500)
			    drawbox (click1X, click1Y, click1X + 30, click1Y + 30, yellow)
			    drawbox (click1X + 1, click1Y + 1, click1X + 29, click1Y + 29, yellow)

			    drawbox (xRange, yRange, xRange + 30, yRange + 30, yellow)
			    drawbox (xRange + 1, yRange + 1, xRange + 29, yRange + 29, yellow)

			    firstClick := true
			    %Deselect both clicks
			end if
		    end if
		end if
	    end if
	end if
    end loop
end userInput

proc fillRandom
    var font := Font.New ("Comic Sans MS:15")

    for x : 75 .. 524 by 30
	for y : 25 .. 474 by 30
	    Font.Draw (chr (Rand.Int (65, 90)), x + 5, y + 5, font, black)
	    drawbox (x, y, x + 30, y + 30, yellow)
	    drawbox (x + 1, y + 1, x + 29, y + 29, yellow)
	end for
    end for
end fillRandom

body proc giveUp
    nextWordSearch % Skip current word search
    display (false) % Go to display and tell it that user lost the game
end giveUp


%Program Screens Procedures
%--------------------------

body proc intro
    %Fancy Animation
    put "Loading music..."
    put "*Any delay you experience is real"

    var middle : int := Rand.Int (300, 700)

    for i : 1 .. middle
	delay (1)
	drawoval (i, 300, 10, 10, black)
    end for

    fork playMusic ("threes.mp3")

    for i : middle .. 1000
	delay (1)
	drawoval (i, 300, 10, 10, black)
    end for

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

body proc wordSearch (number : int)
    title

    fillRandom

    var letterFont := Font.New ("Comic Sans MS:15")
    var wordFont := Font.New ("Comic Sans MS:13")
    var nameFont := Font.New ("Calibri:20:bold")

    var inputStream : int
    var inputFile : string
    var numberOfLines : int
    var lineNumber : int := 0
    %File I/O Variables

    var name : string
    var nameWidth : int
    %Name of word search, and width of the text

    var word : string
    var coordinate : int
    %Stores the word list and coordinates list from the file

    var xChange, yChange : int
    var xPos, yPos : int
    %For drawing the word intro the grid

    var match : boolean
    %For when checking if the clicked coordinates
    %matches a word
    var matchNumber : int
    %Stores which set of coordinates matched with the input

    var inputCoordinates : array 1 .. 4 of int
    %Stores what coordinates the user clicked on

    inputFile := "word_search" + intstr (number) + ".txt"
    open : inputStream, inputFile, get
    %Open a file based on the word search number

    get : inputStream, numberOfLines
    %The first line of the file wil contain the amount of preceding lines

    get : inputStream, name : *
    %The second line is the name of the word search

    var words : flexible array 1 .. numberOfLines of string
    var coordinates : array 1 .. numberOfLines of array 1 .. 4 of int
    %Make a words array and coordinates array, with their lengths being the amount of lines

    loop
	%For each line
	exit when eof (inputStream)
	lineNumber += 1

	get : inputStream, word
	words (lineNumber) := word
	%Get the word

	for i : 1 .. 4 %Get the 4 coordinates
	    get : inputStream, coordinate
	    coordinates (lineNumber) (i) := coordinate
	end for
    end loop

    close : inputStream

    nameWidth := Font.Width (name, nameFont)
    Font.Draw (name, 300 - nameWidth div 2, 500, nameFont, black)
    %Draw the name of wordsearch, centered with Font.Width

    for i : 1 .. upper (coordinates)
	%For all sets of coordinates

	xChange := (coordinates (i) (3) - coordinates (i) (1)) div (length (words (i)) - 1)
	yChange := (coordinates (i) (4) - coordinates (i) (2)) div (length (words (i)) - 1)
	%Find the direction for the x and y
	%e.g. (1, 1), (1, 3) has a direction of 0, 1
	%because x remains constant and y goes up

	for i2 : 0 .. length (words (i)) - 1
	    %Iterating though the charaters of word (i)

	    xPos := coordinates (i) (1) + (i2 * xChange)
	    yPos := coordinates (i) (2) + (i2 * yChange)
	    %Find the position of where to put the letter

	    drawfillbox (xPos * 30 + 47, yPos * 30 - 3, xPos * 30 + 73, yPos * 30 + 23, white)
	    %Clear the current letter from its box

	    Font.Draw (Str.Upper (words (i) (i2 + 1)), xPos * 30 + 50, yPos * 30, letterFont, red)
	    %Add the letter into the box
	end for
    end for

    for i : 1 .. upper (words)
	%For each element in words
	Font.Draw (words (i), 550, 475 - i * 25, wordFont, black)
    end for

    loop
	inputCoordinates := userInput ()
	%Get user input

	matchNumber := 0

	for i : 1 .. upper (coordinates)
	    matchNumber += 1
	    %Increment matchNumber

	    match := true
	    %Assume that the coordinates match

	    for i2 : 1 .. 4
		if inputCoordinates (i2) not= coordinates (i) (i2) then
		    match := false
		    %If one of them doesn't match, they all don't match
		end if
	    end for

	    exit when match = true
	    %When all 4 match, stop searching
	end for

	locate (1, 1)

	if match = true then %If a match was found
	    Draw.ThickLine (coordinates (matchNumber) (1) * 30 + 60, coordinates (matchNumber) (2) * 30 + 10, coordinates (matchNumber) (3) * 30 + 60, coordinates (matchNumber) (4) * 30 + 10, 2,
		black)
	    %Cross out word on word search

	    for i : matchNumber .. upper (words) - 1
		words (i) := words (i + 1)
		new words, upper (words) - 1
	    end for
	    %From the found word to the length of array minus 1
	    %Shift all indexes left 1, then resize array to itself minus 1
	    %Basically deleting the word from the array
	else
	    put "Not a word!"
	end if
    end loop

    %put "Word Search ", number
    GUI.Show (giveUpButton)
    GUI.Show (backToMenuButton)
end wordSearch

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
    Music.PlayFileStop
    GUI.Quit
    Window.Close (window)
end goodBye

%============
%Main Program
%============
shuffleOrder
intro

loop
    exit when GUI.ProcessEvent
end loop
