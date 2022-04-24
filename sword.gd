extends KinematicBody2D
class_name Sword

const H_SPEED = 500
const V_SPEED = 1000

var velocity = Vector2()
onready var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var thrown = false
var player
var enemy_name 
var world = null

func _ready():
	player = get_parent()
	world = player.get_parent()
	set_pnames()
	$Area2D.connect("body_entered", self, "_on_body_entered")

func set_pnames():
	if player.name == "Player1":
		enemy_name = "Player2"
	else:
		enemy_name = "Player1"

signal player_killed
func _on_body_entered(body):
	print(name + " is entering " + body.name)
	if thrown:
		print(enemy_name)
		if body.name == enemy_name:
			print("emitting player_killed")
			emit_signal("player_killed", body)
	if is_on_floor():
		if body.name.begins_with("Player"):
			if body.sword == null:
				add_to_player(body)

func add_to_player(new_player):
	player = new_player
	set_pnames()
	set_collision_mask_bit(PLATFORM_COLLISION_LAYER, false)
	world.remove_child(self)
	player.add_child(self)
	player.sword = self
	thrown = false
	scale = SMALL_SCALE
	init_pos_and_rot()

func init_pos_and_rot():
	if player.move_right:
		position = Vector2(-10.85, -10.85)
		rotation_degrees = 45
	else:
		position = Vector2(10.85, -10.85)
		rotation_degrees = 135

const PLATFORM_COLLISION_LAYER = 0
const PLAYER_COLLISION_LAYER = 1
const BIG_SCALE = Vector2(2, 1)
const SMALL_SCALE = Vector2(0.5, 0.25)
func throw_self():
	thrown = true
	
	var prev_position = global_position
	player.sword = null
	player.remove_child(self)
	world.add_child(self)
	position = prev_position
	scale = BIG_SCALE
	
	if player.move_right:
		velocity = Vector2(H_SPEED, -V_SPEED)
	else:
		velocity = Vector2(-H_SPEED, -V_SPEED)
	
	set_collision_mask_bit(PLATFORM_COLLISION_LAYER, true)
	#set_collision_mask_bit(PLAYER_COLLISION_LAYER, true)

func _physics_process(delta):
	# Vertical movement code. Apply gravity.
	if thrown:
		# Become non dangerous
		if is_on_floor():
			velocity = Vector2()
			set_collision_mask_bit(PLAYER_COLLISION_LAYER, false)
			enemy_name = null
			player = null
		# Rotate and fall
		else:
			velocity.y += gravity * delta
			rotation_degrees += 2
			if is_on_wall():
				velocity.x *= -1
	move_and_slide_with_snap(velocity, Vector2.DOWN, Vector2.UP)
