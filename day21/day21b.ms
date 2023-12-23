import "stringUtil"
import "mapUtil"
import "listUtil"
import "mathUtil"
import "aoc"

// Rough port of: https://github.com/chompaa/advent-of-code/blob/main/2023/21/solver.py
// ...And no, I don't really understand the math behind this solution.

fname = "input.txt"
stepGoal = 26501365

lines = file.readLines(fname)
if lines == null then
	print "Unable to read: " + fname
	exit
end if
if not lines[-1] then lines.pop

rows = lines.len
cols = lines[0].len

for y in lines.indexes
	line = lines[y]
	for x in line.indexes
		c = line[x]
		if c == "S" then startPos = [x, y]
	end for
end for

dirs = [ [-1,0], [1,0], [0,-1], [0,1] ]

walk = function(maxDist)
	queue = [startPos + [0]]
	tiles = {}
	seen = {}
	
	while queue
		item = queue.pull
		pos = item[:2]; dist = item[2]

		if dist == maxDist + 1 or seen.hasIndex(pos) then continue

		tiles[dist] = tiles.get(dist, 0) + 1
		seen.push(pos)

		for neighbor in dirs
			n_pos = pos.plus(neighbor)
			if lines[n_pos[0] % cols][n_pos[1] % rows] != "#" then
				queue.push [n_pos[0], n_pos[1], dist + 1]
			end if
		end for
	end while
	
	return tiles
end function

getGardenTiles = function(steps)
	tiles = walk(steps)
	sum = 0
	for kv in tiles
		if kv.key % 2 == steps % 2 then sum += kv.value
	end for
	return sum
end function

//print "Part A: " + getGardenTiles(64)


// Part 2 ... here's where mysterious math lies.

edge = floor(rows / 2)	// ?

y = []
for i in range(0,2)
	print "y[" + i + "] = ", ""
	y.push getGardenTiles(edge + i * rows)
	print y[-1]
end for

// Obtained by solving some system of equations
a = floor((y[2] - (2 * y[1]) + y[0]) / 2)
b = y[1] - y[0] - a
c = y[0]

// build our polynomial (?)
f = function(n); return a * n^2 + b * n + c; end function

target = floor((26501365 - edge) / rows)

print "Part 2: " + f(target)