extends Control

signal pause
signal resume
signal quit

signal bubbleHidden

signal thatsAllFinished

@export_group("That's all folks")
@export var thatsAllSpeed: float = 1
@export var thatsAllCurve: Curve
@export_group("Thinking bubble")
@export var bubbleWaitingTime: float = 1
@export var bubbleAppearSpeed: float = 1
@export var bubbleDissappearSpeed: float = 1
@export var bubbleXCurve: Curve
@export var bubbleYCurve: Curve
@export_group("Pause Menu")
@export var pauseFadeSpeed: float = 1
@export var pauseMaxOpacity: int = 120

var showDebug: bool = false
var chara: MainCharacter

var bubbleInProcess: bool = false
var bubbleStep: float = 0
var bubbleDirection: int = 0

var pauseShown: bool = false
var pauseFading: bool = false

func _ready():
	setupSignals()
	doThatsAllFolks(true)
	get_parent().charaChanged.connect(changeChara)
	chara = get_parent().chara
	$"InfoLevelLayer/InfoLevel Container/small".scale = Vector2(0, 0)
	$"InfoLevelLayer/InfoLevel Container/medium".scale = Vector2(0, 0)
	$"InfoLevelLayer/InfoLevel Container/big".scale = Vector2(0, 0)

func changeChara(newChara: MainCharacter):
	chara = newChara

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("ui_debug"):
		showDebug = not showDebug
		if showDebug:
			$DebugLayer.show()
		else:
			$DebugLayer.hide()
	if showDebug:
		$DebugLayer/Debug.processDebug(chara)
	if Input.is_action_just_pressed("Pause") and not pauseFading:
		if pauseShown:
			resumeGame()
		else:
			pauseGame()

func doThatsAllFolks(fadeIn: bool):
	var rect = $thatsAllFolksLayer/ThatsAllFolks
	var counter = 0 if fadeIn else 1
	while (counter < 1 and fadeIn) or (counter > 0 and not fadeIn):
		var value = thatsAllCurve.sample(clamp(counter, 0, 1))
		rect.material.set("shader_parameter/threshold", value)
		counter += thatsAllSpeed * get_process_delta_time() * (int(fadeIn) * 2 - 1)
		await get_tree().process_frame
	thatsAllFinished.emit()

func setupSignals():
	$"PauseLayer/Pause Container/BoxContainer/Bubble/MarginContainer/BoxContainer/TextureButton".pressed.connect(resumeGame)
	$"PauseLayer/Pause Container/BoxContainer/Bubble/MarginContainer/BoxContainer/TextureButton3".pressed.connect(quitToTitle)

func processBubbleAnimation():
	bubbleInProcess = true
	var small = $"InfoLevelLayer/InfoLevel Container/small"
	var medium = $"InfoLevelLayer/InfoLevel Container/medium"
	var big = $"InfoLevelLayer/InfoLevel Container/big"
	bubbleStep = clamp(bubbleStep, 0, bubbleWaitingTime * 2 + 1)
	if bubbleDirection == 1:
		$"InfoLevel Container".show()
	while bubbleStep >= 0 and bubbleStep <= bubbleWaitingTime * 2 + 1:		
		if bubbleStep >= 0 and bubbleStep <= 1:
			small.scale = Vector2(bubbleXCurve.sample(bubbleStep), bubbleYCurve.sample(bubbleStep))
		else:
			var trueSize = 0 if bubbleStep < 0 else 1
			small.scale = Vector2(trueSize, trueSize)
		if bubbleStep >= bubbleWaitingTime and bubbleStep <= bubbleWaitingTime + 1:
			medium.scale = Vector2(bubbleXCurve.sample(bubbleStep - bubbleWaitingTime), bubbleYCurve.sample(bubbleStep - bubbleWaitingTime))
		else:
			var trueSize = 0 if bubbleStep < bubbleWaitingTime else 1
			medium.scale = Vector2(trueSize, trueSize)
		if bubbleStep >= bubbleWaitingTime * 2 and bubbleStep <= bubbleWaitingTime * 2 + 1:
			big.scale = Vector2(bubbleXCurve.sample(bubbleStep - bubbleWaitingTime * 2), bubbleYCurve.sample(bubbleStep - bubbleWaitingTime * 2))
		else:
			var trueSize = 0 if bubbleStep < bubbleWaitingTime * 2 else 1
			big.scale = Vector2(trueSize, trueSize)
		bubbleStep += get_process_delta_time() * bubbleAppearSpeed * bubbleDirection
		await get_tree().process_frame
	if bubbleDirection == -1:
		$"InfoLevel Container".hide()
		bubbleHidden.emit()
	bubbleInProcess = false

func showBubble():
	bubbleDirection = 1
	if not bubbleInProcess:
		processBubbleAnimation()

func hideBubble():
	bubbleDirection = -1
	if not bubbleInProcess:
		processBubbleAnimation()

func pauseGame():
	pause.emit()
	fadeInOutPause(true)
	$"PauseLayer/Pause Container/BoxContainer/Bubble/MarginContainer/BoxContainer/TextureButton".grab_focus()

func resumeGame():
	fadeInOutPause(false)
	resume.emit()

func quitToTitle():
	fadeInOutPause(false)
	quit.emit()

func fadeInOutPause(fadeIn: bool):
	pauseFading = true
	var background = $"PauseLayer/Pause Container/Background"
	var pauseBlock = $"PauseLayer/Pause Container/BoxContainer/"
	var pauseText = $"PauseLayer/Pause Container/BoxContainer/Bubble/MarginContainer"
	var counter = 0 if fadeIn else 1
	if fadeIn:
		background.color.a = 0
		$PauseLayer.show()
		pauseShown = true
	while (counter < 1 and fadeIn) or (counter > 0 and not fadeIn):
		var value = ease(clamp(counter, 0, 1), 0.4)
		pauseBlock.scale = Vector2(value, value)
		background.color.a = ease(clamp(counter, 0, 1), 0.4) * (pauseMaxOpacity / 255.0)
		counter += pauseFadeSpeed * get_process_delta_time() * (int(fadeIn) * 2 - 1)
		await get_tree().process_frame
	if not fadeIn:
		$PauseLayer.hide()
		pauseShown = false
	pauseFading = false
	
