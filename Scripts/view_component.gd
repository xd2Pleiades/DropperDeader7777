extends Node
class_name ViewComponent

@export var cone_angle : float = 90.0
var nearby : Array = []
var visible : Array = []

func is_in_cone(target) -> bool:
	var to_target = (target.global_position - get_parent().global_position).normalized()
	var facing = Vector2.from_angle(get_parent().rotation)
	var dot = facing.dot(to_target)
	return dot > cos(deg_to_rad(cone_angle / 2.0))

func has_line_of_sight(target) -> bool:
	var space = get_parent().get_world_2d().direct_space_state
	var query = PhysicsRayQueryParameters2D.create(
		get_parent().global_position,
		target.global_position
	)
	query.exclude = [get_parent()]
	var result = space.intersect_ray(query)
	if result.is_empty():
		return true
	return result.collider == target

func _process(_delta):
	visible.clear()
	for body in nearby:
		if is_in_cone(body) and has_line_of_sight(body):
			visible.append(body)

func _on_area_2d_body_entered(body):
	nearby.append(body)

func _on_area_2d_body_exited(body):
	nearby.erase(body)
