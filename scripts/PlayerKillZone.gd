extends Area2D

@onready var timer = $Timer

func _on_body_entered(body):
	print("Es tevi mīlu, spēle beidzās!")
	Engine.time_scale = 0.5
	body.get_node("CollisionShape2D").queue_free()
	timer.start()

func _on_timer_timeout():
	GameManager.cik_naudinas = 0
	GameManager.cik_monstri_killed = 0
	#GameManager.game_start_time = Time.get_ticks_msec() # Reset game start time
	Engine.time_scale = 1.0
	get_tree().reload_current_scene()
"max_distance"
