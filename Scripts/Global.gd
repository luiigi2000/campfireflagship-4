extends Node2D
#ADD ANOTHER PARAMETER TO LEVEL SELECT AND CHANGE THE LEVEL THERE INSTEAD, ALSO ADD A NEXT LEVEL SCREEN
enum level {level_select,level1,level2,level3,level4}
@onready var state = level.level_select
var level_child
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.set_custom_mouse_cursor(preload("res://Mouse/whitehandmove.png"))
	change_level()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("open_level_selector"):
		state = level.level_select
		change_level() 
	if Input.is_action_just_pressed("click"):
		await get_tree().create_timer(.1).timeout
		
func change_level(reset_scene = false):
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED
	if is_instance_valid(level_child):
		level_child.queue_free()
		
	if state == level.level_select:
		level_child = preload("res://Scenes/level_selector.tscn").instantiate()
	elif state == level.level1:
		level_child = preload("res://Scenes/pianolevel.tscn").instantiate()
	elif state == level.level2:
		level_child = preload("res://Scenes/flappybirdlevel.tscn").instantiate()
	elif state == level.level3:
		level_child = preload("res://Scenes/gun_level.tscn").instantiate()
	add_child(level_child)
