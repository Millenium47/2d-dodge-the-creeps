extends Area2D

export var speed = 400.0 #pixels per second

signal hit

var screen_size = Vector2.ZERO

var direction = Vector2.ZERO

func _ready():
	screen_size = get_viewport_rect().size

func _process(delta):	
	position += _get_direction() * speed * delta
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)
	

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

func _start(new_position):
	position = new_position
	show()
	$CollisionShape2D.disabled = false

func _on_Player_body_entered(body):
	hide()
	$CollisionShape2D.set_deferred("disabled", true)
	emit_signal("hit")
	
