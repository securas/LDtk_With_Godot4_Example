extends FSM_State

var hit_timer : float
var dead_timer : float
var state : int

func _initialize() -> void:
	anim.anim_nxt = "hit"
	hit_timer = 0.5
	dead_timer = 1.0
	state = 0

func _run( delta : float ) -> void:
	match state:
		0:
			var _ret : bool = obj.move_and_slide()
			obj.velocity *= 0.75
			hit_timer -= delta
			if hit_timer <= 0:
				state = 1
				obj.death()
		1:
			dead_timer -= delta
			if dead_timer <= 0:
				obj.player_dead.emit()
				fsm.state_nxt = fsm.states.idle



func _terminate() -> void:
	obj.is_hit = false
	obj.is_dead = false
