extends Control

signal pause
signal resume
signal quit

signal bubbleShown
signal bubbleHidden

signal thatsAllFinished

@export_group("That's all folks")
@export var thatsAllSpeed: float = 1
@export var thatsAllCurve: Curve
@export_group("Thinking bubble")
@export var waitingTime: float = 1
@export var bubbleAppearSpeed: float = 1
@export var bubbleDissappearSpeed: float = 1
@export var bubbleXCurve: Curve
@export var bubbleYCurve: Curve

var showDebug: bool = false
var chara: MainCharacter

var bubbleInProcess: bool = false

var pauseShown: bool = false

func _ready():
	setupSignals()
	doThatsAllFolks(true)
	get_parent().charaChanged.connect(changeChara)
	chara = get_parent().chara

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

func showBubble():
	if bubbleInProcess:
		await bubbleHidden
	bubbleInProcess = true
	$"InfoLevel Container/small".scale = Vector2(0, 0)
	$"InfoLevel Container/medium".scale = Vector2(0, 0)
	$"InfoLevel Container/big".scale = Vector2(0, 0)
	$"InfoLevel Container".show()
	changeBubbleScale($"InfoLevel Container/small", true)
	await get_tree().create_timer(waitingTime / bubbleAppearSpeed).timeout
	changeBubbleScale($"InfoLevel Container/medium", true)
	await get_tree().create_timer(waitingTime / bubbleAppearSpeed).timeout
	changeBubbleScale($"InfoLevel Container/big", true)
	await get_tree().create_timer(1 / bubbleAppearSpeed).timeout
	bubbleInProcess = false
	bubbleShown.emit()

func hideBubble():
	if bubbleInProcess:
		await bubbleShown
	bubbleInProcess = true
	changeBubbleScale($"InfoLevel Container/big", false)
	await get_tree().create_timer(waitingTime / bubbleDissappearSpeed).timeout
	changeBubbleScale($"InfoLevel Container/medium", false)
	await get_tree().create_timer(waitingTime / bubbleDissappearSpeed).timeout
	changeBubbleScale($"InfoLevel Container/small", false)
	await get_tree().create_timer(1 / bubbleDissappearSpeed).timeout
	$"InfoLevel Container".hide()
	bubbleInProcess = false
	bubbleHidden.emit()

func resumeGame():
	pauseShown = false
	$PauseLayer.hide()
	resume.emit()

func quitToTitle():
	$PauseLayer.hide()
	quit.emit()
