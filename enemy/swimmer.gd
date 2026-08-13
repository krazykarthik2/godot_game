
extends Enemy

var move_direction: Vector2 = Vector2.DOWN

func _ready() -> void:
	var viewport_size = get_viewport_rect().size
	
	# Pick a random edge: 0 = Top, 1 = Bottom, 2 = Left, 3 = Right
	var edge = randi() % 4
	match edge:
		0: global_position = Vector2(randf_range(0, viewport_size.x), -50)
		1: global_position = Vector2(randf_range(0, viewport_size.x), viewport_size.y + 50)
		2: global_position = Vector2(-50, randf_range(0, viewport_size.y))
		3: global_position = Vector2(viewport_size.x + 50, randf_range(0, viewport_size.y))
	
	# Point toward a random position near the middle of the screen
	var center_target = Vector2(
		viewport_size.x / 2.0 + randf_range(-200, 200),
		viewport_size.y / 2.0 + randf_range(-200, 200)
	)
	move_direction = (center_target - global_position).normalized()
	
	# Rotate sprite toward movement direction
	rotation = move_direction.angle()

func update_movement(_delta: float) -> void:
	velocity = move_direction * speed
