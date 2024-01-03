class_name Player extends Actor

signal player_dead

enum DustTypes { RUN, JUMP, LAND }




var _fsm : FSM
var dir_cur : int = 0
var dir_nxt : int = 1
var is_dead := false
var is_hit := false
var is_invulnerable := false
var invulnerable_timer := 0.0
var control : Dictionary = {
	is_moving = false,
	dir = 0.0,
	is_jump = false,
	is_just_jump = false,
	is_down = false,
	is_just_down = false,
	is_fire = false,
	is_just_fire = false,
	is_interact = false,
	is_just_interact = false,
}


var cur_level_worldpos : Vector2i

@onready var _rotate : Node2D = $rotate
@onready var _anim : FSM_Anim = $anim
@onready var anim_fx : AnimationPlayer = $anim_fx
@onready var _detect_hazards : Area2D = $detect_hazards

#-------------------------------------------------
# Entity
#-------------------------------------------------
func _entity_activate( a : bool ) -> void:
	if a:
		set_physics_process( true )
		$detect_hazards/hazards_collision.disabled = false
		$RcvDamageArea/damage_collision.disabled = false
		if _anim.assigned_animation:
			_anim.play()
		$rotate/player.show()
	else:
		set_physics_process( false )
		$detect_hazards/hazards_collision.disabled = true
		$RcvDamageArea/damage_collision.disabled = true
		$DealDamageArea/damage_collision.disabled = true
		_anim.pause()


#-------------------------------------------------
# Setup
#-------------------------------------------------
func _ready() -> void:
	game.player = self
	_fsm = FSM.new( self, $states, $states/idle, _anim )
	#$rotate/DealDamageArea.control_node = self


#-------------------------------------------------
# Process
#-------------------------------------------------
func _physics_process( delta : float ) -> void:
	_update_control()
	_fsm.run_machine( delta )
	_anim.update_anim()
	_update_direction()
	_update_invulnerable( delta )
	_update_hazards()

func _update_control() -> void:
	control.dir = Input.get_action_strength( "btn_right" ) - Input.get_action_strength( "btn_left" )
	if abs( control.dir ) > 0.1:
		control.is_moving = true
	else:
		control.is_moving = false
		control.dir = 0.0
	control.is_jump = Input.is_action_pressed( "btn_jump" )
	control.is_just_jump = Input.is_action_just_pressed( "btn_jump" )
	control.is_down = Input.is_action_pressed( "btn_down" )
	control.is_just_down = Input.is_action_just_pressed( "btn_down" )
	#control.is_fire = Input.is_action_pressed( "btn_fire" )
	#control.is_just_fire = Input.is_action_just_pressed( "btn_fire" )
	#control.is_interact = Input.is_action_pressed( "btn_interact" )
	#control.is_just_interact = Input.is_action_just_pressed( "btn_interact" )

func _update_direction() -> void:
	if dir_cur != dir_nxt:
		dir_cur = dir_nxt
		_rotate.scale.x = dir_cur

#-------------------------------------------------
# Cutscenes
#-------------------------------------------------
func set_cutscene( anim_nxt : String, duration : float = -1.0 ) -> void:
	_set_cutscene.call_deferred( anim_nxt, duration )
	
func _set_cutscene( anim_nxt : String, duration : float ) -> void:
	_anim.anim_nxt = anim_nxt
	_fsm.states.cutscene.cutscene_timer = duration
	_fsm.state_nxt = _fsm.states.cutscene
	

func clear_cutscene() -> void:
	_fsm.state_nxt = _fsm.states.idle



#-------------------------------------------------
# Damage
#-------------------------------------------------
func _on_receiving_damage( from : Node2D, damage : int ) -> void:
	if is_dead or is_hit or is_invulnerable: return
	if _fsm.is_state( _fsm.states.cutscene ): return
	game.state.energy = int( max( game.state.energy - damage, 0 ) )
	sigmgr.gamestate_changed.emit()
	#$hit.play()
	var hit_dir : Vector2 = Vector2.ZERO
	if from:
		hit_dir = global_position + Vector2( 0, -6 ) - from.global_position
	if game.state.energy > 0:
		_fsm.state_nxt = _fsm.states.hit
		is_hit = true
		is_invulnerable = true
		invulnerable_timer = 0.4
		sigmgr.camera_shake.emit( 0.2, 2, 60 )
		velocity = hit_dir.normalized() * Params.PLAYER_HAZARD_THROWBACK_VEL * 0.75
	else:
		_fsm.state_nxt = _fsm.states.dead
		is_dead = true
		sigmgr.camera_shake.emit( 0.1, 2, 60 )
		velocity = hit_dir.normalized() * Params.PLAYER_HAZARD_THROWBACK_VEL * 0.75

func death() -> void:
	$rotate/player.hide()
	velocity *= 0
	var x : Sprite2D = preload( "res://entities/vfx/puff.tscn" ).instantiate()
	x.position = position + Vector2( 0, -8 )
	get_parent().add_child( x )
	sigmgr.camera_shake.emit( 0.4, 2, 60 )

func _update_hazards() -> void:
	if is_dead or is_hit or is_invulnerable: return
	if _fsm.is_state( _fsm.states.cutscene ): return
	var has_hazard_body : bool = not _detect_hazards.get_overlapping_bodies().is_empty()
	var has_hazard_area : bool = not _detect_hazards.get_overlapping_areas().is_empty()
	if not has_hazard_body and not has_hazard_area: return
	# find where the hazard is
	var hazard_dir : Vector2 = Vector2.ZERO
	if ( has_hazard_body and not $test_hazards/test_hazards_1.get_overlapping_bodies().is_empty() ) or \
		( has_hazard_area and not $test_hazards/test_hazards_1.get_overlapping_areas().is_empty() ):
			hazard_dir += Vector2.RIGHT
	if ( has_hazard_body and not $test_hazards/test_hazards_2.get_overlapping_bodies().is_empty() ) or \
		( has_hazard_area and not $test_hazards/test_hazards_2.get_overlapping_areas().is_empty() ):
			hazard_dir += Vector2.UP
	if ( has_hazard_body and not $test_hazards/test_hazards_3.get_overlapping_bodies().is_empty() ) or \
		( has_hazard_area and not $test_hazards/test_hazards_3.get_overlapping_areas().is_empty() ):
			hazard_dir += Vector2.LEFT
	if ( has_hazard_body and not $test_hazards/test_hazards_4.get_overlapping_bodies().is_empty() ) or \
		( has_hazard_area and not $test_hazards/test_hazards_4.get_overlapping_areas().is_empty() ):
			hazard_dir += Vector2.DOWN
	
	#$hit.play()
	var damage : int = 1
	game.state.energy = int( max( game.state.energy - damage, 0 ) )
	sigmgr.gamestate_changed.emit()
	if game.state.energy > 0:
		_fsm.state_nxt = _fsm.states.hit
		is_hit = true
		is_invulnerable = true
		invulnerable_timer = 0.4
		sigmgr.camera_shake.emit( 0.2, 2, 60 )
		velocity = -hazard_dir.normalized() * Params.PLAYER_HAZARD_THROWBACK_VEL
	else:
		_fsm.state_nxt = _fsm.states.dead
		is_dead = true
		velocity = -hazard_dir.normalized() * Params.PLAYER_HAZARD_THROWBACK_VEL * 0.75
	
func _update_invulnerable( delta : float ) -> void:
	if is_invulnerable and invulnerable_timer > 0:
		invulnerable_timer -= delta
		if invulnerable_timer <= 0:
			is_invulnerable = false


#func _on_check_level_type_timer_timeout() -> void:
	#if owner and owner._cur_level:
		#var cur_level_type : int = owner._cur_level.type
		#if cur_level_type == 1:
			#if not game.state.heat_resistance:
				#_on_receiving_damage( null, 1 )


#func _on_dealing_damage( _to : Node ) -> void:
	#game.state.energy_charger += 1
	#if game.state.energy_charger >= game.state.max_energy_charger:
		#game.state.energy_charger = 0
		#game.state.energy += 1
		#if game.state.energy > game.state.max_energy: game.state.energy = game.state.max_energy
	#sigmgr.gamestate_changed.emit()
	#$enemy_dead.play()


#-------------------------------------------------
# World checks
#-------------------------------------------------
#func is_on_elevator() -> bool:
	#return false
#
#func is_on_conveyor_belt() -> bool:
	#return false
#
#func get_walls_material() -> int:
	#return -1

#-------------------------------------------------
# VFX
#-------------------------------------------------
#func _whip_particles() -> void:
	#$rotate/whip_particles.rotation = TAU * randf()
	#$rotate/whip_particles/anim.play( "cycle" )
	#$rotate/whip_particles/anim.queue( "RESET" )


func dust( _type : int = DustTypes.RUN ) -> void:
	pass
	#var _cur_dust : Sprite2D
	#for d in $dust.get_children():
		#if not d.get_node( "anim" ).is_playing():
			#cur_dust = d
			#cur_dust.top_level = true
			#break
	#if not cur_dust:
		#return
	#cur_dust.global_position = global_position
	#cur_dust.scale.x = dir_cur
	#match type:
		#DustTypes.RUN:
			#cur_dust.get_node( "anim" ).play( "run" )
		#DustTypes.JUMP:
			#cur_dust.get_node( "anim" ).play( "jump" )
		#DustTypes.LAND:
			#cur_dust.get_node( "anim" ).play( "land" )
			#if randf() > 0.5: cur_dust.scale.x = -dir_cur
	#cur_dust.get_node( "anim" ).queue( "RESET" )



