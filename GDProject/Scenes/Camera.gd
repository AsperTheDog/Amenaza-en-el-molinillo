extends Camera3D

@export var cameraSpeed = 0.1
@export var height: float = 1
@export var length: float = 10

var target: Node3D = null
var speedMult: float = 1

func setTarget(nodeTarget):
	target = nodeTarget

func _process(delta):
	if target != null:
		var newPos = target.global_position
		newPos.y += height
		newPos.z = length
		global_position = lerp(global_position, newPos, cameraSpeed * speedMult * delta)

func setSpeedMult(mult: float):
	speedMult = mult
