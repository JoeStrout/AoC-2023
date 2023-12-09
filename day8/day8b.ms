import "stringUtil"
import "mapUtil"
import "listUtil"
import "mathUtil"
import "aoc"

resultA = []
resultB = []

if 0 then fname = "input.txt" else fname = "example.txt"
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

done = function
	for node in at; if node[-1] != "Z" then return false; end for
	return true
end function

step = 0
while step < 20 //not done
	print "step " + step + " (" + (step%directions.len) + "): " + at
	dir = directions[step % directions.len]
	for i in at.indexes
		at[i] = nodes[at[i]][dir == "R"]
	end for
	step += 1
	if step % 100000 == 0 then print step + "..."
end while
print "step " + step + " (" + (step%directions.len) + "): " + at

print "final answer (part B): " + step
