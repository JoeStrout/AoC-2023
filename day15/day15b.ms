import "stringUtil"
import "mapUtil"
import "listUtil"
import "mathUtil"
import "aoc"

resultA = []
resultB = []

if 1 then fname = "input.txt" else fname = "example.txt"
data = file.readLines(fname)[0]

hash = function(s)
	result = 0
	for c in s
		result = ((result + c.code) * 17) % 256
	end for
	return result
end function

hashMap = [null] * 256	// index: label hash; value: list of labels, e.g. ["cm", "ab"]
focalLength = {}		// index: label, e.g. "cm"; value: focal length, e.g. 7

for item in data.split(",")
	if item[-1] == "-" then
		label = item[:-1]
		h = hash(label)
		if hashMap[h] isa list then hashMap[h].removeVal label
//		print "Removed " + label
	else
		parts = item.split("=")
		label = parts[0]
		focalLen = parts[1].val
		h = hash(label)
		if hashMap[h] == null then hashMap[h] = []
		if not hashMap[h].contains(label) then hashMap[h].push label
		focalLength[label] = focalLen
//		print "Put " + label + " in box " + h + " with focal length " + focalLen
	end if
end for

for boxNum in hashMap.indexes
	box = hashMap[boxNum]
	if box == null then continue
	for slotNum in box.indexes
		power = (boxNum+1) * (slotNum+1) * focalLength[box[slotNum]]
		resultB.push power
	end for
end for



// Visualization, just for fun:
draw = function
	clear
	for i in hashMap.indexes
		col = floor(i/64)
		row = i % 64
		x = col*244
		y = 629 - row*10
		if row % 2 then gfx.color = "#AAFFAA" else gfx.color = "#AAAAFF"
		lenses = []
		for item in hashMap[i]
			lenses.push item + "=" + focalLength[item]
		end for
		s = ("   " + i)[-3:] + ": " + lenses.join
		gfx.print s, x, y, gfx.color, "small"
	end for
end function
draw

key.get
text.row = 2
print "part B: "
print resultB.sum
