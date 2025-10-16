extends Node2D

@onready var red: Node = $Positions/Red
@onready var blue: Node = $Positions/Blue
@onready var orange: Node = $Positions/Orange
@onready var green: Node = $Positions/Green

@onready var player_red: Sprite2D = $Players/PlayerRed
@onready var player_blue: Sprite2D = $Players/PlayerBlue
@onready var player_orange: Sprite2D = $Players/PlayerOrange
@onready var player_green: Sprite2D = $Players/PlayerGreen

@onready var dice: Node2D = $Dice
@onready var roll_button: TextureButton = $RollButton

var game_space_red : Array[Spot]
var game_space_blue : Array[Spot]
var game_space_orange : Array[Spot] 
var game_space_green : Array[Spot]


var rng := RandomNumberGenerator.new()
var board_one_spaces : int
var steps : int

func _ready() -> void:
	randomize()
	game_space_red = _build_array("Positions/Red")
	game_space_blue = _build_array("Positions/Blue")
	game_space_orange = _build_array("Positions/Orange")
	game_space_green = _build_array("Positions/Green")

func _build_array(parent_path: String) -> Array[Spot]:
	var parent := get_node(parent_path) as Node
	var spots: Array[Spot] = []
	for child in parent.get_children():
		spots.append(child)
	
	return spots

func _on_roll_button_pressed() -> void:
	roll_button.disabled = true
	steps = rng.randi_range(1, 6)
	
	await dice.play_roll(steps)
	await get_tree().create_timer(0.25).timeout
	await player_red.animate_steps(steps, board_one_spaces, game_space_red)
	
	match game_space_red[Globals.red_position].condition:
		Condition.State.BAD: _penalty_spot()
		Condition.State.GOOD: _bonus_spot()
		Condition.State.TRANSITION: _transition_spot()
	
	roll_button.disabled = false 

func _penalty_spot() -> void:
	print(":(")

func _bonus_spot() -> void:
	print(":)")

func _transition_spot() -> void:
	print(":^)")
