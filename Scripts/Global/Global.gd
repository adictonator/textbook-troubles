extends Node

const XP_TABLE = {
	'0': {
		'xp': 50,
		'coins': 20,
		'holdCap': 2,
		'time': 120,
	},
	'1': {
		'xp': 90,
		'coins': 25,
		'holdCap': 2,
		'time': 140,
	},
}

var playerLevel = 0
var playerXP = 0
var booksCarrying = []
var instancedShelves = []
var selectorIndex
var selectedBook
var selectedBookIdx = 0

func _ready() -> void:
	_getCurrentLevel()

func _getCurrentLevel():
	return XP_TABLE[str(playerLevel)]

func level():
	return _getCurrentLevel()

func getBookInHand():
	return booksCarrying[selectedBookIdx] if booksCarrying.size() > 0 else null
