extends Node

export (PackedScene) var player_scene
export (PackedScene) var map_scene

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func new_game():
	print("Main scene started a new game")
	
	var map = map_scene.instance()
	add_child(map)
	
	var player = player_scene.instance()
	player.set_camera_limits(map)
	
	map.add_child(player)
