extends Object


static func spawn_gizmo() -> ImmediateMesh:
    var mesh = ImmediateMesh.new()
    # Start drawing line primitives
    mesh.surface_begin(Mesh.PRIMITIVE_TRIANGLES)

    # X-axis in red
    mesh.surface_set_color(Color.RED)
    mesh.surface_add_vertex(Vector3.ZERO)
    mesh.surface_add_vertex(Vector3(1, 0, 0))

    # Y-axis in green
    mesh.surface_set_color(Color.GREEN)
    mesh.surface_add_vertex(Vector3.ZERO)
    mesh.surface_add_vertex(Vector3(0, 0, 1))

    # Z-axis in blue
    mesh.surface_set_color(Color.BLUE)
    mesh.surface_add_vertex(Vector3.ZERO)
    mesh.surface_add_vertex(Vector3(1, 0, 1))

    mesh.surface_end()

    return mesh
