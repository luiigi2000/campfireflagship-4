extends AnimatedSprite2D

@onready var gun_size = preload("res://Mouse/whitehandmove.png").get_size()
# Called when the node enters the scene tree for the first time.
var has_shot_gun = false
var target_position
@onready var raycast = $RayCast
var rotation_target

func _ready() -> void:
	target_position = get_global_mouse_position()
	spawn_shooter()
	rotation_target =  (get_global_mouse_position()-position).angle() + deg_to_rad(90)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	rotation = rotation_target
	if position.x < gun_size.x or position.y < gun_size.y or position.x > get_viewport_rect().size.x+gun_size.x or position.y > get_viewport_rect().size.y-gun_size.y:
		position = position.move_toward(target_position, 1)

	elif not has_shot_gun:
		shoot_gun()
	if raycast.is_colliding():
		Global.change_level(true)
		
		

func spawn_shooter():
	var spawn_position = Vector2(randf_range(-gun_size.x,get_viewport_rect().size.x+gun_size.x),[-gun_size.y,get_viewport_rect().size.y+gun_size.y].pick_random())
	position = spawn_position
	
func shoot_gun():
	has_shot_gun = true
	await get_tree().create_timer(2).timeout
	raycast.enabled = true
	play()
	add_bullet()
	await get_tree().create_timer(2).timeout
	get_parent().queue_free()
	
func add_bullet():
	$Bullet.visible = true
