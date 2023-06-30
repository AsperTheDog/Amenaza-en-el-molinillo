extends State

class_name IdleState

func onEnter(player: MainCharacter, delta: float):
	super.onEnter(player, delta)
	if chara.animationPlayer.assigned_animation in chara.landingAnimations:
		chara.animationPlayer.clear_queue()
		chara.animationPlayer.set_default_blend_time(chara.slowBlendTime)
		chara.animationPlayer.queue("Idle")
	else:
		chara.animationPlayer.play("Idle", chara.slowBlendTime)
		
func onExit(delta: float):
	chara.animationPlayer.set_default_blend_time(chara.blendTime)

func check():
	if abs(chara.velocity.x) > 1:
		return "RunState"
	if Input.is_action_just_pressed("Jump"):
		return "JumpState"
	if not chara.is_on_floor():
		if chara.velocity.y <= 0:
			return "FallState"
		else:
			return "AirState"
	return null

func apply(delta):
	var moveDir = Input.get_axis("Left", "Right")
	chara.applyHorizMovement(delta, moveDir)
