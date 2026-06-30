extends CanvasLayer

var height: int = 200
@export var border: int
@export var anchor: int



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var viewport_size = get_viewport().get_visible_rect().size
	$Bottom.size.x = (viewport_size.x - (border*2)) / scale.x
	$Bottom.size.y = (height) / scale.y
	$Top.size.x = (viewport_size.x - (border*2)) / scale.x
	$Top.size.y = (100) / scale.y
	$Bottom/Control.size.x = $Bottom.size.x - 12
	$Bottom/Control.size.y = $Bottom.size.y - 12
	$Bottom/Control.position.x = 6
	$Bottom/Control.position.y = 6
	$Top/Control.size.x = $Top.size.x - 12
	$Top/Control.size.y = $Top.size.y - 12
	$Top/Control.position.x = 6
	$Top/Control.position.y = 6
	$Bottom.position.x = border/ scale.x
	$Bottom.position.y = ((viewport_size.y - (height)) - border)/ scale.y
	$Top.position.x = border/ scale.x
	$Top.position.y = border/ scale.x

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if GlobalTweaks.current_tile_num:
		$Bottom/Control/HBoxContainer.visible = true
		$Bottom/Control/Label.visible = false
	else:
		$Bottom/Control/HBoxContainer.visible = false
		$Bottom/Control/Label.visible = true
	$Bottom/Control/Label.text = str("Click a tile to edit!")
	$Top/Control/Label.text = str((3600 - (roundi(Time.get_unix_time_from_system())%3600))/60)+":"+str((3600 - (roundi(Time.get_unix_time_from_system())%3600))%60).pad_zeros(2)


func _on_path_pressed() -> void:
	WorldBuilder.map_data[GlobalTweaks.current_tile_num.y][GlobalTweaks.current_tile_num.x]["path"] = true


func _on_hut_pressed() -> void:
	WorldBuilder.map_data[GlobalTweaks.current_tile_num.y][GlobalTweaks.current_tile_num.x]["placedOn"] = 4



func _on_bottom_mouse_entered() -> void:
	GlobalTweaks.on_ui = true


func _on_bottom_mouse_exited() -> void:
	GlobalTweaks.on_ui = false


func _on_village_pressed() -> void:
	WorldBuilder.map_data[GlobalTweaks.current_tile_num.y][GlobalTweaks.current_tile_num.x]["placedOn"] = 5



func _on_clear_pressed() -> void:
	WorldBuilder.clear_tile(GlobalTweaks.current_tile_num.x,GlobalTweaks.current_tile_num.y)
