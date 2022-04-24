extends Node

var tile_size = Vector2(128, 128)
onready var texture = $Sprite.texture

func _ready():
	var cols = texture.get_width() / tile_size.x
	var rows = texture.get_height() / tile_size.y
	
	var ts = TileSet.new()
	
	for col in range(cols):
		for row in range(rows):
			var region = Rect2(col * tile_size.x, row * tile_size.y, tile_size.x, tile_size.y)
			var id = col + row * 10 # an id unique to its position
			
			ts.create_tile(id)
			ts.tile_set_texture(id, texture)
			ts.tile_set_region(id, region)
			
	ResourceSaver.save("res://assets/terrain_tiles.tres", ts)
