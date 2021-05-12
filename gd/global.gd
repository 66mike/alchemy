extends Node

const ELEMENT_DIR = 'res://json/elements/'

var elements

var blackboard


func _ready() -> void:
	var err: int

	elements = cache_elements()
	if elements[0] is int:
		get_tree().quit(elements[0])

	randomize()


# If an error is found, function returns an array that only
# contains the error code.
func cache_elements() -> Array:
	var elements: Array
	var err: int

	var dir := Directory.new()
	var fs := File.new()

	err = dir.open(ELEMENT_DIR)
	if err:
		return [err]
	err = dir.list_dir_begin(true)
	if err:
		return [err]
	
	var next = dir.get_next()
	while next:
		if not next.ends_with('.e') and not next.ends_with('.json'):
			continue

		err = fs.open(ELEMENT_DIR.plus_file(next), File.READ)
		if err:
			return [err]

		var json = fs.get_as_text()
		json = parse_json(json)
		
		elements.push_back(json)

		next = dir.get_next()

	return elements


func find_element(name: String):
	var h = hash(name.to_lower())
	for e in elements:
		if hash(e.name.to_lower()) == h:
			return e
	return null


func combine(e1, e2):
	if e2.name.to_lower() in e1.combos:
		if e1.combos[e2.name.to_lower()]:
			return find_element(e1.combos[e2.name.to_lower()])
	elif e1.name.to_lower() in e2.combos:
		if e2.combos[e1.name.to_lower()]:
			return find_element(e2.combos[e1.name.to_lower()])
	return null


func get_blackboard():
	blackboard = get_tree().current_scene.get_node('.')
	return blackboard

