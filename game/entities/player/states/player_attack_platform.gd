extends FSM_State

var _attack_timer : float

func _initialize() -> void:
	anim.anim_nxt = "attack_paralize"
	_attack_timer = 0.5
	obj.velocity *= 0
	obj.get_node( "rotate/DealDamageArea" ).damage_dealt = -1

func _run( delta : float ) -> void:
	if _attack_timer > 0:
		_attack_timer -= delta
		if _attack_timer <= 0:
			fsm.state_nxt = fsm.state_lst
	obj.move_and_slide()

func _terminate() -> void:
	obj.get_node( "rotate/DealDamageArea" ).damage_dealt = game.state.whip_damage
