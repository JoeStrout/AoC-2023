import "stringUtil"
import "mapUtil"
import "listUtil"
import "mathUtil"
import "qa"
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

actual = {}
actual.red = 12
actual.green = 13
actual.blue = 14

for line in lines
	minVal = {"red":0, "green":0, "blue":0}
	m = line.match("Game {id}: {rest}")
	id = m.id.val
	possible = true
	for game in m.rest.split("; ")
		obs = game.split(", ")	// observation, e.g. ["1 red", "3 blue"]
		//print "game " + id + ": " + obs
		for ob in obs
			parts = ob.split(" ")	// ["1", "red"]
			count = parts[0].val
			color = parts[1]
			if count > actual[color] then possible = false
			minVal[color] = max(minVal[color], count)
		end for
	end for
	if possible then valueA = id else valueA = 0
	print minVal
	valueB = minVal.red * minVal.green * minVal.blue
	print valueB

	resultA.push valueA
	resultB.push valueB
end for

print "final answer (part A): " + resultA.sum
print "final answer (part B): " + resultB.sum
// Also available: list.min, list.max, list.mean