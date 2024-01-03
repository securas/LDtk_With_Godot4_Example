class_name Main extends Node2D

var start_menu : Node2D
var world : Node2D
var credits : Node2D

func _ready() -> void:
	var _ret : int
	_ret = sigmgr.load_screen.connect( _on_load_screen )
	#sigmgr.set_music.connect( _on_set_music )
	
	sigmgr.load_screen.emit( "res://world/world.tscn" )
	


func _on_load_screen( scnfilename : String ) -> void:
	for c : Node2D in $stage.get_children():
		c.queue_free()
	var s : Node2D = load( scnfilename ).instantiate()
	$stage.add_child( s )


#enum MusicStreams { NORMAL, LAVA, BOSS, CREDITS, NONE }
#var streams : Array[AudioStreamWAV] = [
	#preload( "res://assets/music/normal.wav" ),
	#preload( "res://assets/music/lava.wav" ),
	#preload( "res://assets/music/boss.wav" ),
	#preload( "res://assets/music/end_song.wav" ),
#]
#var cur_stream : int = -1
#
#func _on_set_music( stream_no : MusicStreams, restart : bool = false ) -> void:
	#if stream_no == MusicStreams.NONE:
		#$music.stop()
		#cur_stream = stream_no
		#return
		#
	#if restart:
		#cur_stream = stream_no
		#$music.stream = streams[stream_no]
		#$music.play(0.0)
	#else:
		#if cur_stream == stream_no:
			#return
		#_on_set_music( stream_no, true )
