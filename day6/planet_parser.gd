extends Object


static func parse(input: String) -> Dictionary:
    var lines = input.split("\n")
    var result = {}
    for line in lines:
        var parts = line.split(")")

        var first = parts[0].strip_edges()
        var last = parts[1].strip_edges()

        if not result.has(last):
            result[last] = []
        if not result.has(first):
            result[first] = []

        result[first].push_back(last)

    return result
