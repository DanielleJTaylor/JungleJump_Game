extends Node

func _ready() -> void:
	var level_num: String = str(GameState.current_level).pad_zeros(2)
	var path: String = "res://levels/level_%s.tscn" % level_num
	var level: Node = load(path).instantiate() as Node
	add_child(level) 
