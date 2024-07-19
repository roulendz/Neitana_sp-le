extends Area2D

func _on_body_entered(body):
	GameManager.pieskaitit_pacelto_naudinu()
	queue_free()
