extends Node

@export var mob_scene: PackedScene

func _ready():
	$UserInterface/Retry.hide()
	MusicPlayer.play()

func _on_mob_timer_timeout() -> void:
	var mob = mob_scene.instantiate()
	var mob_spawn_location = get_node("SpawnPath/SpawnLocation")
	
	mob_spawn_location.progress_ratio = randf()

	var player_position = $Player.position
	mob_spawn_location.position.y = 0.5
	mob.initialize(mob_spawn_location.position, player_position)
	
	add_child(mob)
	
	mob.squashed.connect($UserInterface/ScoreLabel._on_mob_squashed.bind())

func _on_player_hit() -> void:
	$MobTimer.stop()
	$UserInterface/Retry.show()
	MusicPlayer.stop()
	
func _unhandled_input(event):
	if event.is_action_pressed("ui_accept") and $UserInterface/Retry.visible:
		# This restarts the current scene.
		for child in MusicPlayer.get_children():
			MusicPlayer.get_node(child.get_path()).stop()
		get_tree().reload_current_scene()
		
