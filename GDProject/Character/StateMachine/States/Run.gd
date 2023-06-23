extends State

class_name RunState

func onEnter(player: MainCharacter, delta: float):
	super.onEnter(player, delta)
	chara.hasDoubleJumped = false
	if chara.animationPlayer.assigned_animation == "FallingFloor Ro":
		chara.animationPlayer.clear_queue()
		chara.animationPlayer.queue("Run Ro")
	else:
		chara.animationPlayer.play("Run Ro")
	
func onExit(delta: float):
	chara.animationPlayer.set_speed_scale(chara.animationSpeed)

func check():
	if not Input.is_action_pressed("Left") and not Input.is_action_pressed("Right"):
		return "IdleState"
	if Input.is_action_just_pressed("Jump"):
		return "JumpState"
	if not chara.is_on_floor():
		if chara.velocity.y <= 0:
			return "FallState"
		else:
			return "FlyState"
	return null

func apply(delta):
	chara.applyHorizMovement(delta)
