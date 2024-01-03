@tool
extends LDtkTileMap

var dscn := preload( "res://entities/props/destructibles/destructible.tscn" )

func _ready():
	if Engine.is_editor_hint(): return
	call_deferred( "_set_destructibles" )

func _set_destructibles() -> void:
	for cell in get_used_cells( 0 ):
		var coords = get_cell_atlas_coords( 0, cell )
		var d = dscn.instantiate()
		d.position = cell * 8
		d.tile = coords
		add_child( d )
		set_cell( 0, cell )
