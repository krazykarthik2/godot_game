extends Area2D

func _ready() -> void:
	# Connect signal in code (or do it via the Editor Node Dock)
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _player_entered():
	var manager = get_tree().current_scene
	if manager and manager.has_method("add_coin"):
		manager.add_coin(1)
	queue_free()

func _player_exited():
	pass

func _on_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D and body.name=="player":
		_player_entered()

func _on_body_exited(body: Node2D) -> void:
	if body is CharacterBody2D and body.name=="player":
		_player_exited()
