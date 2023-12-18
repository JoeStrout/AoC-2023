import "stringUtil"
import "mapUtil"
import "listUtil"
import "mathUtil"
import "aoc"

resultA = {}

clear
display(6).mode = displayMode.tile
td = display(6)
td.clear
td.tileSet = file.loadImage("tileset.png")
td.tileSetTileSize = 5
gfx.clear color.clear

if 1 then
	fname = "input.txt"
	td.cellSize = 5
else
	fname = "example.txt"
	td.cellSize = 25
end if

lines = file.readLines(fname)
if lines == null then
	print "Unable to read: " + fname
	exit
end if
if not lines[-1] then lines.pop

// Load the layout
symbols = ".\/|-"
rows = lines.len
cols = lines[0].len
td.extent = [cols, rows]
for y in range(0, rows-1)
	line = lines[y]
	for x in range(0, cols-1)
		c = line[x]
		td.setCell x, rows-1-y, symbols.indexOf(c)
	end for
end for

// Define directions (0-3) (with y-up as in our tile display)
dx = [1, 0, -1, 0]
dy = [0, 1, 0, -1]

// Now trace all the light paths!  Each head is [x, y, direction]
heads = [[-1, rows-1, 0]]
addLight = function(x,y, dir)
	cs = td.cellSize
	offset = cs/2
	hdx = dx[dir]/2
	hdy = dy[dir]/2
	gfx.line (x-hdx)*cs+offset, (y-hdy)*cs+offset, 
			 (x+hdx)*cs+offset, (y+hdy)*cs+offset, 
		     "#FFFF0088", cs*3/5
	resultA.push [x,y]
end function
//addLight heads[0][0], heads[0][1], heads[0][2]

alreadyDone = {}
while heads
	for i in range(heads.len-1)
		h = heads[i]; d = h[2]
		x = h[0] + dx[d]
		y = h[1] + dy[d]
		if x < 0 or x >= cols or y < 0 or y >= rows then
			heads.remove i
			continue
		end if
		h[0] = x; h[1] = y
		if alreadyDone.hasIndex([x,y,d]) then
			heads.remove i
			continue
		end if
		alreadyDone.push [x,y,d]
		addLight x, y, d
		c = symbols[td.cell(x,y)]
		if c == "/" then
			h[2] = [1,0,3,2][d]
		else if c == "\" then
			h[2] = [3,2,1,0][d]
		else if c == "-" then
			if d != 0 and d != 2 then
				h[2] = 0
				heads.push [x,y,2]
			end if
		else if c == "|" then
			if d != 1 and d != 3 then
				h[2] = 1
				heads.push [x,y,3]
			end if
		end if
	end for
	yield //wait 0.1
end while


print "final answer (part A): " + resultA.len
