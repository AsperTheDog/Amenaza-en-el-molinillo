extends Node3D

signal charaChanged(newChara: MainCharacter)

@export var chara: MainCharacter

func _ready():
	chara.trackInput = true
	$MainCamera.setTarget(chara.getTarget())
	chara.startedThinking.connect(startThinking)
	chara.stoppedThinking.connect(stopThinking)
	
func changeTarget(target: MainCharacter):
	chara.trackInput = false
	chara.forceState("FallState")
	chara = target
	chara.trackInput = true
	$MainCamera.setTarget(chara.getTarget())
	charaChanged.emit(chara)

func startThinking():
	$UI.showBubble()

func stopThinking():
	$UI.hideBubble()
