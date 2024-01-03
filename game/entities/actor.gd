class_name Actor extends CharacterBody2D_Entity




func gravity( delta : float, multiplier : float = 1.0 ) -> void:
	velocity.y = min( velocity.y + Params.GRAVITY * delta * multiplier, Params.TERM_VEL )

