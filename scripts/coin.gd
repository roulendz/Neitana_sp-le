extends Area2D
@onready var animation_player = $AnimationPlayer

func _on_body_entered(body):
	GameManager.pieskaitit_pacelto_naudinu()
	animation_player.play("pickup")
