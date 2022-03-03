extends Node2D

export (PackedScene) var enemy_scene 

var score: = 0
var health: = 3

func _ready():
	randomize()

func new_game():
	score = 0
	$HUD.update_score(score)
	$HUD.update_health(health)
	
	get_tree().call_group("enemies", "queue_free")
	$Player.start($PlayerStartPosition.position)
	
	$SpawnDelayTimer.start()
	$Music.play()
	$HUD.show_message("Get ready...")
	
	yield($SpawnDelayTimer, "timeout") # wait until signal
	$ScoreTimer.start()
	$EnemyTimer.start()

func lose_health(health):
	$HitSound.play()
	update_health(health)
	
func update_health(health):
	$HUD.update_health(health)

func game_over():
	$ScoreTimer.stop()
	$EnemyTimer.stop()
	$HUD.show_game_over()
	$Music.stop()
	$GameOverSound.play()

func heal():
	if health < 3:
		health += 1
		update_health(health)

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


func _on_ScoreTimer_timeout():
	score += 1
	$HUD.update_score(score)
