setscreen("text")

var inputStream : int
var numberOfLines : int
var lineNumber : int := 0
var word : string
var coordinate : int

open : inputStream, "word_search1.txt", get

get : inputStream, numberOfLines
%The first line of the file wil contain the amount of preceding lines

var words : array 1 .. numberOfLines of string
var coordinates : array 1 .. numberOfLines, 1 .. 4 of int

loop
    exit when eof (inputStream)
    lineNumber += 1

    get : inputStream, word
    words (lineNumber) := word

    for i : 1 .. 4
	get : inputStream, coordinate
	coordinates (lineNumber, i) := coordinate
    end for
end loop

close : inputStream


%Basic display
for i : 1 .. upper (words)
    put words (i), ":"
    for i2 : 1 .. 4
	put coordinates (i, i2), " " ..
    end for
    put ""
end for
