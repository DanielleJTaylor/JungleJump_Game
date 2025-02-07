extends Node

var num_levels: int = 3

var current_level: int = 0
var game_scene: String = "res://main/main.tscn"
var title_screen: String = "res://ui/title_scene.tscn"

func restart() -> void:
	current_level = 0
	get_tree().change_scene_to_file(title_screen)

func next_level() -> void:
	current_level += 1
	if current_level <= num_levels:
		call_deferred("_change_to_scene", game_scene)
	else:
		restart()
		
func _change_to_scene(scene_path: String) -> void:
	get_tree().change_scene_to_file(scene_path)
