extends Camera3D

@export var cameraSpeed = 0.1
@export var debugTarget: Node3D
@export var debugSpeed: float

var target: Node3D = null
var offset: Vector3
var trueSpeed: float
var trueTarget: Node3D
var debugMode: bool = true

func _ready():
	trueTarget = target if target != null else debugTarget
	trueSpeed = cameraSpeed

func setTarget(nodeTarget):
	target = nodeTarget
	trueTarget = target
	offset.y = global_position.y - target.global_position.y
	offset.x = 0

func _process(delta):
	if target != null:
		var newPos = trueTarget.global_position + offset
		newPos.z = global_position.z
		global_position = lerp(global_position, newPos, trueSpeed)
	if Input.is_action_just_pressed("DebugInput"):
		debugMode = not debugMode
		trueSpeed = cameraSpeed if debugMode else debugSpeed
		trueTarget = target if debugMode else debugTarget
