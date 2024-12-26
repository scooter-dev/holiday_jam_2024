@tool

extends Node3D

@export var material : Material :
	set(m):
		material = m
		if is_inside_tree():
			update()

var iMesh : ImmediateMesh = ImmediateMesh.new()
@export var gridSize : Vector2i = Vector2i(10,10):
	set(gs):
		gridSize = gs
		if is_inside_tree():
			update()

func _ready() -> void:
	update()

@export var grid_mesh_instance: MeshInstance3D

func update() -> void:
	iMesh.clear_surfaces()
	iMesh.surface_begin(Mesh.PRIMITIVE_LINES, material)
	var vertices : Array[Vector3]
	
	for i : int in range(gridSize.x):
		var xCoord : float = (float(i) / float(gridSize.x)) * 2 - 1
		vertices.append(Vector3(-1,0,xCoord))
		vertices.append(Vector3( 1,0,xCoord))
	for i : int in range(gridSize.y):
		var yCoord : float = (float(i) / float(gridSize.y)) * 2 - 1
		vertices.append(Vector3(yCoord,0, 1))
		vertices.append(Vector3(yCoord,0,-1))
	
	for v : Vector3 in vertices:
		iMesh.surface_add_vertex(v)
	iMesh.surface_end()
	grid_mesh_instance.mesh = iMesh
