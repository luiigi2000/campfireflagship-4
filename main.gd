extends Node2D

enum level {level1,level2}
@onready var state = level.level1
var level_child
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	change_level()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func change_level():
	if state == level.level1:
		level_child = preload("res://level_1.tscn").instantiate()
		add_child(level_child)
	elif state == level.level2:
		level_child.queue_free()
		level_child = preload("res://level_1.tscn").instantiate()
		add_child(preload("res://level_2.tscn").instantiate())
