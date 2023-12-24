import "stringUtil"
import "mapUtil"
import "listUtil"
import "mathUtil"
import "aoc"
import "vector3"

if 1 then
	fname = "input.txt"
else
	fname = "example.txt"
end if

lines = file.readLines(fname)
if lines == null then
	print "Unable to read: " + fname
	exit
end if
if not lines[-1] then lines.pop

backColor = "#CCFFCCFF"
forestColor = "#008800FF"

rows = lines.len
cols = lines[0].len

clear
gfx.fillRect 0, 0, cols, rows, backColor
gfx.scale = 4 + 5 * (fname == "example.txt")
for y in lines.indexes
	line = lines[y]
	for x in line.indexes
		c = line[x]
		if c == "#" then gfx.setPixel x, rows-1-y, forestColor
		if c == "." and y == 0 then startPos = [x,y]
		if c == "." and y == rows-1 then endPos = [x,y]
	end for
end for

dirs = [ [-1,0], [1,0], [0,-1], [0,1] ]
inBounds = function(x, y)
	return x >= 0 and x < cols and y >= 0 and y < rows
end function

t0 = time
bestHike = null
toDo = []
toDo.push [startPos, {}]	// [x, y], set of locations on this path
while toDo
	item = toDo.pull; pos = item[0]; seen = item[1]
	gfx.setPixel pos.x, rows-1 - pos.y, color.white
	if pos == endPos then
		if bestHike == null or seen.len > bestHike.len then
			print "New best hike with " + seen.len + " steps"
			bestHike = seen
		end if
		continue
	end if
	for dir in dirs
		npos = [pos[0] + dir[0], pos[1] + dir[1]]
		if not inBounds(npos[0], npos[1]) then continue
		if seen.hasIndex(npos) then continue
		c = lines[npos[1]][npos[0]]
		if c == "#" then continue
		toDo.push [npos, seen + {pos:1}]
	end for
	gfx.setPixel pos.x, rows-1 - pos.y, color.gray
end while
t1 = time


print "final answer (part B): " + bestHike.len
print "Runtime: " + (t1 - t0)


// Yikes.  This is not a great approach -- it'll eventually get
// the answer, but it takes *forever*.
