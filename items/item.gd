extends Area2D
@onready var area2d = get_node("Area2D")

signal picked_up


var textures: Dictionary = {
	"cherry": "res://assets/sprites/cherry.png",
	"gem": "res://assets/sprites/gem.png"
}

func init( item_type: String, _position: Vector2) -> void:
	$Sprite2D.texture = load(textures[item_type]) as Texture
	position = _position
	print(position)
	


func _on_body_entered(body: Node2D) -> void:
	print("player got item on body entered")
	picked_up.emit()
	queue_free()
