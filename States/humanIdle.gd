extends State
class_name HumanIdle

@onready var human = CharacterBody2D
@onready var move_speed := 10.0

var move_direction : Vector2
var wander_time : float

func randomize_wander():
	move_direction = Vector2(randf_range(-1,1), randf_range(-1,1)).normalized()
	wander_time = randf_range(1,3)

func Enter():
	randomize_wander()

func Update(delta: float):
	if wander_time > 0:
		wander_time -= delta

func Physics_Update(_delta: float):
	if human:
		human.velocity = move_direction * move_speed
