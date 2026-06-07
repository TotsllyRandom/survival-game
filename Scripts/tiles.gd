extends Node2D

var mouse_placement: Vector2
var mouse_offset: Vector2
var mouse_down: bool = false
var real_position: Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	real_position += mouse_offset
	for child in get_children():
		if child.name == "Water":
			child.position = Vector2(
				-64 + fposmod(real_position.x, 32.0),
				-64 + fposmod(real_position.y, 36.0)
			)
		else:
			child.position = Vector2(
				-64 + real_position.x,
				-70 + real_position.y
			)
	
	@warning_ignore("int_as_enum_without_cast")
	if Input.is_mouse_button_pressed(1):
		if mouse_down == false:
			mouse_placement = get_global_mouse_position()
		mouse_down = true
	else:
		mouse_down = false
		mouse_offset = Vector2(0.0,0.0)
		
	if mouse_down:
		mouse_offset = (get_global_mouse_position() - mouse_placement) / scale
		mouse_placement = get_global_mouse_position()
