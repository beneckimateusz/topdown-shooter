extends Area2D

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

func set_camera_limits(map):
	var map_limits = map.get_node("Ground").get_used_rect()
	var map_cell_size = map.get_node("Ground").cell_size
	
	$Camera2D.limit_left = map_limits.position.x * map_cell_size.x
	$Camera2D.limit_right = map_limits.end.x * map_cell_size.x
	$Camera2D.limit_top = map_limits.position.y * map_cell_size.y
	$Camera2D.limit_bottom = map_limits.end.y * map_cell_size.y
	
func _process(delta):
	control(delta)
	position += velocity
	


func _on_Player_body_entered(enemy):
	health -= 10
	enemy.collide_with_player()
	
	
