extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.set_custom_mouse_cursor(preload("res://Mouse/whitehandmove.png"))
	for button in $levels.get_children():
		if Global.levels_owned.has(button.name):
			button.connect("pressed",Callable(self,"_level_selected").bind(button))
			button.get_node("Lock").visible = false
		else:
			button.get_node("Lock").visible = true
	for label_to_delete in Global.level_info_label:
		if is_instance_valid(label_to_delete):
			label_to_delete.visible = false
	Global.level_info_label.clear()

	
func _level_selected(button):
	Global.state = Global.level[button.name]
	if Global.state == Global.level.level2 or Global.state == Global.level.level3:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	Global.change_level()
	
func _input(event):
	if event is InputEventMouseButton and event.pressed:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
