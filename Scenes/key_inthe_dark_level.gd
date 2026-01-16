extends Node2D

@onready var light = $Light
@onready var target_position = light.position 
var keys_found = []
@export var total_keys = 3
# Called when the node enters the scene tree for the first time.

func _ready() -> void:
	spawn_items()
	
func _physics_process(delta: float) -> void:
	light.position = light.position.move_toward(target_position, 100 * delta)
		
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		target_position = get_global_mouse_position()
		

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.get_parent() == $Keys and not keys_found.has(body):
		body.modulate = Color.GREEN
		keys_found.append(body)
		if len(keys_found) == total_keys:
			Global.level_cleared()
		
func spawn_items():
	for i in range(total_keys-1):
		var key_dupe = $Keys/Key1.duplicate()
		$Keys.add_child(key_dupe)
	for key in $Keys.get_children():
		var key_size = $Keys/Key1/Collider.shape.size
		key.position = Vector2(randf_range(key_size.x,get_viewport_rect().size.x-key_size.x),randf_range(key_size.y,get_viewport_rect().size.y-key_size.y))
