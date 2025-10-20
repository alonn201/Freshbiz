extends Node

var red_position : int = 0
var green_position : int = 0
var orange_position : int = 0
var blue_position : int = 0

var game_space_red : Array[Spot]
var game_space_blue : Array[Spot]
var game_space_orange : Array[Spot] 
var game_space_green : Array[Spot]
var skip_turn : Array[bool] = [false, false, false, false]

enum PLAYER {player_red, player_green, player_orange, player_blue}
var turn_order : Array[PLAYER] = [PLAYER.player_red, PLAYER.player_green, PLAYER.player_orange, PLAYER.player_blue]

enum LOCATION {game_space_red, game_space_green, game_space_orange, game_space_blue}
var player_location : Array[LOCATION] = [LOCATION.game_space_red, LOCATION.game_space_green, LOCATION.game_space_orange, LOCATION.game_space_blue]

enum POSITION {red_position, green_position, orange_position, blue_position}
var player_position : Array[POSITION] = [POSITION.red_position, POSITION.green_position, POSITION.orange_position, POSITION.blue_position]

var current_turn : int = 0

func next_turn() -> void:
	var start := current_turn
	while true:
		current_turn = wrapi(current_turn + 1, 0, 4)
		if not skip_turn[current_turn]:
			#skip_turn[current_turn] = false 
			break
		if current_turn == start:
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
	match player_location[current_turn]:
		LOCATION.game_space_red: return game_space_red
		LOCATION.game_space_blue: return game_space_blue
		LOCATION.game_space_orange: return game_space_orange
		LOCATION.game_space_green: return game_space_green
	
	return game_space_red
