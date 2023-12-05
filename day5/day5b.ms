import "stringUtil"
import "mapUtil"
import "listUtil"
import "mathUtil"
import "aoc"

resultB = []

if 0 then fname = "input.txt" else fname = "example.txt"
lines = file.readLines(fname)
if lines == null then
	print "Unable to read: " + fname
	exit
end if
if not lines[-1] then lines.pop

maps = []

for line in lines
	if line.startsWith("seeds: ") then
		nums = line.split(": ")[1].split
		nums.apply(@val)
		seeds = []
		for i in range(0, nums.len-1, 2)
			seeds.push Span.makeStartCount(nums[i], nums[i+1])
		end for
		print "seeds: " + seeds
		continue
	end if
	if line.endsWith("map:") then
		curMap = []	// list of remapped ranges
		maps.push curMap
	else if line then
		m = line.match("{dest} {src} {count}")
		m.applyToValues @val
		m.span = Span.makeStartCount(m.src, m.count)
		m.delta = m.dest - m.src
		curMap.push m
	end if
end for

Span.didShift = false
Span.shifted = function(delta)
	result = Span.make(self.startVal + delta, self.endVal + delta)
	result.didShift = true
	return result
end function

applyRemappedRange = function(span, m)
	globals.span = span
	globals.m = m
	if not m.span.overlaps(span) then
		// input span isn't affected by the shifting range at all
		result = [span]
	else if m.span.contains(span) then
		// shifting range entirely contains the input span, so it all shifts
		result = [span.shifted(m.delta)]
	else if span.contains(m.span) then
		// input span entirely contains the shifting range, so we'll
		// have up to 3 output spans (1 of these shifting)
		result = []
		if span.startVal < m.span.startVal then
			result.push Span.make(span.startVal, m.span.startVal-1)
		end if
		result.push	m.span.shifted(m.delta)
		if m.span.endVal+1 <= span.endVal then
			result.push Span.make(m.span.endVal+1, span.endVal)
		end if
	else if span.startVal < m.span.startVal then
		// input span overlaps the shifting span on the left
		result = []
		if span.startVal <= m.span.startVal-1 then
			result.push Span.make(span.startVal, m.span.startVal-1)
		end if
		result.push	Span.make(m.span.startVal, span.endVal).shifted(m.delta)
	else
		// input span overlaps the shifting span on the right
		result = []
		result.push Span.make(span.startVal, m.span.endVal).shifted(m.delta)
		if m.span.endVal+1 <= span.endVal then		
			result.push Span.make(m.span.endVal+1, span.endVal)
		end if
	end if
	return result
end function

Span.count = function; return self.endVal - self.startVal + 1; end function

joinSpans = function(spanList, delimiter=" ")
	result = []
	for item in spanList; result.push item.str; end for
	return result.join(delimiter)
end function

minStartVal = function(spanList)
	result = []
	for item in spanList; result.push item.startVal; end for
	return result.min
end function

for seedRange in seeds
	print
	print "Seeds " + seedRange.str, "..."
	ranges = [seedRange]
	for m in maps		
		for rmr in m
			nextStepRanges = []
			for span in ranges
				if span.didShift then
					nextStepRanges.push span
					continue
				end if
				remapped = applyRemappedRange(span, rmr)
				nextStepRanges += remapped
			end for
			ranges = nextStepRanges
		end for
		// clear the "did shift" flags for the next map
		for item in ranges; item.didShift = false; end for
	end for
	
	print " plant at " + joinSpans(ranges, ", ")
	print " with a min start at " + minStartVal(ranges)

	for span in ranges
		resultB.push span.startVal
	end for
end for
print

print "final answer (part B): " + resultB.min
