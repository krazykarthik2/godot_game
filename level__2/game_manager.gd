extends Node2D


const INITIAL_HEALTH = 100
@export var health: int = INITIAL_HEALTH


const GAME_OVER_UI = preload("res://COMMONS/game_over.tscn")
const LEVEL_FINISH_UI = preload("res://COMMONS/level_finish.tscn")

signal coins_updated(coins: int)
signal health_changed(new_health: int)

var coins: int = 0

func add_coin(coin_count: int = 1) -> void:
	coins += coin_count
	coins_updated.emit(coins)


func take_damage(amount: int) -> void:
	health -= amount
	print("Player Health: ", health)
	if health < 0:
		health = 0
	health_changed.emit(health)
	if health == 0:
		die()


func die() -> void:
	print("Player Died!")
	var game_over_instance = GAME_OVER_UI.instantiate()
	get_tree().root.add_child(game_over_instance)
	get_tree().paused = true
	#queue_free()

func finish() -> void:
	print("Level complete")
	var lvl_finish_instance = LEVEL_FINISH_UI.instantiate()
	get_tree().root.add_child(lvl_finish_instance)
	get_tree().paused = true
	#queue_free()
