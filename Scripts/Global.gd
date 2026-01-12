extends Node2D

enum level {level1,level2,level3}
@onready var state = level.level1
var level_child
var goal
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.set_custom_mouse_cursor(preload("res://Mouse/whitehandmove.png"))
	change_level(false)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("click"):
		await get_tree().create_timer(.1).timeout
		
func change_level(reset_scene):
	if is_instance_valid(level_child):
		level_child.queue_free()
		if not reset_scene:
			await get_tree().create_timer(.5).timeout
			goal.modulate = Color.DARK_GRAY
	if state == level.level1:
		level_child = preload("res://Scenes/pianolevel.tscn").instantiate()
	elif state == level.level2:
		level_child = preload("res://Scenes/flappybirdlevel.tscn").instantiate()
	add_child(level_child)
