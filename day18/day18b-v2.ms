import "stringUtil"
import "mapUtil"
import "listUtil"
import "mathUtil"
import "aoc"
import "vector3"

resultA = {}

pos = [0, 0, 0]

if 1 then
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

polygon = []		// polygon down the center of the trench
perimeter = 0		// perimeter of this trench-center polygon

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
	pos.add dpos
	polygon.push pos[:]
	perimeter += m.dist
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

area = polygonArea(polygon)
print "Center polygon has " + polygon.len + " points"
print "...with perimeter " + perimeter + " and area " + area
print "Expanding for the extra 0.5 m^2 per unit length, we get:"
print area + perimeter/2 + 1
// That + 1 can be derived by careful application of Pick's Theorem.
// Or we can just consider it a fudge factor. :)

