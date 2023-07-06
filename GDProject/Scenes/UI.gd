extends Control

@export_group("That's all folks")
@export var thatsAllSpeed: float = 1
@export var thatsAllCurve: Curve

var thatsAllExecuting: bool = true
var thatsAllFadeOut: bool = true
var thatsAllStep: float = 0

var showDebug: bool = false
var chara: MainCharacter

func _ready():
	doThatsAllFolks(true)
	get_parent().charaChanged.connect(changeChara)
	chara = get_parent().chara

func changeChara(newChara: MainCharacter):
	chara = newChara

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if thatsAllExecuting:
		if thatsAllFadeOut:
			thatsAllStep += delta * thatsAllSpeed
		else:
			thatsAllStep -= delta * thatsAllSpeed
		var value = thatsAllCurve.sample(clamp(thatsAllStep, 0, 1))
		$thatsAllFolksLayer/ThatsAllFolks.material.set("shader_parameter/threshold", value)
		if thatsAllStep < 0 or thatsAllStep > 1:
			thatsAllExecuting = false
	if Input.is_action_just_pressed("ui_debug"):
		showDebug = not showDebug
		if showDebug:
			$DebugLayer/Debug.show()
		else:
			$DebugLayer/Debug.hide()
	if showDebug:
		$DebugLayer/Debug.processDebug(chara)

func doThatsAllFolks(isFadeOut: bool):
	thatsAllStep = int(not isFadeOut)
	thatsAllFadeOut = isFadeOut
	thatsAllExecuting = true
	
func showBubble():
	print("Showing bubble")

func hideBubble():
	print("Hiding bubble")
