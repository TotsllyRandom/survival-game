extends CanvasLayer

@export var bar: String

@export var height: int
@export var border: int
@export var anchor: int



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var viewport_size = get_viewport().get_visible_rect().size
	$NinePatchRect.size.x = (viewport_size.x - (border*2)) / scale.x
	$NinePatchRect.size.y = (height) / scale.y
	if anchor == 1:
		offset = Vector2(border, (viewport_size.y - height) - border)
	else: 
		offset = Vector2(border, border)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if bar == "bottom":
		$NinePatchRect/Label.text = str(GlobalTweaks.current_tile_num)
