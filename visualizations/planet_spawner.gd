extends Node

var Planet = preload("res://day6/Planet.gd")
var planet_parser = preload("res://day6/planet_parser.gd")


func _ready():
    print("hello")
    var planet1 = Planet.new(null, 0.0, 2.0)
    add_child(planet1)
    var content = """COM)B
    B)C
    C)D
    D)E
    E)F
    B)G
    G)H
    D)I
    E)J
    J)K
    K)L"""

    var dict = planet_parser.parse(content)
    print(dict)
    spawn_planet("B", planet1, dict, 1, 1)
    pass


func spawn_planet(_name: String, orbiting: Node3D, dict: Dictionary, depth: int, count: int):
    var this_planet = Planet.new(orbiting, 20.0 / depth + count, 1.0 / depth)
    var child_count = 1
    add_child(this_planet)
    if dict.has(_name):
        for planet in dict[_name]:
            spawn_planet(planet, this_planet, dict, depth + 1, child_count)
            child_count += 1
