extends Node

const SAVEFILENAME = "user://gamesave.dat"

var debug := false
@warning_ignore("untyped_declaration")
var player : set = _set_player, get = _get_player
var state : Dictionary : set = _set_state, get = _get_state
var _state : Dictionary

func _set_player( v : Player ) -> void:
	player = weakref( v )

func _get_player() -> Player:
	if not player: return null
	if player.get_ref():
		return player.get_ref()
	else:
		return null

func _set_state( v : Dictionary ) -> void:
	state = v
	_state = v
	sigmgr.gamestate_changed.emit()

func _get_state() -> Dictionary:
	return _state

func _ready() -> void:
	_initialize_state()


func _initialize_state() -> void:
	_state = {
		events = [],
		worldpos = Vector2i( 100, 14 ),
		coins = 0,
		energy = 1,
		max_energy = 1,
	}
	if debug:
		_initialize_debug_state()

func _initialize_debug_state() -> void:
	pass

func reset_state() -> void:
	_state.energy = _state.max_energy
	sigmgr.gamestate_changed.emit()


func save_gamestate() -> void:
	var _res : bool = Utils.save_encrypted_file( SAVEFILENAME, state )

func load_gamestate() -> bool:
	var new_state : Dictionary = Utils.load_encrypted_file( SAVEFILENAME )
	if new_state:
		state = new_state.duplicate( true )
		return true
	return false



#-----------------------
# Manage events
#-----------------------
func is_event( evt_name : String ) -> bool:
	if state.events.find( evt_name ) > -1:
		return true
	return false

func add_event( evt_name : String ) -> bool:
	if is_event( evt_name ): return false
	state.events.append( evt_name )
	return true
