extends Node2D

#make it so you can destroy hands by making them shoot at eachother
# Called when the node enters the scene tree for the first time.
var guns_despawned = 0
var all_guns_have_spawned = false
@export var total_guns = 25

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED_HIDDEN
	var gun_obj = $Guns/Gun.duplicate()
	$Guns/Gun.queue_free()
	for i in range(total_guns):
		await get_tree().create_timer(randf_range(.5,1)).timeout
		var gun = gun_obj.duplicate()
		$Guns.add_child(gun)
	all_guns_have_spawned = true
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$Mouse.position = get_global_mouse_position()
	if all_guns_have_spawned and $Guns.get_child_count() == 0:
		end_level()
		
func end_level():
	Input.set_custom_mouse_cursor(preload("res://Mouse/whitehandmove.png"))
	Global.state = Global.level.level4
	Global.change_level()
