extends State

class_name VaultState

var timer: float = 0
var initialPos: float
var snapFinished: bool = false

var snapTime = 0.1
var timeUntilLift = 0.13
var liftDuration = 0.2

func onEnter(player: MainCharacter, delta: float):
	super.onEnter(player, delta)
	timer = 0
	initialPos = chara.global_transform.origin.y
	snapFinished = false
	chara.get_node("modelo").rotation.y = deg_to_rad(chara.vaultingDir * 89)
	chara.animationPlayer.play("JumpCorner", -1)
	
func onExit(delta: float):
	pass

func check():
	if timer >= liftDuration:
		return "FallState"

func apply(delta):
	timer += delta
	if timer < snapTime:
		var movePos = chara.vaultingPos.y - 1.6
		chara.global_transform.origin.y = lerp(initialPos, movePos, timer / snapTime)
	elif not snapFinished:
		snapFinished = true
		var movePos = chara.vaultingPos.y - 1.6
		chara.global_transform.origin.y = movePos
	if (timer > timeUntilLift):
		chara.setVertForce(9)
	else:
		chara.velocity.y = 0
	chara.move_and_slide()
