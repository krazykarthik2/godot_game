extends Enemy

@export var wave_frequency: float = 5.0
@export var wave_amplitude: float = 150.0

var time_passed: float = 0.0
var base_direction: Vector2 = Vector2.DOWN
var perpendicular_direction: Vector2 = Vector2.RIGHT

func _ready() -> void:
	var viewport_size = get_viewport_rect().size
	
	# Spawn at top edge
	global_position = Vector2(randf_range(50, viewport_size.x - 50), -50)
	
	# Base downward movement vector
	base_direction = Vector2.DOWN
	
	# Perpendicular vector for sine oscillation
	perpendicular_direction = Vector2(-base_direction.y, base_direction.x)

func update_movement(delta: float) -> void:
	time_passed += delta
	
	# Sine wave calculation for erratic movement
	var sine_offset = cos(time_passed * wave_frequency) * wave_amplitude
	
	# Forward momentum + wave oscillation
	var forward_velocity = base_direction * speed
	var wave_velocity = perpendicular_direction * sine_offset
	
	velocity = forward_velocity + wave_velocity
