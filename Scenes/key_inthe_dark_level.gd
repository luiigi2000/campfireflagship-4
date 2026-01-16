extends Node2D

@onready var light = $Light
@onready var target_position = light.position 
var keys_found = []
@onready var total_keys = $Keys.get_child_count()
# Called when the node enters the scene tree for the first time.

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
			#end_round
			pass
