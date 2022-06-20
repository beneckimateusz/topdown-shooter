extends CanvasLayer

var is_running = false
var elapsed_seconds = 0

func start():
	$Label.show()
	is_running = true

func stop():
	is_running = false

func _ready():
	$Label.hide()

func _process(delta):
	if not is_running: return
	
	elapsed_seconds += delta
	var minutes = int(elapsed_seconds / 60)
	var seconds = int(elapsed_seconds) % 60
	
	$Label.text = "%02d:%02d" % [minutes, seconds]
