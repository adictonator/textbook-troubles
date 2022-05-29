extends RigidBody

export var genre: String = 'Action'
export var sprite: Texture
onready var bookshelves = get_viewport().get_node('Level/Bookshelves')
onready var hud = get_viewport().get_node('Level/HUD')
onready var booksCarrying = BooksCarrying.new(hud)
var holder
var picked_up
var ind

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if picked_up:
		set_global_transform(holder.get_node("Yaw/Camera/pickup_pos").get_global_transform())

func pick_up(player):
	holder = player

	if picked_up:
		leave()
	else:
		carry()

func leave():
	$CollisionShape.set_disabled(false)
	self.set_mode(0)
	picked_up = false

func carry():
	$CollisionShape.set_disabled(true)
	self.set_mode(1)
	picked_up = true
	ind = booksCarrying.updatePanel(sprite, genre)
	Global.booksCarrying.push_back(self)
	# jumble shelves here
	bookshelves.move()

func throw(power):
	Global.booksCarrying[Global.selectedBookIdx].queue_free()
	Global.booksCarrying.remove(Global.selectedBookIdx)
	apply_impulse(Vector3(), holder.look_vector * Vector3(power, power, power))
	leave()
	hud.removeBook(0)

	if hud.books.get_child_count() <= 0:
		hud.get_node('BooksPanel').visible = false

func placed():
	Global.booksCarrying[Global.selectedBookIdx].queue_free()
	Global.booksCarrying.remove(Global.selectedBookIdx)
	#Global.selectedBookIdx = 0

	var rem = hud.removeBook(Global.selectedBookIdx)

	if rem > 0:
		booksCarrying.updateSiblings(0)
		leave()
		# give xp
		Global.playerXP += 5
	else:
		hud.get_node('BooksPanel').visible = false
