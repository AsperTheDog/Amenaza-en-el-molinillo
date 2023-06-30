extends State

class_name RunState

func onEnter(player: MainCharacter, delta: float):
	super.onEnter(player, delta)
	chara.hasDoubleJumped = false
	if chara.animationPlayer.assigned_animation in chara.landingAnimations:
		chara.animationPlayer.clear_queue()
		chara.animationPlayer.queue("Run")
	else:
		chara.animationPlayer.play("Run")
	
func onExit(delta: float):
	chara.animationPlayer.set_speed_scale(chara.animationSpeed)

func check():
	if chara.isBunnyHopTimerActive or Input.is_action_pressed("Jump"):
		chara.isBunnyHopTimerActive = false
		return "JumpState"
	if abs(chara.velocity.x) < 1:
		return "IdleState"
	if not chara.is_on_floor():
		if chara.velocity.y <= 0:
			return "FallState"
		else:
			return "AirState"
	return null

func apply(delta):
	var moveDir = Input.get_action_strength("Right") - Input.get_action_strength("Left")
	chara.applyHorizMovement(delta, moveDir)
	if chara.animationPlayer.assigned_animation not in chara.landingAnimations:
		var speedDiff = 1 - (chara.runMaxSpeed - abs(chara.velocity.x)) / chara.runMaxSpeed
		chara.animationPlayer.set_speed_scale(lerp(0.0, chara.animationSpeed, speedDiff))
