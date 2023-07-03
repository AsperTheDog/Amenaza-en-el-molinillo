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
		
func onExit(_delta: float, _transitionTo: String):
	if isActionBeingPerformed:
		chara.executeAnimation("FallingFloorLongUp", chara.blendTime / 2, 2)

func check():
	if abs(chara.velocity.x) > 1:
		var movingDir = abs(Input.get_axis("Left", "Right"))
		return "WalkState" if movingDir < chara.walkingThreshold else "RunState"
	if Input.is_action_just_pressed("Jump"):
		return "JumpInstantState" if chara.isJumpInstant else "JumpState"
	if not chara.is_on_floor():
		return "FallState" if chara.velocity.y <= 0 else "AirState"
	return null

func apply(delta):
	if not isActionBeingPerformed and timer >= chara.minimumIdleTime:
		isActionBeingPerformed = true
		chara.executeAnimation("IdleAction")
	else:
		timer += delta
	var moveDir = Input.get_axis("Left", "Right")
	chara.applyHorizMovement(delta, moveDir)
	
