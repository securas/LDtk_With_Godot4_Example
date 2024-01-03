extends FSM_State

var cutscene_timer : float
var stop_moving : bool

func _initialize() -> void:
	obj.is_invulnerable = true
	obj.invulnerable_timer = -1.0
	obj.velocity *= 0
	stop_moving = false

func _run( delta : float ) -> void:
	if not stop_moving:
		obj.gravity( delta, 0.1 )
		var _ret : bool = obj.move_and_slide()
		if obj.is_on_floor():
			stop_moving = true
	
	if cutscene_timer > 0:
		cutscene_timer -= delta
		if cutscene_timer <= 0:
			fsm.state_nxt = fsm.states.idle

func _terminate() -> void:
	obj.is_invulnerable = false
