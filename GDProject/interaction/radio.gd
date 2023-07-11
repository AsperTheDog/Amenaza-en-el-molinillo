extends StaticBody3D

@export var animationSpeed: float = 1
@export var animationStrength: float = 1
@export var jumpCurve: Curve
@export var rotateCurve: Curve
@export var punchCooldown: float = 0.5

var radioChannels: Array[AudioStreamPlayer3D]

var activeChannel: int = 0
var lastTimePunched: float = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	for child in get_children():
		if child.is_class("AudioStreamPlayer3D"):
			radioChannels.append(child)
	radioChannels.append(null)
	changeChannel(0)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	lastTimePunched += delta

func changeChannel(idx: int):
	if idx < 0 or idx >= radioChannels.size():
		return
	if radioChannels[activeChannel] != null:
		radioChannels[activeChannel].stop()
	activeChannel = idx
	if radioChannels[activeChannel] != null:
		radioChannels[activeChannel].play()
		$CPUParticles3D.emitting = true
		$"item-radio-speaker_v1/AnimationPlayer".play()
		$"item-radio-speaker_v2/AnimationPlayer".play()
	else:
		$CPUParticles3D.emitting = false
		$"item-radio-speaker_v1/AnimationPlayer".pause()
		$"item-radio-speaker_v2/AnimationPlayer".pause()

func nextChannel():
	var newChannel = (activeChannel + 1) % radioChannels.size()
	changeChannel(newChannel)
	
func getPunched():
	if lastTimePunched <= punchCooldown:
		return
	lastTimePunched = 0
	bounce()
	nextChannel()

func bounce():
	var count = 0
	var origPos = global_position.y
	while count < 1:
		global_position.y = origPos + jumpCurve.sample(count) * animationStrength
		scale = (1 + rotateCurve.sample(count) * animationStrength) * Vector3.ONE
		count += get_process_delta_time() * animationSpeed
		await get_tree().process_frame
	global_position.y = origPos
	global_rotation.z = 0
	
