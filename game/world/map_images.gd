@tool
extends Node2D

@export var map : LDtkMap


func _enter_tree() -> void:
	if not Engine.is_editor_hint(): return
	for c in get_children():
		c.queue_free()
	if map:
		var pos : int = map.resource_path.find( ".ldtk" )
		var png_path : String = map.resource_path.substr( 0, pos ) + "/png"
		var _levels : Array = map.world_data.keys()
		for level_name : String in map.world_data.keys():
			var png_filename : String = "%s/%s.png" % [ png_path, level_name ]
			var texture : Texture = load( png_filename )
			var s : Sprite2D = Sprite2D.new()
			s.texture = texture
			s.position = map.world_data[level_name].level_rect.position
			s.centered = false
			add_child( s )

func _ready() -> void:
	if not Engine.is_editor_hint():
		queue_free()



