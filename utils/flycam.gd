extends Camera3D
class_name FlyCamera

const speed = 0.8
const sensitivity = 0.001

var active := false
var motion: Vector3
var view_motion: Vector2
var gimbal_base: Transform3D
var gimbal_pitch: Transform3D
var gimbal_yaw: Transform3D


func is_active() -> bool:
    return active


func _ready():
    pass

func _input(event):

    if event is InputEventKey:
        if event.keycode == KEY_TAB:
            print(active)
            if event.pressed:
                # Each click toggle.
                active = active == false
                update_activation()
                return

        if active == false:
            return

        var value: float = 0
        if event.pressed:
            value = 1

        Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
        if event.keycode == KEY_W:
            motion.z = value * -1.0
        elif event.keycode == KEY_S:
            motion.z = value
        elif event.keycode == KEY_A:
            motion.x = value * -1.0
        elif event.keycode == KEY_D:
            motion.x = value
        elif event.keycode == KEY_Q:
            motion.y = value
        elif event.keycode == KEY_E:
            motion.y = value * -1.0
        else:
            Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

        get_viewport().set_input_as_handled()
    elif event is InputEventMouseMotion:
        if active:
            view_motion += event.relative
            get_viewport().set_input_as_handled()


func _process(delta):
    if active:
        gimbal_base *= Transform3D(Basis(), global_transform.basis * (motion * speed))

        gimbal_yaw = gimbal_yaw.rotated(Vector3(0, 1, 0), view_motion.x * sensitivity * -1.0)
        gimbal_pitch = gimbal_pitch.rotated(Vector3(1, 0, 0), view_motion.y * sensitivity * -1.0)
        view_motion = Vector2()

        global_transform = gimbal_base * (gimbal_yaw * gimbal_pitch)
    else:

        pass


# ---------------------------------------------------------------------- Private
func update_activation():
    set_process(active)
    current = active
    if active == false:
        Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
