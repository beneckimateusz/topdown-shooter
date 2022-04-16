extends CanvasLayer

signal start_game

func _ready():
	pass # Replace with function body.

func on_StartButton_pressed():
	$StartButton.hide()
	$GameTitle.hide()
	emit_signal("start_game")
