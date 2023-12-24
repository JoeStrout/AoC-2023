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
gfx.scrollX = -390
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

// Convert our raw maze into a graph (list of nodes connected
// to other nodes).  This will be more efficient to search.
// Start by finding all the intersection points (plus start and end).
nodeLocs = {}
nodeLocs.push startPos
nodeLocs.push endPos
for y in range(1, rows-2)
	for x in range(1, cols-2)
		if lines[y][x] == "#" then continue
		neighbors = 0
		for dir in dirs
			if lines[y+dir[1]][x+dir[0]] != "#" then neighbors += 1
		end  for
		if neighbors > 2 then nodeLocs.push [x,y]
	end for
end for
print nodeLocs.len + " nodes found"

// for debugging: color the node points
for p in nodeLocs.indexes
	gfx.setPixel p.x, rows-1-p.y, color.yellow
end for

// Now, find the connections from every node to its neigbors,
// along with the path lengh in between.

Node = {}
Node.loc = null	// [x,y]
Node.neighbors = null	// {node loc:path to that node}
Node.findNeighbors = function
	self.neighbors = {}
	for dir in dirs
		x = self.loc[0] + dir[0]; y = self.loc[1] + dir[1]
		if not inBounds(x,y) then continue
		if lines[y][x] == "#" then continue
		path = [ [x,y] ]
		while true
			for d in dirs
				nx = x + d[0]; ny = y + d[1]
				if nx == self.loc[0] and ny == self.loc[1] then continue
				if lines[ny][nx] == "#" then continue
				if path.indexOf([nx,ny]) != null then continue
				break
			end for
			path.push [nx, ny]
			if nodeLocs.hasIndex([nx, ny]) then break
			x = nx; y = ny
		end while
		self.neighbors[path[-1]] = path
	end for
end function

nodesByLoc = {}	// key: [x,y] location; value: Node
for pos in nodeLocs.indexes
	node = new Node
	node.loc = pos
	node.findNeighbors
	nodesByLoc[pos] = node
end for

// NOW we can do our exhaustive search over this graph.

t0 = time
bestTotal = 0
toDo = []
toDo.push [startPos, []]	// [x, y], list of node locs on this path
while toDo
	item = toDo.pull; pos = item[0]; path = item[1]
	gfx.setPixel pos.x, rows-1 - pos.y, color.white
	if pos == endPos then
		// find total path len
		total = 0
		n = nodesByLoc[startPos]
		for loc in path
			total += n.neighbors[loc].len
			n = nodesByLoc[loc]
		end for
		if total > bestTotal then
			print "New best hike with " + total + " steps"
			bestTotal = total
		end if
		continue
	end if	
	node = nodesByLoc[pos]
	for neighborLoc in node.neighbors.indexes
		if path.indexOf(neighborLoc) != null then continue
		toDo.push [neighborLoc, path + [neighborLoc]]
	end for
	gfx.setPixel pos.x, rows-1 - pos.y, color.gray
end while
t1 = time


print "final answer (part B): " + bestTotal
print "Runtime: " + (t1 - t0)


// Yikes.  This is not a great approach -- it'll eventually get
// the answer, but it takes *forever*.

// 1800: too low

