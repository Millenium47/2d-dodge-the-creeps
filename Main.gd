extends Node2D

export (PackedScene) var enemy_scene 

func _ready():
	randomize()

func _on_EnemyTimer_timeout():
	var enemy_spawn_location = $EnemyPath/EnemySpawnLocation
	enemy_spawn_location.unit_offset = randf()
	
	var enemy = enemy_scene.instance()
	add_child(enemy)
	
	enemy.position = enemy_spawn_location.position
	
	var direction = enemy_spawn_location.rotation + PI / 2
	direction += rand_range(-PI / 4, PI / 4)
	enemy.rotation = direction
	
	var velocity = Vector2(rand_range(enemy.min_speed, enemy.max_speed), 0)
	enemy.linear_velocity = velocity.rotated(direction)
