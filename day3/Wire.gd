extends Object
enum SegmentDirection { Up, Right, Down, Left }


class WireSegment:
    var dir: SegmentDirection
    var length: int

    func _init(new_dir: SegmentDirection, new_length: int):
        dir = new_dir
        length = new_length


static func dir_vector(dir: SegmentDirection) -> Vector2:
    match dir:
        SegmentDirection.Up:
            return Vector2(0,1)
        SegmentDirection.Right:
            return Vector2(1,0)
        SegmentDirection.Down:
            return Vector2(0,-1)
        SegmentDirection.Left:
            return Vector2(-1,0)
        _:
            assert(false)
            return Vector2.ZERO


static func parse_dir(str: String) -> SegmentDirection:
    match str[0]:
        "U":
            return SegmentDirection.Up
        "D":
            return SegmentDirection.Down
        "R":
            return SegmentDirection.Right
        _:
            return SegmentDirection.Left


static func parse(input_wire: String):
    var arr = []
    for segment in input_wire.split(","):
        var length = segment.substr(1, segment.length() - 1).to_int()

        var dir = parse_dir(segment)

        arr.push_back(WireSegment.new(dir, length))

    return arr
