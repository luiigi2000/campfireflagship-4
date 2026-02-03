extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Control/TimeCompletedLabel.text = "You completed the game in \n" + str(Global.recorded_time /60) + " minutes"
