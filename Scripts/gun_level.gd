extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	for i in range(50):
		await get_tree().create_timer(randf_range(0,1)).timeout
		var gun = preload("res://gun.tscn").instantiate()
		add_child(gun)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$Mouse.position = get_global_mouse_position()
