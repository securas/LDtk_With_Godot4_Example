extends Node2D
class_name MenuItem

# warning-ignore:unused_class_variable
@export var selectable : bool = true : set = _set_selectable
var highlight : = false : set = _set_highlight



func _set_highlight( v ):
	highlight = v
	set_highlight( highlight )
	if not selectable: _set_selectable( selectable )

func _set_selectable( v ):
	selectable = v
	set_selectable( selectable )

#-------------------------------------
# methods to override
#-------------------------------------
@warning_ignore("unused_parameter")
func set_highlight( v ):
	pass

@warning_ignore("unused_parameter")
func set_selectable( v ):
	pass

func execute():
	pass





