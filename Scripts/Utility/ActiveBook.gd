extends Node
#extends RigidBody
class_name BooksCarrying

var selector
var selectorIndex
var genreLable
var wrapper

func _init(hud) -> void:
	setSelector()
	wrapper = hud.books

func controls() -> void:
	var left = Input.is_action_just_pressed('ui_left')
	var right = Input.is_action_just_pressed('ui_right')
	var newIdx

	if left:
		newIdx = getNextBookIndex('left')
		_moveSelector(newIdx)
	elif right:
		newIdx = getNextBookIndex('right')
		_moveSelector(newIdx)

func _moveSelector(newIdx):
	if newIdx >= wrapper.get_child_count():
		return

	_removeSelector()

	var old_t = wrapper.get_child(Global.selectedBookIdx)
	if old_t != null:
		old_t.self_modulate = Color(1,1,1, 0.58)
		updateSiblings(newIdx)

	Global.selectedBookIdx = newIdx

# Updating sibling books by reducing their alpha.
func updateSiblings(newIdx):
	var t = wrapper.get_child(newIdx)
	t.self_modulate = Color(1,1,1,1)
	setSelector()
	t.add_child(selector, true)

	Global.selectedBookIdx = 0
	Global.selectorIndex = selector.get_index()

func getNextBookIndex(direction: String):
	var newBookIndex

	match direction:
		'left':
			if Global.selectedBookIdx > 0:
				newBookIndex = Global.selectedBookIdx - 1
			else:
				newBookIndex = Global.selectedBookIdx
		'right':
			newBookIndex = Global.selectedBookIdx + 1

	# Also check if another book exists or not.
	return newBookIndex

func setSelector() -> void:
	selector = Panel.new()
	selector.set("custom_styles/panel", load('res://lol.tres'))
	selector.rect_min_size.x = 80
	selector.rect_min_size.y = 120

func getSelector() -> ColorRect:
	return selector

func setBookDetails(genre):
	genreLable = Label.new()
	genreLable.set_text(genre)
	return genreLable


func _removeSelector() -> void:
	# Remove the selector element from scene.
	var hasChild = wrapper.get_child(Global.selectedBookIdx)
	var t = hasChild.get_child(Global.selectorIndex)
	if hasChild != null:
		hasChild.remove_child(t)

func _setBookTextureArea(bookTexture: Texture):
	var b = TextureRect.new()
	b.rect_min_size.x = 80
	b.set_expand(true)
	b.set_texture(bookTexture)

	return b

func _getBookTextureArea(bookTexture: Texture):
	return bookTexture

func updatePanel(bookTexture: Texture, genre: String):
	var texture = _setBookTextureArea(bookTexture)
	var bookDetals = setBookDetails(genre)

	if wrapper.get_child_count() <= 0:
		# Add selector frame as a child of first book texture.
		texture.add_child(selector, true)
		Global.selectorIndex = selector.get_index()
		#selector.set_owner(texture)
	else:
		texture.self_modulate = Color(1,1,1, 0.58)

	texture.add_child(bookDetals)
	wrapper.add_child(texture)

	return texture.get_index()
