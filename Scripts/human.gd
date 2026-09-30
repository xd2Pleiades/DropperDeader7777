extends CharacterBody2D
class_name Humanoid

func _physics_process(delta):
	if velocity != Vector2.ZERO:
		rotation = velocity.angle() + PI/2
	move_and_slide()
