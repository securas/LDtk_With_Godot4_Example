extends FSM_State

func _initialize() -> void:
	anim.anim_nxt = "run"

func _run( delta : float ) -> void:
	if obj.control.is_just_jump:
		fsm.states.jump.begin_jump()
		return
	
	if obj.control.is_just_fire and game.state.whip:
		fsm.state_nxt = fsm.states.attack
		return
	if obj.control.is_just_interact and game.state.paralize_whip:
		fsm.state_nxt = fsm.states.attack_platform
		return
	
	obj.gravity( delta, 0.1 )
	if obj.control.is_moving:
		var dir : float = sign( obj.control.dir )
		obj.velocity.x = dir * Params.PLAYER_MAX_VEL
		obj.dir_nxt = int( dir )
	else:
		obj.velocity.x = 0
		fsm.state_nxt = fsm.states.idle
		return
	var _ret : bool = obj.move_and_slide()
	
	if not obj.is_on_floor():
		fsm.state_nxt = fsm.states.fall

