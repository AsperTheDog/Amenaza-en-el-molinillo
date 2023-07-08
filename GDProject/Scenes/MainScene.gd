extends Node3D

signal charaChanged(newChara: MainCharacter)

@export var chara: MainCharacter
var mainMenu = load("res://Scenes/Game-Menu.tscn")

func _ready():
	setBlackScreen(true)
	chara.trackInput = true
	$MainCamera.setTarget(chara.getTarget())
	chara.startedThinking.connect(startThinking)
	chara.stoppedThinking.connect(stopThinking)
	$UI.pause.connect(stopStateMachine)
	$UI.resume.connect(resumeStateMachine)
	$UI.quit.connect(quitToTitle)
	$UI.bubbleHidden.connect(finishedThinking)

func setTemporaryTarget(target: Node3D, time: float, moveSpeedMult: float = 1):
	chara.trackInput = false
	%MainCamera.setSpeedMult(moveSpeedMult)
	%MainCamera.setTarget(target)
	await get_tree().create_timer(time).timeout
	%MainCamera.setSpeedMult(1)
	%MainCamera.setTarget(chara.getTarget())
	chara.trackInput = true

func changeCharacter(target: MainCharacter):
	chara.trackInput = false
	chara.forceState("FallState")
	chara = target
	chara.trackInput = true
	%MainCamera.setTarget(chara.getTarget())
	charaChanged.emit(chara)

func startThinking():
	$UI.showBubble()

func stopThinking():
	$UI.hideBubble()

func finishedThinking():
	chara.bubbleHidden = true

func stopStateMachine():
	chara.trackInput = false

func resumeStateMachine():
	chara.trackInput = true

func setBlackScreen(doSet: bool):
	$UI/thatsAllFolksLayer/ThatsAllFolks.material.set("shader_parameter/threshold", 0 if doSet else 1)
	
func quitToTitle():
	chara.freezeStateMachine()
	chara.executeAnimation("Think")
	chara.turnFrontAsync()
	$UI.doThatsAllFolks(false)
	await $UI.thatsAllFinished
	get_tree().change_scene_to_packed(mainMenu)
