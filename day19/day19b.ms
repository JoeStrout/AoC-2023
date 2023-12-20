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

// This time define a part as a RANGE of possible values
// for x, m, a, and s.  We'll split those on each condition
// and work them through until they get to a reject state.
PartRange = {}
PartRange.x = [1,4000]
PartRange.m = [1,4000]
PartRange.a = [1,4000]
PartRange.s = [1,4000]

PartRange.clone = function
	pr = new PartRange
	for field in "xmas"
		pr[field] = self[field][:]
	end for
	return pr
end function

// Each such range-part represents this many combinations:
PartRange.combos = function
	return (self.x[1] - self.x[0] + 1) *
		   (self.m[1] - self.m[0] + 1) *
		   (self.a[1] - self.a[0] + 1) *
		   (self.s[1] - self.s[0] + 1)
end function

// Report whether all the ranges on this range-self are still valid
PartRange.valid = function
	for field in "xmas"
		if self[field][0] > self[field][1] then return false
	end for
	return true
end function

PartRange.str = function
	result = []
	for field in "xmas"
		result.push field + ":" + self[field][0] + "-" + self[field][1]
	end for
	return result.join("; ")
end function

acceptedRanges = []
toDo = [ [PartRange.clone, "in"] ]
while toDo
	item = toDo.pop
	part = item[0]
	if item[1] == "A" then
		print "Accepted: " + part.str
		acceptedRanges.push part
		resultB.push part.combos
		continue
	else if item[1] == "R" then
		continue
	end if
	wf = workflows[item[1]]
	for rule in wf.rules
		if rule.condition == null then
			// no condition; this whole part range is accepted,
			// or rejected, or goes on to another workflow
			toDo.push [part, rule.result]
		else
			// a condition: split this part into the subset
			// to which the condition applies, and push that
			// onto our toDo list, continuing with the next rule
			// for the subset where it doesn't apply.
			newPart = part.clone
			if rule.condition.op == "<" then
				newPart[rule.condition.field][1] = rule.condition.value - 1
				part[rule.condition.field][0] = rule.condition.value
			else
				newPart[rule.condition.field][0] = rule.condition.value +1
				part[rule.condition.field][1] = rule.condition.value
			end if
//			print "Split by " + rule.condition + " into: "
//			print "   newPart: " + newPart
//			print "      part: " + part
			if newPart.valid then toDo.push [newPart, rule.result]
			if not part.valid then break
		end if
	end for
end while

print "final answer (part B): " + resultB.sum
