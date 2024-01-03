extends Node2D_Entity



func _entity_activate( activate : bool ) -> void:
	if activate:
		$detect_player/collision.disabled = false
	else:
		$detect_player/collision.disabled = true

func _entity_initialize( _params : Dictionary ) -> void:
	pass


func _on_detect_player_body_entered( _body : Node2D ) -> void:
	$detect_player/collision.disabled = true
	game.state.coins += 1
	sigmgr.gamestate_changed.emit()
	hide()
	var x : Node2D = preload( "res://entities/vfx/stars.tscn" ).instantiate()
	x.position = position + Vector2( 0, -8 )
	get_parent().add_child( x )
	sigmgr.captured_coin.emit()


