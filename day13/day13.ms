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

symmetryRow = function(chart)
	for row in range(1, chart.len-1)
		booYeah = true
		for i in range(1, min(row, chart.len-row))
			if chart[row-i] != chart[row+i-1] then
				//print "row " + row + " no good because " + (row-i) + " != " + (row+i-1)
				booYeah = false
				break
			end if
		end for
		if booYeah then return row
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
	symRow = symmetryRow(chart)
	chart.blockRotateCW
	symCol = symmetryRow(chart)
	print "row: " + symRow + "    col: " + symCol
	resultA.push symRow*100 + symCol
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

print "final answer (part A): " + resultA.sum
