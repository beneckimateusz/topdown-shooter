extends CanvasLayer

var player

func init(initial_player):
	player = initial_player
	show()
	
func _process(delta):
	if not player: return
	
	$Bar.max_value = player.next_level_threshold
	$Bar.value = player.current_exp
	$Label.text = "Level: %s" % player.level
	
func _ready():
	$Bar.hide() # don't show up in the menu
	$Label.hide()

func show():
	$Bar.show()
	$Label.show()
	
