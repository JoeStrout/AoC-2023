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

maps = []

for line in lines
	if line.startsWith("seeds: ") then
		seeds = line.split(": ")[1].split
		seeds.apply(@val)
		print "seeds: " + seeds
		continue
	end if
	if line.endsWith("map:") then
		curMap = []	// list of remapped ranges
		maps.push curMap
	else if line then
		m = line.match("{dest} {src} {count}")
		m.applyToValues @val
		curMap.push m
	end if
end for


for seed in seeds
	print "Seed " + seed, "..."
	num = seed
	for m in maps
		for rmr in m
			if rmr.src <= num < rmr.src + rmr.count then
				num = rmr.dest + num - rmr.src
				break
			end if
		end for
		print ".", ""
//		print "  --> " + num
	end for
	print
	print "Seed " + seed + " -> location " + num
	resultA.push num
end for

print "final answer (part A): " + resultA.min
print "final answer (part B): " + resultB.sum
// Also available: list.min, list.max, list.mean