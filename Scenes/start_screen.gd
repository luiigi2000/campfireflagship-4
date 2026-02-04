extends Node2D

var speedrun_toggled := false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_play_button_pressed() -> void:
	Global.state += 1
	Global.change_level()
