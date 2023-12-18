import "stringUtil"
import "mapUtil"
import "listUtil"
import "mathUtil"
import "aoc"
import "vector3"

resultA = {}

pos = [0, 0, 0]

if 0 then
	fname = "input.txt"
	gfx.scale = 1
	gfx.scrollX = 0; gfx.scrollY = 0
else
	fname = "example.txt"
	gfx.scale = 10
	gfx.scrollX = 4000; gfx.scrollY = 3000
end if

lines = file.readLines(fname)
if lines == null then
	print "Unable to read: " + fname
	exit
end if
if not lines[-1] then lines.pop


dir = {}
dir.U = [0, 1, 0]
dir.D = [0, -1, 0]
dir.L = [-1, 0, 0]
dir.R = [1, 0, 0]
dirs = "RDLU"

polygon = []

lastDir = ""
for line in lines
	m = line.match("{} {} ({data})")
	if not m then
		print "Pattern did not match on line: " + line
		continue
	end if
	m.dist = hexVal(m.data[:-1])
	m.dir = dirs[m.data[-1].val]
	dpos = dir[m.dir].times(m.dist)
	
	// Assume the square at our current pos is fully dug out.
	// Add polygon points to describe the LEFT side of the
	// trench we are digging with the current instruction.
	if m.dir == lastDir then
		print "Oops!  Same dir repeats on line " + lines.indexOf(line)
		exit
	end if
	if m.dir == "U" then
		if lastDir == "R" then polygon[-1][0] -= 1
		pos.add dpos
		polygon.push [pos.x, pos.y+1]
	else if m.dir == "D" then
		if lastDir == "L" then polygon[-1][0] += 1
		pos.add dpos
		polygon.push [pos.x+1, pos.y]
	else if m.dir == "R" then
		if lastDir == "D" then polygon[-1][1] += 1
		pos.add dpos
		polygon.push [pos.x+1, pos.y+1]
	else  // "L"
		if lastDir == "U" then polygon[-1][1] -= 1
		pos.add dpos
		polygon.push [pos.x, pos.y]
	end if
	lastDir = m.dir
end for

// DANG!  It appears that mathUtil.polyArea is not quite accurate.
// Let's try this method (Shoelace formula):
polygonArea = function(verts)
    area = 0.0
    n = verts.len
    j = n - 1
    for i in range(0,n-1)
        area += (verts[j][0] + verts[i][0]) * (verts[j][1] - verts[i][1])
        j = i
    end for
    return abs(area / 2.0)
end function

print "Polygon has " + polygon.len + " points"
print "MathUtil.polyArea:  " + mathUtil.polyArea(polygon)
print "Custom polygonArea: " + polygonArea(polygon)


print "final answer (part A): " + resultA.len
