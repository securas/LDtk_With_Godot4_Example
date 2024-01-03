class_name Node2D_Entity extends Node2D


var entity_iid : String
#var confirm_activation : bool = true
#
#var _restart_timer : Timer
#var _restart_parameters : Dictionary
#var _is_restarting : bool = false

func _entity_activate( _a : bool ) -> void:
	pass

func _entity_initialize( _params : Dictionary ) -> void:
	pass
	

#
#
#func _initiate_restart() -> void:
	#_is_restarting = true
	#position = _restart_parameters.position
	#if not _restart_timer:
		#_restart_timer = Timer.new()
		#_restart_timer.autostart = false
		#_restart_timer.one_shot = true
		#_restart_timer.wait_time = 1.0
		#add_child( _restart_timer )
	#_restart_timer.timeout.connect( _on_restart_timer_timeout.bind( Params.ENEMY_RESPAWN_DELAY ) )
	#_restart_timer.call_deferred( "start" )
#
#
#func _test_timer( a : int ):
	#print( "TIMER CALLED ", name, " ", a )
#
#func _on_restart_timer_timeout( counter : int ) -> void:
	#if not _is_restarting:
		#return
	#if _restart_timer.timeout.is_connected( _on_restart_timer_timeout ):
		#_restart_timer.timeout.disconnect( _on_restart_timer_timeout )
	#if not game.player: return
	#var dist : float = ( global_position - game.player.global_position ).length()
	#if dist < Params.ENEMY_RESPAWN_DISTANCE:
		#_restart_timer.timeout.connect( _on_restart_timer_timeout.bind( Params.ENEMY_RESPAWN_DELAY ) )
		#_restart_timer.start()
		#return
	#var new_count : int = counter - 1
	#if new_count > 0:
		#_restart_timer.timeout.connect( _on_restart_timer_timeout.bind( new_count ) )
		#_restart_timer.start()
		#return
	#else:
		#_is_restarting = false
		#_entity_initialize( _restart_parameters )
		#_entity_activate( true )
		#show()
		##var x = preload( "res://entities/vfx/small_blast.tscn" ).instantiate()
		##x.position = position + Vector2( 0, -4 )
		##x.rotation = randf() * TAU
		##get_parent().add_child( x )
#
#func _stop_restart() -> void:
	#if _is_restarting:
		#_is_restarting = false
	#if _restart_timer:
		#_restart_timer.stop()
		#if _restart_timer.timeout.is_connected( _on_restart_timer_timeout ):
			#_restart_timer.timeout.disconnect( _on_restart_timer_timeout )
