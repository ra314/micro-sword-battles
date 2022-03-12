extends KinematicBody2D

const H_SPEED = 2
const V_SPEED = 200

var velocity = Vector2()
onready var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var thrown = false
var player = null
var enemy_name 
var world = null

func _ready():
	player = get_parent()
	if player.name == "Player1":
		enemy_name = "Player2"
	else:
		enemy_name = "Player1"
	world = player.get_parent()
	$Area2D.connect("body_entered", self, "_on_body_entered")

signal player_killed
func _on_body_entered(body):
	if thrown and body.name == enemy_name:
		emit_signal("player_killed", body)

func throw_self():
	thrown = true
	var prev_position = global_position
	player.remove_child(self)
	world.add_child(self)
	position = prev_position
	scale = Vector2(2, 1)
	if player.move_right:
		velocity = Vector2(H_SPEED, -V_SPEED)
	else:
		velocity = Vector2(-H_SPEED, -V_SPEED)

func _physics_process(delta):
	# Vertical movement code. Apply gravity.
	if thrown:
		if is_on_floor():
			velocity = Vector2()
		else:
			velocity.y += gravity * delta
			rotation_degrees += 2
	move_and_slide_with_snap(velocity, Vector2.DOWN, Vector2.UP)
