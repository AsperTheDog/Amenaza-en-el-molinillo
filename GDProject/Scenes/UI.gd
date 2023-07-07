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
@export var pauseCurve: Curve

var showDebug: bool = false
var chara: MainCharacter

var bubbleInProcess: bool = false
var bubbleStep: float = 0
var bubbleDirection: int = 0

var pauseShown: bool = false

func _ready():
	setupSignals()
	doThatsAllFolks(true)
	get_parent().charaChanged.connect(changeChara)
	chara = get_parent().chara
	$"InfoLevel Container/small".scale = Vector2(0, 0)
	$"InfoLevel Container/medium".scale = Vector2(0, 0)
	$"InfoLevel Container/big".scale = Vector2(0, 0)

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
	if Input.is_action_just_pressed("Pause"):
		if pauseShown:
			resumeGame()
		else:
			$PauseLayer.show()
			pause.emit()
			pauseShown = true

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
	

func changeBubbleScale(bubble: Sprite2D, appear: bool):
	var counter = 0 if appear else 1
	var speed = bubbleAppearSpeed if appear else bubbleDissappearSpeed
	while (counter < 1 and appear) or (counter > 0 and not appear):
		bubble.scale = Vector2(bubbleXCurve.sample(counter), bubbleYCurve.sample(counter))
		counter += get_process_delta_time() * (int(appear) * 2 - 1) * speed
		await get_tree().process_frame
	var objective = 1 if appear else 0
	bubble.scale = Vector2(objective, objective)

func processBubbleAnimation():
	bubbleInProcess = true
	var small = $"InfoLevel Container/small"
	var medium = $"InfoLevel Container/medium"
	var big = $"InfoLevel Container/big"
	bubbleStep = clamp(bubbleStep, 0, bubbleWaitingTime * 2 + 1)
	if bubbleDirection == 1:
		$"InfoLevel Container".show()
	while bubbleStep >= 0 and bubbleStep <= bubbleWaitingTime * 2 + 1:
		if small.scale.x <= 0.05:
			small.scale = Vector2(0, 0)
		if medium.scale.x <= 0.05:
			medium.scale = Vector2(0, 0)
		if big.scale.x <= 0.05:
			big.scale = Vector2(0, 0)
		
		if bubbleStep >= 0 and bubbleStep <= 1:
			small.scale = Vector2(bubbleXCurve.sample(bubbleStep), bubbleYCurve.sample(bubbleStep))
		if bubbleStep >= bubbleWaitingTime and bubbleStep <= bubbleWaitingTime + 1:
			medium.scale = Vector2(bubbleXCurve.sample(bubbleStep - bubbleWaitingTime), bubbleYCurve.sample(bubbleStep - bubbleWaitingTime))
		if bubbleStep >= bubbleWaitingTime * 2 and bubbleStep <= bubbleWaitingTime * 2 + 1:
			big.scale = Vector2(bubbleXCurve.sample(bubbleStep - bubbleWaitingTime * 2), bubbleYCurve.sample(bubbleStep - bubbleWaitingTime * 2))
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

func resumeGame():
	pauseShown = false
	$PauseLayer.hide()
	resume.emit()

func quitToTitle():
	$PauseLayer.hide()
	quit.emit()

func fadeInOutPause(fadeIn: bool):
	var pause
	var count = 0 if fadeIn else 1
	
