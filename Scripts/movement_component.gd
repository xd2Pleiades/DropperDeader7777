extends Node
class_name MovementComponent

enum MovementState { crawl, crouch, walk, jog, run, sprint }

var current_state : MovementState = MovementState.walk

var speed_multipliers : Dictionary = {
	MovementState.crawl: 0.40,
	MovementState.crouch: 0.50,
	MovementState.walk: 1.00,
	MovementState.jog: 1.60,
	MovementState.run: 2.20,
	MovementState.sprint: 4.80
}

var stamina_drain : Dictionary = {
	MovementState.crawl: 0.0,
	MovementState.crouch: 0.0,
	MovementState.walk: 0.0,
	MovementState.jog: 2.50,
	MovementState.run: 4.00,
	MovementState.sprint: 10.00
}

var stamina_recovery : Dictionary = {
	MovementState.crawl: 3.0,
	MovementState.crouch: 4.0,
	MovementState.walk: 5.0,
	MovementState.jog: 0.0,
	MovementState.run: 0.0,
	MovementState.sprint: 0.0
}

const base_speed : float = 100.0
const max_stamina : float = 100.0
var stamina : float = max_stamina

func _process(delta: float):
	var drain = stamina_drain[current_state]
	var recovery = stamina_recovery[current_state]

	if drain > 0:
		stamina -= drain * delta
		if stamina <= 0:
			stamina = 0
			set_state(MovementState.walk)
	elif recovery > 0:
		stamina = min(stamina + recovery * delta, max_stamina)

func set_state(new_state: MovementState):
	current_state = new_state

func get_speed() -> float:
	return base_speed * speed_multipliers[current_state]
