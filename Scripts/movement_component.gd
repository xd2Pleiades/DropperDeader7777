extends Node
class_name MovementComponent

enum MovementState { CRAWL, CROUCH, WALK, JOG, RUN, SPRINT }

var current_state : MovementState = MovementState.WALK

var speed_multipliers : Dictionary = {
	MovementState.CRAWL: 0.40,
	MovementState.CROUCH: 0.50,
	MovementState.WALK: 1.00,
	MovementState.JOG: 1.60,
	MovementState.RUN: 2.20,
	MovementState.SPRINT: 4.80
}

var stamina_drain : Dictionary = {
	MovementState.CRAWL: 0.0,
	MovementState.CROUCH: 0.0,
	MovementState.WALK: 0.0,
	MovementState.JOG: 2.50,
	MovementState.RUN: 4.00,
	MovementState.SPRINT: 10.00
}

var stamina_recovery : Dictionary = {
	MovementState.CRAWL: 3.0,
	MovementState.CROUCH: 4.0,
	MovementState.WALK: 5.0,
	MovementState.JOG: 0.0,
	MovementState.RUN: 0.0,
	MovementState.SPRINT: 0.0
}

const BASE_SPEED : float = 100.0
const MAX_STAMINA : float = 100.0
var stamina : float = MAX_STAMINA

func _process(delta: float):
	var drain = stamina_drain[current_state]
	var recovery = stamina_recovery[current_state]

	if drain > 0:
		stamina -= drain * delta
		if stamina <= 0:
			stamina = 0
			set_state(MovementState.WALK)
	elif recovery > 0:
		stamina = min(stamina + recovery * delta, MAX_STAMINA)

func set_state(new_state: MovementState):
	current_state = new_state

func get_speed() -> float:
	return BASE_SPEED * speed_multipliers[current_state]
