extends Actor

enum COIN_STATES { NORMAL, FINISHING }

var coin_timer : float
var active_timer : float
var state : int = COIN_STATES.NORMAL

func _ready() -> void:
	velocity.y = -300
	coin_timer = 10.0
	active_timer = 0.2
	$detect_player/collision.disabled = true

func _physics_process( delta : float ) -> void:
	if active_timer > 0:
		active_timer -= delta
		if active_timer <= 0:
			$detect_player/collision.disabled = false
	match state:
		COIN_STATES.NORMAL:
			coin_timer -= delta
			if coin_timer <= 0:
				coin_timer = 1.0
				state = COIN_STATES.FINISHING
		COIN_STATES.FINISHING:
			coin_timer -= delta
			if coin_timer <= 0:
				queue_free()
	
	gravity( delta )
	var coldata : KinematicCollision2D = move_and_collide( velocity * delta )
	if coldata:
		velocity = velocity.bounce( coldata.get_normal() )
	

var cought := false
func _on_detect_player_body_entered( _body : Node2D ) -> void:
	if cought: return
	cought = true
	game.state.coins += 1
	sigmgr.gamestate_changed.emit()
	queue_free()
	var x : Node2D = preload( "res://entities/vfx/stars.tscn" ).instantiate()
	x.position = position + Vector2( 0, -8 )
	get_parent().add_child( x )
	sigmgr.captured_coin.emit()
