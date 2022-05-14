extends Node2D

var player
var offset = Vector2(0, 60)

func init(initial_player):
	player = initial_player
	
func _process(delta):
	position = player.position + offset
	$Bar.value = player.health
	
	if not player.alive:
		hide()
	
func _ready():
	pass
