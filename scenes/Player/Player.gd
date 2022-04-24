extends Area2D

signal health_changed
signal dead

export (PackedScene) var Bullet
export (int) var speed = 200 # (pixels/sec)
export (float) var rotation_speed = 1
export (float) var gun_cooldown = 0.4
export (int) var health = 100

var screen_size
var velocity
var can_shoot = true
var alive = true

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
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

func _process(delta):
	control(delta)
		
	position += velocity
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)
