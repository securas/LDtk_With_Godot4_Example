extends LDtkWorld


@export var world_debug : bool = true
@onready var camera : Camera2D = $player/camera
@onready var player : Player = $player

func _ready() -> void:
	if Engine.is_editor_hint():
		return
	
	if world_debug:
		game.debug = world_debug
		game._initialize_state()
	#$fade_layer.fade_out( true )
	var _ret : int = player.player_dead.connect( _on_player_dead )
	_ret = world_ready.connect( _on_world_ready )
	super._ready()



func _on_world_ready() -> void:
	if world_debug:
		game.state.worldpos = Vector2i( $player.global_position )
	_on_player_leaving_level( null, game.state.worldpos )


func _on_player_leaving_level( _player : Node2D, player_world_position : Vector2 ) -> void:
	var new_level_name : String = map.get_level_name_at( player_world_position )
	if _debug: print( "New level: ", new_level_name, " at ", player_world_position )
	if not new_level_name:
		printerr( "Unable to find level" )
		return
	player._entity_activate( false )
	#$hud_layer.set_physics_process( false )
	$fade_layer.fade_out()
	await $fade_layer.fade_complete
	load_level( new_level_name )
	await level_ready
	player.position = player_world_position - Vector2( _cur_level.get_worldpos_px() )
	camera.limit_left = 0
	camera.limit_right = _cur_level.get_worldsize_px().x
	camera.limit_top = 0
	camera.limit_bottom = round( _cur_level.get_worldsize_px().y / 240.0 ) * 240.0
	camera._reset_camera()
	$fade_layer.fade_in()
	await $fade_layer.fade_complete
	#$hud_layer.set_physics_process( true )
	player._entity_activate( true )
	player.cur_level_worldpos = _cur_level.get_worldpos_px()


func _on_player_dead() -> void:
	game.reset_state()
	_on_player_leaving_level( $player, game.state.worldpos )


