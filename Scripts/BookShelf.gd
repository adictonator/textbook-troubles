extends StaticBody

export var genre: String = 'Action'
export var color: Color = '#b20000'

# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func interact(player) -> void:
	var book = player.carried_object
	# Check if player is carrying anything.
	if book != null:

		# Match book and bookshelf genre.
		if book.genre == genre:
			book.placed()
		else:
			player.frustrate()
			player.get_node('error').set_text('chal lavde')


		# player places the book here
		# the book gets removed from the scene

	# book gets removed from the hud
	# player gets point?
	print('inetereacted', player)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass


func _onPlayerEntered(body:Node) -> void:
	print('c', body)
