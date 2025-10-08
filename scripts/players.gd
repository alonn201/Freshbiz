extends Node

@onready var player_red: Node2D = $"."

func animate_steps(step : int, board_one_spaces : int, game_space : Array[Spot]) -> void:
	for i in step:
		Globals.red_position = wrapi(Globals.red_position + 1, 0, board_one_spaces)
		var tw := create_tween()
		tw.tween_property(player_red, "position", game_space[Globals.red_position].position, 0.15)
		await get_tree().create_timer(.5).timeout
	
