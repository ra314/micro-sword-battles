extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$Player1/Sword1.connect("player_killed", self, "reset")
	$Player2/Sword2.connect("player_killed", self, "reset")
	$Button1.connect("button_down", $Player1, "action")
	$Button2.connect("button_down", $Player2, "action")

func _process(delta):
	if Input.is_action_just_pressed("move_right"):
		$Button1.emit_signal("button_down")
	if Input.is_action_just_pressed("move_left"):
		$Button2.emit_signal("button_down")
	if Input.is_action_just_pressed("jump"):
		reset(null)


func reset(killed_player):
	get_tree().reload_current_scene()
	pass
