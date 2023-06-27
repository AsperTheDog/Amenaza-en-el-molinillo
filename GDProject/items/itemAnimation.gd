extends Node
class_name ItemAnimator

@export var strength: float = 0.5
@export var speed: float = 2
@export var rotationSpeed: float = 120

var counter = 0.0
var initialPos: Vector3
var parent: Node3D

# Called when the node enters the scene tree for the first time.
func _ready():
	parent = get_parent()
	initialPos = parent.transform.origin


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	counter += delta
	var height = sin(counter * speed) * strength + initialPos.y
	var newPos = initialPos
	newPos.y = height
	parent.transform.origin = newPos
	parent.rotate(Vector3(0, 1, 0), deg_to_rad(rotationSpeed) * delta)
	
