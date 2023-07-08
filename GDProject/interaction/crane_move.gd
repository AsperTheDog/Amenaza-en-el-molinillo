extends Node3D

@export var target: Node3D
@export var camTarget: Node3D
@export var focusTime: float = 1
@export var moveSpeed: float = 1

func activate():
	owner.setTemporaryTarget(camTarget, focusTime, 0.5)
	move()
	
func move():
	var origPos = global_position
	var targetPos = target.global_position
	var count = 0
	while count < 1:
		global_position = lerp(origPos, targetPos, count)
		count += get_process_delta_time() * moveSpeed
		await get_tree().process_frame
