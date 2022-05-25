extends RigidBody

export var genre: String = 'Action'
export var sprite: Texture
onready var hhh = get_viewport().get_node('Level/HUD')
var holder
var picked_up
var ind

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
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
	holder.carried_object = null
	self.set_mode(0)
	picked_up = false
	hhh.removeBook(ind)

func carry():
	$CollisionShape.set_disabled(true)
	holder.carried_object.push_back(self)
	self.set_mode(1)
	picked_up = true
	ind = hhh.updatePanel(sprite)

func throw(power):
	leave()
	apply_impulse(Vector3(), holder.look_vector * Vector3(power, power, power))

func placed():
	leave()
	queue_free()
