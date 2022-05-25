extends KinematicBody

const SPEED = 10
const GRAVITY = 8
var velocity = Vector3.ZERO
var booksHolding = 0



var carried_object = []
var throw_power = 0

var interactor = null

# this was supposedd to be for fall damage, not sure if works
var last_floor_height
var can_change_last_floor_height = true

# Movement
const IDLE = 0

const RUN = 1 # default movement
const SPRINT = 2
const WALK = 3

var movement_state = IDLE

const STAND = 0
const CROUCH = 1

var posture_state = STAND

var run_speed = 8
var sprint_speed = 10
var walk_speed = 2.7

var move_speed = run_speed

# Controls

var yaw = 0
var pitch = 0
var is_moving = false
var view_sensitivity = 0.15

var look_vector = Vector3()

# Physics
var gravity = -40

const ACCEL = 0.5
const DEACCEL = 0.8

const JUMP_STR = 15

# Ladder
var on_ladder = false
const LADDER_SPEED = 8
const LADDER_ACCEL = 2

#slope variables
const MAX_SLOPE_ANGLE = 60

#stair variables
const MAX_STAIR_SLOPE = 20
const STAIR_JUMP_HEIGHT = 6
const FRUSTO_VALUE = 20
var bookSprite
var frustoValue: int = 0
var xp: int = 60

var carryingBooks = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _process(d):

#######################################################################################################
# INTERACTIONS

	if $Yaw/Camera/InteractionRay.is_colliding():
		var x = $Yaw/Camera/InteractionRay.get_collider()
		if x.has_method("pick_up"):
			$interaction_text.set_text("[E]  Pick up: " + x.get_name())
		elif x.has_method("interact"):
			$interaction_text.set_text("[F]  Interact with: " + x.get_name() + ' --- ' + x.genre)
		else:
			$interaction_text.set_text("")
	else:
		$interaction_text.set_text("")


#######################################################################################################
# VECTOR 3 for where the player is currently looking

	var dir = (get_node("Yaw/Camera/look_at").get_global_transform().origin - get_node("Yaw/Camera").get_global_transform().origin).normalized()
	look_vector = dir

func _physics_process(delta: float) -> void:
	if on_ladder:
		pass
	#_process_on_ladder(delta)
	else:
		_process_movements(delta)
	#if Input.is_action_pressed('move_right'):
	#	velocity.x = SPEED
	#elif Input.is_action_pressed('move_left'):
	#	velocity.x = -SPEED
	#else:
	#	velocity.x = lerp(velocity.x, 0, 0.1)


	#if Input.is_action_pressed('move_forward'):
	#	velocity.z = -SPEED
	#elif Input.is_action_pressed('move_backward'):
	#	velocity.z = SPEED
	#else:
	#	velocity.z = lerp(velocity.z, 0, 0.1)

	#velocity = move_and_slide(velocity, Vector3.UP)
var direction = Vector3()
func _process_movements(delta):
	var up = Input.is_action_pressed("move_forward")
	var down = Input.is_action_pressed("move_backward")
	var left = Input.is_action_pressed("move_left")
	var right = Input.is_action_pressed("move_right")

	var sprint = Input.is_action_pressed("sprint")
	var walk = Input.is_action_pressed("walk")

	var aim = $Yaw/Camera.get_camera_transform().basis

	direction = Vector3()

	if up:
		direction -= aim[2]
	if down:
		direction += aim[2]
	if left:
		direction -= aim[0]
	if right:
		direction += aim[0]

	if up or right or left or down: # IS MOVING?
		if posture_state == STAND:
			movement_state = RUN
			move_speed = run_speed
			if !on_ladder:
				if up or right or left: # IS MOVING FORWARDS?
					if sprint:
						movement_state = SPRINT
						move_speed = sprint_speed
					elif walk:
						movement_state = WALK
						move_speed = walk_speed
		else:
			movement_state = WALK
			move_speed = walk_speed
	else: # IS NOT MOVING?
		movement_state = IDLE

	_apply_gravity(delta)
	if can_change_last_floor_height:
		last_floor_height = get_translation().y
		can_change_last_floor_height = false

	if velocity.x > 0 or velocity.x < 0 and is_moving == false:
		is_moving = true
	else:
		is_moving = false
	if velocity.y > 0 or velocity.y < 0 and is_moving == false:
		is_moving = true
	else:
		is_moving = false
	if velocity.z > 0 or velocity.z < 0 and is_moving == false:
		is_moving = true
	else:
		is_moving = false
		pass

	direction.y = 0
	#Normalize direction
	direction = direction.normalized()

	#if (direction.length() > 0 and $Yaw/stair_check.is_colliding()):
	#	var stair_normal = $Yaw/stair_check.get_collision_normal()
	#	var stair_angle = rad2deg(acos(stair_normal.dot(Vector3(0, 1, 0))))
	#	if stair_angle < MAX_STAIR_SLOPE:
	#		print("STAIR")
	#		velocity.y = STAIR_JUMP_HEIGHT

	var hvel = velocity
	hvel.y = 0
	var target = direction * move_speed
	var accel
	if(direction.dot(hvel) > 0):
		accel = ACCEL
	else:
		accel = DEACCEL

	hvel = hvel.linear_interpolate(target, accel * move_speed * delta)
	velocity.x = hvel.x
	velocity.z = hvel.z

	velocity = move_and_slide(velocity, Vector3(0, 1, 0), 0.05, 4, deg2rad(MAX_SLOPE_ANGLE))

	#throwing(delta)

func _input(event):
	#if Input.is_key_pressed(KEY_R):
	#	get_tree().reload_current_scene()

	# If already carries an object - release it, otherwise (if ray is colliding) pick an object up
	if Input.is_action_just_pressed("pick_up"):
		if carried_object.size() <= 1:
			if $Yaw/Camera/InteractionRay.is_colliding():
				var x = $Yaw/Camera/InteractionRay.get_collider()
				if x.has_method("pick_up"):
					x.pick_up(self)
		else:
			$error.set_text('bs kr yar')
		#if carried_object.size() > 0:
		#	#carryingBooks.append()
		#	carried_object.pick_up(self)
		#else:
		#	if $Yaw/Camera/InteractionRay.is_colliding():
		#		var x = $Yaw/Camera/InteractionRay.get_collider()
		#		if x.has_method("pick_up"):
		#			x.pick_up(self)

	# Hold Left Mouse Button (LMB) to throw carried object
	if Input.is_action_just_released("LMB"):
		if carried_object.size() > 0:
			carried_object.throw(throw_power)
		throw_power = 0

	# Interact
	if Input.is_action_just_pressed("interact"):
		if $Yaw/Camera/InteractionRay.is_colliding():
			var x = $Yaw/Camera/InteractionRay.get_collider()
			if x.has_method("interact"):
				x.interact(self)

func _apply_gravity(delta):
	velocity.y += delta * gravity

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		yaw = fmod(yaw - event.relative.x * view_sensitivity, 360)
		pitch = max(min(pitch - event.relative.y * view_sensitivity, 89), -89)
		$Yaw.rotation = Vector3(0, deg2rad(yaw), 0)
		$Yaw/Camera.rotation = Vector3(deg2rad(pitch), 0, 0)

func frustrate() -> void:
	print('frustrated player')
	# Increase frustration level by some amount
	frustoValue += FRUSTO_VALUE
	# Show the frustration bar if not shown
	# update the HUD

	if frustoValue >= 100:
		# do some here
		pass
