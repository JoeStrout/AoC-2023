import "stringUtil"
import "mapUtil"
import "listUtil"
import "mathUtil"
import "aoc"

resultB = []

nonEmpty = function(s)
	return s.len > 0
end function

if 1 then fname = "input.txt" else fname = "example.txt"
lines = file.readLines(fname)

lines[0] = lines[0].replace(" ", "")
time = lines[0].split(":")[1].val

lines[1] = lines[1].replace(" ", "")
dist = lines[1].split(":")[1].val

print "time: " + time
print "dist: " + dist

// Now the distance y covered for any time x is given by:
// y = x * (T - x) = x T - x^2
//
// Solving for x (given y), there are two solutions, given by:

minTime = time/2 - sqrt(time^2 - 4*dist)/2
maxTime = time/2 + sqrt(time^2 - 4*dist)/2

// And now we can just use that directly to calculate:
winCount = floor(maxTime) - ceil(minTime) + 1

print "final answer (part B): " + winCount
