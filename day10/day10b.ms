import "stringUtil"
import "mapUtil"
import "listUtil"
import "mathUtil"
import "aoc"

pipeLetters = "|-LJ7F.S"
pipeDirs = [
	[[0,-1], [0,1] ],	// |
	[[-1,0], [1,0] ],	// -
	[[0,1],  [1,0] ],	// L
	[[0,1],  [-1,0]],	// J
	[[-1,0], [0,-1]],	// 7
	[[1,0],  [0,-1]],	// F
	[], [] ]			// . and S

if 1 then
	fileName = "input.txt"
	width = 140
	height = 140
else if 0 then
	fileName = "example2.txt"
	width = 10
	height = 10
else
	fileName = "example3.txt"
	width = 20
	height = 10
end if

clear
display(5).mode = displayMode.off
display(6).mode = displayMode.tile
td = display(6)
td.clear
td.tileSet = file.loadImage("pipeTiles.png")
td.tileSetTileSize = 5
td.cellSize = 5 + 20 * fileName.startsWith("example")
td.extent = [width, height]
td.scrollX = -(960 - 140*5)

white = "#FFFFFFFF"
explored = "#FF8800FF"

row = height-1
for line in file.readLines(fileName)
	if not line then continue
	for col in line.indexes
		td.setCell col, row, pipeLetters.indexOf(line[col])
		td.setCellTint col, row, white
		if line[col] == "S" then start = [col,row]
	end for
	row -= 1
end for

print "Start at " + start

inBounds = function(pos)
	return pos[0] >= 0 and pos[0] < width and pos[1] >= 0 and pos[1] < height
end function

dist = list.init2d(width, height, 0)
maxDist = 0
toDo = []
for dir in [[-1,0], [1,0], [0,-1], [0,1]]
	pos = start.plus(dir)
	if not inBounds(pos) then continue
	c = td.cell(pos[0], pos[1])
	if pipeDirs[c].contains(dir.times(-1)) then toDo.push pos
end for
loopStart = toDo[0]
toDo = [loopStart]

colorRelative = function(basePos, dx, dy, colorToSet)
	newPos = basePos.plus([dx, dy])
	if not inBounds(newPos) then return
	if td.cellTint(newPos[0], newPos[1]) == explored then return
	td.setCellTint newPos[0], newPos[1], colorToSet
end function

setAcolor = "#880000FF"
setBcolor = "#00FF44FF"

while toDo
	pos = toDo.pull
	td.setCellTint pos[0], pos[1], explored
	if pos == start then continue
	c = td.cell(pos[0], pos[1])
	for dir in pipeDirs[c]
		nextPos = pos.plus(dir)
		if not inBounds(nextPos) then continue
		if td.cellTint(nextPos[0], nextPos[1]) == explored then continue
		
		// OK, we're traveling along the pipe from pos to nextPos
		// (in direction dir).  Define ONE side of this as "region A"
		// and the other side as "region B", and color accordingly.

		// main direction: just use the perpendiculars
		colorRelative pos, -dir[1], dir[0], setAcolor
		colorRelative pos, dir[1], -dir[0], setBcolor
		
		// secondary direction: matters only in corners, but doesn't
		// hurt on straights
		otherDir = pipeDirs[c][dir == pipeDirs[c][0]].times(-1)
		colorRelative pos, -otherDir[1], otherDir[0], setAcolor
		colorRelative pos, otherDir[1], -otherDir[0], setBcolor
		
		toDo.push nextPos
		nextDist = dist[pos[0]][pos[1]]+1
		dist[nextPos[0]][nextPos[1]] = nextDist
		if nextDist > maxDist then maxDist = nextDist
	end for
	if td.cellSize > 10 then wait 0.1	// slow it down so you can watch it go
end while

// I just ran the above on each of my examples, and by inspection,
// saw which color was the "inside" color for each file:
if fileName == "example3.txt" then insideColor = setAcolor else insideColor = setBcolor

// Now do a flood-fill to extend and count the inside color.
toDo = []
insideCount = 0
for row in range(0, height-1)
	for col in range(0, width-1)
		if td.cellTint(col, row) == insideColor and not toDo.contains([col,row]) then
			insideCount += 1
			toDo.push [col, row]
		end if
	end for
end for


while toDo
	pos = toDo.pull
	for dir in [[-1,0], [1,0], [0,-1], [0,1]]
		nextPos = pos.plus(dir)
		if not inBounds(nextPos) then continue
		if td.cellTint(nextPos[0], nextPos[1]) != white then continue
		td.setCellTint nextPos[0], nextPos[1], insideColor
		insideCount += 1
		toDo.push nextPos
	end for
end while

print "Inside count: " + insideCount

// 452 is too low!
