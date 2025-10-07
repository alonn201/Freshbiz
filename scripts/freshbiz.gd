extends Node2D

@onready var player_red: Node2D = $Players/PlayerRed
@onready var dice: Node2D = $Dice
@onready var roll_button: TextureButton = $RollButton

@export var game_space : Array[Node]

var rng := RandomNumberGenerator.new()
var place : int = 0
var board_one_spaces : int
var steps : int 

func _ready() -> void:
	randomize()
	board_one_spaces = game_space.size()

func _on_roll_button_pressed() -> void:
	roll_button.disabled = true
	
	steps = rng.randi_range(1, 6)
	print("Rolled ", steps)
	
	await dice.play_roll(steps)
	await get_tree().create_timer(0.25).timeout
	await animate_steps(steps)
	
	roll_button.disabled = false 

func animate_steps(step : int) -> void:
	for i in step:
		place = wrapi(place + 1, 0, board_one_spaces)
		var tw := create_tween()
		tw.tween_property(player_red, "position", game_space[place].position, 0.15)
		await tw.finished
