extends Node

class_name Books
var random = RandomNumberGenerator.new()
var bookScene = preload("res://Scenes/Book.tscn")

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

func _init() -> void:
	random.randomize()
	generateBook()

func generateBook():
	var genreIdx = random.randi_range(0, Genres.size() - 1)
	var newBook = bookScene.instance()
	newBook.genre = Genres[genreIdx]

	# @todo: change book texture and color based on their genre.
	return newBook

func generateBooks():
	for _i in range(Genres.size()):
		generateBook()
