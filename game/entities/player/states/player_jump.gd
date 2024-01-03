extends FSM_State

var hold_timer : float


func begin_jump() -> void:
	obj.dust( Player.DustTypes.JUMP )
	obj.velocity.y = -Params.PLAYER_JUMP_VEL
	var _ret : bool = obj.move_and_slide()
	obj.anim_fx.play( "jump" )
	hold_timer = Params.PLAYER_VARIABLE_JUMP_MARGIN
	anim.anim_nxt = "jump"
	fsm.state_nxt = fsm.states.jump

func begin_small_jump() -> void:
	obj.dust( Player.DustTypes.JUMP )
	if obj.control.is_jump:
		obj.velocity.y = -Params.PLAYER_JUMP_VEL
	else:
		obj.velocity.y = -Params.PLAYER_JUMP_VEL * 0.75
	var _ret : bool = obj.move_and_slide()
	obj.anim_fx.play( "jump" )
	hold_timer = Params.PLAYER_VARIABLE_JUMP_MARGIN
	anim.anim_nxt = "jump"
	fsm.state_nxt = fsm.states.jump


func _run( delta : float ) -> void:
	if obj.control.is_just_fire and game.state.whip:
		fsm.state_nxt = fsm.states.attack
		return
	if obj.control.is_just_interact and game.state.paralize_whip:
		fsm.state_nxt = fsm.states.attack_platform
		return
	
	if hold_timer > 0:
		hold_timer -= delta
		if obj.velocity.y >= 0:
			hold_timer = 0
		elif hold_timer <= 0 or not obj.control.is_jump:
			hold_timer = 0
			obj.velocity.y *= 0.5
	
	#if obj.is_on_elevator():
		##obj.elevator( delta ) 
		#pass
	#else:
		#obj.gravity( delta )
	obj.gravity( delta )
	
	if obj.control.is_moving:
		var dir : float = sign( obj.control.dir )
		obj.velocity.x = lerp( obj.velocity.x, dir * Params.PLAYER_MAX_VEL, Params.PLAYER_AIR_ACCEL * delta )
		obj.dir_nxt = int( dir )
	else:
		obj.velocity.x = lerp( obj.velocity.x, 0.0, Params.PLAYER_AIR_DECEL * delta )
	var _ret : bool = obj.move_and_slide()
	
	if obj.velocity.y > 0:
		fsm.state_nxt = fsm.states.fall
		return
	
	if obj.is_on_floor():
		fsm.state_nxt = fsm.states.idle







