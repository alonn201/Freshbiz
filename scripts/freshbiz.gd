extends Node2D

@onready var player_red: Sprite2D = $Players/PlayerRed
@onready var player_blue: Sprite2D = $Players/PlayerBlue
@onready var player_orange: Sprite2D = $Players/PlayerOrange
@onready var player_green: Sprite2D = $Players/PlayerGreen

@onready var board_one_camera: Camera2D = $Cameras/BoardOneCamera
@onready var board_two_camera: Camera2D = $Cameras/BoardTwoCamera

@onready var dice: Sprite2D = $Die/Dice
@onready var roll_button: TextureButton = $Die/RollButton
@onready var turn_label: Label = $Die/TurnLabel

@onready var dice_2: Sprite2D = $Die/Dice2
@onready var roll_button_2: TextureButton = $Die/RollButton2
@onready var turn_label_2: Label = $Die/TurnLabel2

@onready var red_money: Label = $Score/RedMoney
@onready var blue_money: Label = $Score/BlueMoney
@onready var green_money: Label = $Score/GreenMoney
@onready var orange_money: Label = $Score/OrangeMoney

var rng := RandomNumberGenerator.new()
var board_one_size : int
var board_two_size : int
var steps : int

func _ready() -> void:
	randomize()
	Globals.board_one_red = _build_array("Positions/BoardOne/Red")
	Globals.board_one_blue = _build_array("Positions/BoardOne/Blue")
	Globals.board_one_orange = _build_array("Positions/BoardOne/Orange")
	Globals.board_one_green = _build_array("Positions/BoardOne/Green")
	board_one_size = Globals.board_one_red.size()
	
	Globals.board_two_red = _build_array("Positions/BoardTwo/Red")
	Globals.board_two_blue = _build_array("Positions/BoardTwo/Blue")
	Globals.board_two_orange = _build_array("Positions/BoardTwo/Orange")
	Globals.board_two_green = _build_array("Positions/BoardTwo/Green")
	board_two_size = Globals.board_two_red.size()
	
	turn_label.text = "Red's turn"
	turn_label_2.text = "Red's turn"

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
	turn_label_2.text = ["Red", "Green", "Orange", "Blue"][Globals.current_turn] + "'s turn"
	roll_button.disabled = false 
	switch_camera()

func _on_roll_button_2_pressed() -> void:
	roll_button_2.disabled = true
	steps = rng.randi_range(1, 6)
	
	await dice_2.play_roll(steps)
	await get_tree().create_timer(0.25).timeout
	await current_player().animate_steps(steps, board_two_size,current_player())
	
	match Globals.current_player_location()[Globals.current_player_position()].condition:
		Condition.State.BAD: _penalty_spot()
		Condition.State.GOOD: _bonus_spot()
		Condition.State.TRANSITION: _transition_spot()
		
	Globals.next_turn()
	turn_label.text = ["Red", "Green", "Orange", "Blue"][Globals.current_turn] + "'s turn"
	turn_label_2.text = ["Red", "Green", "Orange", "Blue"][Globals.current_turn] + "'s turn"
	roll_button_2.disabled = false 
	switch_camera()

func _penalty_spot() -> void:
	print(":( You lost:(")

func _bonus_spot() -> void:
	print(":) you won :)")

func _transition_spot() -> void:
	print(":^) bye bye")
	Globals.on_board_two[Globals.current_turn] = true
	
	match Globals.player_location[Globals.current_turn]:
		Globals.LOCATION.board_one_red: Globals.red_position = 0
		Globals.LOCATION.board_one_green: Globals.green_position = 0
		Globals.LOCATION.board_one_orange: Globals.orange_position = 0
		Globals.LOCATION.board_one_blue: Globals.blue_position = 0
	
	var player_node := current_player()
	var new_board := Globals.current_player_location()
	player_node.position = new_board[0].position
	
	switch_camera()

func switch_camera() -> void:
	if Globals.on_board_two[Globals.current_turn]:
		board_two_camera.make_current()
	else:
		await get_tree().create_timer(1).timeout
		board_one_camera.make_current()
