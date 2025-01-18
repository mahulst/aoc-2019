extends Node3D
class_name Pixel

# Default size of the box
# Default color of the box (black or white)
var box_color: Color
var box_size: Vector3
var padding = 0.1


func pixel_to_position(pixel_coord: Vector2) -> Vector3:
    return Vector3(
        pixel_coord.x * (box_size.x + padding), 0.0, pixel_coord.y * (box_size.z + padding)
    )


func _init(
    pixel_position = Vector2(0, 0),
    layer: int = 1,
    _size: Vector3 = Vector3(1, 1, 1),
    _color: Color = Color(0, 0, 0)
):
    box_size = _size
    box_color = _color

    # Create the RigidBody3D
    var rigid_body = RigidBody3D.new()
    rigid_body.lock_rotation = true
    add_child(rigid_body)

    # Create the MeshInstance3D for the box
    var mesh_instance = MeshInstance3D.new()
    var box_mesh = BoxMesh.new()
    box_mesh.size = box_size
    mesh_instance.mesh = box_mesh

    # Apply the color
    var material = StandardMaterial3D.new()
    material.albedo_color = box_color
    mesh_instance.material_override = material

    rigid_body.add_child(mesh_instance)

    # Create the CollisionShape3D for the box
    var collision_shape = CollisionShape3D.new()
    var shape = BoxShape3D.new()
    shape.size = box_size  # Godot uses half-extents for BoxShape3D
    collision_shape.shape = shape
    rigid_body.add_child(collision_shape)

    # Position the children properly (if necessary)
    var pos = pixel_to_position(pixel_position)
    pos.y = layer * (box_size.y) + 0.1

    mesh_instance.position = pos
    collision_shape.position = pos
