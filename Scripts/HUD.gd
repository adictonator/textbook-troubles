extends CanvasLayer

onready var level = get_viewport().get_node('Level')
onready var levelTimer = level.get_node('Timer')
onready var player = get_node('../Player')
onready var frustoHeads = $Stats/FrustoHeads
#onready var timer = $Stats/Timer
onready var books = $BooksPanel/Wrapper
onready var frustoMeter = $FrustoMeter
onready var xpBar = $"Stats/XP&Coins/XPWrapper/XPBar"

func _ready() -> void:
	#timer.set_text(str(levelTimer.get_time_left()))
	frustoMeter.set_value(player.frustoValue)
	xpBar.set_value(player.xp)

func _process(_delta) -> void:
	#timer.set_text(str(levelTimer.get_time_left()))
	xpBar.set_value(player.xp)

	if player.frustoValue >= 100:
		player.frustoValue = 0
		frustoHeads.get_child(frustoHeads.get_child_count()-1).queue_free()
		player.xp -= 10
	else:
		frustoMeter.set_value(player.frustoValue)

func updatePanel(tt) -> int:
	var b = TextureRect.new()
	b.set_texture(tt)
	books.add_child(b)
	return b.get_index()

func removeBook(idx) -> void:
	var f =books.get_child(idx)
	f.queue_free()
