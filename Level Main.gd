extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var sword1
var sword2

# Called when the node enters the scene tree for the first time.
func _ready():
	sword1 = $Player1/Sword1
	sword2 = $Player2/Sword2
	
	$Player1/Sword1.connect("player_killed", self, "reset")
	$Player2/Sword2.connect("player_killed", self, "reset")
	
	$Button1.connect("button_down", $Player1, "action")
	$Button2.connect("button_down", $Player2, "action")

func get_other_player(player):
	var players = [$Player1, $Player2]
	players.erase(player)
	assert(len(players) == 1)
	return players[0]

func increase_score(killed_player):
	# Updating the text
	var label
	if "1" in killed_player.name:
		label = $Label1
	else:
		label = $Label2
	label.text = str(int(label.text)+1)

func _process(delta):
	if Input.is_action_just_pressed("move_right"):
		$Button1.emit_signal("button_down")
	if Input.is_action_just_pressed("move_left"):
		$Button2.emit_signal("button_down")
	if Input.is_action_just_pressed("jump"):
		reset(null)

func is_game_over():
	return $Label1.text == str(GAME_OVER_SCORE) or $Label2.text == str(GAME_OVER_SCORE)

func game_over(winner_color):
	$Label3.text = winner_color + " wins!"

const GAME_OVER_SCORE = 5
const DEATH_RESET_TIME = 4
func reset(killed_player):
	if killed_player:
		increase_score(killed_player)
	
	if is_game_over():
		game_over(get_other_player(killed_player).color)
	
	yield(get_tree().create_timer(DEATH_RESET_TIME), "timeout")
	
	$Player1.reset()
	$Player2.reset()
	sword1.add_to_player($Player1)
	sword2.add_to_player($Player2)
