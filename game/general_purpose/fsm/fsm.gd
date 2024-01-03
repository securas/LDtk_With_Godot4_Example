class_name FSM extends RefCounted


var debug : bool = false
var states : Dictionary = {}
var state_cur : FSM_State = null
var state_nxt : FSM_State = null
var state_lst : FSM_State = null
var obj : CharacterBody2D = null
var anim : FSM_Anim = null


# warning-ignore:shadowed_variable
func _init( _obj : CharacterBody2D, _states_parent_node : Node, \
	_initial_state : FSM_State, _anim : FSM_Anim = null, _debug : bool = false ) -> void:
	obj = _obj
	debug = _debug
	anim = _anim
	_set_states_parent_node( _states_parent_node )
	state_nxt = _initial_state

func _set_states_parent_node( pnode : Node ) -> void:
	if debug: print( "Found ", pnode.get_child_count(), " states" )
	if pnode.get_child_count() == 0:
		return
	var state_nodes : Array = pnode.get_children()
	for state_node : Node in state_nodes:
		if not state_node is FSM_State: continue
		if debug: print( "adding state: ", state_node.name )
		states[ state_node.name ] = state_node
		state_node.fsm = self
		state_node.obj = self.obj
		state_node.anim = self.anim

func run_machine( delta : float ) -> void:
	if state_nxt != state_cur:
		if state_cur != null:
			if debug:
				print( "(", obj.get_tree().get_frame(), ") ", obj.name, ": changing from state ", state_cur.name, " to ", state_nxt.name )
			state_cur._terminate()
		elif debug:
			print( "(", obj.get_tree().get_frame(), ") ", obj.name, ": starting with state ", state_nxt.name )
		state_lst = state_cur
		state_cur = state_nxt
		state_cur._initialize()
	# run state
	state_cur._run( delta )

func is_state( check : FSM_State ) -> bool:
	if state_cur == check or state_nxt == check:
		return true
	return false

