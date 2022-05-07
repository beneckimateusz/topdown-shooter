extends KinematicBody2D

export (int) var health
export (int) var speed
var target

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func init(player):
	target = player
	
func _physics_process(delta):
	if target == null: return
	
	var dir = (target.position - global_position).normalized()
	move_and_collide(dir * speed * delta)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func collide_with_player():
#	queue_free()
	pass

func take_damage(damage):
	health -= damage
	if health <= 0:
		queue_free()
