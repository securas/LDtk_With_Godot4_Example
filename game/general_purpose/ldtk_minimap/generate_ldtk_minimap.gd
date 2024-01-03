extends Node2D

@export var map : LDtkMap
var layer_name : String = "minimap_walls"
var cell_size : int = 8

func _ready() -> void:
	if map:
		call_deferred( "_generate_minimap" )


func _generate_minimap() -> void:
	var level_names = map.get_level_names()
	var levels : Dictionary = {}
	var maxpos : Vector2 = -100000 * Vector2.ONE
	var minpos : Vector2 = 100000 * Vector2.ONE
	for level_name in level_names:
		var pos = map.resource_path.find( ".ldtk" )
		var filename = map.resource_path.substr( 0, pos )
		filename += "/%s.ldtkl" % [ level_name ]
		var level : LDtkMap = load( filename ) as LDtkMap
		levels[level_name] = level
		var cur_minpos = level.world_data[level_name].level_rect.position
		var cur_maxpos = cur_minpos + level.world_data[level_name].level_rect.size
		if cur_minpos.x < minpos.x: minpos.x = cur_minpos.x
		if cur_minpos.y < minpos.y: minpos.y = cur_minpos.y
		if cur_maxpos.x > maxpos.x: maxpos.x = cur_maxpos.x
		if cur_maxpos.y > maxpos.y: maxpos.y = cur_maxpos.y
	var world_minpos : Vector2i = Vector2i( minpos )
	var world_maxpos : Vector2i = Vector2i( maxpos )
	var world_size : Vector2i = world_maxpos - world_minpos
	var world_cellsize : Vector2i = world_size / cell_size
	# create world image
	var img : Image
	img = Image.create( world_cellsize.x, world_cellsize.y, false, Image.FORMAT_RGBA8 )
	
	
	for level_name in level_names:
		var level : LDtkMap = levels[level_name]
		var world_data = level.world_data[level_name]
		var cell_data = level.cell_data[level_name]
		var pos_ref : Vector2i = Vector2i( world_data.level_rect.position / cell_size )
		pos_ref -= world_minpos / cell_size
		for c in cell_data[layer_name].tilemap_position:
			var pixel_pos : Vector2 = Vector2( pos_ref ) + Vector2( c )
			pixel_pos = ( pixel_pos * 0.49 ).floor()
			#print( pixel_pos )
			img.set_pixelv( pixel_pos, Color.WHITE )
		#break
	
	var texture = ImageTexture.create_from_image( img )
	$minimap_texture.texture = texture
	$minimap_texture.position = Vector2( world_minpos / cell_size ).floor()



