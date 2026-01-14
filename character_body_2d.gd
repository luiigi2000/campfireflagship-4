extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var walls = []
var key_spawned_debounce = false

func _ready() -> void:
	get_tree().paused = false
	print("BEGGINING")
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	$"../SpawnWallTimer".start()
	await get_tree().create_timer(15).timeout
	key_spawned_debounce = true
	
	
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if key_spawned_debounce:
		$"../Key".position.x -= 1
	for wall in walls:
		wall.position.x -= 3
		if wall.position.x < 0-wall.get_rect().size.x:
			walls.erase(wall)
			wall.queue_free()
	
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept"):
		velocity.y = JUMP_VELOCITY
		$Sprite2D.texture = preload("res://Mouse/whitehandhover.png")
		await get_tree().create_timer(1).timeout
		$Sprite2D.texture = preload("res://Mouse/whitehandmove.png")

	move_and_slide()
	
func create_walls():
	for i in range(2):
		var wall = Sprite2D.new()
		wall.texture = preload("res://Mouse/whitehandhover.png")
		wall.scale.y = (randf_range(get_viewport_rect().size.y/1.7,get_viewport_rect().size.y/2-wall.get_rect().size.y))/wall.texture.get_size().y
		
		var area = Area2D.new()
		wall.add_child(area)
		area.body_entered.connect(_on_area_2d_body_entered)
		
		var collision = CollisionShape2D.new()             
		area.add_child(collision)
		
		var shape = RectangleShape2D.new()
		shape.size = wall.texture.get_size()
		collision.shape = shape
		
		
		if i%2 == 0:
			wall.global_position = Vector2(get_viewport_rect().size.x+shape.size.x,0+shape.size.y)
		else:
			wall.global_position = Vector2(get_viewport_rect().size.x+shape.size.x,get_viewport_rect().size.y-shape.size.y)
		walls.push_back(wall)
		$"../WallContainer".add_child(wall)
	
func _on_spawn_wall_timer_timeout() -> void:
	create_walls()
	$"../SpawnWallTimer".start()


func _on_key_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		Global.state = Global.level.level3
		Global.change_level()
		
		
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name != "Player":
		return 
	call_deferred("_reload_scene")
		
func _reload_scene():
	Global.state = Global.level.level2
	Global.change_level(true)

		
