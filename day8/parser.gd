extends Object

static func decode_images(input: String, width: int, height: int):
    var result = []
    var image = []
    for c in input:
        image.push_back(c.to_int())
        if image.size() < width * height:
            pass
        else:
            result.push_back(image)
            image = []
            pass

    return result

