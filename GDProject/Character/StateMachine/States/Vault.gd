extends State

class_name VaultState

var timer: float = 0
var initialPos: Vector3
var snapFinished: bool = false

var snapTime = 0.1
var timeUntilLift = 0.14
var liftDuration = 0.25
var vaultingPosHoriz = 0.0

func onEnter(player: MainCharacter, delta: float):
	super.onEnter(player, delta)
	timer = 0
	initialPos = chara.global_transform.origin
	snapFinished = false
	chara.executeAnimation("JumpCorner", -1)
	chara.animationPlayer.seek(0)
	vaultingPosHoriz = chara.vaultingPos.x - 0.3 * chara.vaultingDir
	
func onExit(_delta: float, _transitionTo: String):
	pass

func check():
	if timer >= liftDuration:
		return "FallState"

func apply(delta):
	timer += delta
	if timer < snapTime:
		chara.turn(chara.vaultingDir, delta)
		chara.global_transform.origin.y = lerp(initialPos.y, chara.vaultingPos.y - 1.6, timer / snapTime)
		chara.global_transform.origin.x = lerp(initialPos.x, vaultingPosHoriz, timer / snapTime)
	elif not snapFinished:
		chara.instantTurn(chara.vaultingDir)
		chara.global_transform.origin.y = chara.vaultingPos.y - 1.6
		chara.global_transform.origin.x = vaultingPosHoriz
		snapFinished = true
	if (timer > timeUntilLift):
		chara.setVertForce(9)
	else:
		chara.velocity.y = 0
		chara.velocity.x = 0
	chara.move_and_slide()
