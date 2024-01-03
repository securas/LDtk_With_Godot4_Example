extends Node


signal gamestate_changed

#@warning_ignore("untyped_declaration")
signal camera_shake( duration : float, magnitude : float, frequency : float )

signal load_screen( scn_filename : String )

#signal set_music( stream_no : Main.MusicStreams )
signal captured_coin
