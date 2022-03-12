extends KinematicBody2D

const WALK_SPEED = 200
const JUMP_SPEED = 800

var velocity = Vector2(WALK_SPEED, 0)
export var move_right = bool()

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
	velocity.y += gravity * delta
	
	# Move based on the velocity and snap to the ground.
	move_and_slide_with_snap(velocity, Vector2.DOWN, Vector2.UP)

func action():
	# Check for jumping. is_on_floor() must be called after movement code.
	if is_on_floor():
		if has_sword():
			emit_signal("throwing")
		else:
			velocity.y = -JUMP_SPEED
