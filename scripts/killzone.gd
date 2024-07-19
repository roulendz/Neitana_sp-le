extends Area2D

@onready var timer = $Timer

signal enemy_killed  # Add this line to define the signal

func _on_body_entered(_body):
	print("Enemy Killed")
	emit_signal("enemy_killed")  # Emit a signal when the enemy is killed
	kill_enemie()

func _on_timer_timeout():
	Engine.time_scale = 1.0
	#get_tree().reload_current_scene()
	
func kill_enemie():
	queue_free()
