@tool
class_name BaseLevel extends LDtkLevel

var type : int = 0


# Called before finish activating
func _activate( _act : bool = true) -> void:
	var level_params : Dictionary = get_level_params()
	if level_params:
		type = int( level_params.type )
	#if act:
		## setup particles
		#$particles.process_material.set_shader_parameter( "level_size", Vector2( get_worldsize_px() ) )
		#$particles.amount = 40 * int( get_worldsize_px().x * get_worldsize_px().y / ( 240 * 135.0 ) )
		#$particles.visibility_rect = Rect2(
			#Vector2.ZERO, Vector2( get_worldsize_px() )
		#)
		#$particles.emitting = true
		#
		## setup lava levels
		#if type == 1:
			#$particles.modulate = Color( "ff004d" )
			#$heat_shader.region_rect.size = Vector2( get_worldsize_px() )
			#$heat_shader.show()
		#
		## music
		#if type == 1:
			#sigmgr.set_music.emit( Main.MusicStreams.LAVA )
		#else:
			#sigmgr.set_music.emit( Main.MusicStreams.NORMAL )
	#else:
		#$particles.emitting = false
		#$heat_shader.hide()

