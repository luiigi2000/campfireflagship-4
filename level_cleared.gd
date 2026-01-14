extends Node2D

func _ready() -> void:
	pass

func _on_back_pressed() -> void:
	Global.state = Global.level.level_select
	Global.change_level()



func _on_next_pressed() -> void:
	Global.state += 1
	Global.change_level()
