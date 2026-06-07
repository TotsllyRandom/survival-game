extends Node2D

var mouse_placement: Vector2i
var mouse_offset: Vector2i
var mouse_down: bool

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	position.x = mouse_offset.x % int(32 * scale.x)
	position.y = mouse_offset.y % int(32 * scale.y)
	
	@warning_ignore("int_as_enum_without_cast")
	if Input.is_mouse_button_pressed(1) and !mouse_down:
		mouse_down = true
		mouse_placement = get_global_mouse_position()
		mouse_placement.x -= mouse_offset.x
		mouse_placement.y -= mouse_offset.y
	
	if mouse_down:
		@warning_ignore("int_as_enum_without_cast")
		if !Input.is_mouse_button_pressed(1):
			mouse_down = false
		else:
			@warning_ignore("narrowing_conversion")
			mouse_offset.y = get_global_mouse_position().y - mouse_placement.y
			@warning_ignore("narrowing_conversion")
			mouse_offset.x = get_global_mouse_position().x - mouse_placement.x
		
		
