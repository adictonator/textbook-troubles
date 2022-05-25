extends StaticBody

var p
var bookScene = preload("res://Scenes/Book.tscn")
var book
var h = Books.new()
func _ready() -> void:
	#p = get_parent()
	var g = h.generateBook()
	print('xxss', g)
	# generate a couple of books classes randomly
	# let's generate 10 books for first level

	add_child(g)

		#pass
		#b.mode = 2
		#b.gravity_scale = 0
		#b.set_translation(Vector3(1, 5, 1))

func _process(_d) -> void:
	pass

