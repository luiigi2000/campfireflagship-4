extends Node2D

@onready var worm_stick = $WormStickAnim
@onready var vis_area = $WormStickAnim/VisibilityArea
var dragging := false
var worm_pos_targets := []
@onready var worm_move_timer := $WormMoveTimer
@onready var all_worms = [$Worms/WormDot]
var worms_being_reeled := []
var is_reeling_in := false
var last_mouse_pos = Vector2.ZERO
var raycasts = []
const grass_y = 473.0
@onready var dirt_burst_dup = $DirtBursts/DirtBurst.duplicate()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$DirtBursts/DirtBurst.queue_free()
	setup_raycasts()
	last_mouse_pos = get_global_mouse_position()
	spawn_worms()
	worm_stick.frame = 6
	worm_stick.position.y = grass_y
	shuffle_worm_targets()
	worm_move_timer.start()

func _physics_process(delta: float) -> void:
	if $Worms.get_child_count() == 0:
		Global.level_cleared()
	if not dragging and is_reeling_in:
		detect_worms_via_raycast()
	var current_mouse_pos = get_global_mouse_position()
	if current_mouse_pos == last_mouse_pos:
		is_reeling_in = false
	else:
		is_reeling_in = true
	last_mouse_pos = current_mouse_pos
	
	if dragging:
		worm_stick.position = get_global_mouse_position()
	move_worm()
	for worm in worms_being_reeled:
		worm.set_meta("detected", false)
	worms_being_reeled = []
	
	


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and not dragging:
		var mouse_dir = sign(event.relative.x)
		
		if mouse_dir == 1.0:
			worm_stick.frame += 1
		else:
			worm_stick.frame -= 1
	else:
		worm_stick.frame = 6


func _on_drag_area_button_down() -> void:
	dragging = true
	$WormStickAnim/VisibilityArea/VisAreaBody.monitoring = false
	fade_visibility(0.0)


func _on_drag_area_button_up() -> void:
	dragging = false
	$WormStickAnim/VisibilityArea/VisAreaBody.monitoring = true
	worm_stick.position = Vector2(get_global_mouse_position().x,grass_y)
	fade_visibility(1.0)
	
func fade_visibility(transparency: float):
	var tween = get_tree().create_tween()
	tween.tween_property(vis_area, "modulate:a",transparency,.5)
	tween.play()
	
func move_worm(reeling = false):
	for worm in $Worms.get_child_count():
		var worm_obj = $Worms.get_child(worm)
		if not worm_obj.get_meta("detected"):
			worm_obj.position = worm_obj.position.move_toward(worm_pos_targets[worm],.25)
		else:
			worm_obj.position =  worm_obj.position.move_toward(worm_stick.position, .25)
		worm_obj.position = Vector2(clamp(worm_obj.position.x,0,get_viewport_rect().size.x),clamp(worm_obj.position.y,grass_y,get_viewport_rect().size.y))
		if (worm_stick.position.y - worm_obj.position.y)  >= -3:
			if worms_being_reeled.has(worm_obj):
				worms_being_reeled.erase(worm_obj)
				worm_obj.queue_free()
			spawn_actual_worm()
			
	
			
func shuffle_worm_targets():
	worm_pos_targets.clear()
	for worm in $Worms.get_children():
		worm_pos_targets.append(Vector2(randf_range(0,get_viewport_rect().size.x),randf_range(grass_y,get_viewport_rect().size.y)))


func _on_worm_move_timer_timeout() -> void:
	worm_move_timer.start()
	shuffle_worm_targets()
	
		
			
#INSTEAD OF USING AREA BODIES, USE RAYCASTS

func setup_raycasts():
	var area_obj = $WormStickAnim/VisibilityArea
	var target_x = area_obj.position.x - area_obj.texture.get_size().x/2
	while target_x <= area_obj.position.x + area_obj.texture.get_size().x/2:
		var raycast = RayCast2D.new()
		raycast.position = worm_stick.position
		raycast.target_position = Vector2(target_x,area_obj.texture.get_size().y)
		raycast.collide_with_areas = true
		target_x += 1
		raycast.enabled = true

		add_child(raycast)
		raycasts.append(raycast)
		
func detect_worms_via_raycast():
	for ray in raycasts:
		ray.position = worm_stick.position
		if ray.is_colliding():
			if is_instance_valid(ray.get_collider()):
				ray.get_collider().get_parent().set_meta("detected",true)
				worms_being_reeled.append(ray.get_collider().get_parent())
		
func spawn_worms():
	for i in range(4):
		var worm_clone = $Worms/WormDot.duplicate()
		worm_clone.position = Vector2(randf_range(0,get_viewport_rect().size.x),randf_range(473,get_viewport_rect().size.y))
		all_worms.append(worm_clone)
		$Worms.add_child(worm_clone)
		
func spawn_actual_worm():
	shake_camera()
	var dirt_burst = dirt_burst_dup.duplicate()
	dirt_burst.position = worm_stick.position
	$DirtBursts.add_child(dirt_burst)
	dirt_burst.play()
		
	var worm = dirt_burst.get_child(0)
		
	worm.linear_velocity = Vector2(randf_range(-1000,1000),randf_range(-2000,-1000))
	
func shake_camera():
	$Explosion.play()
	var camera = $Camera2D
	for i in range(10):
		camera.rotation = randf_range(deg_to_rad(-75),deg_to_rad(75))
		await get_tree().create_timer(.2).timeout
