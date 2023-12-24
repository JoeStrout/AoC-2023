import "stringUtil"
import "mapUtil"
import "listUtil"
import "mathUtil"
import "aoc"

if 1 then
	fname = "input.txt"
	testMin = 200000000000000; testMax = 400000000000000
else
	fname = "example.txt"
	testMin = 7; testMax = 27
end if

lines = file.readLines(fname)
if lines == null then
	print "Unable to read: " + fname
	exit
end if
if not lines[-1] then lines.pop

hail = []
for line in lines
	m = line.match("{x}, {y}, {z} @ {vx}, {vy}, {vz}")
	m.applyToValues @val
	if m == null then
		print "Could not match on line: " + line
		exit
	end if
	hail.push m
end for

print hail.len + " hailstones loaded"

intersection = function(stoneA, stoneB)
	denom = stoneA.vx * stoneB.vy - stoneA.vy * stoneB.vx
	if denom == 0 then return null
	t = ((stoneB.x - stoneA.x) * stoneB.vy + (stoneA.y - stoneB.y) * stoneB.vx) / denom
	return [stoneA.x + t * stoneA.vx, stoneA.y + t * stoneA.vy]
end function

resultA = 0
for a in range(0, hail.len-2)
	print a + "/" + hail.len + "..."
	stoneA = hail[a]
	for b in range(a+1, hail.len-1)
		stoneB = hail[b]
		point = intersection(stoneA, stoneB)
//		print "[" + a + "] and [" + b + "]: " + str(point)
		if point == null then continue		
		if testMin <= point[0] <= testMax and testMin <= point[1] <= testMax then
			// make sure this is in the future for both stones
			dx = point[0] - stoneA.x; dy = point[1] - stoneA.y
			if sign(dx) != sign(stoneA.vx) or sign(dy) != sign(stoneA.vy) then continue
			dx = point[0] - stoneB.x; dy = point[1] - stoneB.y
			if sign(dx) != sign(stoneB.vx) or sign(dy) != sign(stoneB.vy) then continue			
//			print "Stones " + char(65+a) + " and " + char(65+b) + " intersect in range"
			resultA += 1
		end if
	end for
end for

print "final answer (part A): " + resultA