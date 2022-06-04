extends Node2D

export (PackedScene) var map_scene

# stores 9 tilemap segments, stored in row-major order
var segments: Array = []
var player

func _ready():
	for i in range(9):
		var segment = map_scene.instance()
		
		var x_bias = [-1, 0, 1][i % 3]
		var y_bias = [-1, 0, 1][floor(i / 3)]
		print(x_bias, y_bias)
		
		segment.set_position(
			Vector2(x_bias * segment.get_width(), y_bias * segment.get_height())
		)
		segments.push_back(segment)
		add_child(segment)

func _process(delta):
	if not player: return
	
	var center_tile = segments[4]
	var x_bias = -1 if player.position.x < center_tile.position.x else (0 if player.position.x < center_tile.position.x + center_tile.get_width() else 1)
	var y_bias = -1 if player.position.y < center_tile.position.y else (0 if player.position.y < center_tile.position.y + center_tile.get_height() else 1)
	
	if x_bias != 0 || y_bias != 0:
		move(x_bias, y_bias)

func add_player(new_player):
	player = new_player
	add_child(player)

func move(x, y):
	move_x(x)
	move_y(y)
	
func move_x(x):
	if x == 0: return
	var new_segments = []
	for y in range(3):
		var left = segments[3 * y + 0]
		var center = segments[3 * y + 1]
		var right = segments[3 * y + 2]
		
		if x < 0: # move left
			right.position = left.position - Vector2(left.get_width(), 0)
			new_segments.append_array([right, left, center])
		else: # move right
			left.position = right.position + Vector2(right.get_width(), 0)
			new_segments.append_array([center, right, left])
	segments = new_segments
	
func move_y(y):
	if y == 0: return
	var new_segments = []
	new_segments.resize(9)
	for x in range(3):
		var top = segments[3 * 0 + x]
		var center = segments[3 * 1 + x]
		var bottom = segments[3 * 2 + x]
		
		if y < 0: # move up
			bottom.position = top.position - Vector2(0, top.get_height())
			new_segments[3 * 0 + x] = bottom
			new_segments[3 * 1 + x] = top
			new_segments[3 * 2 + x] = center
		else: # move down
			top.position = bottom.position + Vector2(0, bottom.get_height())
			new_segments[3 * 0 + x] = center
			new_segments[3 * 1 + x] = bottom
			new_segments[3 * 2 + x] = top
	segments = new_segments
