extends AnimationPlayer

var anim_cur : String

func set_anim( anim_nxt : String ) -> void:
	if anim_cur != anim_nxt:
		anim_cur = anim_nxt
		play( anim_cur )
