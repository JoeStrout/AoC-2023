import "stringUtil"
import "mapUtil"
import "listUtil"
import "mathUtil"
import "aoc"

resultA = []
resultB = []

clear
gfx.clear color.black

if 1 then
	fname = "input.txt"
	gfx.scale = 1
	gfx.scrollX = -340
else
	fname = "example.txt"
	gfx.scale = 5
	gfx.scrollX = -600
end if

lines = file.readLines(fname)
if lines == null then
	print "Unable to read: " + fname
	exit
end if
if not lines[-1] then lines.pop

rows = lines.len
cols = lines[0].len

drawRock = function(row, col, square=false)
	x = 10 + col * 6; y = 10 + row * 6
	if square then
		gfx.fillRect x-3, y-3, 5, 5, color.gray
	else
		gfx.fillEllipse x-3, y-3, 5, 5, color.silver
	end if
end function

clearRock = function(row, col)
	x = 10 + col * 6; y = 10 + row * 6
	gfx.fillRect x-3, y-3, 6, 6, color.black
end function

m = list.init2d(rows, cols, ".")
row = rows - 1
for line in lines
	for col in line.indexes
		c = line[col]
		if not c or c == "." then continue
		drawRock row, col, c=="#"
		m[row][col] = c
	end for
	row -= 1
end for

redraw = function
	for row in range(0, rows-1)
		for col in range(0, cols-1)
			if m[row][col] == "." then
				clearRock row, col
			else
				drawRock row, col, m[row][col]=="#"
			end if
		end for
	end for
end function

rollNorth = function
	// Now roll all the O's north (i.e. in the +Y direction)!
	for col in range(0, cols-1)
		emptyRow = rows-1
		for row in range(rows-1)
			if m[row][col] == "O" then
				if emptyRow != null and row < emptyRow then
					//print "Moving " + [row,col] + " to " + [emptyRow,col]
//					clearRock row, col; drawRock emptyRow, col
					m[row][col] = "."
					m[emptyRow][col] = "O"
					emptyRow = emptyRow - 1
				else
					emptyRow = row-1
				end if
			else if m[row][col] == "#" then
				emptyRow = row-1
			end if
		end for
	end for
end function

pack = function
	result = []
	for row in m
		result.push row.join("")
	end for
	return result.join("")
end function

unpack = function(s)
	for row in range(0, rows-1)
		for col in range(0, cols-1)
			m[row][col] = s[row*cols + col]
		end for
	end for
end function

doOneCycle = function
	rollNorth
	m.blockRotateCCW
	rollNorth
	m.blockRotateCCW
	rollNorth
	m.blockRotateCCW
	rollNorth
	m.blockRotateCCW
end function

// Do an initial 100 runs to get things settled...
for i in range(1, 100)
	doOneCycle
	//redraw
end for

// Now, look for a cycle
seen = [pack]
for i in range(101, 1E6)
	doOneCycle
	redraw
	k = pack
	idx = seen.indexOf(k)
	if idx != null then
		print "Aha!  Iteration " + i + " was seen on " + (idx+100)
		//if key.get == char(27) then break
		break
	end if
	seen.push k
	if i % 100 == 0 then print i + "..."
end for

sameAs = (1E9 - 100) % (i-100)
print "So iteration 1E9 will look just like " + (sameAs+100)
print seen[sameAs]
unpack seen[sameAs]; redraw

calcLoad = function
	// And now compute total load
	globals.resultA = []
	for row in range(rows-1)
		for col in range(cols-1)
			if m[row][col] == "O" then resultA.push row+1
		end for
	end for
	print "final answer (part A): " + resultA.sum
end function

calcLoad
