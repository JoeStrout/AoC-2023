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
splitPos = lines.indexOf("")
workflowLines = lines[:splitPos]
partLines = lines[splitPos+1:]

Rule = {}
Rule.condition = null
Rule.result = ""
Rule.make = function(s)
	r = new Rule
	fields = s.split(":")
	if fields.len == 1 then
		r.result = s
	else
		r.condition = {
			"field":fields[0][0],
			"op":fields[0][1],
			"value":fields[0][2:].val }
		r.result = fields[1]
	end if
	return r
end function
Rule.appliesTo = function(part)
	if self.condition == null then return true
	if self.condition.op == ">" then
		return part[self.condition.field] > self.condition.value
	else if self.condition.op == "<" then
		return part[self.condition.field] < self.condition.value
	else
		print "Unknown operator"; exit
	end if
end function	

Workflow = {}
Workflow.make = function(line)
	p0 = line.indexOf("{")
	p1 = line.indexOf("}")
	wf = new Workflow
	wf.name = line[:p0]
	wf.rules = []
	for s in line[p0+1:p1].split(",")
		wf.rules.push Rule.make(s)
	end for
	return wf
end function

// Apply this workflow to the given part, and return the
// name of the resulting workflow or state
Workflow.flow = function(part)
	for r in self.rules
		if r.appliesTo(part) then return r.result
	end for
	print "wtf?"; exit
end function

workflows = {}
for line in workflowLines
	wf = Workflow.make(line)
	workflows[wf.name] = wf
end for

parts = []
for line in partLines
	parts.push line[1:-1].match("x={x},m={m},a={a},s={s}")
	parts[-1].applyToValues @val
end for

for part in parts
	curWf = "in"
	while true
		curWf = workflows[curWf].flow(part)
		if curWf == "A" then
			print "ACCEPTED"
			resultA.push part.values.sum
			break
		else if curWf == "R" then
			print "rejected"
			break
		end if
	end while
end for

print "final answer (part A): " + resultA.sum
