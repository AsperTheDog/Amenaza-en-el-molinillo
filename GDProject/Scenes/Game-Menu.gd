extends Control

signal fadeOutFinished

@export var fadeInSpeed: float = 0.3
@export var fadeOutSpeed: float = 1

var mainGameScene = preload("res://Scenes/Scene-Demo.tscn")
var isFadingIn: bool = false
@onready var origVolume: float = AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Master"))

# Called when the node enters the scene tree for the first time.
func _ready():
	fadeInOut(true)
	$"MainLayer/Container/MenuContainer/BoxContainer/TextureButton".pressed.connect(loadMainGame)
	$"MainLayer/Container/MenuContainer/BoxContainer/TextureButton3".pressed.connect(quit)
	$"MainLayer/Container/MenuContainer/BoxContainer/TextureButton".grab_focus()


func fadeInOut(fadeIn: bool):
	isFadingIn = fadeIn
	var fade = $"FadeInLayer/ColorRect"
	var count = fade.color.a
	var audio: int = AudioServer.get_bus_index("Master")
	while (count < 1 and not fadeIn) or (count > 0 and fadeIn):
		if isFadingIn != fadeIn:
			return
		AudioServer.set_bus_volume_db(audio, lerp(-50.0, origVolume, ease(1 - count, 0.4)))
		fade.color = Color(0, 0, 0, lerp(0, 1, count))
		var speed = fadeInSpeed if fadeIn else fadeOutSpeed
		count += get_process_delta_time() * speed * (int(not fadeIn) * 2 - 1)
		await get_tree().process_frame
	fade.color = Color(0, 0, 0, 0 if fadeIn else 1)
	if not fadeIn:
		$music.stop()
	AudioServer.set_bus_volume_db(audio, origVolume)
	fadeOutFinished.emit()


func loadMainGame():
	fadeInOut(false)
	await fadeOutFinished
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), origVolume)
	get_tree().change_scene_to_packed(mainGameScene)


func quit():
	get_tree().quit()


func focusChangeEvent():
	$Audio/changeFocus.play()


func buttonPressEvent():
	$Audio/changeFocus.stop()
	$Audio/press.play()
