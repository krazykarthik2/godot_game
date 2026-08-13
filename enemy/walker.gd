extends Enemy

var walk_direction: float = 1.0

func _ready() -> void:
	var viewport_size = get_viewport_rect().size
	
	# Pick Left (0) or Right (1)
	if randi() % 2 == 0:
		global_position = Vector2(-50, randf_range(50, viewport_size.y - 50))
		walk_direction = 1.0 # Walk Right
	else:
		global_position = Vector2(viewport_size.x + 50, randf_range(50, viewport_size.y - 50))
		walk_direction = -1.0 # Walk Left
		
	# Flip sprite if walking left
	if $walker.find_child("walker"):
		$walker.find_child("walker").flip_h = (walk_direction < 0)

func update_movement(_delta: float) -> void:
	velocity = Vector2(walk_direction * speed, 0)
