extends Node2D
class_name Menu

signal selected_item( item )
# warning-ignore:unused_signal
signal return_menu
signal activated
signal deactivated
signal highlighted_item( itemno )

@export var is_active : bool = false : set = _set_active
@export var vertical : bool = true
@export var horizontal : bool = true
@export var stop_after_select : bool = true
@export var circulate : bool = true
var items : Array = []
var cur_item : int = 0


func _ready() -> void:
	for c in get_children():
		if c is MenuItem:
			items.append( c )
			c.set_highlight( false )
	update_menu()
	set_physics_process( is_active )

func _set_active( v : bool ) -> void:
	is_active = v
	set_physics_process( is_active )
	if is_active:
		emit_signal("activated")
	else:
		emit_signal("deactivated")
		
func _physics_process( _delta : float ) -> void:
	var selection_changed := false
	
	if vertical:
		if Input.is_action_just_pressed( "btn_down" ):
				advance_cur_item(1)
				selection_changed = true
		if Input.is_action_just_pressed( "btn_up" ):
				advance_cur_item(-1)
				selection_changed = true
	if horizontal:
		if Input.is_action_just_pressed( "btn_right" ):
				advance_cur_item(1)
				selection_changed = true
		if Input.is_action_just_pressed( "btn_left" ):
				advance_cur_item(-1)
				selection_changed = true
	if selection_changed:
		update_menu()
	
	if Input.is_action_just_pressed( "btn_action" ):
			items[cur_item].call_deferred( "execute" )
			if stop_after_select:
				is_active = false
			emit_signal( "selected_item", items[cur_item] )



func advance_cur_item( direction : int ) -> void:
	var found_valid_item : bool = false
	var candidate_item : int = cur_item
	while not found_valid_item:
		if circulate:
			candidate_item = ( candidate_item + direction ) % items.size()
			if candidate_item < 0: candidate_item = items.size() - 1
		else:
			candidate_item += direction
			if candidate_item >= items.size() - 1: candidate_item = items.size() - 1
			if candidate_item < 0: candidate_item = 0
		if items[candidate_item].selectable:
			found_valid_item = true
			cur_item = candidate_item
			emit_signal( "highlighted_item", cur_item )

func update_menu() -> void:
	items[cur_item].highlight = true
	for idx : int in range( items.size() ):
		if idx != cur_item:
			items[idx].highlight = false



