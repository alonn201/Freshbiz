extends Node

var red_position : int = 0
var green_position : int = 0
var orange_position : int = 0
var blue_position : int = 0

var board_one_red : Array[Spot]
var board_one_blue : Array[Spot]
var board_one_orange : Array[Spot] 
var board_one_green : Array[Spot]

var board_two_red : Array[Spot]
var board_two_blue : Array[Spot]
var board_two_orange : Array[Spot] 
var board_two_green : Array[Spot]

var skip_turn : Array[bool] = [false, false, false, false]
var on_board_two : Array[bool] = [false, false, false, false]

enum PLAYER {player_red, player_green, player_orange, player_blue}
var turn_order : Array[PLAYER] = [PLAYER.player_red, PLAYER.player_green, PLAYER.player_orange, PLAYER.player_blue]

enum LOCATION {board_one_red, board_one_green, board_one_orange, board_one_blue,
			   board_two_red, board_two_green, board_two_orange, board_two_blue}
var player_location : Array[LOCATION] = [LOCATION.board_one_red, LOCATION.board_one_green, LOCATION.board_one_orange, LOCATION.board_one_blue,
										LOCATION.board_two_red, LOCATION.board_two_green, LOCATION.board_two_orange, LOCATION.board_two_blue]

enum POSITION {red_position, green_position, orange_position, blue_position}
var player_position : Array[POSITION] = [POSITION.red_position, POSITION.green_position, POSITION.orange_position, POSITION.blue_position]

var current_turn : int = 0
var current_turn_two : int = 4

func next_turn() -> void:
	var start := current_turn
	while true:
		current_turn = wrapi(current_turn + 1, 0, 4)
		current_turn_two = wrapi(current_turn + 4, 0, 8)
		if on_board_two[current_turn] == false:
			if not skip_turn[current_turn]:
				skip_turn[current_turn] = false
				break
			if current_turn == start:
				push_warning("All players flagged to skip – breaking")
				break
		else:
			if not skip_turn[current_turn]:
				skip_turn[current_turn] = false
				break
			if current_turn_two == start:
				push_warning("All players flagged to skip – breaking")
				break

func current_player_position() -> int:
	match player_location[current_turn]:
		POSITION.red_position: return red_position
		POSITION.blue_position: return blue_position
		POSITION.orange_position: return orange_position
		POSITION.green_position: return green_position
	
	return red_position

func current_player_location() -> Array[Spot]:
	if on_board_two[current_turn]:
		match player_location[current_turn]:
			LOCATION.board_one_red: return board_two_red
			LOCATION.board_one_blue: return board_two_blue
			LOCATION.board_one_orange: return board_two_orange
			LOCATION.board_one_green: return board_two_green
	else:
		match player_location[current_turn]:
			LOCATION.board_one_red: return board_one_red
			LOCATION.board_one_blue: return board_one_blue
			LOCATION.board_one_orange: return board_one_orange
			LOCATION.board_one_green: return board_one_green
	
	return board_one_red
