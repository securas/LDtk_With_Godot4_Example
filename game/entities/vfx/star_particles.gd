extends GPUParticles2D

@export var continuous : bool = false

func _ready() -> void:
	var _ret : int = sigmgr.captured_coin.connect( _on_captured_coin )

func _on_captured_coin() -> void:
	if continuous: return
	emitting = true
	$timer.start()

func _on_timer_timeout() -> void:
	emitting = false


