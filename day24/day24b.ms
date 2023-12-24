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

hailstr = function(m)
	return [m.x,m.y] + "+" + [m.vx,m.vy] + "t"
end function

print hail.len + " hailstones loaded"

intersection = function(stoneA, stoneB, velChange)
	avx = stoneA.vx + velChange[0]; avy = stoneA.vy + velChange[1]
	bvx = stoneB.vx + velChange[0]; bvy = stoneB.vy + velChange[1]
	
	denom = avx * bvy - avy * bvx
	if denom == 0 then return null // lines are parallel or coincident.
	t = ((stoneB.x - stoneA.x) * bvy + (stoneA.y - stoneB.y) * bvx) / denom
	//if t < 0 then return null	// (rules out past-hits for stone A; does not for stone B though)
	return [stoneA.x + t * avx, stoneA.y + t * avy]
end function

cross2d = function(a, b)
	return a[0] * b[1] - a[1] * b[0]
end function

approxEqual = function(a,b)
	if abs(a) > 1E+12 then return abs(a - b) < 100
	return abs(a - b) < 0.1
end function

approxEqual2 = function(a,b)
	return approxEqual(a[0], b[0]) and approxEqual(a[1], b[1])
end function

// Approach: try different velocities for the rock we're throwing.
// But pick a moving frame of reference, by subtracting the rock
// velocity from everything else, so (in this frame) the rock is 
// stationary.  Then we just need to ask whether all the hailstones
// intersect at the same point.  And for a first pass, we can ask
// this for just X and Y, ignoring Z.  Maybe we get lucky.
possible = function(rockVelocity)
	velChange = rockVelocity.times(-1)
	commonPoint = null
	passCount = 0
	for a in range(0, hail.len-2)
		stoneA = hail[a]
		for b in range(a+1, hail.len-1)
			stoneB = hail[b]
			pt = intersection(stoneA, stoneB, velChange)
//			print "#"+a+":"+hailstr(stoneA) + ", #"+b+":"+ hailstr(stoneB) + " --> " + pt
			if pt == null then
				// lines are parallel or coincident.  Coincident is
				// OK, and occurs when this calculation is zero:
				if approxEqual(cross2d([stoneB.x-stoneA.x, stoneB.y-stoneA.y], 
				  [stoneA.vx + velChange[0], stoneA.vy + velChange[1]]), 0) then continue
				// otherwise, they are parallel and not coincident, so no good
			end if
			if commonPoint == null then commonPoint = pt
			if pt == null or not approxEqual2(commonPoint, pt) then
				return false
			end if
			passCount += 1
		end for
	end for
	outer.wtf = commonPoint
	return true
end function

if not globals.hasIndex("rockVel") then
	possibilities = []
	for vx in range(-350, 350)
		for vy in range(-350, 350)
			if possible([vx,vy]) then
				print "Velocity " + [vx,vy] + " is possible"
				possibilities.push [vx,vy]
			end if
		end for
		if vx % 20 == 0 then print vx + "..."
	end for
	print possibilities
	rockVel = possibilities[0]
end if

// rockVelocity [44, 305] is possible once we loosened up approxEqual for big numbers.
// OK!  We have an X and Y velocity; now we need to find Z.

intersectionXZ = function(stoneA, stoneB, velChange)
	avx = stoneA.vx + velChange[0]; avz = stoneA.vz + velChange[2]
	bvx = stoneB.vx + velChange[0]; bvz = stoneB.vz + velChange[2]
	
	denom = avx * bvz - avz * bvx
	if denom == 0 then return null // lines are parallel or coincident.
	outer.t = ((stoneB.x - stoneA.x) * bvz + (stoneA.z - stoneB.z) * bvx) / denom
	//if t < 0 then return null	// (rules out past-hits for stone A; does not for stone B though)
	return [stoneA.x + t * avx, stoneA.z + t * avz]
end function

possibleZ = function(rockVZ)
	velChange = [-rockVel[0], -rockVel[1], -rockVZ]
	commonPoint = null
	passCount = 0
	for a in range(0, hail.len-2)
		stoneA = hail[a]
		for b in range(a+1, hail.len-1)
			stoneB = hail[b]
			pt = intersectionXZ(stoneA, stoneB, velChange)
//			print "#"+a+":"+hailstr(stoneA) + ", #"+b+":"+ hailstr(stoneB) + " --> " + pt
			if pt == null then
				// lines are parallel or coincident.  Coincident is
				// OK, and occurs when this calculation is zero:
				if approxEqual(cross2d([stoneB.x-stoneA.x, stoneB.z-stoneA.z], 
				  [stoneA.vx + velChange[0], stoneA.vz + velChange[1]]), 0) then continue
				// otherwise, they are parallel and not coincident, so no good
			end if
			if commonPoint == null then commonPoint = pt
			if pt == null or not approxEqual2(commonPoint, pt) then
				if passCount > 100 then print "passCount=" + passCount + " with z=" + rockVZ					
				return false
			end if
			passCount += 1
		end for
	end for
	outer.wtf = commonPoint
	return true
end function

if rockVel.len < 3 then
	for vz in range(-450, 450)
		if possibleZ(vz) then
			print "vz = " + vz + " is possible"
		end if
	end for
end if

// ...And this shows me that my rock velocity is [44, 305, 75].
// Now I need the rock starting position (P_r).  To find this, I'll take any
// two of the hailstones and set up some equations.  And then Imma just use
// some online equation solver because it's Christmas Eve, fer gunny sacks.
// But let's print the equations out:
for i in [0,1]
	h = hail[i]
	print h.x + " + " + h.vx + " t_" + i + " = R_x + 44 * t_" + i + ","
	print h.y + " + " + h.vy + " t_" + i + " = R_y + 305 * t_" + i + ","
	print h.z + " + " + h.vz + " t_" + i + " = R_z + 75 * t_" + i + ","
end for

// I put the first 5 equations above into
// https://www.emathhelp.net/en/calculators/algebra-2/system-of-equations-solver
// ...and got:
// 𝑟𝑥=234382970331570, 𝑟𝑦=100887864960615, 𝑟𝑧=231102671115832, 𝑡0=880353154900, 𝑡1=505744646762
rockPos = [234382970331570, 100887864960615, 231102671115832]
print "Part Two answer: " + rockPos.sum

