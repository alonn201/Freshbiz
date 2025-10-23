extends Node

@onready var player_red: Node2D = $"."
@onready var player_blue: Sprite2D = $"../PlayerBlue"
@onready var player_orange: Sprite2D = $"../PlayerOrange"
@onready var player_green: Sprite2D = $"../PlayerGreen"

func animate_steps(step : int, board_size : int, cur_player : Node2D) -> void:
	var temp_pos = Globals.current_player_position()
	for i in step:
		temp_pos = wrapi(temp_pos + 1, 0, board_size)
		
		var tw := create_tween()
		tw.tween_property(cur_player, "position", Globals.current_player_location()[temp_pos].position, 0.15)
		await get_tree().create_timer(.5).timeout
	
	if Globals.on_board_two[Globals.current_turn]:
		match Globals.player_location[Globals.current_turn_two]:
			Globals.LOCATION.board_two_red: Globals.red_position = temp_pos
			Globals.LOCATION.board_two_green: Globals.green_position = temp_pos
			Globals.LOCATION.board_two_orange: Globals.orange_position = temp_pos
			Globals.LOCATION.board_two_blue: Globals.blue_position = temp_pos
	else:
		match Globals.player_location[Globals.current_turn]:
			Globals.LOCATION.board_one_red: Globals.red_position = temp_pos
			Globals.LOCATION.board_one_green: Globals.green_position = temp_pos
			Globals.LOCATION.board_one_orange: Globals.orange_position = temp_pos
			Globals.LOCATION.board_one_blue: Globals.blue_position = temp_pos
