extends Node

export (PackedScene) var player_scene
export (PackedScene) var map_scene
export(PackedScene) var monster_scene

var player

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func new_game():
	print("Main scene started a new game")
	

	var map = map_scene.instance()
	add_child(map)
	
	player = player_scene.instance()
	player.set_camera_limits(map)
	
	map.add_child(player)
	
	$SpawnEnemyTimer.start()


func _on_SpawnEnemyTimer_timeout():
	var sampler = get_node("ScreenEdgePath/Sampler")
	sampler.offset = randi()
	
	var camera_rect = get_camera_rect(player.get_node("Camera2D"))
	
	var min_x = camera_rect.x; var min_y = camera_rect.y
	var max_x = camera_rect.w; var max_y = camera_rect.h
	
	var edge = randi() % 4
	
	var x; var y
	if edge == 0: # top
		x = rand_range(min_x, max_x)
		y = min_y
	elif edge == 1: # right
		x = max_x
		y = rand_range(min_y, max_y)
	elif edge == 2: # bottom	
		x = rand_range(min_x, max_x)
		y = max_y
	else: # left
		x = min_x
		y = rand_range(min_y, max_y)
	
	var spawned_enemy = monster_scene.instance()
	add_child(spawned_enemy)
	
	spawned_enemy.position = Vector2(x, y)
	spawned_enemy.init(player)


func get_camera_rect(camera):
	var rect = {"x": 0, "y": 0, "w": 0, "h": 0}
	var cameraPos = camera.get_camera_screen_center()
	var viewportRect = get_viewport().get_visible_rect().size / 2 * camera.zoom
	rect.x = cameraPos.x - viewportRect.x
	rect.y = cameraPos.y - viewportRect.y
	rect.w = cameraPos.x + viewportRect.x
	rect.h = cameraPos.y + viewportRect.y
	return rect
