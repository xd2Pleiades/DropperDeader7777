extends State
class_name HumanIdle

var human : CharacterBody2D
var movement : MovementComponent
var home_position : Vector2 = Vector2.ZERO
var target_position : Vector2

var wander_radius : float = 200.0

enum Phase { WALK_OUT, LOOKING, WALK_HOME, WAITING }
var phase : Phase = Phase.WAITING

var look_timer : float = 0.0
var wait_timer : float = 0.0

func Enter():
	human = get_parent().get_parent()
	movement = human.get_node("MovementComponent")
	if home_position == Vector2.ZERO:
		home_position = human.global_position
	start_walk_out()

func start_walk_out():
	var offset = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized() * randf_range(50, wander_radius)
	target_position = home_position + offset
	phase = Phase.WALK_OUT

func start_looking():
	phase = Phase.LOOKING
	look_timer = randf_range(1.0, 3.0)

func start_walk_home():
	target_position = home_position
	phase = Phase.WALK_HOME

func start_waiting():
	phase = Phase.WAITING
	wait_timer = randf_range(0.5, 2.0)

func Update(delta: float):
	var view = human.get_node("ViewComponent")

	match phase:
		Phase.LOOKING:
			look_timer -= delta
			human.rotation += randf_range(-1.0, 1.0) * delta * 2.0
			if look_timer <= 0:
				start_walk_home()
			if view.visible.size() > 0:
				emit_signal("Transitioned", self, "human curious")
		Phase.WAITING:
			wait_timer -= delta
			if wait_timer <= 0:
				start_walk_out()
			if view.visible.size() > 0:
				emit_signal("Transitioned", self, "human curious")

func Physics_Update(_delta: float):
	match phase:
		Phase.WALK_OUT, Phase.WALK_HOME:
			var direction = target_position - human.global_position
			if direction.length() < 5.0:
				human.velocity = Vector2.ZERO
				if phase == Phase.WALK_OUT:
					start_looking()
				else:
					start_waiting()
			else:
				human.velocity = direction.normalized() * movement.get_speed()
		Phase.LOOKING, Phase.WAITING:
			human.velocity = Vector2.ZERO
