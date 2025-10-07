extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func play_roll(value: int) -> void:
	if value < 1 or value > 6:
		return
	animation_player.play("roll_%d" % value)
	await animation_player.animation_finished
