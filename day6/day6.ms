import "stringUtil"
import "mapUtil"
import "listUtil"
import "mathUtil"
import "aoc"

resultA = []

nonEmpty = function(s)
	return s.len > 0
end function

if 1 then fname = "input.txt" else fname = "example.txt"
lines = file.readLines(fname)

times = lines[0][10:].split.filtered(@nonEmpty)
times.apply(@val)
dists = lines[1][10:].split.filtered(@nonEmpty)
dists.apply(@val)

for i in times.indexes
	winCount = 0
	for t in range(1, times[i])
		d = t * (times[i] - t)
		if d > dists[i] then winCount += 1
	end for
	resultA.push winCount
end for

print "final answer (part A): " + resultA.product
