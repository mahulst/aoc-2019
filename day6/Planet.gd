extends Node3D
class_name Planet
var center: Planet
var radius: float
var speed := 1.0
var theta = 0.0

var tilt_axis: Vector3
var tilt_angle: float
var rotation_matrix: Basis
var sphere_ins
var ring_ins


func _init(_orbiting: Planet, _distance: float, size: float):
    var sphere = load("res://day6/Planet.tscn")
    var ins = sphere.instantiate()
    var planet_mesh = ins.get_node("PlanetMesh")

    ins.scale = Vector3(size, size, size)
    sphere_ins = ins

    add_child(ins)
    center = _orbiting
    radius = _distance

    tilt_axis = (
        Vector3(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0), randf_range(-1.0, 1.0)).normalized()
    )

    tilt_angle = randf_range(0, PI)
    rotation_matrix = Basis(tilt_axis.normalized(), tilt_angle)

    spawn_orbital_path()
    if center == null:
        var mat = StandardMaterial3D.new()
        mat.emission_enabled = true
        mat.emission = Color(0.2, 1.0, 1.0)
        mat.emission_operator = BaseMaterial3D.EMISSION_OP_ADD
        mat.emission_energy = 20.0
        planet_mesh.material_override = mat
    else:
        var new_material = StandardMaterial3D.new()

        new_material.albedo_color = Color(
            randf_range(0, 1.0), randf_range(0, 1.0), randf_range(0, 1.0)
        )

        planet_mesh.material_override = new_material


func spawn_orbital_path():
    var torus_mesh = TorusMesh.new()

    torus_mesh.outer_radius = radius + 0.02
    torus_mesh.inner_radius = radius - 0.02

    var mesh_instance = MeshInstance3D.new()
    mesh_instance.mesh = torus_mesh

    ring_ins = mesh_instance
    ring_ins.basis = rotation_matrix
    add_child(mesh_instance)


func _process(delta):
    theta += speed * delta
    theta = fmod(theta, 360)

    var flat_rotation = Vector3(radius * cos(theta), 0, radius * sin(theta))

    var tilted_position = rotation_matrix * flat_rotation

    if center is Planet:
        ring_ins.position = center.sphere_ins.position
        tilted_position += center.sphere_ins.position
    if sphere_ins != null:
        sphere_ins.position = tilted_position
