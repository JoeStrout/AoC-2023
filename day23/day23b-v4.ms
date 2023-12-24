// Translation of:
// https://gist.githubusercontent.com/ke-hermann/279f352829cd590d61104c27cac59bdc/raw/32f8d626927a28847b386b14cf76240cc7b2f38c/day23.py

import "listUtil"

data = file.readLines("example.txt")
if not data[-1] then data.remove -1
START = [0,1]
END = [data[0].len-1, data.len-2]

// add a map.setdefault method just like Python's
// (sets the given key to the given default value unless it
// is already set to something else; then returns the current value)
map.setdefault = function(key, default=null)
	if not self.hasIndex(key) then self[key] = default
	return self[key]
end function

neighbors = {}	// key: [x,y]; value: list of walkable [x,y] neighbors
intersections = [START, END]
graph = {}

print "Reading data"

// read the data and build our neighbors map (so we can look up
// the walkable neighbors of any walkable point int the grid);
// also collect intersections, which are spots with > 2 neighbors.
for i in data.indexes
	row = data[i]
	for j in row.indexes
		val = row[j]
		if val == "#" then continue
		ec = 0
		
		for dir in [[0,-1], [0,1], [1,0], [-1,0]]
			m = i + dir[0]; n = j + dir[1]
			if m < 0 or m >= len(data) or n < 0 or n >= len(data[0]) then continue
			if data[m][n] == "#" then continue
			ec += 1
			
			neighbors.setdefault([i,j], []).push [m,n]			
		end for
		if ec >= 3 then intersections.push [i,j]
	end for
end for

print "Building graph"

intersect_dist = function(cur, dist, seen)
	if intersections.contains(cur) then return [cur, dist]
	for n in neighbors[cur]
		if not seen.hasIndex(n) then break
	end for
	return intersect_dist(n, dist + 1, seen + {cur:1})
end function

for i in intersections
	for n in neighbors[i]
		td = intersect_dist(n, 1, {i:1})
		graph.setdefault(i, []).push td[:]
	end for
end for

print "Doing BFS"

bfs = function(node, score, seen)
	scores = []
	
	if node == END then return [score]
	
	for pAndDist in graph[node]
		p = pAndDist[0]; dist = pAndDist[1]
		if seen.hasIndex(p) then continue
		scores += bfs(p, score + dist, seen + {node:1})
	end for
	
	return scores
end function

result = bfs(START, 0, {START:1})
print result.max

