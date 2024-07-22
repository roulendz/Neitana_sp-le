extends CharacterBody2D

enum State {
	WAKEUP,
	WALKING,
	DEAD,
}

const WALK_SPEED = 22.0

var _state := State.WAKEUP


@onready var enemy_killzone = $EnemyKillzone
#@onready var timer = $Timer
@onready var gravity: int = ProjectSettings.get("physics/2d/default_gravity")
@onready var platform_detector := $PlatformDetector as RayCast2D
@onready var floor_detector_left := $RayCastLeft as RayCast2D
@onready var floor_detector_right := $RayCastRight as RayCast2D
@onready var animation_player := $AnimationPlayer as AnimationPlayer
@onready var collision_shape := $CollisionShape2D as CollisionShape2D  # Reference to CollisionShape2D

func _ready() -> void:
	animation_player.connect("animation_finished", Callable(self, "_on_animation_finished"))
	enemy_killzone.connect("enemy_killed", Callable(self, "_on_enemy_killed"))  # Connect the signal to a handler

func _physics_process(delta: float) -> void:
	if _state == State.WAKEUP:
		if animation_player.current_animation != "wake_up":
			animation_player.play("wake_up")
		return

	if _state == State.WALKING and velocity.is_zero_approx():
		velocity.x = WALK_SPEED
	
	velocity.y += gravity * delta
	
	if not floor_detector_left.is_colliding():
		velocity.x = WALK_SPEED
	elif not floor_detector_right.is_colliding():
		velocity.x = -WALK_SPEED
	
	if is_on_wall():
		velocity.x = -velocity.x
	
	move_and_slide()

	var animation := get_new_animation()
	if animation != animation_player.current_animation:
		animation_player.play(animation)


func destroy() -> void:
	GameManager.saskaitit_killed_monstrus()
	_state = State.DEAD
	#animation_player.play("destroy")
	velocity = Vector2.ZERO

	# Defer disabling the collision shape
	call_deferred("disable_collision_shape")  

func disable_collision_shape():
	collision_shape.set_disabled(true) 

func get_new_animation() -> StringName:
	var animation_new: StringName
	if _state == State.WALKING:
		if velocity.x == 0:
			animation_new = "idle"
		else:
			if velocity.x < 0:
				animation_new = "walk_left"
			else:
				animation_new = "walk_right"
	else:
		animation_new = "destroy"
		
	return animation_new

func _on_animation_finished(anim_name: String) -> void:
	if anim_name == "wake_up":
		_state = State.WALKING

func _on_enemy_killed() -> void:	
	
	destroy()  # Call destroy when the enemy is killed
