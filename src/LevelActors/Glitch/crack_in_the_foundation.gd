@tool

extends Node3D
@export var glitchName : String
@export var nodeToBreak : Node3D
@export var mesh : MeshInstance3D
@export var size : float = 1.0:
	set(sz):
		size = sz
		if is_inside_tree():
			mesh.mesh.size = Vector2(size,size)

func _ready() -> void:
	mesh.mesh.size = Vector2(size,size)
	if !Engine.is_editor_hint():
		if !LevelManager.glitches.has(glitchName):
			nodeToBreak.queue_free()
		else:
			queue_free()
