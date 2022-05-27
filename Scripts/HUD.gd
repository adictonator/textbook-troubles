extends CanvasLayer

onready var level = get_viewport().get_node('Level')
onready var levelTimer = level.get_node('Timer')
onready var player = get_node('../Player')
onready var frustoHeads = $Stats/FrustoHeads
onready var books = $BooksPanel/Wrapper
onready var frustoMeter = $FrustoMeter
onready var xpBar = $"Stats/XP&Coins/XPWrapper/XPBar"
onready var booksCarrying = BooksCarrying.new(self)

func _ready() -> void:
	frustoMeter.set_value(player.frustoValue)
	xpBar.set_max(Global.level().xp)
	xpBar.set_value(Global.playerXP)

func _process(_delta) -> void:
	xpBar.set_value(Global.playerXP)

	booksCarrying.controls()

	if player.frustoValue >= 100:
		player.frustoValue = 0
		frustoHeads.get_child(frustoHeads.get_child_count()-1).queue_free()
		player.xp -= 10
	else:
		frustoMeter.set_value(player.frustoValue)

func removeBook(idx) -> int:
	var f = books.get_child(idx)
	if f != null:
		books.remove_child(f)

	return books.get_child_count()
