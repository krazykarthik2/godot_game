extends CanvasLayer

@onready var coin_label: Label = $COINS
@onready var hpbar:ProgressBar = $HP

func _ready() -> void:
	# 'owner' points directly to the root node of this scene (your Level Node2D)
	var manager = owner
	
	if manager and manager.has_signal("coins_updated"):
		print("Manager (Root Scene) found!")
		manager.coins_updated.connect(_on_coins_updated)
		manager.health_changed.connect(_on_health_updated)
		_on_coins_updated(manager.coins)
		_update_maxhealth(manager.INITIAL_HEALTH)
		_on_health_updated(manager.health)
	else:
		print("Manager (Root Scene) not found!")

func _on_coins_updated(coins: int) -> void:
	coin_label.text = "Coins: " + str(coins)

func _on_health_updated(health:int) ->void:
	hpbar.value = health

func _update_maxhealth(maxhealth:int) -> void:
	hpbar.max_value = maxhealth
