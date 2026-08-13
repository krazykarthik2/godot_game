# EnemySpawner.gd
extends Node2D

@export var enemy_scenes: Array[PackedScene] = []
@export var min_spawn_time: float = 0.8
@export var max_spawn_time: float = 2.0

@onready var timer: Timer = $Timer

func _ready() -> void:
	# Connect signal safely if not already connected in editor
	if not timer.timeout.is_connected(_on_timer_timeout):
		timer.timeout.connect(_on_timer_timeout)
	
	# Force timer settings
	timer.one_shot = false
	_start_next_spawn_timer()

func _start_next_spawn_timer() -> void:
	# Set a new random interval and start counting
	timer.wait_time = randf_range(min_spawn_time, max_spawn_time)
	timer.start()

func _on_timer_timeout() -> void:
	if enemy_scenes.is_empty():
		push_warning("No enemy scenes in EnemySpawner array!")
		return

	# 1. Spawn a random enemy
	var random_scene: PackedScene = enemy_scenes.pick_random()
	var enemy_instance = random_scene.instantiate()
	get_parent().add_child(enemy_instance)

	# 2. RESTART the timer for the NEXT enemy
	_start_next_spawn_timer()
