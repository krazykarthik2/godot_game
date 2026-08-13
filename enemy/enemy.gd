# Enemy.gd
class_name Enemy
extends CharacterBody2D

@export var speed: float = 150.0
@export var damage: int = 10

# Prevents the enemy from double-hitting the player in a single frame
var has_dealt_damage: bool = false

@onready var collision_shape: CollisionShape2D = $CollisionShape2D

func _physics_process(delta: float) -> void:
	# 1. Custom movement logic overridden by child scripts
	update_movement(delta)
	
	# 2. Move and handle collisions
	move_and_slide()
	handle_player_collisions()
	
	# 3. Off-screen cleanup
	check_out_of_bounds()

# Overridden by Swimmer, Walker, and Fly
func update_movement(_delta: float) -> void:
	pass

func handle_player_collisions() -> void:
	# Stop immediately if damage was already dealt in this frame
	if has_dealt_damage:
		return

	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		
		if collider and collider.has_method("take_damage"):
			has_dealt_damage = true # Lock hit state immediately
			collider.take_damage(damage)
			
			# Disable collision physics safely using set_deferred
			if collision_shape:
				collision_shape.set_deferred("disabled", true)
				
			queue_free() # Destroy enemy node at end of frame
			break # Exit loop instantly

func check_out_of_bounds() -> void:
	var viewport_rect = get_viewport_rect()
	var margin = 100.0 # Safety buffer before deleting
	
	if global_position.x < -margin or global_position.x > viewport_rect.size.x + margin \
	or global_position.y < -margin or global_position.y > viewport_rect.size.y + margin:
		queue_free()
