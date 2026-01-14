extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for button in $levels.get_children():
		if Global.levels_owned.has(button.name):
			button.connect("pressed",Callable(self,"_level_selected").bind(button))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass 
	
func _level_selected(button):
	Global.state = Global.level[button.name]
	Global.change_level()
