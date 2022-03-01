extends Area2D

signal hit
signal death
signal health_updated

export var speed = 400.0 #pixels per second
export var max_health = 3

onready var health = max_health

var screen_size = Vector2.ZERO

var direction = Vector2.ZERO

func _ready():
	screen_size = get_viewport_rect().size
	hide()

func _process(delta):	
	position += _get_velocity() * delta
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)

func _get_velocity():
	return _get_direction() * speed
	
func _get_direction():
	direction.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	direction.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	
	if direction.length() > 0:
		direction = direction.normalized()
		$AnimatedSprite.play() # get_node("AnimatedSprite").play
	else:
		$AnimatedSprite.stop()
	
	if direction.x != 0:
		$AnimatedSprite.animation = "right"
		$AnimatedSprite.flip_v = false
		$AnimatedSprite.flip_h = direction.x < 0
	elif direction.y !=0:
		$AnimatedSprite.animation = "up"
		$AnimatedSprite.flip_v = direction.y > 0
	
	return direction

func start(new_position):
	position = new_position
	health = max_health
	show()
	$CollisionShape2D.disabled = false

func _on_Player_body_entered(_body):
	health -= 1
	$CollisionShape2D.set_deferred("disabled", true)
	emit_signal("hit", health)
	
	if health == 0:
		emit_signal("death")
		hide()
		
	yield(get_tree().create_timer(1.0), "timeout")
	$CollisionShape2D.set_deferred("disabled", false)
	
