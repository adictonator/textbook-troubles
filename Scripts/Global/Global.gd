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

func _ready() -> void:
	_getCurrentLevel()

func _getCurrentLevel():
	#print('xx', XP_TABLE[str(playerLevel)])
	return XP_TABLE[str(playerLevel)]

func level():
	#pass
	return _getCurrentLevel()
