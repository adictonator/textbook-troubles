extends StaticBody

export var genre: String = 'Action'
export var color: Color = '#b20000'

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func interact(player) -> void:
	var book = Global.getBookInHand()
	# Check if player is carrying anything.
	if book != null:
		# Match book and bookshelf genre.
		if book.genre == genre:
			book.placed()
		else:
			player.frustrate()
			player.showErrorMessage('This book doesn\'t belong here!')

