@tool

extends Node3D

class_name VectorCube

@export var size : Vector3 = Vector3(1,1,1):
	set(ns):
		size = ns
		if is_inside_tree():
			update()
@export var color : Color = Color.WHITE:
	set(col):
		color = col
		if is_inside_tree():
			update()
@export var material : BaseMaterial3D:
	set(nM):
		material = nM
		if is_inside_tree():
			update()
@export var filled : bool = true:
	set(fl):
		filled = fl
		if is_inside_tree():
			update()
@export var collision : bool = false:
	set(col):
		collision = col
		if is_inside_tree():
			update()
@export var mesh_instance: MeshInstance3D


func getVertices(sz : Vector3) -> Array[Vector3]:
	var vertices : Array[Vector3] = [
		Vector3( 1,  1,  1) * sz,
		Vector3(-1,  1,  1) * sz,
		
		Vector3( 1,  1,  1) * sz,
		Vector3( 1, -1,  1) * sz,
		
		Vector3( 1,  1,  1) * sz,
		Vector3( 1,  1, -1) * sz,
		
		Vector3(-1, -1, -1) * sz,
		Vector3( 1, -1, -1) * sz,
		
		Vector3(-1, -1, -1) * sz,
		Vector3(-1,  1, -1) * sz,
		
		Vector3(-1, -1, -1) * sz,
		Vector3(-1, -1,  1) * sz,
		
		Vector3(-1,  1,  1) * sz,
		Vector3(-1, -1,  1) * sz,
		
		Vector3( 1,  1, -1) * sz,
		Vector3( 1, -1, -1) * sz,
		
		Vector3( 1,  -1,  1) * sz,
		Vector3(-1,  -1,  1) * sz,
		
		Vector3( 1,  -1,  1) * sz,
		Vector3( 1,  -1, -1) * sz,
		
		Vector3(-1,   1, -1) * sz,
		Vector3(-1,   1,  1) * sz,
		
		Vector3(-1,   1, -1) * sz,
		Vector3( 1,   1, -1) * sz,
	]
	
	return vertices

var iMesh : ImmediateMesh = ImmediateMesh.new()
func _ready() -> void:
	update()

@export var collisionBody: StaticBody3D
@export var collisionShape: CollisionShape3D

@export var fill_mesh: MeshInstance3D

func update() -> void:
	iMesh.clear_surfaces()
	iMesh.surface_begin(Mesh.PRIMITIVE_LINES, material)
	var vertices : Array[Vector3] = getVertices(size * Vector3(0.5,0.5,0.5))
	for v : Vector3 in vertices:
		iMesh.surface_add_vertex(v)
	iMesh.surface_end()
	mesh_instance.mesh = iMesh
	
	fill_mesh.visible = filled
	fill_mesh.scale = size
	
	collisionBody.collision_layer = 1 if collision else 0
	collisionShape.shape.size = size
	
	material.albedo_color = color
