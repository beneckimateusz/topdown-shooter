extends KinematicBody2D

export (int) var health
export (int) var speed
export (int) var knockback_distance

var target
var collided_last_frame = false
var is_player_alive = true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func init(player):
	target = player
	target.connect("dead", self, "_on_Player_dead")
	
func _physics_process(delta):
	if target == null || !is_player_alive: return
	

	var dir = (target.position - global_position).normalized()

	if collided_last_frame:
		collided_last_frame = false
		move_and_collide(-dir * knockback_distance)
	else:
		move_and_collide(dir * speed * delta)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func collide_with_player():
	collided_last_frame = true
	take_damage(50)

func take_damage(damage):
	health -= damage
	if health <= 0:
		queue_free()
		
func _on_Player_dead():
	is_player_alive = false
	
