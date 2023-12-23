// NOTE: First run part A (day22.ms)!

for idx in blocks.indexes
	b = blocks[idx]
	b.idx = idx
	b.remove "fallCount"
end for

Block.supports = []

Block.fallCount = function
	// create a "gone" set of block (indexes) that are
	// disintegrated or fallen; keep adding to this until
	// we can't find any more unsupported blocks.
	globals.gone = {self.idx:1}
	while true
		anyFell = false
		for b in blocks
			if gone.hasIndex(b.idx) then continue	// already gone
			if b.z.startVal < 1 then continue	// on the ground
			supported = false
			for bs in b.supportedBy
				if not gone.hasIndex(bs) then
					supported = true
					break
				end if
			end for
			if not supported then
				//print b.idx + " is not supported and falls"; key.get
				anyFell = true
				gone.push b.idx
			end if
		end for
		if not anyFell then break
	end while
	return gone.len - 1
end function

total = 0
for i in range(blocks.len - 1)
	f = blocks[i].fallCount
	total += f
	print i + ": " + f
end for
print total

// 94896: too high
// 11387: too low
