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
else
	fileName = "example.txt"
	width = 5
	height = 5
end if

clear
display(5).mode = displayMode.off
display(6).mode = displayMode.tile
td = display(6)
td.tileSet = file.loadImage("pipeTiles.png")
td.tileSetTileSize = 5
td.cellSize = 5
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
print toDo

while toDo
	pos = toDo.pull
	if pos == start then continue
	if td.cellTint(pos[0], pos[1]) != white then continue
	td.setCellTint pos[0], pos[1], explored
	c = td.cell(pos[0], pos[1])
	for dir in pipeDirs[c]
		nextPos = pos.plus(dir)
		if not inBounds(nextPos) then continue
		toDo.push nextPos
		nextDist = dist[pos[0]][pos[1]]+1
		dist[nextPos[0]][nextPos[1]] = nextDist
		if nextDist > maxDist then maxDist = nextDist
	end for	
end while

print "maxDist: " + maxDist
