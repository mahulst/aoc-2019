extends SceneTree
var file = FileAccess.open("res://day1/input.txt", FileAccess.READ)

func part_1(input: String):
    var total = 0
    var lines = input.trim_suffix("\n").split("\n")
    for a in lines:
        total += int(a) / 3 - 2

    print("part 1 answer: ",total)

func part_2(input: String):
    var total = 0
    var lines = input.trim_suffix("\n").split("\n")
    for a in lines:
        total += get_mass(int(a))

    print("part 2 answer: ",total)

func get_mass(amount: int):
    var a = amount / 3 - 2
    if a <= 0 :
        return 0
    else:
        return a + get_mass(a)

func _init():
    if file:
        var content = file.get_as_text()
        file.close()
        part_1(content)
        part_2(content)

    else:
        print("Failed to open file.")
    quit()

