extends AnimationPlayer

@export var player : Player
@export var player_pos: Node3D
@export var jumpPad : JumpPad

func _ready() -> void:
	if LevelManager.glitches.has("FINAL"):
		freezePlayer(false)
		deleteAllSaves()
		play("AllGlitches")
	elif !LevelManager.initialCutscene:
		play("Intro")
	await get_tree().physics_frame
	jumpPad.enabled = LevelManager.initialCutscene

@export var saves : Node3D
func deleteAllSaves() -> void:
	saves.queue_free()
	pass

func freezePlayer(reparent : bool = true) -> void:
	player.suspend(true)
	if reparent:
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


func _on_interactable_interacted(interactor: Interactor) -> void:
	play("FinalCutscene")


func _on_boss_cutscene_area_body_entered(body: Node3D) -> void:
	play("BigReveal")
