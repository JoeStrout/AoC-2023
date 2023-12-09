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

hands = []
bids = {}		// key: hand; value: bid

for line in lines
	fields = line.split
	hands.push fields[0]
	bids[fields[0]] = fields[1].val
end for

// return 7 for strongest type (5 of a kind), 1 for weakest  (high card)
handType = function(hand)
	sets = {}
	for c in hand
		if c == "J" then continue	// skip jokers
		sets[c] = sets.get(c, 0) + 1
	end for
	if sets.len <= 1 then return 7	// 5 of a kind
	setKeys = sets.indexes
	setValues = sets.values
	jokers = 5 - setValues.sum
	if sets.len == 2 then
		if setValues[0]+jokers >= 4 or setValues[1]+jokers >= 4 then return 6	// 4 of a kind
		return 5	// full house
	end if
	for v in setValues
		if v + jokers >= 3 then return 4	// 3 of a kind
	end for
	if sets.len == 3 then return 3	// two pair
	if sets.len == 4 then return 2	// one pair
	return 1	// high card
end function

cardOrder = "A, K, Q, T, 9, 8, 7, 6, 5, 4, 3, 2, J".split(", ")

compareHands = function(hand1, hand2)
	typeDiff = handType(hand1) - handType(hand2)
	if typeDiff then return typeDiff
	for i in hand1.indexes
		idx1 = cardOrder.indexOf(hand1[i])
		idx2 = cardOrder.indexOf(hand2[i])
		if idx1 < idx2 then return 1
		if idx1 > idx2 then return -1
	end for
	return 0
end function

hands.sortWithFunction @compareHands

//pprint hands

for i in hands.indexes
	resultB.push (i+1) * bids[hands[i]]
end for

debugOut = []
typeNames = ["-", "1 Pair", "2 Pair", "3 of a Kind", "Full House", "4 of a Kind", "5 of a Kind"]
for h in hands
	debugOut.push h + ": " + handType(h) + " " + typeNames[handType(h)-1] + "   ***" * h.contains("J")
end for
pageThrough debugOut


print "final answer (part B): " + resultB.sum
// Also available: list.min, list.max, list.mean

// 247563175 is too high
// 247171022 still too high :(
// 246894760