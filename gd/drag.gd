extends Node

const Atom = preload('res://gd/atom.gd')

var atom


func _input(event: InputEvent):
	if event is InputEventMouseButton:
		if event.pressed:
			if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
				if event.pressed:
					var board = Global.blackboard
					atom = get_atom_at_mouse()
					if atom:
						board.move_child(
								atom,
								Global.blackboard.get_child_count() - 1
						)
						Input.set_custom_mouse_cursor(null, Input.CURSOR_MOVE)
		elif atom:
			if atom.get_overlapping_areas().size() > 0:
				var other = atom.get_overlapping_areas()[0]
				var new = atom.combine(other)
				if new:
					print(other)
					print(new)
					var a = Atom.new(new)
					Global.blackboard.add_child(a)
					a.translate(atom.position)

					atom.free()
					other.free()

			atom = null
	elif event is InputEventMouseMotion and atom:
		atom.translate(event.relative)


func is_hovering_atom(atom):
	if not atom:
		return false
	var rect = Rect2()
	rect.size = Vector2.ONE * Atom.SIZE
	rect.position = atom.position - Vector2(Atom.SIZE, Atom.SIZE) / 2
	if rect.has_point(get_viewport().get_mouse_position()):
		return true
	return false


func get_atom_at_mouse():
	var atoms = Global.blackboard.get_atoms()
	atoms.invert()

	for a in atoms:
		if is_hovering_atom(a):
			return a
	return null


func change_cursor(cursor_shape: int):
	Input.set_custom_mouse_cursor(null, cursor_shape)

