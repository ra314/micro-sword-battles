extends KinematicBody2D

const WALK_SPEED = 300
const JUMP_SPEED = 1200

const FALL_MULTIPLIER = 2.5;

var velocity = Vector2(WALK_SPEED, 0)
export var move_right = bool()
var is_jumping = false

onready var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	connect("throwing", $Sword, "throw_self")

func has_sword():
	for child in get_children():
		if child.name == "Sword":
			return true
	return false

signal throwing
func _physics_process(delta):
	if is_on_wall():
		print("im on the wall")
		move_right = not move_right
		print(velocity)
	
	if move_right:
		velocity.x = WALK_SPEED
	else:
		velocity.x = -WALK_SPEED
	
	# Vertical movement code. Apply gravity.
	# velocity.y += gravity * delta
	
	if is_on_floor() and !is_jumping:
		velocity.y = 0
	elif velocity.y < 0:
		is_jumping = false
		velocity.y += gravity * (FALL_MULTIPLIER - 1) * delta
	else:
		velocity.y += gravity * delta
	
	# Move based on the velocity and snap to the ground.
	move_and_slide_with_snap(velocity, Vector2.DOWN, Vector2.UP)

func action():
	# Check for jumping. is_on_floor() must be called after movement code.
	if is_on_floor():
		#if has_sword():
		#	emit_signal("throwing")
		#else:
		velocity.y = -JUMP_SPEED
		is_jumping = true
