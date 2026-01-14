extends Node2D


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
		Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED_HIDDEN)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
