import "stringUtil"
import "mapUtil"
import "listUtil"
import "mathUtil"
//import "aoc"

resultA = []
resultB = []

if 1 then fname = "input.txt" else fname = "example.txt"
lines = file.readLines(fname)
if lines == null then
	print "Unable to read: " + fname
	exit
end if
if not lines[-1] then lines.pop

names = "zero one two three four five six seven eight nine".split

for line in lines
	digit0 = null
	digit1 = null
	
	// iterate forward to find first digit
	for i in range(0, line.len-1)
		for n in names.indexes
			if line[i:].startsWith(names[n]) then
				digit0 = n
				break
			end if
		end for
		if line[i] >= "0" and line[i] <= "9" then
			digit0 = line[i].val
		end if
		if digit0 != null then break
	end for		
	
	// iterate backward to find last one
	for i in range(line.len-1)
		for n in names.indexes
			if line[i:].startsWith(names[n]) then
				digit1 = n
				break
			end if
		end for
		if line[i] >= "0" and line[i] <= "9" then
			digit1 = line[i].val
		end if
		if digit1 != null then break
	end for		
	valueA = digit0*10 + digit1

	print line + ": " + valueA
	resultA.push valueA
end for

print "final answer (part A): " + resultA.sum
// Also available: list.min, list.max, list.mean