extends State

class_name IdleState

var timer: float = 0
var isActionBeingPerformed: bool = false

func onEnter(player: MainCharacter, delta: float):
	super.onEnter(player, delta)
	if chara.animationPlayer.assigned_animation in chara.landingAnimations:
		chara.queueAnimation("Idle")
	else:
		chara.executeAnimation("Idle", chara.slowBlendTime)
	timer = 0
	isActionBeingPerformed = false
		
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
	if not isActionBeingPerformed and timer >= chara.minimumIdleTime:
		isActionBeingPerformed = true
		chara.executeAnimation("IdleAction")
	else:
		timer += delta
	var moveDir = Input.get_axis("Left", "Right")
	chara.applyHorizMovement(delta, moveDir)
	
