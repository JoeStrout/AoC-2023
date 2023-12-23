import "inspectDialog"

inspect = function(value)
	dlog = inspectDialog.InspectDialog.make(@value)
	btn = dlog.show
	return @btn.payload
end function

_savedGlobals.inspectDialog = inspectDialog
_savedGlobals.inspect = @inspect
