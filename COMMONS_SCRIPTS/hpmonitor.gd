extends CanvasLayer

# Optional: Drag your Player node here in the Inspector to auto-connect!
@export var player: CharacterBody2D

@onready var hp_label: Label = $hp

func _ready() -> void:
	if player:
		# 1. Connect to the player's health signal
		player.health_changed.connect(update_hp_display)
		# 2. Set initial display value
		update_hp_display(player.health)

func update_hp_display(current_hp: int) -> void:
	if hp_label:
		hp_label.text = "HP: " + str(current_hp)
