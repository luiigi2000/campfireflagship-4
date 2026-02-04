extends Node2D

@onready var game_timer = $GameTime

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	game_timer.start()
	

func _on_game_time_timeout() -> void:
	if not Global.completed_before:
		Global.recorded_time += 1
		game_timer.start()
