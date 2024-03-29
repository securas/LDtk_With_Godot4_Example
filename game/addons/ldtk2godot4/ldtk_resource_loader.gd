class_name LDtkResourceLoader extends RefCounted

signal loading_complete()

const _hidden_level_position : Vector2 = Vector2.ONE * 10000
const _hidden_entity_position : Vector2 = Vector2( 0, 10000 )

var _map : LDtkMap
var _base_level_scene : String
var _base_level_folder : String
var _debug := false
var _entity_types : Dictionary
var _parent : Node2D

var levels : Array[LDtkLevel]
var entities : Array[Node2D]
var entity_data : Array[Dictionary]

func _init( parent : Node2D, map : LDtkMap, base_level_scene : String, base_level_folder : String ) -> void:
	_parent = parent
	_map = map
	_base_level_scene = base_level_scene
	_base_level_folder = base_level_folder

func start_loading() -> void:
	_generate_ldtk_levels.call_deferred()

# Ok for small games but maybe too much for large games
# This will simply load all levels, hide them and place them far away
func _generate_ldtk_levels() -> void:
	#--------------------------------
	# Generate levels
	#--------------------------------
	## list files in folder
	#if _base_level_folder:
		#var dir = DirAccess.open( _base_level_folder )
		#if dir:
			#dir.list_dir_begin()
			#var file_name = dir.get_next()
			#while file_name != "":
				#if dir.current_is_dir():
					#print("Found directory: " + file_name)
				#else:
					#print("Found file: " + file_name)
				#file_name = dir.get_next()
		#else:
			#print("An error occurred when trying to access the path.")

	var level_names = _map.get_level_names()
	levels.clear()
	_entity_types = {}
	for level_name in level_names:
		if _debug: print( "LDtkResourceLoader: Preparing resource for level - ", level_name )
		# get resource for this level
		var resource_path : String = "%s/%s" % [
			_map.resource_path.substr( 0, _map.resource_path.rfind( "/" ) ),
			_map.world_data[level_name].external_resource ]
		var new_map : LDtkMap = load( resource_path )
		
		# check if file exists. If not, generate level at runtime
		var filename = "%s/%s.tscn" % [ _base_level_folder, level_name ]
		var exported_filename = "%s.remap" % [ filename ]
		#var dir = DirAccess.open( _base_level_folder )
		if _debug: print( "LDtkResourceLoader: Searching for level file - ", filename )
		#if dir and dir.file_exists( "%s.tscn" % [ level_name ] ):
		if FileAccess.file_exists( filename ) or FileAccess.file_exists( exported_filename ):
			if _debug: print( "LDtkResourceLoader: Preloading level - ", filename )
			var new_level : LDtkLevel = load( filename ).instantiate()
			new_level.hide()
			new_level.position = _hidden_level_position
			levels.append( new_level )
			new_level._map = new_map
			_parent.add_child( new_level )
		else:
			if _debug: print( "LDtkResourceLoader: Initializing level - ", resource_path )
			if not _base_level_scene:
				printerr( "LDtkResourceLoader: Unable to find base level scene - ", _base_level_scene )
				continue
			var new_level : LDtkLevel = load( _base_level_scene ).instantiate()
			new_level.hide()
			new_level.position = _hidden_level_position
			_parent.add_child( new_level )
			new_level.name = level_name
			new_level._map = new_map
			new_level._update_map()
			new_level.force_level_limits()
			levels.append( new_level )
		
		# count entities for this level
		var ldtk_entities := []
		if new_map.entity_data[level_name].has( "entities" ) and new_map.entity_data[level_name].entities:
			#print( ">>>", new_map.entity_data[level_name].entities )
			ldtk_entities = new_map.entity_data[level_name].entities
		var _level_entity_counts : Dictionary
		for ldtk_entity in ldtk_entities:
			if not ldtk_entity.parameters.has( "resource" ):
				printerr( "Unable to find resource in entity with id: ", ldtk_entity.id )
				continue
			var entity_id : String = ldtk_entity.id
			if _level_entity_counts.has( entity_id ):
				_level_entity_counts[entity_id].count += 1
			else:
				_level_entity_counts[entity_id] = {
					"count" : 1,
					"res" : ldtk_entity.parameters.resource
				}
		# increment entities
		for entity_id in _level_entity_counts:
			if _entity_types.has( entity_id ):
				_entity_types[entity_id].count = maxi(
					_entity_types[entity_id].count,
					_level_entity_counts[entity_id].count
				)
			else:
#				_entity_types[entity_id] = _level_entity_counts[entity_id].duplicate( true )
				_entity_types[entity_id] = {
					"count" : _level_entity_counts[entity_id].count,
					"res" : _level_entity_counts[entity_id].res
				}
	#--------------------------------
	# Generate required entities
	#--------------------------------
	entities.clear()
	entity_data.clear()
	for entity_id in _entity_types:
		var entity_scn : PackedScene = load( _entity_types[entity_id].res )
		for entity_count in range( _entity_types[entity_id].count ):
			var new_entity = entity_scn.instantiate()
			new_entity._entity_activate( false )
			new_entity.hide()
			new_entity.position = _hidden_entity_position
			_parent.add_child( new_entity )
			new_entity._entity_activate( false )
			entities.append( new_entity )
			new_entity.owner = _parent
			var new_entity_data = {
				"id" : entity_id,
				"reserved" : false
			}
			entity_data.append( new_entity_data )
	
	# All done
	loading_complete.emit()


#----------------------------------------
# Utilities
#----------------------------------------
func get_level( level_name : String ) -> LDtkLevel:
	for level in levels:
		if level.name == level_name:
			return level
	return null

func reserve_entity( entity_id : String ) -> Node2D:
	for idx in range( entities.size() ):
		if not entity_data[idx].reserved and entity_data[idx].id == entity_id:
			entity_data[idx].reserved = true
			return entities[idx]
	return null

func release_entity( entity : Node2D ) -> void:
	var pos = entities.find( entity )
	if pos == -1:
		printerr( "LDtkResourceLoader : Unable to release entity" )
	entity_data[pos].reserved = false















