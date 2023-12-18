import "stringUtil"
import "mapUtil"
import "listUtil"
import "mathUtil"
import "aoc"
import "vector3"

resultA = {}

clear
gfx.clear color.gray
pos = [480, 320, 0]

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

for line in lines
	m = line.match("{dir} {dist} ({color})")
	if not m then
		print "Pattern did not match on line: " + line
		continue
	end if
	m.dist = m.dist.val
	for i in range(1, m.dist)
		if resultA.hasIndex(pos) then print "Overlap at " + pos
		gfx.setPixel pos.x, pos.y, m.color
		resultA.push pos[:]
		pos.add dir[m.dir]
	end for
end for

// Now do a flood fill!
toDo = [[481, 319, 0]]
addIfNotDone = function(basePos, dir)
	x = basePos[0] + dir[0]
	y = basePos[1] + dir[1]
	if not resultA.hasIndex([x,y,0]) then
		toDo.push [x,y,0]
	end if
end function
while toDo
	p = toDo.pull
	if resultA.hasIndex(p) then continue
	resultA.push p
	gfx.setPixel p[0], p[1], color.black
	addIfNotDone p, dir.U
	addIfNotDone p, dir.L
	addIfNotDone p, dir.R
	addIfNotDone p, dir.D	
end while

print "final answer (part A): " + resultA.len
