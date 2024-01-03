extends FSM_State

func _initialize() -> void:
	anim.anim_nxt = "idle"
	obj.position = obj.position.round()

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
	
	obj.velocity.x = 0
	
	if obj.control.is_moving:
		fsm.state_nxt = fsm.states.run
	
	obj.gravity( delta, 0.1 )
	var _ret : bool = obj.move_and_slide()
	
	if obj.is_on_floor():
		if obj.control.is_down and _check_drop( delta ):
			obj.position.y += 1
		pass
	else:
		fsm.state_nxt = fsm.states.fall


func _check_drop( delta : float ) -> bool:
	var tm : bool = obj.test_move( obj.get_transform().translated( Vector2.DOWN ), Params.GRAVITY * delta * Vector2.DOWN )
	return not tm

#func _terminate():
	#var _ret = obj.check_conveyor_belt(false)
