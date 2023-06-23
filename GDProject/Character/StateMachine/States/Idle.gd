extends State

class_name IdleState

func onEnter(player: MainCharacter, delta: float):
	super.onEnter(player, delta)
		
func onExit(delta: float):
	pass

func check():
	if Input.is_action_pressed("Left") or Input.is_action_pressed("Right"):
		return "RunState"
	if Input.is_action_just_pressed("Jump"):
		return "JumpState"
	if not chara.is_on_floor():
		if chara.velocity.y <= 0:
			return "FallState"
		else:
			return "FlyState"
		
	return null

func apply(delta):
	if (abs(chara.velocity.x) < 0.1):
		chara.velocity.x = 0
		if chara.animationPlayer.assigned_animation != "Idle Ro":
			if chara.animationPlayer.assigned_animation == "FallingFloor Ro":
				chara.animationPlayer.clear_queue()
				chara.animationPlayer.queue("Idle Ro")
			else:
				chara.animationPlayer.play("Idle Ro")
	else:
		chara.applyHorizMovement(delta)
