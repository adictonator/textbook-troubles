extends Control

const Util = preload('Utility/Utility.gd')
var minutes: int = 0
var seconds: int = 0
var dseconds = 0

func _ready() -> void:
	var time = Util._secondsToMinutes(Global.level().time)
	minutes = time[0]
	seconds = time[1]

func _physics_process(delta: float) -> void:
	if seconds > 0 && dseconds <= 0:
		seconds -= 1
		dseconds = 10

	if minutes > 0 && seconds <= 0:
		minutes -= 1
		seconds = 60

	if seconds >= 10:
		$Sec.set_text(str(seconds))
	else:
		$Sec.set_text('0' + str(seconds))

	if dseconds >= 10:
		$dSec.set_text(str(dseconds))
	else:
		$dSec.set_text('0' + str(dseconds))

	if minutes >= 10:
		$Min.set_text(str(minutes))
	else:
		$Min.set_text('0' + str(minutes))

func _on_Timer_timeout() -> void:
	dseconds -= 1
