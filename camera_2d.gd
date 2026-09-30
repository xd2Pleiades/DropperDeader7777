extends Camera2D

@export var speed: float = 500.0
@export var edge_margin: float = 20.0
@export var zoom_speed: float = 0.1
@export var min_zoom: float = 0.5
@export var max_zoom: float = 2.0

var dragging: bool = false

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_MIDDLE:
			dragging = event.pressed
		
		elif event.button_index == MOUSE_BUTTON_WHEEL_UP:
			zoom_camera(zoom_speed)
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			zoom_camera(-zoom_speed)

	elif event is InputEventMouseMotion and dragging:
		position -= event.relative / zoom.x

func _process(delta: float) -> void:
	var direction := Vector2.ZERO
	# Movement Controls
	direction.x = Input.get_axis("camera_left", "camera_right")
	direction.y = Input.get_axis("camera_up", "camera_down")
	
	var wasd_active = direction != Vector2.ZERO
	
	if not dragging and not wasd_active:
		var mouse_pos = get_viewport().get_mouse_position()
		var screen_size = get_viewport().get_visible_rect().size
		# Edge Scrolling
		if mouse_pos.x < edge_margin:
			direction.x = -1.0
		elif mouse_pos.x > screen_size.x - edge_margin:
			direction.x = 1.0
			
		if mouse_pos.y < edge_margin:
			direction.y = -1.0
		elif mouse_pos.y > screen_size.y - edge_margin:
			direction.y = 1.0

	position += direction.normalized() * speed * delta

func zoom_camera(amount: float) -> void:
	var new_zoom = zoom + Vector2(amount, amount)
	zoom = new_zoom.clamp(Vector2(min_zoom, min_zoom), Vector2(max_zoom, max_zoom))
