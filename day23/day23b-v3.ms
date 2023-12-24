import "stringUtil"
import "mapUtil"
import "listUtil"
import "mathUtil"
import "aoc"
import "vector3"
import "qa"

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
// to other nodes).  Give each one a unique character.
nodeNames = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*"

Node = {}
Node.name = ""
Node.loc = null	// [x,y]
Node.neighbors = null	// {node name:path to that node}

nodes = {}		// key: name; value: Node
nodeLocs = {}	// key: [x,y]; value: Node

startNode = new Node; startNode.name = "A"; startNode.loc = startPos
nodes.A = startNode; nodeLocs[startPos] = startNode
endNode = new Node; endNode.name = "B"; endNode.loc = endPos
nodes.B = endNode; nodeLocs[endPos] = endNode

for y in range(1, rows-2)
	for x in range(1, cols-2)
		if lines[y][x] == "#" then continue
		neighbors = 0
		for dir in dirs
			if lines[y+dir[1]][x+dir[0]] != "#" then neighbors += 1
		end  for
		if neighbors > 2 then
			node = new Node
			node.name = nodeNames[nodes.len]
			node.loc = [x,y]
			qa.assert not nodes.hasIndex(node.name)
			nodes[node.name] = node
			nodeLocs[node.loc] = node
		end if
	end for
end for
print nodes.len + " nodes found"

// for debugging: color the node points
for n in nodes.values
	gfx.setPixel n.loc.x, rows-1-n.loc.y, color.yellow
end for

// Now, find the connections from every node to its neigbors,
// along with the path lengh in between.
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
				if not inBounds(nx, ny) then continue
				if lines[ny][nx] == "#" then continue
				if path.indexOf([nx,ny]) != null then continue
				break
			end for
			path.push [nx, ny]
			if nodeLocs.hasIndex([nx, ny]) then break
			x = nx; y = ny
		end while
		neighborNode = nodeLocs[path[-1]]
		self.neighbors[neighborNode.name] = path
	end for
end function

print "Finding neighbors... ", ""
c = text.column
for name in nodes.indexes
	print name + char(8), ""
	nodes[name].findNeighbors
end for
print "Done"

// Now we can approach it as a dynamic programming problem.
// The state will be the current node + ":" + remaining nodes.
// For any such state, find the longest path to the goal.
cache = {}
bestSoFar = 0
maxDistToEnd = function(state)
	if cache.hasIndex(state) then return cache[state]	// <-- dynamic programming!
	srcName = state[0]
	availNames = state[2:]
	srcNode = nodes[srcName]
	// if the end state is no longer available, then there's no 
	// way to reach it
	if availNames.indexOf(endNode.name) == null then
		print "No path to end in " + state
		cache[state] = 0
		return 0
	end if
	// find the maximum of the distance to each of the available neighbors
	maxDist = 0
	for kv in srcNode.neighbors
		neighborName = kv.key
		if availNames.indexOf(neighborName) == null then continue
		distToNeighbor = kv.value.len
		if neighborName == endNode.name then
			distToEnd = distToNeighbor
		else
			nextAvail = availNames.replace(neighborName, "")
			nextState = neighborName + ":" + nextAvail
			distToEnd = distToNeighbor + maxDistToEnd(nextState)
		end if
		if distToEnd > maxDist then maxDist = distToEnd
	end for
	// cache and return
	//print state + " -> " + maxDist
	if maxDist > bestSoFar then
		globals.bestSoFar = maxDist
		print "bestSoFar: " + bestSoFar
	end if
	cache[state] = maxDist
	return maxDist
end function

t0 = time
startState = startNode.name + ":" + nodeNames[1:nodes.len]
bestTotal = maxDistToEnd(startState)
t1 = time


print "final answer (part B): " + bestTotal
print "Runtime: " + (t1 - t0)
