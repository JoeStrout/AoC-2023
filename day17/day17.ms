import "stringUtil"
import "mapUtil"
import "listUtil"
import "mathUtil"
import "aoc"
import "search"

resultA = []
resultB = []

if 1 then fname = "input.txt" else fname = "example.txt"
lines = file.readLines(fname)
if lines == null then
	print "Unable to read: " + fname
	exit
end if
if not lines[-1] then lines.pop

cityMap = []		// heat cost at [row][col]
for line in lines
	cityMap.push line.split("")
	cityMap[-1].apply @val
end for
rows = cityMap.len
cols = cityMap[0].len

startPos = [0,0]
endPos = [cols-1, rows-1]

inBounds = function(x,y)
	return x >= 0 and x < cols and y >= 0 and y < rows
end function

// Define directions (0-3) (with y-up as in our tile display)
dx = [1, 0, -1, 0]
dy = [0, 1, 0, -1]

// For our state representation we will use: [x, y, dir, straightMoves]
// (where straightMoves is 1-3, how many times we've moved straight).

clear
gfx.scale = 3; gfx.scrollX = -500

finder = new search.Search
finder.heuristic = @search.manhattanDistance
finder.neighbors = function(state)
	x = state[0]; y = state[1]; dir = state[2]; smoves = state[3]
	result = {}
	addResult = function(x, y, dir, smoves)
		if inBounds(x,y) then 
			outer.result[[x,y, dir, smoves]] = cityMap[y][x]
		end if
	end function
	
	leftDir = (dir + 1) % 4
	addResult x+dx[leftDir], y+dy[leftDir], leftDir, 1
	
	rightDir = (dir + 3) % 4
	addResult x+dx[rightDir], y+dy[rightDir], rightDir, 1
	
	if smoves < 3 then
		addResult x+dx[dir], y+dy[dir], dir, smoves+1
	end if
	return result
end function

t0 = time
path = finder.findPath(startPos+[0, 0], endPos)
t1 = time
for point in path[1:]	// (skipping the initial entry cell!)
	resultA.push cityMap[point[1]][point[0]]
end for

print "final answer (part A): " + resultA.sum
print "time: " + (t1 - t0)
