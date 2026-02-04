extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Control/TimeCompletedLabel.text = "You completed the game in \n" + str(Global.recorded_time /60) + " minutes"


func _on_back_button_pressed() -> void:
	Global.state = Global.level.level_select
	Global.change_level()
