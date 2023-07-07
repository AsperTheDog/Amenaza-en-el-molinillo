extends Control

signal fadeOutFinished

@export var fadeInSpeed: float = 0.3
@export var fadeOutSpeed: float = 1

var mainGameScene = preload("res://Scenes/Scene-Demo.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	fadeInOut(true)
	$"MainLayer/Container/MenuContainer/BoxContainer/TextureButton".pressed.connect(loadMainGame)
	$"MainLayer/Container/MenuContainer/BoxContainer/TextureButton3".pressed.connect(quit)

func fadeInOut(fadeIn: bool):
	var fade = $"FadeInLayer/ColorRect"
	var count = fade.color.a
	while (count < 1 and not fadeIn) or (count > 0 and fadeIn):
		fade.color = Color(0, 0, 0, lerp(0, 1, count))
		var speed = fadeInSpeed if fadeIn else fadeOutSpeed
		count += get_process_delta_time() * speed * (int(not fadeIn) * 2 - 1)
		await get_tree().process_frame
	fade.color = Color(0, 0, 0, 0 if fadeIn else 1)
	fadeOutFinished.emit()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func loadMainGame():
	fadeInOut(false)
	await fadeOutFinished
	get_tree().change_scene_to_packed(mainGameScene)

func quit():
	get_tree().quit()
