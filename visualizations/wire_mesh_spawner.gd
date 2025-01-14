extends Node3D
var wire_instance
var box_mesh
var wire_instance2
var box_mesh2

var wire_material
var wire_material2
@onready var shader = preload("res://visualizations/wire_grower.gdshader")

var wire: Array
var wire2: Array
var file = FileAccess.open("res://day3/input.txt", FileAccess.READ)
const Wire = preload("res://day3/Wire.gd")


func generate_wire_mesh(segments: Array, wire_width: float) -> Array:
    var vertices = PackedVector3Array()
    var indices = PackedInt32Array()
    var normals = PackedVector3Array()
    var uvs = PackedVector2Array()

    var current_index = 0

    var start_pos = Vector2(0, 0)

    var normal_3d = Vector3(0, 1, 0)
    var count = 0
    var length_so_far = 0
    for segment in segments:
        count += 1
        var last = count == segments.size()
        var first = count == 0

        var dir_2d = Wire.dir_vector(segment.dir)
        var segment_length_reasonable = float(segment.length) / 4.0
        var end_pos = start_pos + dir_2d * float(segment_length_reasonable)

        # Remove overlapping pieces and draw the corner separately later
        var vert_end_pos = end_pos
        var vert_start_pos = start_pos

        if !last:
            vert_end_pos -= dir_2d * (wire_width / 2.0)

        if !first:
            vert_start_pos += dir_2d * (wire_width / 2.0)

        var perpendicular_to_dir = Vector2(-dir_2d.y, dir_2d.x)

        var half_wire_width = wire_width * 0.5

        # Line segment
        var left_offset_start = vert_start_pos + perpendicular_to_dir * half_wire_width
        var right_offset_start = vert_start_pos - perpendicular_to_dir * half_wire_width
        var left_offset_end = vert_end_pos + perpendicular_to_dir * half_wire_width
        var right_offset_end = vert_end_pos - perpendicular_to_dir * half_wire_width

        var corner_left_start = Vector3(
            left_offset_start.x,
            1,
            left_offset_start.y,
        )
        var corner_right_start = Vector3(
            right_offset_start.x,
            1,
            right_offset_start.y,
        )
        var corner_left_end = Vector3(
            left_offset_end.x,
            1,
            left_offset_end.y,
        )
        var corner_right_end = Vector3(
            right_offset_end.x,
            1,
            right_offset_end.y,
        )

        vertices.append(corner_left_start)
        vertices.append(corner_right_start)
        vertices.append(corner_left_end)
        vertices.append(corner_right_end)

        uvs.append(Vector2(length_so_far, 0))
        uvs.append(Vector2(length_so_far, 0))
        uvs.append(Vector2(length_so_far + segment_length_reasonable - half_wire_width, 0))
        uvs.append(Vector2(length_so_far + segment_length_reasonable - half_wire_width, 0))

        normals.append(normal_3d)
        normals.append(normal_3d)
        normals.append(normal_3d)
        normals.append(normal_3d)

        indices.append(current_index + 0)
        indices.append(current_index + 1)
        indices.append(current_index + 2)

        indices.append(current_index + 2)
        indices.append(current_index + 1)
        indices.append(current_index + 3)

        current_index += 4

        # Add corner segment
        var extend_left_top = left_offset_end + wire_width * dir_2d
        var extend_right_top = right_offset_end + wire_width * dir_2d

        var extend_corner_left_start = Vector3(
            left_offset_end.x,
            1,
            left_offset_end.y,
        )
        var extend_corner_right_start = Vector3(
            right_offset_end.x,
            1,
            right_offset_end.y,
        )
        var extend_corner_left_end = Vector3(
            extend_left_top.x,
            1,
            extend_left_top.y,
        )
        var extend_corner_right_end = Vector3(
            extend_right_top.x,
            1,
            extend_right_top.y,
        )

        vertices.append(extend_corner_left_start)
        vertices.append(extend_corner_right_start)
        vertices.append(extend_corner_left_end)
        vertices.append(extend_corner_right_end)

        normals.append(normal_3d)
        normals.append(normal_3d)
        normals.append(normal_3d)
        normals.append(normal_3d)

        uvs.append(Vector2(length_so_far + segment_length_reasonable - half_wire_width, 0))
        uvs.append(Vector2(length_so_far + segment_length_reasonable - half_wire_width, 0))
        uvs.append(Vector2(length_so_far + segment_length_reasonable + half_wire_width, 0))
        uvs.append(Vector2(length_so_far + segment_length_reasonable + half_wire_width, 0))

        indices.append(current_index + 0)
        indices.append(current_index + 1)
        indices.append(current_index + 2)

        indices.append(current_index + 2)
        indices.append(current_index + 1)
        indices.append(current_index + 3)

        current_index += 4

        length_so_far += segment_length_reasonable
        start_pos = end_pos

    var mesh_arrays = []
    mesh_arrays.resize(Mesh.ARRAY_MAX)
    mesh_arrays[Mesh.ARRAY_VERTEX] = vertices
    mesh_arrays[Mesh.ARRAY_INDEX] = indices
    mesh_arrays[Mesh.ARRAY_NORMAL] = normals
    mesh_arrays[Mesh.ARRAY_TEX_UV] = uvs

    return mesh_arrays


func _ready():
    var mesh_data = generate_wire_mesh(wire, 10.0)
    var mesh = ArrayMesh.new()

    mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, mesh_data)

    wire_material = ShaderMaterial.new()
    wire_material.shader = shader

    wire_material.set_shader_parameter("color", Vector3(0.0, 0.0, 1.0))
    box_mesh = mesh
    var rs = RenderingServer
    wire_instance = rs.instance_create()
    rs.mesh_surface_set_material(box_mesh.get_rid(), 0, wire_material.get_rid())
    rs.instance_set_base(wire_instance, mesh)
    rs.instance_set_scenario(wire_instance, get_world_3d().scenario)
    var tf = Transform3D(Basis.IDENTITY, Vector3.ZERO)
    rs.instance_set_transform(wire_instance, tf)

    var mesh_data2 = generate_wire_mesh(wire2, 10.0)
    var mesh2 = ArrayMesh.new()
    mesh2.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, mesh_data2)

    wire_material2 = ShaderMaterial.new()
    wire_material2.shader = shader

    wire_material2.set_shader_parameter("color", Vector3(1.0, 0.0, 0.0))
    box_mesh2 = mesh2
    wire_instance2 = rs.instance_create()
    rs.mesh_surface_set_material(box_mesh2.get_rid(), 0, wire_material2.get_rid())
    rs.instance_set_base(wire_instance2, mesh2)
    rs.instance_set_scenario(wire_instance2, get_world_3d().scenario)
    var tf2 = Transform3D(Basis.IDENTITY, Vector3.ZERO)
    rs.instance_set_transform(wire_instance2, tf2)


func _exit_tree():
    RenderingServer.free_rid(wire_instance)
    RenderingServer.free_rid(wire_instance2)


func _init():
    if file:
        var content = file.get_as_text()
        # var content = "R8,U5,L5,D3\nU7,R6,D4,L4"
        # var content = "R75,D30,R83,U83,L12,D49,R71,U7,L72\nU62,R66,U55,R34,D71,R55,D58,R83"
        wire = Wire.parse(content.split("\n")[0])
        wire2 = Wire.parse(content.split("\n")[1])
        file.close()

    else:
        print("Failed to open file.")


func _process(delta: float):
    var current = wire_material.get_shader_parameter("growth")
    var new_t = current if current != null else 0.0

    var new_growth = new_t + (delta * 200.0)

    wire_material.set_shader_parameter("growth", new_growth)
    wire_material2.set_shader_parameter("growth", new_growth)
