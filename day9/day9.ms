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

list.allSame = function
	if self.len < 2 then return true
	for i in range(1, self.len-1)
		if self[i] != self[0] then return false
	end for
	return true
end function

extrapolate = function(nums)
	if nums.allSame then return nums[0]
	diffs = []
	for i in range(1, nums.len-1)
		diffs.push nums[i] - nums[i-1]
	end for
	nextDiff = extrapolate(diffs)
	return nums[-1] + nextDiff
end function

extrapolateBackwards = function(nums)
	if nums.allSame then return nums[0]
	diffs = []
	for i in range(1, nums.len-1)
		diffs.push nums[i] - nums[i-1]
	end for
	prevDiff = extrapolateBackwards(diffs)
	return nums[0] - prevDiff
end function

for line in lines
	nums = line.split
	nums.apply(@val)
	nextNum = extrapolate(nums)
	prevNum = extrapolateBackwards(nums)
	print prevNum + " -> " + nums + " -> " + nextNum
	resultA.push nextNum
	resultB.push prevNum
end for


print "final answer (part A): " + resultA.sum
print "final answer (part B): " + resultB.sum
// Also available: list.min, list.max, list.mean