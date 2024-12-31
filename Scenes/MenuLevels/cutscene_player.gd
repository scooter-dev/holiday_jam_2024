extends AnimationPlayer

@export var player : Player
@export var player_pos: Node3D
@export var jumpPad : JumpPad

func _ready() -> void:
	if !LevelManager.initialCutscene:
		play("Intro")
	else:
		jumpPad.enabled = true

func freezePlayer() -> void:
	player.suspend(true)
	player.reparent(player_pos,true)
	print(player.get_parent().name)
	player.position = Vector3()
	player.rotation.y = 0

func unfreezePlayer() -> void:
	player.unsuspend()

func displayDialog(text : String) -> void:
	player.hud.display_info_box(text)

func closeDialog() -> void:
	player.hud.close_info_box()

func _on_cutscene_trigger_body_entered(body: Node3D) -> void:
	if !LevelManager.initialCutscene:
		LevelManager.initialCutscene = true
		play("Story01")
