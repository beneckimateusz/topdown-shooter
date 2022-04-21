extends Node

export(PackedScene) var player_scene

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func new_game():
	print("Main scene started a new game")
	
	var player = player_scene.instance()
	add_child(player)
