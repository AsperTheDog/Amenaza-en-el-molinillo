extends Node3D

@export var target: Node3D
@export var camTarget: Node3D
@export var focusTime: float = 1
@export var moveSpeed: float = 1
@export var volumeCurve: Curve

func activate():
	owner.setTemporaryTarget(camTarget, focusTime, 0.5)
	move()
	
func move():
	var origPos = global_position
	var targetPos = target.global_position
	var count = 0
	var origVolume = $moveSound.volume_db
	$moveSound.volume_db = -50.0
	$moveSound.play()
	while count < 1:
		$moveSound.volume_db = lerp(-50.0, origVolume, volumeCurve.sample(count))
		global_position = lerp(origPos, targetPos, count)
		count += get_process_delta_time() * moveSpeed
		await get_tree().process_frame
	$moveSound.stop()
	$moveSound.volume_db = origVolume
