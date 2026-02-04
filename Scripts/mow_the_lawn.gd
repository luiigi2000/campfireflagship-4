extends Node2D

const grass_y = 473.0
var direction = [-1,1].pick_random()
@export var SPEED = 5
@onready var mower = $LawnMower
var dirt_children = []
var dirt_already_placed_locations = []
@onready var mole_dup = $MoleAnim.duplicate()
var moles = []
@onready var cloud = $RainCloud
var cloud_direct = 1
enum cloud_states {clear,changing,rainy}
var cloud_state = cloud_states.clear

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$MoleAnim.queue_free()
	if direction == -1:
		mower.scale.x = -1
	else:
		mower.scale.x = 1
	$PlaceDirtOnGrass.start()
	mower.play("cutting_grass")
	cloud.play("NormalCloud")
	spawn_mole()
	move_cloud()
	make_cloud_rain()
	spawn_dirt()



func _physics_process(delta: float) -> void:
	check_win_condition()
	delete_dirt_below(mower.global_position.x+(direction *10),10,true) #mows the grass, not delete
	if cloud_state == cloud_states.rainy:
		delete_dirt_below(cloud.get_global_position().x,1)
	if Input.is_action_just_pressed("mower-left"):
		direction = -1
		mower.scale.x = -1
	if Input.is_action_just_pressed("mower-right"):
		direction = 1
		mower.scale.x = 1
	mower.position.x += direction * delta * SPEED
	mower.position.x = clamp(mower.position.x,0,get_viewport_rect().size.x)
	
	move_cloud()
	
func spawn_dirt():
	if dirt_already_placed_locations.has(mower.global_position):
		return
	else:
		dirt_already_placed_locations.append(mower.global_position)
	for x in range(0,get_viewport_rect().size.x, 1):
		var dirt_replacement = MeshInstance2D.new()
		dirt_replacement.modulate = Color.from_rgba8(79,21,10)
		var mesh = QuadMesh.new()
		mesh.size = Vector2(1,50)
		dirt_replacement.mesh = mesh
		
		dirt_replacement.global_position = Vector2(x,473+mesh.size.y/2-3)
		dirt_replacement.visible = false
		add_child(dirt_replacement)
		dirt_children.append(dirt_replacement)
	
func _on_place_dirt_on_grass_timeout() -> void:
	$PlaceDirtOnGrass.start()
	
func spawn_mole():
	var mole_spawn_timer = Timer.new()
	add_child(mole_spawn_timer)
	while true:
		mole_spawn_timer.wait_time = randf_range(1,5)
		mole_spawn_timer.start()
		await mole_spawn_timer.timeout
		
		var mole = mole_dup.duplicate()
		var x = randf_range(120,160) * direction
		mole.global_position = mower.position + Vector2(x,0)
		add_child(mole)
		mole.play("arrise")
		moles.push_front(mole)
		await mole.animation_finished
		delete_mole()
		
func delete_mole():
	for i in len(moles):
		moles[i].queue_free()
		moles.erase(moles[i])
		
func make_cloud_rain():
	var rain_timer = Timer.new()
	add_child(rain_timer)
	while true:
		rain_timer.wait_time = randi_range(4,10)
		rain_timer.start()
		await rain_timer.timeout
		cloud.play("ChangeCloud")
		cloud_state = cloud_states.changing
		await cloud.animation_finished
		break
	cloud.play("Rain")
	cloud_state = cloud_states.rainy

func move_cloud():
	if cloud.position.x > get_viewport_rect().size.x or cloud.position.x < 0:
		cloud_direct =- cloud_direct
	cloud.position.x += cloud_direct * 2


func _on_cloud_button_pressed() -> void:
	if cloud_state != cloud_states.clear:
		cloud.play("NormalCloud")
		cloud_state = cloud_states.clear
		make_cloud_rain()
	else:
		cloud.stop()
		cloud.play("Lightning")
		await cloud.animation_finished
		delete_dirt_below(cloud.global_position.x)
		cloud.play("NormalCloud")
		
func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.name == "MoleArea":
		mower.play("kill_mole")
		delete_dirt_below(area.global_position.x)
		area.get_parent().play("explode")
		await mower.animation_finished	
		mower.play("cutting_grass")
		
func delete_dirt_below(self_x,radius = 250, mow = false):
	for dirt in len(dirt_children):
		if is_instance_valid(dirt_children[dirt]):
			if abs(self_x - dirt_children[dirt].global_position.x) <= radius:
				if not mow:
					dirt_children[dirt].visible = false
				else:
					dirt_children[dirt].visible = true
				
func check_win_condition():
	for dirt in dirt_children:
		if dirt.visible == false:
			return
	Global.state += 1
	Global.change_level()
		
