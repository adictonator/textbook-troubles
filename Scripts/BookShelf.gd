extends StaticBody

export var genre: String = 'Action'
export var color: Color = '#b20000'

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

