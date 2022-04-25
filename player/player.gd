extends KinematicBody2D
class_name Player

const WALK_SPEED = 300
const JUMP_SPEED = 1200

const FALL_MULTIPLIER = 2.5;

var velocity = Vector2(WALK_SPEED, 0)
export var move_right: bool
export(String, "Blue", "Red") var color
var is_jumping = false
var sword
var dead = false

onready var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var init_position
var init_direction
var init_velocity
func _ready():
	init_position = position
	init_direction = move_right
	init_velocity = velocity
	reset()
	sword = get_sword()

func get_sword():
	for child in get_children():
		if child.name.begins_with("Sword"):
			return child
	return null

func has_sword():
	return get_sword() != null

func switch_direction():
	move_right = not move_right
	rot_clockwise = not rot_clockwise
	
	if has_sword():
		sword.init_pos_and_rot()

func die():
	dead = true
	visible = false

const MAX_ROT_RANGE_DEG = 120
const ROT_SPEED = 1

const RIGHT_MAX_ROT_DEG = 0
const LEFT_MIN_ROT_DEG = -180
const RIGHT_MIN_ROT_DEG = -MAX_ROT_RANGE_DEG
const LEFT_MAX_ROT_DEG = LEFT_MIN_ROT_DEG+MAX_ROT_RANGE_DEG

var rot_clockwise = false
func rotate_arrow():
	var new_degrees = $Sprite2.rotation_degrees
	
	# Rotation
	if rot_clockwise:
		new_degrees += ROT_SPEED
	else:
		new_degrees -= ROT_SPEED
	
	# Clamping rotation and switching rotation direction
	if move_right:
		if rot_clockwise:
			new_degrees = min(new_degrees, RIGHT_MAX_ROT_DEG)
		else:
			new_degrees = max(new_degrees, RIGHT_MIN_ROT_DEG)
		if new_degrees in [RIGHT_MIN_ROT_DEG, RIGHT_MAX_ROT_DEG]:
			rot_clockwise = not rot_clockwise
	else:
		if rot_clockwise:
			new_degrees = min(new_degrees, LEFT_MAX_ROT_DEG)
		else:
			new_degrees = max(new_degrees, LEFT_MIN_ROT_DEG)
		if new_degrees in [LEFT_MIN_ROT_DEG, LEFT_MAX_ROT_DEG]:
			rot_clockwise = not rot_clockwise
	
	$Sprite2.rotation_degrees = new_degrees

func _physics_process(delta):
	if dead:
		return
	
	rotate_arrow()
	
	if is_on_wall():
		switch_direction()
	
	if move_right:
		velocity.x = WALK_SPEED
	else:
		velocity.x = -WALK_SPEED
	
	# Vertical movement code. Apply gravity.	
	if is_on_floor() and !is_jumping:
		velocity.y = 0
	elif velocity.y < 0:
		is_jumping = false
		velocity.y += gravity * (FALL_MULTIPLIER - 1) * delta
	else:
		velocity.y += gravity * delta
	
	# Move based on the velocity and snap to the ground.
	move_and_slide_with_snap(velocity, Vector2.DOWN, Vector2.UP)

func reset():
	position = init_position
	move_right = init_direction
	velocity = init_velocity
	sword = null
	dead = false
	visible = true
	
	if move_right:
		$Sprite2.rotation_degrees = 0
		rot_clockwise = false
	else:
		$Sprite2.rotation_degrees = -180
		rot_clockwise = true

func action():
	# Check for jumping. is_on_floor() must be called after movement code.
	if is_on_floor():
		if has_sword():
			sword.throw_self()
		else:
			velocity.y = -JUMP_SPEED
			is_jumping = true
