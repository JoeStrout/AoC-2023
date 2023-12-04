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

copies = {}	// key: card ID; value: how many copies of this card we have

for line in lines
	m = line.match("Card {num}: {winningNumbers} | {myNumbers}")
	if not m then
		print "Pattern did not match on line: " + line
		continue
	end if
	cardID = m.num.trim.val
	copies[cardID] = copies.get(cardID,0) + 1
	winNums = m.winningNumbers.split.filtered(@nonEmptyString)
	winNums.apply(@val)
	myNums = m.myNumbers.split.filtered(@nonEmptyString)
	myNums.apply(@val)
	matches = 0
	for n in myNums
		if winNums.contains(n) then matches += 1
	end for
	print "Card " + cardID + " has " + matches + " winning numbers"
	for i in range(cardID + 1, cardID + matches, 1)
		copies[i] = copies.get(i, 0) + copies[cardID]
		print "   ...so we now have " + copies[i] + " of card " + copies[i]
	end for
end for

resultA = copies.values

print "final answer (part A): " + resultA.sum
print "final answer (part B): " + resultB.sum
// Also available: list.min, list.max, list.mean