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
	pass

func reset(killed_player):
	get_tree().reload_current_scene()
	pass
