extends SceneTree
var file = FileAccess.open("res://day2/input.txt", FileAccess.READ)


func part_1(input: String):
    var numbers = input.trim_suffix("\n").split(",")
    var int_array = PackedInt32Array()
    for s in numbers:
        int_array.append(s.to_int())
    var answer = run_program(int_array, 12, 2)
    print("part 1 answer: ", answer)


func part_2(input: String):
    var numbers = input.trim_suffix("\n").split(",")
    var int_array = PackedInt32Array()
    for s in numbers:
        int_array.append(s.to_int())
    var expected = 19690720
    for verb in range(100):
        for noun in range(100):
            var answer = run_program(int_array, noun, verb)
            if expected == answer:
                print("part 2 answer: ", 100 * noun + verb)
                return
        pass
    pass


func run_program(memory_input: PackedInt32Array, noun: int, verb: int):
    var memory = memory_input.duplicate()
    memory[1] = noun
    memory[2] = verb
    var finished = false
    var cursor = 0
    while !finished:
        var num = memory[cursor]
        if num == 1:
            var a = memory[memory[cursor + 1]] + memory[memory[cursor + 2]]
            memory[memory[cursor + 3]] = a
            cursor += 4
            pass
        elif num == 2:
            var a = memory[memory[cursor + 1]] * memory[memory[cursor + 2]]
            memory[memory[cursor + 3]] = a
            cursor += 4
            pass
        else:
            finished = true
            pass
        pass
    return memory[0]


func _init():
    if file:
        var content = file.get_as_text()
        file.close()
        part_1(content)
        part_2(content)

    else:
        print("Failed to open file.")
    quit()
