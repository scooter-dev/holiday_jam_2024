extends Node3D

class_name PlayerModel

@export var player_anim_tree: AnimationTree
@export var playerMovement : PlayerMovement
@export var phrog : Node3D
@export var body: MeshInstance3D


var blendSlide : float = 0.0
var blendFall : float = 0.0
var blendSwim : float = 0.0
var blendAttack : float = 0.0
var phrogXRot : float = 0.0
var phrogWXRot : float = 0.0
const HPI : float = PI/2
const QPI : float = PI/4

func _ready() -> void:
	playerMovement.jumped.connect(jumped)
	PlayerInput.interact.connect(attacking)

func jumped() -> void:
	player_anim_tree["parameters/TSJumpFall/seek_request"] = 1.0
func attacking():
	player_anim_tree["parameters/TSAttack/seek_request"] = 1.0
	blendAttack = 1

func _process(delta: float) -> void:
	blendAttack = lerpf(blendAttack, 0, delta * 12.0)
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
	player_anim_tree["parameters/B2_Attack/blend_amount"] = blendAttack
	if playerMovement.h_speed > 0.01:
		global_rotation.y = lerp_angle(global_rotation.y, -Vector2(playerMovement.velocity.x,playerMovement.velocity.z).angle() + HPI, delta * 8.0)
	
	var lpSize : int = lightProbes.size()
	if lpSize == 0:
		body.material_override.set_shader_parameter("probe1Blend", 0.0)
		body.material_override.set_shader_parameter("probe2Blend", 0.0)
	elif lpSize == 1:
		var probe : LightProbe = lightProbes[0]
		body.material_override.set_shader_parameter("probe1", probe.lightTexture)
		body.material_override.set_shader_parameter("probe1Blend", getProbeBlend(probe))
		body.material_override.set_shader_parameter("probe1Direction", probe.directionNode.global_basis.y if probe.directionNode else Vector3(0,1,0))
		body.material_override.set_shader_parameter("probe2Blend", 0.0)
	elif lpSize > 1:
		var probe : LightProbe = lightProbes[0]
		body.material_override.set_shader_parameter("probe1", probe.lightTexture)
		body.material_override.set_shader_parameter("probe1Blend", getProbeBlend(probe))
		body.material_override.set_shader_parameter("probe1Direction", probe.directionNode.global_basis.y if probe.directionNode else Vector3(0,1,0))
		if probe.mode == LightProbe.e_mode.OVERRIDE:
			body.material_override.set_shader_parameter("probe2Blend", 0.0)
		else:
			probe = lightProbes[1]
			body.material_override.set_shader_parameter("probe2", probe.lightTexture)
			body.material_override.set_shader_parameter("probe2Blend", getProbeBlend(probe))
			body.material_override.set_shader_parameter("probe2Direction", probe.directionNode.global_basis.y if probe.directionNode else Vector3(0,1,0))
			if probe.mode == LightProbe.e_mode.OVERRIDE:
				body.material_override.set_shader_parameter("probe1Blend", 0.0)
	#print(body.material_override.get_shader_parameter("probe1"), " || ", body.material_override.get_shader_parameter("probe2"))

func getProbeBlend(probe : LightProbe) -> float:
	var colShape : CollisionShape3D = probe.shape
	var shapeSize : Vector3 = colShape.shape.size
	var blend : float = -sdBox((colShape.global_transform.inverse() * body.global_position), shapeSize, probe.falloff)
	blend = clampf(blend / max(probe.falloff, 0.001),0,1)
	return blend

func sdBox(pos : Vector3, box : Vector3, falloff : float) -> float:
	var q : Vector3 = abs(pos) - (box / Vector3(2,2,2))
	return Vector3(maxf(0,q.x),maxf(0,q.y),maxf(0,q.z)).length() + minf(maxf(q.x, maxf(q.y,q.z)),0.0);

var lightProbes : Array[LightProbe] = []

func registerLightProbe(probe : LightProbe) -> void:
	lightProbes.append(probe)
	lightProbes.sort_custom(sortLightProbes)

func sortLightProbes(a : LightProbe, b : LightProbe) -> bool:
	return a.priority > b.priority

func unregisterLightProbe(probe : LightProbe) -> void:
	lightProbes.erase(probe)
	lightProbes.sort_custom(sortLightProbes)
