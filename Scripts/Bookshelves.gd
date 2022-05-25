extends Spatial

class_name Bookshelves
var random = RandomNumberGenerator.new()
var bookshelf = preload('res://Scenes/Bookshelf.tscn')

const Genres = [
	'Action',
	'Thriller',
	'Comedy',
	'Romance',
	'Horror',
	'Drama',
	'Fiction',
	'Fanatsy'
]
var pervMesh
var checkShelves = []
var p
func _ready() -> void:
	p = self
	some()

func _init() -> void:
	pass

func generateBook(i):
	var genreIdx = random.randi_range(0, Genres.size() - 1)
	var newShelf = bookshelf.instance()
	newShelf.genre = Genres[genreIdx]
	pervMesh = newShelf.get_node('Mesh').mesh.size
	newShelf.transform.origin = Vector3(i, 0, i) * pervMesh

	# @todo: change book texture and color based on their genre.
	return newShelf

func jumble(i):
	random.randomize()
	var g = generateBook(i)
	check(g.genre, g, i)

func some():
	for i in range(0, Genres.size()):
		jumble(i)


func check(genre: String, obj, i):
	if genre in checkShelves:
		jumble(i)
	else:
		pervMesh = obj.get_node('Mesh').mesh.size
		obj.transform.origin = Vector3(i, 0, i) * pervMesh
		checkShelves.push_back(genre)
		Global.instancedShelves.push_back(obj)
		add_child(obj)

func move():
	if Global.instancedShelves.size() <= 0:
		return

	for i in Global.instancedShelves.size():
		remove_child(Global.instancedShelves[i])
		Global.instancedShelves[i].queue_free()

	Global.instancedShelves = []
	checkShelves = []

	some()
