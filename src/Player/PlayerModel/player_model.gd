extends Node3D

@export var player_anim_tree: AnimationTree
@export var playerMovement : PlayerMovement
@export var phrog : Node3D

var blendSlide : float = 0.0
var blendFall : float = 0.0
var phrogXRot : float = 0.0
const HPI : float = PI/2
const QPI : float = PI/4

func _ready() -> void:
	playerMovement.jumped.connect(jumped)

func jumped() -> void:
	player_anim_tree["parameters/TSJumpFall/seek_request"] = 1.0

func _process(delta: float) -> void:
	phrogXRot = 0.0
	match playerMovement.movementMode:
		PlayerMovement.M_GROUNDED:
			blendSlide = lerpf(blendSlide, 0, delta * 12.0)
			blendFall = lerpf(blendFall, 0, delta * 12.0)
			player_anim_tree["parameters/TS_IWR/scale"] = clamp(playerMovement.h_speed / 4.0,0,1) * 2.0
			player_anim_tree["parameters/IdleWalkRun/blend_position"] = clamp(playerMovement.h_speed / 4.0,0,1)
		PlayerMovement.M_FALLING:
			blendSlide = lerpf(blendSlide, 0, delta * 12.0)
			blendFall = lerpf(blendFall, 1, delta * 12.0)
			player_anim_tree["parameters/JumpFall/blend_position"] = clamp(playerMovement.velocity.y,-1,1)
		PlayerMovement.M_SLIDING:
			blendSlide = lerpf(blendSlide, 1, delta * 12.0)
			blendFall = lerpf(blendFall, 0, delta * 12.0)
			if playerMovement.slideRay.get_collider():
				var colNorm : Vector3 = playerMovement.slideRay.get_collision_normal()
				phrogXRot = acos(colNorm.dot(Vector3.UP)) * (1.0 if global_basis.z.dot(colNorm) > 0.0 else -1.0)
			else:
				phrogXRot = clamp(-playerMovement.velocity.y * 0.06,-QPI,QPI)
	
	phrog.rotation.x = lerp_angle(phrog.rotation.x, phrogXRot, delta * 12.0)
	
	player_anim_tree["parameters/B2Fall/blend_amount"] = blendFall
	player_anim_tree["parameters/B2_Slide/blend_amount"] = blendSlide
	if playerMovement.h_speed > 0.01:
		global_rotation.y = lerp_angle(global_rotation.y, -Vector2(playerMovement.velocity.x,playerMovement.velocity.z).angle() + HPI, delta * 8.0)
