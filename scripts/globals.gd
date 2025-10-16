extends Node

var red_position    : int = 0
var green_position  : int = 0
var orange_position : int = 0
var blue_position   : int = 0

enum PLAYER { RED, GREEN, ORANGE, BLUE}
var turn_order : Array[PLAYER] = [PLAYER.RED, PLAYER.GREEN, PLAYER.ORANGE, PLAYER.BLUE]
var current_turn : int = 0

func _next_turn() -> void:
	current_turn = wrapi(current_turn + 1, 0, 4)
