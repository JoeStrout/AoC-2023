import "stringUtil"
import "mapUtil"
import "listUtil"
import "mathUtil"
import "aoc"

resultA = []
resultB = []

if 1 then fname = "input.txt" else fname = "example.txt"
data = file.readLines(fname)[0]

hash = function(s)
	result = 0
	for c in s
		result = ((result + c.code) * 17) % 256
	end for
	return result
end function

for item in data.split(",")
	resultA.push hash(item)
end for

print "final answer (part A): " + resultA.sum
