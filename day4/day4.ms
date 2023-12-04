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

nonEmptyString = function(s)
	return s != ""
end function

for line in lines
	m = line.match("Card {num}: {winningNumbers} | {myNumbers}")
	if not m then
		print "Pattern did not match on line: " + line
		continue
	end if
	winNums = m.winningNumbers.split.filtered(@nonEmptyString)
	winNums.apply(@val)
	myNums = m.myNumbers.split.filtered(@nonEmptyString)
	myNums.apply(@val)
	cardValue = 0
	for n in myNums
		if winNums.contains(n) then
			if cardValue == 0 then cardValue = 1 else cardValue *= 2
		end if
	end for
	
	resultA.push cardValue
end for

print "final answer (part A): " + resultA.sum
print "final answer (part B): " + resultB.sum
// Also available: list.min, list.max, list.mean