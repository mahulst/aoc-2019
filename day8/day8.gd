extends SceneTree
var file = FileAccess.open("res://day8/input.txt", FileAccess.READ)
var parser = preload("res://day8/parser.gd")

func part_1(input: String, width: int, height: int):
    var result = parser.decode_images(input, width, height)
    var max = [9999, []]

    for i in result:
        print(i.size())
        var count = i.count(0)

        if max[0] > count:
            max = [count, i]

    print(result.size())
    var total = max[1].count(1) * max[1].count(2)
    print("part 1 answer: ", total)




func part_2(input: String):
    var total
    print("part 2 answer: ", total)


func _init():
    if file:
        var content = file.get_as_text()
        file.close()
        part_1("123456789012", 3, 2)
        part_1(content, 25, 6)
        part_2(content)
    else:
        print("Failed to open file.")
    quit()
