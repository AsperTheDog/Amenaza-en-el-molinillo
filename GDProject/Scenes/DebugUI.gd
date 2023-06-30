extends Control

@export var chara: MainCharacter
var label: Label

# Called when the node enters the scene tree for the first time.
func _ready():
	label = $Label


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	label.text = "FPS: " + str(1 / delta) \
	+ "\n\nState: " + chara.stateMachine.activeStateName \
	+ "\nGravity: " + str(chara.gravity) \
	+ "\nVelocity: " \
	+ "\n\t- X: " + str(snapped(chara.velocity.x, 0.01)) \
	+ "\n\t- Y: " + str(snapped(chara.velocity.y, 0.01)) \
	+ "\nLast Top Fall Speed: " + str(snapped(chara.lastTopFallingSpeed, 0.01)) \
	+ "\n\nHas Double Jumped: " + str(chara.hasDoubleJumped) \
	+ "\nIs BunnyHop Timer Active: " + str(chara.isBunnyHopTimerActive) \
	+ "\nBunnyHop Timer: " + str(chara.bunnyHopTimer) \
	+ "\nJump Request: " + str(chara.execJumpAction) \
	+ "\n\nJump Pressed:" + str(Input.is_action_pressed("Jump")) \
	+ "\n\nRun Direction: " + str(Input.get_axis("Left", "Right"))
 