extends Node2D_Entity

enum ENEMY_STATES { PATROL, SIGHT, CHASE, DEAD, RESTART }

var _state : int = ENEMY_STATES.PATROL
var _params : Dictionary

@onready var anim : AnimationPlayer = $anim
@onready var rot : Node2D = $rotate

func _ready() -> void:
	set_physics_process( false )

func _entity_activate( activate : bool ) -> void:
	if activate:
		set_physics_process( true )
		$DealDamageArea/damage_collision.disabled = false
		$RcvDamageArea/rcv_damage_collision.disabled = false
	else:
		set_physics_process( false )
		$DealDamageArea/damage_collision.disabled = true
		$RcvDamageArea/rcv_damage_collision.disabled = true

func _entity_initialize( params : Dictionary ) -> void:
	_params = params
	_prepare_enemy()


func _prepare_enemy() -> void:
	_state = ENEMY_STATES.PATROL
	position = _params.position
	_params.path_px = [ position ]
	_params.path_px.append( Vector2( _params.path.cx, _params.path.cy ) * 16 + Vector2( 8, 16 ) )
	_params.path_rect = Rect2(
		Vector2(
			min( _params.path_px[0].x, _params.path_px[1].x ),
			min( _params.path_px[0].y, _params.path_px[1].y )
		) + Vector2( -8, -16 ),
		Vector2(
			abs( _params.path_px[0].x - _params.path_px[1].x ),
			abs( _params.path_px[0].y - _params.path_px[1].y )
		) + Vector2( 16, 16 )
	)
	_params.path_idx = 1
	_params.dead_timer = 0.5
	_params.restart_timer = 5.0
	_params.sight_timer = 0.25
	
	var dir : Vector2 = ( _params.path_px[_params.path_idx] - position ).normalized()
	if abs( dir.x ) > 0:
		rot.scale.x = sign( dir.x )


func _physics_process( delta : float ) -> void:
	match _state:
		ENEMY_STATES.PATROL:
			anim.set_anim( "patrol" )
			var dir : Vector2 = ( _params.path_px[_params.path_idx] - position ).normalized()
			#print( dir )
			position += dir * Params.TROOPER_WALK_VEL * delta
			if( position - _params.path_px[_params.path_idx] ).length() < ( 2.0 * Params.SLIME_WALK_VEL / 60.0 ):
				position = _params.path_px[_params.path_idx]
				_params.path_idx= ( _params.path_idx + 1 ) % _params.path_px.size()
				dir = ( _params.path_px[_params.path_idx] - position ).normalized()
				if abs( dir.x ) > 0:
					rot.scale.x = sign( dir.x )
			if _player_in_sight():
				_params.sight_timer = 0.5
				_state = ENEMY_STATES.SIGHT
		ENEMY_STATES.SIGHT:
			anim.set_anim( "sight" )
			_params.sight_timer -= delta
			if _params.sight_timer <= 0:
				_state = ENEMY_STATES.CHASE
		ENEMY_STATES.CHASE:
			anim.set_anim( "chase" )
			var dir : Vector2 = ( _params.path_px[_params.path_idx] - position ).normalized()
			#print( dir )
			position += dir * Params.TROOPER_CHASE_VEL * delta
			if( position - _params.path_px[_params.path_idx] ).length() < ( 2.0 * Params.SLIME_WALK_VEL / 60.0 ):
				position = _params.path_px[_params.path_idx]
				_params.path_idx= ( _params.path_idx + 1 ) % _params.path_px.size()
				dir = ( _params.path_px[_params.path_idx] - position ).normalized()
				if abs( dir.x ) > 0:
					rot.scale.x = sign( dir.x )
				_state = ENEMY_STATES.PATROL
		ENEMY_STATES.DEAD:
			if _params.dead_timer > 0:
				_params.dead_timer -= delta
				if _params.dead_timer <= 0:
					hide()
					var x : Sprite2D = preload( "res://entities/vfx/puff.tscn" ).instantiate()
					x.position = position + Vector2( 0, -4 )
					get_parent().add_child( x )
					sigmgr.camera_shake.emit( 0.1, 1, 60 )
					if randf() < 0.1:
						var c : Node2D = preload( "res://entities/coin/coin_reward.tscn" ).instantiate()
						c.position = position + Vector2( 0, -4 )
						c.velocity.x = randf_range( -30, 30 )
						get_parent().add_child( c )
					_state = ENEMY_STATES.RESTART
					_params.restart_timer = 4.0
					position = _params.position
		ENEMY_STATES.RESTART:
			_params.restart_timer -= delta
			if _params.restart_timer <= 0:
				var dist : Vector2 = game.player.global_position - global_position
				if dist.length() > Params.MIN_DISTANCE_RESPAWN:
					# restarting
					_prepare_enemy()
					var x : Sprite2D = preload( "res://entities/vfx/puff.tscn" ).instantiate()
					x.position = position + Vector2( 0, -4 )
					get_parent().add_child( x )
					show()
					$DealDamageArea/damage_collision.call_deferred( "set_disabled", false )
				else:
					_params.restart_timer = 1.0


func _on_receiving_damage( player : Player, _damage : int ) -> void:
	if _state == ENEMY_STATES.DEAD or _state == ENEMY_STATES.RESTART: return
	if player.velocity.y <= 0: return # player must be falling down
	if player.global_position.y >= global_position.y - 8: return
	_state = ENEMY_STATES.DEAD
	#player.velocity.y = -Params.PLAYER_JUMP_VEL
	player._fsm.states.jump.begin_small_jump()
	_set_dead()


func _set_dead() -> void:
	$DealDamageArea/damage_collision.call_deferred( "set_disabled", true )
	anim.set_anim( "dead" )

func _player_in_sight() -> bool:
	var playerpos : Vector2 = game.player.position + Vector2( 0, -8 )
	var dist : Vector2 = playerpos - ( position + Vector2( 0, -4 ) )
	if sign( dist.x ) != sign( rot.scale.x ):
		return false
	if _params.path_rect.has_point( playerpos):
		return true
	return false
	
