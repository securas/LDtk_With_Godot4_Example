extends FSM_State

var rejump_timer : float
var coyote_timer : float
var fall_timer : float

func _initialize() -> void:
	fall_timer = 0.0
	rejump_timer = 0.0
	#if fsm.state_lst != fsm.states.jump and \
			#fsm.state_lst != fsm.states.attack and \
			#fsm.state_lst != fsm.states.attack_platform:
	if fsm.state_lst != fsm.states.jump:
		coyote_timer = Params.PLAYER_COYOTE_MARGIN
	else:
		coyote_timer = -1.0
	anim.anim_nxt = "fall"
	obj.get_node( "DealDamageArea/damage_collision" ).disabled = false

func _run( delta : float ) -> void:
	if coyote_timer > 0:
		coyote_timer -= delta
		if obj.control.is_just_jump:
			fsm.states.jump.begin_jump()
			return
	
	if obj.control.is_just_fire and game.state.whip:
		fsm.state_nxt = fsm.states.attack
		return
	if obj.control.is_just_interact and game.state.paralize_whip:
		fsm.state_nxt = fsm.states.attack_platform
		return
	
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
	
	rejump_timer -= delta
	if obj.control.is_just_jump:
		rejump_timer = 0.2
	
	fall_timer += delta
	if obj.is_on_floor():
		obj.dust( Player.DustTypes.LAND )
		if rejump_timer >= 0:
			fsm.states.jump.begin_jump()
			return
		else:
			#if abs( obj.velocity.x ) < 15:
				#obj.get_node( "step" ).play()
			if fall_timer > 0.15:
				obj.anim_fx.play( "land" )
			if abs( obj.velocity.x ) > Params.PLAYER_MAX_VEL * 0.25:
				fsm.state_nxt = fsm.states.run
			else:
				fsm.state_nxt = fsm.states.idle

func _terminate() -> void:
	obj.get_node( "DealDamageArea/damage_collision" ).disabled = true
