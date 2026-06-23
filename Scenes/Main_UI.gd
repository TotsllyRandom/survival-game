extends CanvasLayer

var height: int = 200
@export var border: int
@export var anchor: int



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var viewport_size = get_viewport().get_visible_rect().size
	$Bottom.size.x = (viewport_size.x - (border*2)) / scale.x
	$Bottom.size.y = (height) / scale.y
	$Bottom/Control.size.x = $Bottom.size.x - 6
	$Bottom/Control.size.y = $Bottom.size.y - 6
	if anchor == 1:
		offset = Vector2(border, (viewport_size.y - height) - border)
	else: 
		offset = Vector2(border, border)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	$Bottom/Control/Label.text = str(GlobalTweaks.current_tile_num)
