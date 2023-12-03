import "stringUtil"
import "mapUtil"
import "listUtil"
import "mathUtil"
import "aoc"

resultA = []

if 0 then fname = "input.txt" else fname = "example.txt"
lines = file.readLines(fname)
if lines == null then
	print "Unable to read: " + fname
	exit
end if
if not lines[-1] then lines.pop

symbolAt = function(row, column)
	if row < 0 or row >= lines.len then return false
	line = lines[row]
	if column < 0 or column >= line.len then return false
	c = line[column]
	if ("0" <= c <= "9") or c == "." then return false
	return true
end function

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
				if symbolAt(y,x) then
					isPartNumber = true
				else
					//print "Not a symbol at " + x+","+y
				end if
			end for
		end for
		print "Found " + line[i:j] + " in " + line + " part num: " + isPartNumber
		if isPartNumber then resultA.push line[i:j].val
		i = j
	end while
end for

print "final answer (part A): " + resultA.sum
