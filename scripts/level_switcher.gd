extends Area2D

@onready var animation_player = $AnimationPlayer

@export_enum("Next Level:+1", "Previous Level:-1") var go_to: int



func _ready():
	animation_player.play("hoover")
	print(10 + go_to)

const FILE_BEGIN = "res://scenes/levels/game_level_"

func _on_body_entered(body):
	if body.is_in_group("Player"):
		var current_sceen_file = get_tree().current_scene.scene_file_path
		print(current_sceen_file)
		var next_level_number = current_sceen_file.to_int() +go_to
		print(next_level_number )
		
		var next_level_path = FILE_BEGIN + str(next_level_number) + ".tscn"
		print(next_level_path)
		get_tree().change_scene_to_file(next_level_path)
