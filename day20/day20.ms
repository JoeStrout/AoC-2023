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

Module = {}
Module.inputs = null		// list of input module names
Module.outputs = null		// list of output module names
Module.init = function
	for outname in self.outputs
		if not modules.hasIndex(outname) then modules[outname] = new Module
		outm = modules[outname]
		if outm.inputs == null then outm.inputs = []
		outm.inputs.push self.name
	end for
end function
Module.sendPulse = function(high)
	for outname in self.outputs
		sendPulse self.name, high, outname
	end for
end function
Module.handlePulse = function(sender, high)
	self.sendPulse high
end function

FlipFlop = new Module
FlipFlop.isOn = false
FlipFlop.handlePulse = function(sender, high)
	if high then return
	self.isOn = not self.isOn
	self.sendPulse self.isOn
end function

Conjunction = new Module
Conjunction.memory = null	// key: input module name; value: last pulse value received
Conjunction.init = function
	super.init
	self.memory = {}
end function
Conjunction.handlePulse = function(sender, high)
	self.memory[sender] = high
	allHigh = true
	for inp in self.inputs
		if not self.memory.get(inp, 0) then; allHigh = false; break; end if
	end for
	self.sendPulse not allHigh
end function

modules = {}
for line in lines
	parts = line.split(" -> ")
	name = parts[0]; outputs = parts[1]
	if name[0] == "%" then
		m = new FlipFlop
		name = name[1:]
	else if name[0] == "&" then
		m = new Conjunction
		name = name[1:]
	else
		m = new Module
	end if
	m.name = name
	m.outputs = outputs.split(", ")
	modules[m.name] = m
end for
for m in modules.values
	m.init
end for

totalHighCount = 0
totalLowCount = 0
pendingPulses = []
sendPulse = function(senderName, high, destName)
	//print senderName + " -" + ["low","high"][high] + "-> " + destName
	pendingPulses.push [senderName, high, destName]
	if high then globals.totalHighCount += 1 else globals.totalLowCount += 1
end function

process = function
	while pendingPulses
		p = pendingPulses.pull
		modules[p[2]].handlePulse p[0], p[1]
	end while
end function

pushButton = function
	sendPulse "button", 0, "broadcaster"
	process
end function

for i in range(1,1000)
	pushButton
end for

print "total high pulses: " + totalHighCount
print "total low pulses:  " + totalLowCount
print "final answer (part A): " + totalHighCount * totalLowCount
