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

Block = {}
Block.supportedBy = null
Block.supports = null
blocks = []
Block.overlaps = function(other)
	// this block overlaps the other if it overlaps in
	// all three (X,Y,Z) spans
	return self.x.overlaps(other.x) and self.y.overlaps(other.y) and self.z.overlaps(other.z)
end function
Block.settle = function
	selfi = blocks.indexOf(self)
	while self.z.startVal >= 0
		supportBlocks = []
		self.z.shift -1
		for i in range(selfi - 1, 0, -1)
			if self.overlaps(blocks[i]) then supportBlocks.push i
			//if blocks[i].maxz < self.z.startVal then break
		end for
		if supportBlocks then break
	end while
	self.supportedBy = supportBlocks
	for idx in supportBlocks
		b = blocks[idx]
		if b.supports == null then b.supports = []
		b.supports.push selfi
	end for
	self.z.shift 1
	self.maxz = self.z.endVal
end function

lineNum = 0
for line in lines
	m = line.match("{x1},{y1},{z1}~{x2},{y2},{z2}")
	if not m then
		print "Pattern did not match on line: " + line
		continue
	end if
	m.applyToValues @val
	b = new Block
	b.x = Span.make(m.x1, m.x2)
	b.y = Span.make(m.y1, m.y2)
	b.z = Span.make(m.z1, m.z2)
	b.maxz = b.z.endVal
	b.lineNum = lineNum
	blocks.push b
	lineNum += 1
end for
blocks.sort "maxz"

print "Settling blocks"
for i in range(0, blocks.len-1)
	if i % 100 == 0 then print i + " / " + blocks.len + "..."
	blocks[i].settle
end for

print "Finding blocks to disintegrate"
for b in blocks
	ok = true
	for otherIdx in b.supports
		if blocks[otherIdx].supportedBy.len == 1 then ok = false
	end for
	if ok then print "   line " + b.lineNum + " can"
	if ok then resultA.push b.lineNum
end for

print "final answer (part A): " + resultA.len
