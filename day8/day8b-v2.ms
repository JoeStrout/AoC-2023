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
directions = lines.pull
lines.pull	// (remove blank link)

nodes = {}	// key: "AAA"; value: ["BBB","CCC"]
for line in lines
	m = line.match("{node} = ({left}, {right})")
	if not m then
		print "Pattern did not match on line: " + line
		continue
	end if
	nodes[m.node] = [m.left, m.right]
end for

//pprint nodes

endsInA = function(s); return s[-1]=="A"; end function
at = nodes.indexes.filtered(@endsInA)
print "Starting at nodes: " + at

// Find how long each of our "ghosts" goes before repeating.
// We'll know they are repeating when they are at the same
// node, on the same point in the directions list.
// Return [start, length] of the repeat.
repeatStartAndLen = function(startNode)
	nodesAtStep = [null] * directions.len
	curNode = startNode
	step = 0
	globals.history = [startNode + "@0"]
	while true
		modStep = step % directions.len
		dir = directions[modStep]
		curNode = nodes[curNode][dir == "R"]
		//print "step " + step + " (" + modStep + "), at " + curNode
		key = curNode + "@" + modStep
		if curNode[-1] == "Z" then print key + "  (on actual step " + step + ")"
		if history.contains(key) then
			prevStep = history.indexOf(key)
			print "Hey, we were here (" + key + ") before on step " + prevStep
			history.push key
			print "Pushed " + key + " at " + history.len + "; returning"
			return [prevStep, step - prevStep + 1]
		end if
		history.push key
		step += 1
		//input
	end while
end function



for n in at
	print n + ": " + repeatStartAndLen(n)
end for
exit

// At this point, I took the cycle lengths printed above, ignored the offsets
// and just computed the Least Common Multiple of them.  That turned out to be
// the answer AoC was looking for.  :( 
//
// Apparently, this works because the input was carefully constructed in
// such a way that the distance from A->Z happens to be the same as the
// distance from Z->Z, and that cycle contains no other Z's.  So the
// initial offset doesn't matter, because it just so happens to jump
// into the middle of the "real" loop at just the right point that it's
// as if it started in the loop to begin with.  And that is what makes
// LCM work.  Blech.
