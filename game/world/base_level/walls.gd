@tool
extends LDtkTileMap

#
#var grass_scn : PackedScene = preload( "res://entities/props/wavy_grass/wavy_grass.tscn" )
#var grass_cells : Array[Vector2i]= [
	#Vector2i( 2, 5 ), Vector2i( 3, 5 ), Vector2i( 4, 5 ), Vector2i( 5, 5 ), Vector2i( 6, 5 ),
#]
#
#func _ready() -> void:
	#if Engine.is_editor_hint(): return
	#finished_populating_map.connect( _on_finished_populating_map )
#
#
#
#func _on_finished_populating_map() -> void:
	#_set_grass()
#
#func _set_grass() -> void:
	#var used_cells : Array[Vector2i] = get_used_cells(0)
	#for cell in used_cells:
		#var autotile_coord : Vector2i = get_cell_atlas_coords( 0, cell )
		#var pos = grass_cells.find( autotile_coord )
		#if pos == -1: continue
		#var g = grass_scn.instantiate()
		#g.position = cell * 8
		#g.tile_rect = Rect2i( autotile_coord, Vector2i( 1, 1 ) )
		#add_child( g )
		#set_cell( 0, cell )
	
