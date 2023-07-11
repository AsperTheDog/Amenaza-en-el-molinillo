extends BirdState
class_name IdleBirdState

var timer: float = 0
var isActionBeingPerformed: bool = false

func onEnter(player: Bird, delta: float):
	super.onEnter(player, delta)
	chara.animationPlayer.play("Idle")
	chara.shouldFly = false
	timer = 0
	isActionBeingPerformed = false
	
func onExit(_delta: float, _transitionTo: String):
	pass

func check():
	if chara.shouldFly:
		return "FlyState"

func apply(delta):
	if isActionBeingPerformed:
		timer = 0
		if chara.animationPlayer.assigned_animation == "Idle":
			isActionBeingPerformed = false
	elif timer >= chara.minimumIdleTime and randf() < chara.idleActionChance * delta:
		isActionBeingPerformed = true
		if randf() < 0.5:
			chara.animationPlayer.play("IdleAction")
		else:
			chara.animationPlayer.play("IdleAction2")
		chara.animationPlayer.queue("Idle")
	else:
		timer += delta
