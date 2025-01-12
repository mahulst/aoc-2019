extends SceneTree
var file = FileAccess.open("res://day3/input.txt", FileAccess.READ)

const Wire = preload("res://day3/Wire.gd")
const INT32_MAX = (1 << 31) - 1


func part_1(input: String):
    var lines = input.split("\n")
    var line1 = Wire.parse(lines[0])
    var line2 = Wire.parse(lines[1])
    var grid = {}
    var current = Vector2.ZERO
    for segment in line1:
        var dir = Wire.dir_vector(segment.dir)
        for i in range(segment.length):
            current = dir + current
            grid[current] = 0

    var grid2 = {}
    current = Vector2.ZERO
    for segment in line2:
        var dir = Wire.dir_vector(segment.dir)
        for i in range(segment.length):
            current = dir + current
            grid2[current] = 0
    var smallest = Vector2(INT32_MAX, INT32_MAX)

    for cross in intersect(grid, grid2).keys():
        var v: Vector2 = cross
        if manhattan_distance(v, Vector2.ZERO) < manhattan_distance(smallest, Vector2.ZERO):
            smallest = v

    print("part 1 answer: ", manhattan_distance(smallest, Vector2.ZERO))


func manhattan_distance(a: Vector2, b: Vector2) -> float:
    return abs(a.x - b.x) + abs(a.y - b.y)


func intersect(dict1: Dictionary, dict2: Dictionary) -> Dictionary:
    var result = {}
    for v in dict1.keys():
        if dict2.has(v):
            result[v] = dict1[v] + dict2[v]
    return result


func part_2(input: String):
    var lines = input.split("\n")
    var line1 = Wire.parse(lines[0])
    var line2 = Wire.parse(lines[1])
    var grid = {}
    var current = Vector2.ZERO
    var dist = 0
    for segment in line1:
        var dir = Wire.dir_vector(segment.dir)
        for i in range(segment.length):
            current = dir + current
            dist += 1
            grid[current] = dist

    var grid2 = {}
    current = Vector2.ZERO
    dist = 0
    for segment in line2:
        var dir = Wire.dir_vector(segment.dir)
        for i in range(segment.length):
            current = dir + current
            dist += 1
            grid2[current] = dist
    var smallest = INT32_MAX
    var crosses = intersect(grid, grid2)
    for cross in crosses.keys():
        var v: Vector2 = cross
        if crosses[cross] < smallest:
            smallest = crosses[cross]

    print("part 2 answer: ", smallest)


func _init():
    if file:
        var content = file.get_as_text()
        # var content = "R8,U5,L5,D3\nU7,R6,D4,L4"
        # var content = "R75,D30,R83,U83,L12,D49,R71,U7,L72\nU62,R66,U55,R34,D71,R55,D58,R83"

        file.close()
        part_1(content)
        part_2(content)

    else:
        print("Failed to open file.")
    quit()
