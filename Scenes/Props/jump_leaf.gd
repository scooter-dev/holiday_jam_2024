@tool
extends Node3D

class_name JumpLeaf

var activePlayer : Player = null
var launchSpeed : float = 0.0
@export var verticalClamp : float = 30.0 :
	set(vC):
		verticalClamp = vC
		if is_inside_tree():
			height_marker.position.y = pow(verticalClamp,2) / (4 * 9.8)
@export var launchFWSpeed : float = 0.0
@export var addHeight : float = 4.0

@export_category("Components")
@export var detection_area: Area3D
@export var leaf_pos: BoneAttachment3D
@export var animation_player: AnimationPlayer
@export var height_marker: MeshInstance3D
@export var leafCollision : CollisionShape3D

func _ready() -> void:
	set_physics_process(false)
	height_marker.position.y = pow(verticalClamp,2) / (4 * 9.8)
	if !Engine.is_editor_hint():
		height_marker.visible = false

func _on_area_3d_body_entered(body: Node3D) -> void:
	var player : Player = body if body is Player else null
	
	if (player != null 
	and player.global_position.y > detection_area.global_position.y 
	and player.movement.velocity.y < -5.0):
		
		launchSpeed = abs(player.movement.velocity.y)
		activePlayer = player
		activePlayer.suspend()
		set_physics_process(true)
		animation_player.stop()
		animation_player.play("JumpStart", -1, launchSpeed * 0.25)
		leafCollision.set_deferred("disabled",true)

func _physics_process(delta: float) -> void:
	activePlayer.global_position = lerp(activePlayer.global_position, leaf_pos.global_position, delta * 8.0)


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	match anim_name:
		"JumpStart":
			print("Launch: ", min(launchSpeed + 3, verticalClamp))
			activePlayer.movement.launchPlayer(Vector3(0,min(launchSpeed + addHeight, verticalClamp),0) + launchFWSpeed * global_basis.x.normalized())
			activePlayer.unsuspend()
			set_physics_process(false)
			activePlayer = null
			animation_player.play("JumpEnd")
		"JumpEnd":
			await get_tree().create_timer(0.2).timeout
			leafCollision.set_deferred("disabled",false)


func _on_high_detection_area_body_entered(body: Node3D) -> void:
	if body is Player and body.movement.velocity.y < -5:
		leafCollision.set_deferred("disabled",true)


func _on_high_detection_area_body_exited(body: Node3D) -> void:
	leafCollision.set_deferred("disabled",false)
