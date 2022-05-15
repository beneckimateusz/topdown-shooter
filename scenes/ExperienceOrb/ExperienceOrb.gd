extends Area2D

signal collect

func init(initial_position: Vector2):
	position = initial_position

func _ready():
	pass

func _on_Area2D_area_entered(body):
	emit_signal("collect")
	queue_free()
