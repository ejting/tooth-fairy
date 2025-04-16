extends Area3D

@export var player_ref : Player

func on_body_enter(body):
	# fade
	player_ref.dm_ref.lock_down_player()
	player_ref.dm_ref.reset(null)
	player_ref.dm_ref.blackout()
	await get_tree().create_timer(1.0).timeout
	# Ok now switch scenes
	get_tree().change_scene_to_file("res://scenes/teeth_scenes/teeth_pulling.tscn")
