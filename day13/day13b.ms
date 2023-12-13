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

almostSymmetryRow = function(chart)
	for row in range(1, chart.len-1)
		// we're looking for a *single* pair of rows that does not match
		nonMatch = null
		tooMany = false
		for i in range(1, min(row, chart.len-row))
			if chart[row-i] != chart[row+i-1] then
				//print "row " + row + " has " + (row-i) + " != " + (row+i-1)
				if nonMatch == null then
					nonMatch = i
				else
					// ...if we find more than one, then this is not almost symmetric
					tooMany = true
					break
				end if
			end if
		end for
		if nonMatch == null or tooMany then continue
		// now, see if the two rows differ by only 1 change
		if chart[row-nonMatch].editDistance(chart[row+nonMatch-1]) == 1 then
			// Huzzah!
			return row
		end if
	end for
	return 0
end function

pchart = function(chart)
	if chart == null then chart = outer.chart
	for i in chart.indexes
		print i + " "*(i<10) + "   " + chart[i]
	end for
end function

processChart = function
	print "Chart " + chartNum + ": ", ""
	symRow = almostSymmetryRow(chart)
	chart.blockRotateCW
	symCol = almostSymmetryRow(chart)
	print "row: " + symRow + "    col: " + symCol
	resultB.push symRow*100 + symCol
	if not symRow and not symCol then exit
end function

chart = []
chartNum = 1
for line in lines
	if not line then
		processChart
		chart = []
		chartNum += 1
	else
		chart.push line
	end if
end for	
if chart then processChart

print "final answer (part B): " + resultB.sum
