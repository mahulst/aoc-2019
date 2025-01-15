extends SceneTree

var file = FileAccess.open("res://day6/input.txt", FileAccess.READ)

var planet_parser = preload("res://day6/planet_parser.gd")


func part_1(input: String):
    var dict = planet_parser.parse(input)

    var total = 0
    for key in dict:
        var count = count_parents(key, dict)
        total += count

    print("Answer part 1: ", total)


func count_parents(name: String, dict: Dictionary) -> int:
    for key in dict:
        if dict[key].has(name):
            return 1 + count_parents(key, dict)

    return 0


func list_parents(name: String, dict: Dictionary) -> Array:
    for key in dict:
        if dict[key].has(name):
            var arr = [key]
            arr.append_array(list_parents(key, dict))
            return arr

    return []


func part_2(input: String):
    var dict = planet_parser.parse(input)
    var you_list = list_parents("YOU", dict)
    var san_list = list_parents("SAN", dict)
    var you_count = 0
    var san_count = 0
    for plan in you_list:
        san_count = 0
        for plan_2 in san_list:
            if plan == plan_2:
                print("Answer part 2: ", you_count + san_count)
                return
                pass
            san_count += 1
        you_count +=1


func _init():
    var content = file.get_as_text().strip_edges()
    # var content = """COM)B
    # B)C
    # C)D
    # D)E
    # E)F
    # B)G
    # G)H
    # D)I
    # E)J
    # J)K
    # K)L
    # K)YOU
    # I)SAN"""

    part_1(content)
    part_2(content)

    quit()
