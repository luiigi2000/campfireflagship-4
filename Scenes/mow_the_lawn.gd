extends Node2D

const grass_y = 473.0
var direction = [-1,1].pick_random()
@export var SPEED = 5
@onready var mower = $LawnMower

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("mower-left"):
		direction = -1
	if Input.is_action_just_pressed("mower-right"):
		direction = 1
	mower.position.x += direction * delta * SPEED
	mower.position.x = clamp(mower.position.x,0,get_viewport_rect().size.x)
