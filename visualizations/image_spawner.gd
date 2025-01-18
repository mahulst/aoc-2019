extends Node
var gizmos = preload("res://utils/Gizmo.gd")
var file = FileAccess.open("res://day8/input.txt", FileAccess.READ)
var parser = preload("res://day8/parser.gd")
var images = []
func _ready():
    var cam = get_node("/root/Day8/Camera3D")

    cam.position = Vector3(3, 6, 8)
    print(cam.rotation)
    cam.look_at(Vector3(3, 00, 00), Vector3.UP)
    print(cam.rotation)
    images= parser.decode_images(file.get_as_text(), 25, 6)

    pass

func spawn():
    var dict = {}
    var layer = 0
    for image in images:
        var count = 0
        for pixel in image:
            var pixel_pos = Vector2(count % 25, count / 25)
            if dict.has(pixel_pos):
                count += 1
                continue;

            if pixel == 2:
                count += 1
                continue;

            var color = Color(1,1,1) if pixel == 1 else Color(0,0,0)
            dict[pixel_pos] = [color, layer]
            count += 1
        layer += 1

    for key in dict:
        var value = dict[key]
        add_child(Pixel.new(key, value[1], Vector3(0.3, 0.3, 0.3), value[0]))


func _input(event):
    if event is InputEventKey:
        if event.keycode == KEY_SPACE:
            if event.pressed:
                spawn()
                return

