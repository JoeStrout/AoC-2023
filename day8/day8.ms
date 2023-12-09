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

step = 0
at = "AAA"
while at != "ZZZ"
	dir = directions[step % directions.len]
	at = nodes[at][dir == "R"]
	step += 1
end while

print "final answer (part A): " + step
