static func _secondsToMinutes(seconds: int) -> Array:
	var sec = seconds % 60
	var minutes = (seconds / 60) % 60

	return [ minutes, sec ]