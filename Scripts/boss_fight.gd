extends Node2D

@onready var latta = $ZachLatta
enum latta_state {attacking, idol}
var state = latta_state.idol
var target_x
var increment = randf_range(2.,5)
@onready var attack_timer = $AttackTimer
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	attack_timer.start()
	target_x = randf_range(0,get_viewport_rect().size.x)
	

func _physics_process(delta: float) -> void:
	if state == latta_state.idol:
		if abs(latta.global_position.x - target_x) > increment:
			latta.global_position.x = move_toward(latta.global_position.x,target_x,increment)
		else:
			increment = randf_range(2.,5)
			target_x = randf_range(0,get_viewport_rect().size.x)

func choose_attack():
	var attack = randi_range(1,3)
		
	if attack == 3:
		lazer_attack()
	elif attack == 2:
		puke_attack()
	else:
		smash_attack()
	await latta.animation_finished
	latta.play("Normal")
	state = latta_state.idol
		
func lazer_attack():
	latta.play("LazerAttack")
	
func puke_attack():
	latta.play("PukeAttack")
	
func smash_attack():
	latta.play("SmashAttack")
	
func _on_attack_timer_timeout() -> void:
	state = latta_state.attacking
	choose_attack()
	attack_timer.start()
