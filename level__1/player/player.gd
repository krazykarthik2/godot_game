extends CharacterBody2D

const SPEED = 300.0
const INITIAL_HEALTH = 100
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@export var health:int = INITIAL_HEALTH

signal health_changed(new_health:int)


const GAME_OVER_UI = preload("res://COMMONS/game_over.tscn")

func _physics_process(_delta: float) -> void:
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = direction * SPEED
	move_and_slide()
	clamp_to_viewport()

func clamp_to_viewport() -> void:
	
	var viewport_rect = get_viewport_rect()

	# 1. Calculate actual size taking both Shape size and Node global_scale into account
	var actual_size = collision_shape.shape.size * collision_shape.global_scale
	
	# 2. Account for any position offset of the CollisionShape2D relative to CharacterBody2D
	var offset = collision_shape.position * global_scale

	# 3. Calculate exact distance from Player origin (0,0) to each outer edge
	var left_limit = (actual_size.x / 2.0) - offset.x
	var right_limit = (actual_size.x / 2.0) + offset.x
	var top_limit = (actual_size.y / 2.0) - offset.y
	var bottom_limit = (actual_size.y / 2.0) + offset.y

	# 4. Clamp within viewport rect
	global_position.x = clamp(global_position.x, left_limit, viewport_rect.size.x - right_limit)
	global_position.y = clamp(global_position.y, top_limit, viewport_rect.size.y - bottom_limit)

func take_damage(amount: int) -> void:
	health -= amount
	print("Player Health: ", health)
	if health < 0:health=0
	if health==0:die()
	health_changed.emit(health)

func die() -> void:
	print("Player Died!")
	var game_over_instance = GAME_OVER_UI.instantiate()
	get_tree().root.add_child(game_over_instance)

	# 2. Pause physics, movement, and spawner logic
	get_tree().paused = true
	queue_free()
