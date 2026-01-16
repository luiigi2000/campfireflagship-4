extends Node2D

func _ready() -> void:
	Input.set_custom_mouse_cursor(preload("res://Mouse/whitehandmove.png"))
	if not Global.levels_owned.has(Global.level.keys()[Global.state+1]):
		Global.levels_owned.append(Global.level.keys()[Global.state+1])
	
	
func _on_back_pressed() -> void:
	Global.state = Global.level.level_select
	set_mouse_mode()
	Global.change_level()

func _on_next_pressed() -> void:
	Global.state += 1
	set_mouse_mode()
	Global.change_level()
	
func set_mouse_mode():
	if Global.state == Global.level.level1 or Global.state == Global.level.level2:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
