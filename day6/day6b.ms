import "stringUtil"
import "mapUtil"
import "listUtil"
import "mathUtil"
import "aoc"

resultB = []

nonEmpty = function(s)
	return s.len > 0
end function

if 0 then fname = "input.txt" else fname = "example.txt"
lines = file.readLines(fname)

lines[0] = lines[0].replace(" ", "")
time = lines[0].split(":")[1].val

lines[1] = lines[1].replace(" ", "")
dist = lines[1].split(":")[1].val

print "time: " + time
print "dist: " + dist

winCount = 0
t = 0
while t < time
	t += 1
	d = t * (time - t)
	if d > dist then winCount += 1
	if t % 100000 == 0 then print "t=" + t + ", winCount=" + winCount
end while

print "final answer (part B): " + winCount
