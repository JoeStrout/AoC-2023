import "stringUtil"
import "mapUtil"
import "listUtil"
import "mathUtil"
import "aoc"
import "vector3"

if 0 then
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

distMap = {}	// key: [x,y]; value: (max) distance from the goal
distMap[endPos] = 0

t0 = time
toDo = [endPos]
while toDo
	pos = toDo.pull
	dist = distMap[pos]
	text.row = 25; text.column = 60; print dist + "   "
	gfx.setPixel pos.x, rows-1 - pos.y, rgb(0, floor(dist/255), dist%255)
	for dir in dirs
		npos = [pos[0] + dir[0], pos[1] + dir[1]]
		if not inBounds(npos[0], npos[1]) then continue
		c = lines[npos[1]][npos[0]]
		if c == "#" then continue
		if c == "<" and dir != [1,0] then continue
		if c == ">" and dir != [-1,0] then continue
		if c == "^" and dir != [0,1] then continue
		if c == "v" and dir != [0,-1] then continue
		prevDist = distMap.get(npos, null)
		if prevDist == dist-1 then continue // (no backtracking)
		if prevDist > dist then continue	// (longer path already found)
		distMap[npos] = dist+1
		toDo.push npos
	end for
end while
t1 = time

// Now we've marked all the distances, we can build our path
// by walking along and always choosing the unused neighbor
// with the longest distance from the goal.

print "final answer (part A): " + distMap[startPos]
print "Runtime: " + (t1 - t0)

//for p in path
//	gfx.setPixel p.x, rows-1 - p.y, color.aqua
//	yield
//end for

