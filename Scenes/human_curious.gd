extends State
class_name HumanCurious

var human : CharacterBody2D
var movement : MovementComponent
var view : ViewComponent

var target : CharacterBody2D

var curiosity_timer : float = 30.0
var stare_timer : float = 0.0
var personal_space : float = 150.0

enum Phase { stare, walk_toward, walk_away }
var phase : Phase = Phase.stare

func Enter():
	human = get_parent().get_parent()
	movement = human.get_node("MovementComponent")
	view = human.get_node("ViewComponent")
	curiosity_timer = 30.0
	stare_timer = 10.0
	phase = Phase.stare
	if view.visible.size() > 0:
		target = view.visible[0]

func Update(delta: float):
	curiosity_timer -= delta

	if curiosity_timer <= 0:
		phase = Phase.walk_away

	match phase:
		Phase.stare:
			if target:
				var direction = target.global_position - human.global_position
				human.rotation = lerp_angle(human.rotation, direction.angle() + PI/2, delta * 5.0)
				if direction.length() < personal_space:
					phase = Phase.walk_away
			stare_timer -= delta
			if stare_timer <= 0:
				phase = Phase.walk_toward

		Phase.walk_toward:
			if target:
				var direction = target.global_position - human.global_position
				if direction.length() < personal_space:
					phase = Phase.walk_away

func Physics_Update(_delta: float):
	match phase:
		Phase.stare:
			human.velocity = Vector2.ZERO

		Phase.walk_toward:
			if target:
				var direction = target.global_position - human.global_position
				human.rotation = lerp_angle(human.rotation, direction.angle() + PI/2, _delta * 5.0)
				if direction.length() < personal_space:
					human.velocity = Vector2.ZERO
				else:
					human.velocity = direction.normalized() * movement.get_speed()
			else:
				phase = Phase.walk_away

		Phase.walk_away:
			var home = human.get_node("State Machine/Human Idle").home_position
			var direction = home - human.global_position
			human.rotation = lerp_angle(human.rotation, direction.angle() + PI/2, _delta * 5.0)
			if direction.length() < 5.0:
				human.velocity = Vector2.ZERO
				emit_signal("Transitioned", self, "human idle")
			else:
				human.velocity = direction.normalized() * movement.get_speed()
