setscreen ("graphics:1000;600;position:center;center;nobuttonbar")

%Argument Number
var number : int := 2

var inputStream : int
var inputFile : string
var numberOfLines : int
var lineNumber : int := 0

var word : string
var coordinate : int
%Temporary Values from file

var xChange, yChange : int
var xPos, yPos : int
%For drawing the word intro the grid

inputFile := "word_search" + intstr (number) + ".txt"
open : inputStream, inputFile, get
%Open a file based on the word search number

get : inputStream, numberOfLines
%The first line of the file wil contain the amount of preceding lines

var words : array 1 .. numberOfLines of string
var coordinates : array 1 .. numberOfLines of array 1 .. 4 of int
%Make a words array and coordinates array, with its length being the amount of lines

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

var font := Font.New ("Comic Sans MS:15")

for i : 1 .. upper (coordinates)
    xChange := (coordinates (i) (3) - coordinates (i) (1)) div (length (words (i)) - 1)
    yChange := (coordinates (i) (4) - coordinates (i) (2)) div (length (words (i)) - 1)
    
    for i2 : 0 .. length (words (i)) - 1
        xPos := coordinates (i) (1) + (i2 * xChange)
        yPos := coordinates (i) (2) + (i2 * yChange)
        
        Font.Draw(Str.Upper(words(i)(i2 + 1)), xPos * 30 + 80, yPos * 30 + 30   , font, black)
    end for
end for
