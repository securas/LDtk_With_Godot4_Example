class_name Utils extends RefCounted


static func on_screen( obj : Node2D, margin : float = 16.0 ) -> bool:
	var screen_rect : Rect2 = obj.get_viewport_rect()
	screen_rect.position -= Vector2.ONE * margin
	screen_rect.size += Vector2.ONE * margin * 2.0
	var screen_pos : Vector2 = screen_position( obj )
	return screen_rect.has_point( screen_pos )

static func screen_position( obj : Node2D ) -> Vector2:
	return obj.get_global_transform_with_canvas().origin

static func get_unique_id( obj : Node ) -> String:
	var id : String = obj.owner.filename + "_" + obj.owner.get_path_to( obj )
	return id

static func load_encrypted_file( filename : String ) -> Dictionary:
	if FileAccess.file_exists( filename ):
		var faccess : FileAccess = FileAccess.open_encrypted_with_pass( \
			filename, FileAccess.READ, OS.get_unique_id() )
		if not faccess:
			return {}
		var data : Dictionary = faccess.get_var( true )
		faccess.close()
		return data
	else:
		return {}

static func save_encrypted_file( filename : String, data : Dictionary ) -> bool:
	var faccess := FileAccess.open_encrypted_with_pass( \
		filename, FileAccess.WRITE, OS.get_unique_id() )
	if faccess:
		faccess.store_var( data, true )
		faccess.close()
		return true
	else:
		faccess.close()
		return false

#static func target_in_sight( sourcenode : Node2D, sourcepos : Vector2, targetpos : Vector2, \
		#max_dist : float, view_direction : float, view_angle : float, exclude : Array, colmask : int ) -> bool:
	#var dist = targetpos - sourcepos
	## check maximum distance
	#if max_dist > 0 and dist.length() > max_dist:
		#return false
	## check if direction dependent view in the horizontal axis
	#if abs( dist.x ) > 0.0 and abs( view_direction) > 0.0:
		#if sign( dist.x ) != sign( view_direction ):
			#return false
		## if there is a view direction, then also checks the view angle
		#if abs( dist.angle_to( Vector2.RIGHT * sign( dist.x ) ) ) > view_angle:
			#return false
	## check the view angle
	#var space_state = sourcenode.get_world_2d().direct_space_state
	#var result = space_state.intersect_ray( \
			#sourcepos, targetpos, exclude, colmask )
	#if result.empty(): return true
##	print( "obstacle: ", result.collider.name )
	#return false
