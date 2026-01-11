extends Node2D

enum level {level1,level2}
@onready var state = level.level1
var level_child
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.set_custom_mouse_cursor(preload("res://Mouse/whitehandmove.png"))
	change_level()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("click"):
		await get_tree().create_timer(.1).timeout
	
func change_level():
	if state != level.level1:
		await get_tree().create_timer(3).timeout
	if state == level.level1:
		level_child = preload("res://Scenes/level_1.tscn").instantiate()
		add_child(level_child)
	elif state == level.level2:
		level_child.queue_free()
		level_child = preload("res://Scenes/level_1.tscn").instantiate()
		add_child(preload("res://Scenes/level_2.tscn").instantiate())
