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
@onready var turn_label: Label = $TurnLabel
@onready var red_money: Label = $Score/RedMoney
@onready var blue_money: Label = $Score/BlueMoney
@onready var green_money: Label = $Score/GreenMoney
@onready var orange_money: Label = $Score/OrangeMoney

var rng := RandomNumberGenerator.new()
var board_one_size : int
var steps : int

func _ready() -> void:
	randomize()
	Globals.game_space_red = _build_array("Positions/Red")
	Globals.game_space_blue = _build_array("Positions/Blue")
	Globals.game_space_orange = _build_array("Positions/Orange")
	Globals.game_space_green = _build_array("Positions/Green")
	board_one_size = Globals.game_space_red.size()
	
	turn_label.text = "Red's turn"

func _build_array(parent_path: String) -> Array[Spot]:
	var parent := get_node(parent_path) as Node
	var spots: Array[Spot] = []
	for child in parent.get_children():
		spots.append(child)
	
	return spots

func current_player() -> Node2D:
	match Globals.turn_order[Globals.current_turn]:
		Globals.PLAYER.player_red: return player_red
		Globals.PLAYER.player_blue: return player_blue
		Globals.PLAYER.player_orange: return player_orange
		Globals.PLAYER.player_green: return player_green
	
	return player_red

func _on_roll_button_pressed() -> void:
	roll_button.disabled = true
	steps = rng.randi_range(1, 6)
	
	await dice.play_roll(steps)
	await get_tree().create_timer(0.25).timeout
	await current_player().animate_steps(steps, board_one_size,current_player())
	
	match Globals.current_player_location()[Globals.current_player_position()].condition:
		Condition.State.BAD: _penalty_spot()
		Condition.State.GOOD: _bonus_spot()
		Condition.State.TRANSITION: _transition_spot()
	
	Globals.next_turn()
	turn_label.text = ["Red", "Green", "Orange", "Blue"][Globals.current_turn] + "'s turn"
	roll_button.disabled = false 

func _penalty_spot() -> void:
	print(":( You lost:(")
	var temp_int : int
	if current_player() == player_red:
		temp_int = int(red_money.text)
		temp_int -= 10
		red_money.text = str(temp_int)
	elif current_player() == player_blue:
		temp_int = int(blue_money.text)
		temp_int -= 10
		blue_money.text = str(temp_int)
	elif current_player() == player_green:
		temp_int = int(green_money.text)
		temp_int -= 10
		green_money.text = str(temp_int)
	else:
		temp_int = int(orange_money.text)
		temp_int -= 10
		orange_money.text = str(temp_int)

func _bonus_spot() -> void:
	print(":) you won :)")
	var temp_int : int
	if current_player() == player_red:
		temp_int = int(red_money.text)
		temp_int += 20
		red_money.text = str(temp_int)
	elif current_player() == player_blue:
		temp_int = int(blue_money.text)
		temp_int += 20
		blue_money.text = str(temp_int)
	elif current_player() == player_green:
		temp_int = int(green_money.text)
		temp_int += 20
		green_money.text = str(temp_int)
	else:
		temp_int = int(orange_money.text)
		temp_int += 20
		orange_money.text = str(temp_int)

func _transition_spot() -> void:
	print(":^) bye bye")
	current_player().hide()
	Globals.skip_turn[Globals.current_turn] = true
