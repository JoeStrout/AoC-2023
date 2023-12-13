import "stringUtil"
import "mapUtil"
import "listUtil"
import "mathUtil"
import "aoc"
import "qa"

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

string.lastIndexOf = function(substr)
	sslen = substr.len
	i = self.len - sslen
	while i >= 0
		if self[i:i+sslen] == substr then return i
		i -= 1
	end while
	return null
end function

measure = function(s)
	s = s.trim(".").compress(".")
	parts = s.split(".")
	parts.apply(@len)
	return parts
end function

partiallyFits = function(s, expected)
//	print "partiallyFits(" + s + ", " + expected + ")"
	qpos = s.indexOf("?")
	if qpos == null then return measure(s) == expected
	if qpos > 0 then
		leftPart = s[:qpos]
		actual = measure(leftPart)
		alen = actual.len
//		print "leftPart: " + leftPart + " -> " + actual + "; expected: " + expected
		if alen > expected.len then return false
		if leftPart[-1] == "." then
			if actual != expected[:alen] then return false
		else
			if actual[:alen-1] != expected[:alen-1] then return false
			if actual[alen-1] > expected[alen-1] then return false
		end if
	end if
	qpos = s.lastIndexOf("?")
	if qpos < s.len-1 then
		rightPart = s[qpos+1:]
		actual = measure(rightPart)
//		print "rightPart: " + rightPart + " -> " + actual + "; expected: " + expected
		alen = actual.len
		if alen > expected.len then return false
		if rightPart[0] == "." then
			if actual != expected[-alen:] then return false
		else
			if alen > 1 and actual[1:] != expected[-(alen-1):] then return false
			if actual[0] > expected[-alen] then return false
		end if
	end if
//	print "...Looks good!"
	return true
end function

runTests = function
	qa.assert partiallyFits("#??.###", [1,1,3])
	qa.assert partiallyFits("#??.###", [2,3])
	qa.assert partiallyFits("#.?.###", [1,1,3])
	qa.assert partiallyFits("#.?.#?#", [1,1,3])
	qa.assert partiallyFits("#??.?##", [2,3])
	qa.assert partiallyFits("#??.???", [2,3])
	qa.assert not partiallyFits("#.?##", [2,3])
	qa.assert not partiallyFits("#??.?.#", [2,3])	
end function
runTests

unfold = function(parts)
	parts[0] = (parts[0]+"?") * 5 - "?"
	parts[1] = (parts[1]+",") * 5 - ","
end function

// Fancier approach:
waysToFit = function(s, expected, memo)
	if memo == null then memo = {}
	if memo.hasIndex(s) then return memo[s]
	if debug then print "waysToFit(" + s + ", )"
	s = s.trim(".").compress(".")
	if not s.contains("?") then return measure(s) == expected
	result = 0
	
	optA = s.replace("?", ".", 1)
	if partiallyFits(optA, expected) then
		result += waysToFit(optA, expected, memo)
	end if
	
	optB = s.replace("?", "#", 1)
	if partiallyFits(optB, expected) then
		result += waysToFit(optB, expected, memo)
	end if
	
	if debug then print "waysToFit(" + s + ", ) --> " + result
	memo[s] = result
	return result	
end function

debug = false
lineNum = 0
for line in lines
	parts = line.split
	if parts.len != 2 then continue
	unfold parts
	expected = parts[1].split(",")
	expected.apply(@val)
	resultB.push waysToFit(parts[0], expected)
	lineNum += 1
	print "Line " + lineNum + " fits " + parts[1] + " " + resultB[-1] + " ways (" + round(100*lineNum/lines.len) + "% done)"
end for

print "final answer (part B): " + resultB.sum
// Also available: list.min, list.max, list.mean