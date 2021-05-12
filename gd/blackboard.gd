extends Node2D

const Atom = preload('res://gd/atom.gd')

const INITIAL_ELEMENTS = [
	'air',
	'water',
	'earth',
	'fire'
]


func _ready():
	Global.get_blackboard()
	create_initial_elements()


func _input(event: InputEvent):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT:
			if event.pressed and event.doubleclick:
				var atom_at_mouse = Drag.get_atom_at_mouse()
				if atom_at_mouse:
					create_atom(atom_at_mouse.element, get_viewport().get_mouse_position())
				else:
					create_initial_elements(event.position)

	update()


func _draw():
	draw_string(
			Control.new().get_font('font'),
			Vector2(0, 32),
			'mouse pos %s' % str(get_viewport().get_mouse_position())
	)
	if not Drag.atom:
		return
	draw_string(
			Control.new().get_font('font'),
			Vector2(0, 64),
			'%s pos %s' % [Drag.atom.element.name, str(Drag.atom.position)]
	)


func get_atoms():
	var arr = get_children()
	for n in get_children():
		if not n is Atom:
			arr.erase(n)
	return arr


func create_atom(element, position := Vector2(512, 512), random_max := 128, random_min := 0):
	var a = Atom.new(element)
	add_child(a)
	a.translate(position)
	if abs(random_max) >= 1:
		var x = rand_range(-random_max, random_max)
		var y = rand_range(-random_max, random_max)
		var xy = Vector2(x, y)
		a.translate(xy)
	return a


func create_initial_elements(position := Vector2(512, 512)) -> void:
	var step = TAU / INITIAL_ELEMENTS.size()
	var radius = Atom.SIZE * 1.5
	var cur = -step * (float(INITIAL_ELEMENTS.size()) / 2)

	position += Vector2.ONE * radius / 2

	for s in INITIAL_ELEMENTS:
		if s.empty():
			continue
		print(s)
		var e = Global.find_element(s)
		if e:
			position += Vector2(
					sin(cur) * radius,
					cos(cur) * radius
			)
			create_atom(e, position, 0)
			cur += step

