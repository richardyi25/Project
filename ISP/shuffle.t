setscreen ("text")

var a : array 1 .. 100 of int

for i : 1 .. 100
    a (i) := i
end for

proc shuffle
    var i, temp, random : int
    i := upper (a)

    loop
	exit when i = 1
	random := Rand.Int (1, i + 1)

	temp := a (i)
	a (i) := a (random)
	a (random) := temp
	i -= 1
    end loop
end shuffle

shuffle

for i : 1 .. 100
    put a (i)
end for
