%------------
%Top Comments
%------------
/*
 Jan. 8th, 2016
 Richard Yi
 Mrs. Krasteva
 #16 Word Search ISP
 */

/*
 This program is a word search.
 The user tries to find hidden words in a grid.
 They have an option to plat in timed or untimed mode, and the time limit is set by them.
 If they find all the words in the time limit, they win.
 If fail to find all the words or give up, they lose.
 The program repeats until the user wants to exit.
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
var window := Window.Open ("position:center;center;graphics:1000;600;nobuttonbar;nocursor")
%Only one screen, centered and max size

%Buttons
var introButton := GUI.CreateButton (448, 0, 0, "Launch Game", mainMenu)
var playButton := GUI.CreateButton (457, 48, 0, "Play Game", askTimed)
var helpButton := GUI.CreateButton (440, 24, 0, "Help/Instructions", help)
var quitButton := GUI.CreateButton (473, 0, 0, "Quit", goodBye)
var backToMenuButton := GUI.CreateButton (800, 0, 0, "Go back to main menu", mainMenu)
var confirmButton := GUI.CreateButton (443, 24, 0, "Confirm Choice", goToWordSearch)
var giveUpButton := GUI.CreateButton (800, 24, 0, "Give Up", giveUp)
%MOVE COORDINATES!

%Values
var inputLocked : boolean := false
var wordSearchOrder : array 1 .. 3 of int := init (1, 2, 3)
var wordSearchCounter : int := 1
var timed : boolean := false
var timeLeft : int
var backgroundColor : int
var firstTime : boolean := true

%Fonts
var titleFont := Font.New ("Verdana:30")
var headerFont := Font.New ("Verdana:20")
var regularFont := Font.New ("Verdana:15")
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
    loop
	timeLeft -= 1
	delay (1000)
    end loop
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
    if wordSearchCounter = 3 then
	wordSearchCounter := 1
    else
	wordSearchCounter += 1
    end if
end nextWordSearch

body proc goToWordSearch
    wordSearch (wordSearchOrder (wordSearchCounter))
end goToWordSearch

body proc title
    backgroundColor := RGB.AddColor (Rand.Int (600, 1000) / 1000, Rand.Int (600, 1000) / 1000, Rand.Int (600, 1000) / 1000)
    %Create a random bright color

    colorback (backgroundColor)
    %Set background color

    GUI.Hide (introButton)
    GUI.Hide (playButton)
    GUI.Hide (helpButton)
    GUI.Hide (quitButton)
    GUI.Hide (giveUpButton)
    GUI.Hide (backToMenuButton)
    GUI.Hide (confirmButton)
    %Hide all buttons

    cls %Clear Screen

    Font.Draw ("Word Search", 371, 560, titleFont, black)
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

    loop %Display seconds left
	if timed then
	    Font.Draw ("Seconds left:", 720, 400, headerFont, black)

	    if Time.Elapsed mod 1000 = 0 then %only every second
		drawfillbox (720, 350, 1000, 400, backgroundColor) %erase
		Font.Draw (intstr (timeLeft), 720, 350, headerFont, black) %display time
	    end if

	    if timeLeft <= 0 then %if time runs out
		display (false)
		exit
	    end if
	end if

	mousewhere (xCoord, yCoord, button)
	xRange := xCoord - ((xCoord - 75) mod 30)
	yRange := yCoord - ((yCoord - 25) mod 30)
	%Round coordinates to nearest 30 x 30 box
	%e.g. (123, 321) rounds to (120, 300)

	if button = 1 and inputLocked = false then
	    fork lockInput (300)

	    exit when xCoord >= 800 and xCoord <= 950 and yCoord >= 0 and yCoord <= 50

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

    %If loop is exited
    for i : 1 .. 4 %Fill "coordinates" with -1
	coordinates (i) := -1
    end for

    result coordinates
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
    title
    Font.Draw ("Loading music...", 0, 550, headerFont, black)
    Font.Draw ("*Any delay you experience is real", 0, 500, headerFont, black)

    fork playMusic ("threes.mp3")

    delay (1)

    cls

    var font : int := Font.New ("Comic Sans MS:20")

    for i : 0 .. 120
	drawbox (i - 1, i - 1, 180 + i + 1, 180 + i + 1, backgroundColor)
	drawbox (i + 1, i + 1, 180 + i - 1, 180 + i - 1, backgroundColor)  %Erase 1

	drawbox (i - 1, 420 - i - 1, 180 + i + 1, 600 - i + 1, backgroundColor)
	drawbox (i + 1, 420 - i + 1, 180 + i - 1, 600 - i - 1, backgroundColor) %Erase 2

	drawbox (420 - i - 1, 420 - i - 1, 600 - i + 1, 600 - i + 1, backgroundColor)
	drawbox (420 - i + 1, 420 - i + 1, 600 - i - 1, 600 - i - 1, backgroundColor) %Erase 3

	drawbox (420 - i - 1, i - 1, 600 - i + 1, 180 + i + 1, backgroundColor)
	drawbox (420 - i + 1, i + 1, 600 - i - 1, 180 + i - 1, backgroundColor) %Erase 4

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
		drawfillbox (i + 1, i2 + 1, i + 59, i2 + 59, backgroundColor)
		Font.Draw (chr (Rand.Int (65, 90)), i + 20, i2 + 20, font, black)
	    end for
	end for
	delay (100)
    end for

    for i : 1 .. 4
	drawfillbox (321, 480 - i * 60 + 1, 359, 480 - i * 60 + 59, backgroundColor)
	Font.Draw ("WORD" (i), 320, 480 - i * 60 + 20, font, black)
    end for

    for i : 1 .. 6
	drawfillbox (61 + i * 60, 301, 119 + i * 60, 359, backgroundColor)
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
    GUI.Show (introButton)
end intro

body proc mainMenu
    title

    GUI.Show (playButton)
    GUI.Show (helpButton)
    GUI.Show (quitButton)
end mainMenu

body proc help
    var letterFont := Font.New ("Comic Sans MS:15")

    title

    cls

    Font.Draw ("The purpose of the game is to find all the hidden words in the grid", 45, 570, headerFont, black)
    Font.Draw ("Words can appear horizontally, vertically, or diagonally", 126, 530, headerFont, black)


    for x : 440 .. 530 by 30
	for y : 240 .. 330 by 30
	    drawbox (x, y, x + 30, y + 30, yellow)
	    drawbox (x + 1, y + 1, x + 29, y + 29, yellow) %Draw empty boxes
	end for
    end for

    for i : 1 .. 4
	Font.Draw ("WORD" (i), 447, i * 30 + 218, letterFont, black) %Draw "WORD"
	Font.Draw ("WORD" (i), i * 30 + 417, 248, letterFont, black)
	Font.Draw ("WORD" (i), i * 30 + 417, i * 30 + 218, letterFont, black)
    end for

    delay (2000)

    Font.Draw ("To select a word, just click its first letter and last letter", 124, 460, headerFont, black)


    delay (2000)

    drawbox (440, 240, 470, 270, green) %Draw green frame
    drawbox (441, 241, 469, 269, green)

    delay (500)

    drawbox (530, 330, 560, 360, green) %Draw green frame
    drawbox (531, 329, 561, 359, green)

    delay (500)

    Draw.ThickLine (455, 255, 545, 345, 2, black) %Draw line connecting

    GUI.Show (backToMenuButton)
end help

body proc askTimed
    var input : string (1)
    var minutes, seconds : int

    title

    GUI.Show (backToMenuButton)

    locate (10, 1)
    Font.Draw ("Do you want it to be timed?", 309, 500, headerFont, black) %Font.Draw!
    Font.Draw ("Type y/n for yes/no", 365, 460, headerFont, black)

    loop
	getch (input)
	exit when input = "y" or input = "Y" or input = "n" or input = "N"
	%Error-trapping
    end loop

    if input = "y" or input = "Y" then
	timed := true

	Font.Draw ("How many minutes and seconds should the time limit be?", 107, 400, regularFont, black)

	locate (14, 1)
	put "Minutes:  " ..
	get minutes

	put "Seconds:  " ..
	get seconds

	timeLeft := minutes * 60 + seconds
    end if

    GUI.Show (confirmButton)
end askTimed

body proc wordSearch (number : int)
    title

    GUI.Show (giveUpButton)
    GUI.Show (backToMenuButton)

    if timed and firstTime then
	fork countTime
	firstTime := false
    end if
    %Start timer

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

    var match, wordMatch : boolean
    %For when checking if the clicked coordinates match a word
    %For checking if a word is found in wordList

    var matchNumber, wordMatchNumber : int
    %Stores which set of coordinates matched with the input
    %Stores which word was found

    var inputCoordinates : array 1 .. 4 of int
    %Stores what coordinates the user clicked on

    inputFile := "word_search" + intstr (number) + ".txt"
    open : inputStream, inputFile, get
    %Open a file based on the word search number

    get : inputStream, numberOfLines
    %The first line of the file wil contain the amount of preceding lines

    get : inputStream, name : *
    %The second line is the name of the word search

    var words : array 1 .. numberOfLines of string
    var coordinates : array 1 .. numberOfLines of array 1 .. 4 of int
    %Make a words array and coordinates array, with their lengths being the amount of lines

    var wordList : flexible array 1 .. numberOfLines of string
    %This stores the words that are haven't been found yet (dynamic array)

    loop
	%For each line
	exit when eof (inputStream)
	lineNumber += 1

	get : inputStream, word
	words (lineNumber) := word
	wordList (lineNumber) := word
	%Get the word and put into word arrays

	for i : 1 .. 4     %Get the 4 coordinates
	    get : inputStream, coordinate
	    coordinates (lineNumber) (i) := coordinate
	end for
    end loop

    close : inputStream

    %Copy words to wordsList

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

	    drawfillbox (xPos * 30 + 47, yPos * 30 - 3, xPos * 30 + 73, yPos * 30 + 23, backgroundColor)
	    %Clear the current letter from its box

	    Font.Draw (Str.Upper (words (i) (i2 + 1)), xPos * 30 + 50, yPos * 30, letterFont, black)
	    %Add the letter into the box
	end for
    end for

    for i : 1 .. upper (wordList)
	%For each element in words
	Font.Draw (wordList (i), 550, 475 - i * 25, wordFont, black)
	%Display words
    end for

    loop
	inputCoordinates := userInput ()
	%Get user input

	if inputCoordinates (1) = -1 then %If userInput returns -1
	    return
	    %Stop proc
	end if

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

	if match = true then     %If a match was found
	    Draw.ThickLine (coordinates (matchNumber) (1) * 30 + 60, coordinates (matchNumber) (2) * 30 + 10, coordinates (matchNumber) (3) * 30 + 60, coordinates (matchNumber) (4) * 30 + 10, 2,
		black)
	    %Cross out word on word search

	    wordMatchNumber := 0
	    wordMatch := false
	    %Reset variables

	    for i : 1 .. upper (wordList)
		wordMatchNumber += 1
		if words (matchNumber) = wordList (i) then
		    wordMatch := true
		    exit
		    %Exit when found match
		end if
	    end for

	    if wordMatch = true then
		%If found word
		for i : wordMatchNumber .. upper (wordList) - 1
		    wordList (i) := wordList (i + 1)
		end for

		new wordList, upper (wordList) - 1
		%From the found word to the length of array minus 1
		%Shift all indexes left 1, then resize array to itself minus 1
		%Basically deleting the word from the array

		drawfillbox (550, 0, 700, 475, backgroundColor)     %Erase word display area

		for i : 1 .. upper (wordList)
		    %For each element in words
		    Font.Draw (wordList (i), 550, 475 - i * 25, wordFont, black)
		    %Display words
		end for

		if upper (wordList) = 0 then     %If there are no more words left to choose
		    display (true)
		    return
		    %The user wins
		end if
	    end if
	end if
    end loop
end wordSearch

body proc display (win : boolean)
    title
    if win = true then
	colorback (72)
	cls
	Font.Draw ("Yay, you win!", 363, 284, titleFont, black)
    else
	colorback (64)
	cls
	Font.Draw ("Sorry, you lost", 343, 284, titleFont, black)
    end if
    GUI.Show (backToMenuButton)
end display

body proc goodBye
    title
    Font.Draw ("Thank you for using my program", 275, 500, headerFont, black)
    Font.Draw ("Programed by: Richard Yi", 326, 450, headerFont, black)

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
