extends Node2D
#ADD ANOTHER PARAMETER TO LEVEL SELECT AND CHANGE THE LEVEL THERE INSTEAD, ALSO ADD A NEXT LEVEL SCREEN
enum level {level_select,next_level,level1,level2,level3,level4,level5}
@onready var state = level.level4
var levels_owned = [level.keys()[level.level1]]
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
	if is_instance_valid(level_child):
		level_child.queue_free()	
	if state == level.level_select:
		level_child = preload("res://Scenes/level_selector.tscn").instantiate()
	elif state == level.level1:
		level_child = preload("res://Scenes/pianolevel.tscn").instantiate()
	elif state == level.level2:
		level_child = preload("res://Scenes/flappybirdlevel.tscn").instantiate()
	elif state == level.level3:
		Input.set_custom_mouse_cursor(preload("res://Mouse/1pixmouse.png"))
		level_child = preload("res://Scenes/gun_level.tscn").instantiate()
	elif state == level.level4:
		level_child = preload("res://Scenes/key_inthe_dark_level.tscn").instantiate()
	add_child(level_child)
	display_level_info()
	
func level_cleared():
	level_child.queue_free()
	level_child = preload("res://Scenes/level_cleared.tscn").instantiate()
	add_child(level_child)
	
func _input(event: InputEvent) -> void:
	#changes mouse input
	if event is InputEventKey and event.pressed:
		if event.is_action_pressed("open_level_selector"):
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if event is InputEventMouseButton  and event.pressed:
		if state == level.level2:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			
func display_level_info(custom_info = null, parent = null):
	var level_info_scene = preload("res://Scenes/level_info.tscn").instantiate()
	var label = level_info_scene.get_child(0).get_child(0)
	if custom_info != null:
		label.text = custom_info
	elif state == level.level1:
		label.text = "Can you play Fur Elise?"
	elif state == level.level2:
		label.text = "PRESS SPACE NOW AHHHHHHHH"
	elif state == level.level3:
		label.text = "Are those... EVIL SHOOTING HANDS"
	elif state == level.level4:
		label.text = "Can you find all 5 keys?"
	if parent == null:
		add_child(level_info_scene)
	else:
		parent.add_child(level_info_scene)
	await get_tree().create_timer(2.5).timeout
	var tween = get_tree().create_tween()
	tween.tween_property(label, "modulate:a", 0.0, .5)
	await tween.finished
	level_info_scene.queue_free()
