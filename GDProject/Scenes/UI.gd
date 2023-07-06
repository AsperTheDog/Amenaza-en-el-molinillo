extends Control

signal bubbleShown
signal bubbleHidden

@export_group("That's all folks")
@export var thatsAllSpeed: float = 1
@export var thatsAllCurve: Curve
@export_group("Thinking bubble")
@export var bubbleAppearSpeed: float = 1
@export var bubbleDissappearSpeed: float = 1
@export var bubbleXCurve: Curve
@export var bubbleYCurve: Curve

var thatsAllExecuting: bool = true
var thatsAllFadeOut: bool = true
var thatsAllStep: float = 0

var showDebug: bool = false
var chara: MainCharacter

var bubbleInProcess: bool = false

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
	await get_tree().create_timer(1 / bubbleAppearSpeed).timeout
	changeBubbleScale($"InfoLevel Container/medium", true)
	await get_tree().create_timer(1 / bubbleAppearSpeed).timeout
	changeBubbleScale($"InfoLevel Container/big", true)
	await get_tree().create_timer(1 / bubbleAppearSpeed).timeout
	bubbleInProcess = false
	bubbleShown.emit()

func hideBubble():
	if bubbleInProcess:
		await bubbleShown
	bubbleInProcess = true
	changeBubbleScale($"InfoLevel Container/big", false)
	await get_tree().create_timer(1 / bubbleDissappearSpeed).timeout
	changeBubbleScale($"InfoLevel Container/medium", false)
	await get_tree().create_timer(1 / bubbleDissappearSpeed).timeout
	changeBubbleScale($"InfoLevel Container/small", false)
	await get_tree().create_timer(1 / bubbleDissappearSpeed).timeout
	$"InfoLevel Container".hide()
	bubbleInProcess = false
	bubbleHidden.emit()
