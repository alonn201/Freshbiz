extends Node2D

@onready var player_red: Node2D = $Players/PlayerRed

@export var game_space : Array[Node]

var rng := RandomNumberGenerator.new()
var place : int = 0
var board_one_spaces : int

func _ready() -> void:
	randomize()
	board_one_spaces = game_space.size()

func _on_roll_button_pressed() -> void:
	var steps := rng.randi_range(1, 6)
	print("Rolled ", steps)
	animate_steps(steps)

func animate_steps(steps : int) -> void:
	for i in steps:
		place = wrapi(place + 1, 0, board_one_spaces)
		var tw := create_tween()
		tw.tween_property(player_red, "position", game_space[place].position, 0.15)
		await tw.finished
