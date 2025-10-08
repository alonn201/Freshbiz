extends Node2D

@onready var player_red: Node2D = $Players/PlayerRed
@onready var dice: Node2D = $Dice
@onready var roll_button: TextureButton = $RollButton

@export var game_space : Array[Spot]

var rng := RandomNumberGenerator.new()
#var red_position : int = 0
var board_one_spaces : int
var steps : int 

func _ready() -> void:
	randomize()
	board_one_spaces = game_space.size()

func _on_roll_button_pressed() -> void:
	roll_button.disabled = true
	steps = rng.randi_range(1, 6)
	
	await dice.play_roll(steps)
	await get_tree().create_timer(0.25).timeout
	await player_red.animate_steps(steps, board_one_spaces, game_space)
	
	if game_space[Globals.red_position].condition == Condition.State.BAD:
		_penalty_spot()
	
	elif game_space[Globals.red_position].condition == Condition.State.GOOD:
		_bonus_spot()
	
	elif game_space[Globals.red_position].condition == Condition.State.TRANSITION:
		_transition_spot()
	
	roll_button.disabled = false 

func _penalty_spot() -> void:
	print(":(")

func _bonus_spot() -> void:
	print(":)")

func _transition_spot() -> void:
	print(":^)")
