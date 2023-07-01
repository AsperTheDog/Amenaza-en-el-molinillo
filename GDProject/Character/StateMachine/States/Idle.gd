extends State

class_name IdleState

var timer: float = 0

func onEnter(player: MainCharacter, delta: float):
	super.onEnter(player, delta)
	if chara.animationPlayer.assigned_animation in chara.landingAnimations:
		chara.animationPlayer.clear_queue()
		chara.animationPlayer.queue("Idle")
	else:
		chara.animationPlayer.play("Idle", chara.slowBlendTime)
	timer = 0
		
func onExit(delta: float):
	chara.animationPlayer.clear_queue()

func check():
	if abs(chara.velocity.x) > 1:
		if abs(Input.get_axis("Left", "Right")) < chara.walkingThreshold:
			return "WalkState"
		else:
			return "RunState"
	if Input.is_action_just_pressed("Jump"):
		if chara.isJumpInstant:
			return "JumpInstantState"
		else:
			return "JumpState"
	if not chara.is_on_floor():
		if chara.velocity.y <= 0:
			return "FallState"
		else:
			return "AirState"
	return null

func apply(delta):
	timer += delta
	if timer >= chara.minimumIdleTime and randf() < chara.idleActionChance * delta:
		timer = 0
		chara.animationPlayer.play("IdleAction")
		chara.animationPlayer.queue("Idle")
	var moveDir = Input.get_axis("Left", "Right")
	chara.applyHorizMovement(delta, moveDir)
	
