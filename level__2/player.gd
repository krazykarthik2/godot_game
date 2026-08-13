extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# --- Movement Tuning ---
const ACCELERATION = 1200.0  # How fast you reach top speed
const FRICTION = 100.0       # LOWER value = MORE sliding! (e.g., 200 = ice slide)
const AIR_RESISTANCE = 300.0 # Friction while in mid-air

@onready var collision_shape: CollisionShape2D = $CollisionShape2D


func _ready() -> void:
	get_tree().paused = false

func _physics_process(delta: float) -> void:
	## 1. Apply gravity
	if not is_on_floor():
		velocity += get_gravity() * delta
		#print("applying gravity")
	else:
		#print("not applying gravity")
		pass

	## 2. Handle jump
	if (Input.is_action_just_pressed("ui_up") or Input.is_action_just_pressed("ui_accept")) and is_on_floor():
		velocity.y = JUMP_VELOCITY
		#print("jumping")

	# 3. Handle smooth horizontal movement & sliding
	var direction := Input.get_axis("ui_left", "ui_right")
	#
	#if direction != 0:
		#print("Moving direction: ", direction)
	if direction != 0:
		# Accelerate towards max speed
		velocity.x = move_toward(velocity.x, direction * SPEED, ACCELERATION * delta)
	else:
		# Choose ground friction or air drag
		var active_friction = FRICTION if is_on_floor() else AIR_RESISTANCE
		#var active_friction=.1
		pass
		# Slide smoothly down to 0 speed over time
		velocity.x = move_toward(velocity.x, 0, active_friction * delta)

	clamp_to_viewport()
	move_and_slide()

func clamp_to_viewport() -> void:
	var viewport_rect = get_viewport_rect()
	var shape = collision_shape.shape
	var unscaled_size := Vector2.ZERO

	if shape is CapsuleShape2D:
		unscaled_size = Vector2(shape.radius * 2.0, shape.height)
	elif shape is RectangleShape2D:
		unscaled_size = shape.size
	else:
		return

	var actual_size = unscaled_size * collision_shape.global_scale
	var offset = collision_shape.position * global_scale

	var left_limit = (actual_size.x / 2.0) - offset.x
	var right_limit = (actual_size.x / 2.0) + offset.x
	var top_limit = (actual_size.y / 2.0) - offset.y
	var bottom_limit = (actual_size.y / 2.0) + offset.y

	if global_position.x < left_limit or global_position.x > viewport_rect.size.x - right_limit:
		global_position.x = clamp(global_position.x, left_limit, viewport_rect.size.x - right_limit)
		
	if global_position.y < top_limit or global_position.y > viewport_rect.size.y - bottom_limit:
		global_position.y = clamp(global_position.y, top_limit, viewport_rect.size.y - bottom_limit)
