class_name FSM_Anim extends AnimationPlayer


var anim_nxt : String
var anim_cur : String

func update_anim() -> void:
	if anim_cur != anim_nxt:
		anim_cur = anim_nxt
		play( anim_cur )


