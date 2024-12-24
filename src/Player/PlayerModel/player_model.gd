extends Node3D

class_name PlayerModel

@export var player_anim_tree: AnimationTree
@export var playerMovement : PlayerMovement
@export var phrog : Node3D

var blendSlide : float = 0.0
var blendFall : float = 0.0
var blendSwim : float = 0.0
var phrogXRot : float = 0.0
var phrogWXRot : float = 0.0
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
			blendSwim = lerpf(blendSwim, 0, delta * 12.0)
			player_anim_tree["parameters/TS_IWR/scale"] = clamp(playerMovement.h_speed / 4.0,0.4,1) * 2.5
			player_anim_tree["parameters/IdleWalkRun/blend_position"] = clamp(playerMovement.h_speed / 4.0,0,1)
		PlayerMovement.M_FALLING:
			blendSlide = lerpf(blendSlide, 0, delta * 12.0)
			blendFall = lerpf(blendFall, 1, delta * 12.0)
			blendSwim = lerpf(blendSwim, 0, delta * 2.0)
			player_anim_tree["parameters/JumpFall/blend_position"] = clamp(playerMovement.velocity.y,-1,1)
		PlayerMovement.M_SLIDING:
			blendSlide = lerpf(blendSlide, 1, delta * 12.0)
			blendFall = lerpf(blendFall, 0, delta * 12.0)
			blendSwim = lerpf(blendSwim, 0, delta * 12.0)
			if playerMovement.groundRays.groundDistance < -0.15:
				var colNorm : Vector3 = playerMovement.groundRays.groundNormal
				phrogXRot = acos(colNorm.dot(Vector3.UP)) * (1.0 if global_basis.z.dot(colNorm) > 0.0 else -1.0)
			else:
				phrogXRot = clamp(-playerMovement.velocity.y * 0.06,-QPI,QPI)
		PlayerMovement.M_SWIMMING:
			blendSwim = lerpf(blendSwim, 1, delta * 12.0)
			blendSlide = lerpf(blendSlide, 0, delta * 12.0)
			blendFall = lerpf(blendFall, 0, delta * 12.0)
			
			player_anim_tree["parameters/SwimMotion/blend_position"] = lerpf(player_anim_tree["parameters/SwimMotion/blend_position"], clamp(playerMovement.h_speed / 4.0 + abs(playerMovement.velocity.y),0,1), delta * 2.0)
			player_anim_tree["parameters/TS_Swim/scale"] = clamp(playerMovement.h_speed / 4.0,0.4,1) * 2.5
			phrogWXRot = lerpf(phrogWXRot, clamp(-playerMovement.velocity.dot(Vector3.UP) * QPI * 0.333, -QPI, QPI),delta * 4.0)
			phrogXRot = phrogWXRot
	phrog.rotation.x = lerp_angle(phrog.rotation.x, phrogXRot, delta * 12.0)
	
	player_anim_tree["parameters/B2Fall/blend_amount"] = blendFall
	player_anim_tree["parameters/B2_Slide/blend_amount"] = blendSlide
	player_anim_tree["parameters/B2_Swim/blend_amount"] = blendSwim
	if playerMovement.h_speed > 0.01:
		global_rotation.y = lerp_angle(global_rotation.y, -Vector2(playerMovement.velocity.x,playerMovement.velocity.z).angle() + HPI, delta * 8.0)
	
	match lightProbes.size():
		1:
			pass
		2:
			pass
	

var lightProbes : Array[LightProbe] = []

func registerLightProbe(probe : LightProbe) -> void:
	lightProbes.append(probe)
	lightProbes.sort_custom(sortLightProbes)

func sortLightProbes(a : LightProbe, b : LightProbe) -> bool:
	return a.priority > b.priority

func unregisterLightProbe(probe : LightProbe) -> void:
	lightProbes.erase(probe)
	lightProbes.sort_custom(sortLightProbes)
