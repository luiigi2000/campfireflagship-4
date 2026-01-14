extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for button in $levels.get_children():
		button.connect("pressed",Callable(self,"_level_selected").bind(button))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass 
	
func _level_selected(button):
	Global.state = Global.level[button.name]
	Global.change_level()
