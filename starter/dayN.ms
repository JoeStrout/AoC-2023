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

p = aoc.LineParser.make(lines)
while not p.atEnd
	foo = p.get("{}items: {list}")
end while

//for line in lines
//	m = line.match("{p1},{p2}")
//	if not m then
//		print "Pattern did not match on line: " + line
//		continue
//	end if
//	span1 = Span.make(m.p1)
//	span2 = Span.make(m.p2)
//
//	valueA = null	
//	valueB = null
//	
//	print m + ": " + valueA + ", " + valueB
//	resultA.push valueA
//	resultB.push valueB
//end for

print "final answer (part A): " + resultA.sum
print "final answer (part B): " + resultB.sum
// Also available: list.min, list.max, list.mean