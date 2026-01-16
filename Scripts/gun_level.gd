extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED_HIDDEN
	var total_shots = get_meta("total_shots")
	for i in range(total_shots):
		await get_tree().create_timer(randf_range(0,1)).timeout
		var gun = preload("res://gun.tscn").instantiate()
		add_child(gun)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$Mouse.position = get_global_mouse_position()
	if get_meta("guns_shot") == get_meta("total_shots"):
		end_level()
		
func end_level():
	Input.set_custom_mouse_cursor(preload("res://Mouse/whitehandmove.png"))
	Global.state = Global.level.level4
	Global.change_level()
