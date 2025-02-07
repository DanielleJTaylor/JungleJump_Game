extends MarginContainer

var _life_counter: Array[Node] = [] # Will store child controls of LifeCounter
var _score_label: Label = null # Reference to the Score label

# Getter for life_counter
func get_life_counter() -> Array[Node]:
	if _life_counter.is_empty():
		var life_counter_node: HBoxContainer = $HBoxContainer/LifeCounter
		_life_counter = life_counter_node.get_children() as Array[Node]
		print("got lives")
	return _life_counter
	
# Getter for score_label
func get_score_label() -> Label:
	if _score_label == null:
		_score_label = $HBoxContainer/Score as Label
	return _score_label

# Updates the visibility of life icons
func update_life(value: int) -> void:
	for heart in range(get_life_counter().size()):
		get_life_counter()[heart].visible = value > heart
	
# Updates the score display
func update_score(value: int) -> void:
	$Pickup.play()
	get_score_label().text = str(value)
