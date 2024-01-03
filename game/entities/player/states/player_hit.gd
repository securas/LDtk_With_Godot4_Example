extends FSM_State

var hit_timer : float

func _initialize() -> void:
	anim.anim_nxt = "hit"
	obj.anim_fx.play( "hit" )
	obj.anim_fx.queue( "RESET" )
	hit_timer = 0.15

func _run( delta : float ) -> void:
	obj.gravity( delta )
	var _ret : bool = obj.move_and_slide()
	
	if obj.is_on_floor():
		obj.velocity.x *= 0.95
	
	hit_timer -= delta
	if hit_timer <= 0:
		fsm.state_nxt = fsm.states.idle
	


func _terminate() -> void:
	obj.is_hit = false
