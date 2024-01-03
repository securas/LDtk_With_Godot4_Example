extends AudioStreamPlayer
class_name RandomPitchStreamPlayer

@export var range_extent : float = 0.2
@export var stream_1 : AudioStream
@export var stream_2: AudioStream
@export var stream_3 : AudioStream
var streams : Array

func _ready():
	if stream_1:
		streams.append( stream_1 )
	if stream_2:
		streams.append( stream_2 )
	if stream_3:
		streams.append( stream_3 )
	if not streams:
		streams.append( stream )



@warning_ignore("native_method_override")
func play( from_position : float = 0.0 ):
	pitch_scale = 1 + randf_range( -range_extent, range_extent )
	stream = streams[ randi() % streams.size() ]
	super.play( from_position )

