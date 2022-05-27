static func _secondsToMinutes(seconds) -> Array:
	var sec = seconds % 60
	var minutes = (seconds / 60) % 60

	return [ minutes, sec ]