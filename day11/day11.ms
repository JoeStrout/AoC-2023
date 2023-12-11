import "stringUtil"
import "mapUtil"
import "listUtil"
import "mathUtil"
import "aoc"

distances = []
resultB = []

if 1 then fname = "input.txt" else fname = "example.txt"
lines = file.readLines(fname)
if lines == null then
	print "Unable to read: " + fname
	exit
end if
if not lines[-1] then lines.pop

// find galaxies
galaxies = []	// list of [x,y] image coordinates
width = 0
y = 0
for line in lines
	for x in line.indexes
		if line[x] == "#" then galaxies.push [x,y]
	end for
	if line.len > width then width = line.len
	y += 1
end for
height = y

print "Found " + galaxies.len + " galaxies in " + width + " x " + height + " image"

isEmptyX = function(x)
	for g in galaxies; if g[0] == x then return false; end for
	return true
end function

isEmptyY = function(y)
	for g in galaxies; if g[1] == y then return false; end for
	return true
end function

// find real (expanded) coordinates
imageToRealX = range(0, width-1)
imageToRealY = range(0, height-1)
for x in imageToRealX.indexes
	if isEmptyX(x) then
		for i in range(x+1, width-1)
			imageToRealX[i] += 999999		// for part A, use 1
		end for
	end if
end for
for y in imageToRealY.indexes
	if isEmptyY(y) then
		for i in range(y+1, height-1)
			imageToRealY[i] += 999999		// for part A, use 1
		end for
	end if
end for

imageToReal = function(pos)
	return [imageToRealX[pos[0]], imageToRealY[pos[1]]]
end function

realDist = function(g1, g2)
	pos1 = imageToReal(g1)
	pos2 = imageToReal(g2)
	return abs(pos1[0]-pos2[0]) + abs(pos1[1]-pos2[1])
end function

for i in galaxies.indexes
	for j in range(i+1, galaxies.len-1, 1)
		distances.push realDist(galaxies[i], galaxies[j])
	end for
end for


print "total distance: " + distances.sum
