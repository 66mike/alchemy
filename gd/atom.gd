# Instantiated form of an element.
extends Area2D

const Element = preload('res://gd/element.gd')

const SIZE = 96

var element

var collider


func _init(element) -> void:
	var err: int

	if not element:
		print('element cannot be null')
		queue_free()
		return

	match typeof(element):
		TYPE_DICTIONARY:
			self.element = Element.new(element)
		TYPE_OBJECT:
			if element is Element:
				self.element = element
			else:
				queue_free()
				return
		_:
			print('invalid type %s for element parameter' % typeof(element))
			queue_free()
			return

	collider = CollisionShape2D.new()

	connect('mouse_entered', Input, 'set_custom_mouse_cursor', [ null, 13 ])
	connect('mouse_exited', Input, 'set_custom_mouse_cursor', [ null, 0 ])

	name = element.name


func _enter_tree() -> void:
	add_child(collider)

	collider.shape = RectangleShape2D.new()
	collider.shape.extents = Vector2.ONE * SIZE / 2


func _ready() -> void:
	update()


func _draw() -> void:
	var rect = Rect2()
	var font = Control.new().get_font('font')

	# If uncombinable, draw a hint for this.
	if element.combos.size() < 1:
		draw_arc(Vector2(), SIZE / 2.5, 0, TAU, 32, Color.red, 2, true)
	# Draw icon
	rect.size = Vector2.ONE * SIZE
	rect.position = -Vector2.ONE * SIZE / 2
	draw_texture_rect(element.icon, rect, false)
	# Draw text
	var str_size = font.get_string_size(element.name)
	draw_string(font, Vector2(-str_size.x / 2, SIZE / 2 + str_size.y), element.name)


func set_position(value: Vector2) -> void:
	value.x = clamp(value.x, 0, 1024)
	value.y = clamp(value.y, 0, 1024)
	.set_position(value)


func combine(atom):
	return Global.combine(element, atom.element)

