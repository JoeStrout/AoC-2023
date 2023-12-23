import "stringUtil"
import "mapUtil"
import "listUtil"
import "mathUtil"
import "aoc"

if 1 then
	fname = "input.txt"
	stepGoal = 64
else
	fname = "example.txt"
	stepGoal = 6
end if

lines = file.readLines(fname)
if lines == null then
	print "Unable to read: " + fname
	exit
end if
if not lines[-1] then lines.pop

backColor = "#000000FF"
stoneColor = "#AAAAAAFF"

rows = lines.len
cols = lines[0].len

clear
gfx.clear backColor
gfx.scale = 5 + 5 * (fname == "example.txt")
for y in lines.indexes
	line = lines[y]
	for x in line.indexes
		c = line[x]
		if c == "#" then gfx.setPixel x, y, stoneColor
		if c == "S" then startPos = [x, y, 0]	// (third element is how many steps we've gone)
	end for
end for

dirs = [ [-1,0], [1,0], [0,-1], [0,1] ]
inBounds = function(x, y)
	return x >= 0 and x < cols and y >= 0 and y < rows
end function


// Do a flood-fill `stepGoal` long, and count how many of those
// spots are an even number of steps from the start (i.e., form
// a checkerboard based on the start position).

toDo = [startPos]
count = 0
while toDo
	pos = toDo.pull
	if pos[2] <= stepGoal and gfx.pixel(pos[0],pos[1]) == backColor then
		if abs(pos[0]-startPos[0]) % 2 != abs(pos[1]-startPos[1]) % 2 then
			gfx.setPixel pos[0], pos[1], color.green
		else
			gfx.setPixel pos[0], pos[1], color.red
			count += 1
		end if
		for dir in dirs
			x = pos[0] + dir[0]; y = pos[1] + dir[1]
			if inBounds(x, y) and gfx.pixel(x,y) == backColor then
				toDo.push [x, y, pos[2]+1]
			end if
		end for
	end if
end while

print "final answer (part A): " + count
