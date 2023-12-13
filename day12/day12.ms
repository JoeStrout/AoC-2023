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

string.compress = function(charToCompress=" ")
	s = self
	prevLen = -1
	charTimes2 = charToCompress + charToCompress
	while true
		s = s.replace(charTimes2, charToCompress)
		if s.len == prevLen then break
		prevLen = s.len
	end while
	return s
end function

measure = function(s)
	s = s.trim(".").compress(".")
	parts = s.split(".")
	parts.apply(@len)
	return parts.join(",")
end function

// Brute-force approach:		
waysToFit = function(s, expected)
	toDo = [s.trim(".").compress(".")]
	result = 0
	while toDo
		s = toDo.pull
		if not s.contains("?") then
			if measure(s) == expected then result += 1
		else
			toDo.push s.replace("?", ".", 1).trimLeft(".")
			toDo.push s.replace("?", "#", 1).trimLeft(".")
		end if			
	end while
	return result
end function


lineNum = 0
for line in lines
	parts = line.split
	if parts.len != 2 then continue
	resultA.push waysToFit(parts[0], parts[1])
	lineNum += 1
	print parts[0] + " fits " + parts[1] + " " + resultA[-1] + " ways (" + round(100*lineNum/lines.len) + "% done)"
end for

print "final answer (part A): " + resultA.sum
