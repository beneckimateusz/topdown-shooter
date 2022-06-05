extends Node2D

var WIDTH = 18
var HEIGHT = 12

func get_width():
	return $Ground.cell_size.x * WIDTH
	
func get_height():
	return $Ground.cell_size.y * HEIGHT

