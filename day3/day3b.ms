import "stringUtil"
import "mapUtil"
import "listUtil"
import "mathUtil"
import "aoc"

resultA = []
resultB = []

if 1 then fname = "input.txt" else fname = "example.txt"
lines = file.readLines(fname)
if lines == null then
	print "Unable to read: " + fname
	exit
end if
if not lines[-1] then lines.pop

symbolAt = function(row, column)
	if row < 0 or row >= lines.len then return null
	line = lines[row]
	if column < 0 or column >= line.len then return null
	c = line[column]
	if ("0" <= c <= "9") or c == "." then return null
	return c
end function

gears = {}	// key: [y,x]; value: [list of numbers]

for lineNum in lines.indexes
	line = lines[lineNum]
	i = 0
	while i < line.len
		if line[i] < "0" or line[i] > "9" then
			i += 1
			continue
		end if
		for j in range(i+1, line.len)
			if j == line.len or line[j] < "0" or line[j] > "9" then break
		end for
		isPartNumber = false
		for x in range(i-1, j)
			for y in range(lineNum-1, lineNum+1)
				if symbolAt(y,x) == "*" then
					nums = gears.get([y,x], [])
					nums.push line[i:j].val
					gears[[y,x]] = nums
					print "Found " + line[i:j] + " for gear at " + [y,x]
				end if
			end for
		end for
		i = j
	end while
end for

for kv in gears
	if kv.value.len == 2 then resultB.push kv.value.product	
end for

print "final answer (part B): " + resultB.sum
