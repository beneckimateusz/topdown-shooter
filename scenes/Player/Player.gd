extends Area2D

signal shoot
signal health_changed
signal dead

export (PackedScene) var Bullet
export (int) var speed = 300 # (pixels/sec)
export (float) var rotation_speed = 2
export (float) var gun_cooldown = 0.4
export (int) var health = 100

var velocity
var can_shoot = true
var alive = true

var level = 1
var current_exp = 0
var next_level_threshold = 100

# Called when the node enters the scene tree for the first time.
func _ready():
	$GunTimer.wait_time = gun_cooldown
	
func control(delta):
	$Barrel.look_at(get_global_mouse_position())
	
	# tank rotation
	var rotation_direction = 0
	if Input.is_action_pressed("turn_right"):
		rotation_direction += 1
	if Input.is_action_pressed("turn_left"):
		rotation_direction -= 1
		
	rotation += rotation_direction * rotation_speed * delta
	
	# tank movement
	velocity = Vector2.ZERO
	if Input.is_action_pressed("move_forward"):
		velocity.x = speed
	if Input.is_action_pressed("move_backward"):
		velocity.x = -speed / 2
		
	velocity = velocity.rotated(rotation) * delta
	
	# shooting
	if Input.is_action_pressed("click"):
		shoot()

func shoot():
	if alive && can_shoot:
		can_shoot = false
		$GunTimer.start()
		$GunStream.play()
		
		var dir = Vector2(1, 0).rotated($Barrel.global_rotation)
		emit_signal("shoot", Bullet, $Barrel/Muzzle.global_position, dir)
	
func _process(delta):
	if not alive:
		return
	control(delta)
	position += velocity

func _on_Player_body_entered(enemy):
	health -= 10
	
	enemy.collide_with_player()
	
	if (health <= 0):
		emit_signal("dead")
		alive = false
		hide()
			
func _on_Player_area_entered(area: Area2D):
	# check if we collided with the experience orb
	if not area.get_collision_layer_bit(3): return

	current_exp += 10
	if current_exp >= next_level_threshold:
		current_exp -= next_level_threshold
		level += 1
		$LevelUpStream.play()

func _on_GunTimer_timeout():
	can_shoot = true


