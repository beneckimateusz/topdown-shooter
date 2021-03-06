extends Node

export (PackedScene) var player_scene
export (PackedScene) var map_scene
export (PackedScene) var monster_scene
export (PackedScene) var exp_orb_scene
export (PackedScene) var health_bar_scene

var player
var map

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func new_game():
	print("Main scene started a new game")

	map = map_scene.instance()
	add_child(map)
	
	spawn_player()
	map.add_player(player)
	
	$SpawnEnemyTimer.start()
	
func spawn_player():
	player = player_scene.instance()
	player.connect("shoot", self, "_on_Player_shoot")
	player.connect("dead", self, "_on_Player_dead")
	
	var health_bar = health_bar_scene.instance()
	health_bar.init(player)
	add_child(health_bar)
	
	$ExperienceBar.init(player)
	$GameTimer.start()

func _on_SpawnEnemyTimer_timeout():
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
	spawned_enemy.connect("dead", self, "_on_Enemy_dead")
	

func get_camera_rect(camera):
	var rect = {"x": 0, "y": 0, "w": 0, "h": 0}
	var cameraPos = camera.get_camera_screen_center()
	var viewportRect = get_viewport().get_visible_rect().size / 2 * camera.zoom
	rect.x = cameraPos.x - viewportRect.x
	rect.y = cameraPos.y - viewportRect.y
	rect.w = cameraPos.x + viewportRect.x
	rect.h = cameraPos.y + viewportRect.y
	return rect

func _on_Player_shoot(_bullet, _position, _direction):
	var bullet = _bullet.instance()
	add_child(bullet)
	bullet.init(_position, _direction)

func _on_Player_dead():
	print("GAME OVER")
	$SpawnEnemyTimer.stop()
	$GameTimer.stop()
	
func _on_Enemy_dead(enemy_pos: Vector2):
	var exp_orb = exp_orb_scene.instance()
	exp_orb.init(enemy_pos)
	exp_orb.connect("collect", self, "_on_ExperienceOrb_collect")
	add_child(exp_orb)
	$EnemyDeadStream.play()
	
func _on_ExperienceOrb_collect():
	$CollectStream.play()
	print("essa")
