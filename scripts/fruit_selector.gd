extends Area2D

# Using @export_enum to create dropdown selections in the Inspector
@export_enum("Apple", "Pear", "Grape") var fruit_type : int
@export_enum("Green", "Orange", "Purple", "Red") var fruit_color : int

@onready var sprite_2d = $CollisionShape2D/sprite2D
@onready var animation_player = $AnimationPlayer

func _ready():
	_update_sprite_frame()

func _update_sprite_frame():
	print("fruit_type")
	print(fruit_type)
	var frame_x = fruit_type
	print("fruit_type")
	print(fruit_type)
	var frame_y = fruit_color
	sprite_2d.frame_coords = Vector2(frame_x, frame_y)

func _on_fruit_type_changed(new_value):
	_update_sprite_frame()

func _on_fruit_color_changed(new_value):
	_update_sprite_frame()


func _on_body_entered(body):
	if body.is_in_group("Player"):
		animation_player.play("pick_up")
