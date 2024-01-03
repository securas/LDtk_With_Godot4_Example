extends AudioStreamPlayer
class_name RandomPitchStreamMultiPlayer

@export var no_players : int = 3
@export var range_extent : float = 0.2
@export var stream_1 : AudioStream
@export var stream_2: AudioStream
@export var stream_3 : AudioStream

var streams : Array

var players = []
var cur_player = 0
var cur_pitch = 1.0
var base_pitch : float
func _ready():
	base_pitch = pitch_scale
	if stream_1:
		streams.append( stream_1 )
	if stream_2:
		streams.append( stream_2 )
	if stream_3:
		streams.append( stream_3 )
	if not streams:
		streams.append( stream )
	players.append( self )
	for _n in range( no_players - 1 ):
		var a = AudioStreamPlayer.new()
		players.append( a )
		add_child( a )
		a.bus = self.bus
		a.volume_db = self.volume_db

func get_player():
	cur_player = ( cur_player + 1 ) % no_players
	return players[ cur_player ]

func set_pitch( p ):
	cur_pitch = p

@warning_ignore("native_method_override")
func play( from_position : float = 0.0 ):
	var p = get_player()
	p.pitch_scale = base_pitch + randf_range( -range_extent, range_extent )
	p.stream = streams[ randi() % streams.size() ]
	#print( "playing on: ", p, " with ", p.pitch_scale )
	if p == self:
		super.play( from_position )
	else:
		p.play( from_position )

@warning_ignore("native_method_override")
func stop():
	for p in players:
		if p != self:
			p.stop()
	super.stop()

