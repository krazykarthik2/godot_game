extends CanvasLayer

func _ready() -> void:
	# Make sure this node processes even when the rest of the game is paused!
	process_mode = Node.PROCESS_MODE_ALWAYS

func _on_retry_button_pressed() -> void:
	get_tree().paused = false # Unpause game
	get_tree().reload_current_scene() # Restart level
	queue_free()


func _on_button_pressed() -> void:
	_on_retry_button_pressed()

func _on_nextlvl_pressed() -> void:
	get_tree().paused = false # Unpause game
	
	var current_path: String = get_tree().current_scene.scene_file_path

	# Find the digit(s) in the current scene path
	var regex := RegEx.new()
	regex.compile("\\d+")
	var result := regex.search(current_path)

	if result:
		var current_num := result.get_string().to_int()
		var next_num := current_num + 1

		# Reconstruct path using Godot string formatting (%)
		# Adjust underscore count if you have single vs double underscores in your folder name:
		var next_path := "res://level__%d/level%d.tscn" % [next_num, next_num]

		# Check if the next level file exists before loading
		if ResourceLoader.exists(next_path):
			get_tree().change_scene_to_file(next_path)
			queue_free()
		else:
			print("Reached last level or path not found: ", next_path)
