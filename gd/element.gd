extends Object

var name: String
var icon: Texture

var combos: Dictionary


func _init(data: Dictionary):
	name = data.name
	icon = load(data.icon)
	combos = data.combos

