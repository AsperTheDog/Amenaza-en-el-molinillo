extends CharacterBody3D

class_name MainCharacter

signal startedThinking
signal stoppedThinking

var game: Node3D

@export_category("Movement")
@export_group("Jump")
@export_subgroup("Basic")
@export var fallGravityMult: float = 1.7
@export var jumpSpeed: float = 10
@export var jumpCutGravityMult: float = 3
@export var maxFallSpeed: float = 30
@export var defaultGravity: float = 23.5
@export var bunnyHopTime: float = 0.08
@export var coyoteTime: float = 0.15
@export var canDoubleJump: bool = true
@export var isJumpInstant: bool = true
@export_subgroup("Acceleration")
@export var accelInAirMult: float = 1.0
@export var deccelInAirMult: float = 1.0
@export_subgroup("Hang time")
@export var jumpHangTimeThreshold: float = 0.2
@export var jumpHangAccelMult: float = 1.4
@export var jumpHangMaxSpeedMult: float = 1.4
@export_subgroup("Touch Floor Thresholds")
@export var lightFallThreshold: float = 0.5
@export var strongFallThreshold: float = 1
@export var strongFallRecoveryTime: float = 1

@export_group("Run")
@export var runAccelAmount: float = 5
@export var runDeccelAmount: float = 10
@export var runMaxSpeed: float = 7
@export var doConserveMomentum = true
@export var deadZoneMovement: float = 0.25
@export var walkingThreshold: float = 0.5

@export_group("Punch")
@export var upwardsForce: float = 5

@export_category("Animation")
@export var turnSpeed: float = 10
@export var animationSpeed: float = 1
@export var blendTime: float = 0.1
@export var slowBlendTime: float = 0.3
@export var defaultEyes: CompressedTexture2D
@export_group("Blinking")
@export var blinkChance: float = 0.4
@export var blinkDuration: float = 0.15
@export var blinkingEyes: CompressedTexture2D
@export_group("Idle Action")
@export var minimumIdleTime: float = 2
@export var idleActionChance: float = 0.2

var trackInput: bool = false

var animationPlayer: AnimationPlayer
var runParticles: CPUParticles3D
var jumpParticles: CPUParticles3D
var fallParticles: CPUParticles3D
var punchParticles: CPUParticles3D

var zPos: float
const landingAnimations = [
	"FallingFloorLongUp", 
	"FallingFloor", 
	"FallingFloorRun", 
	"FallingFloorNear", 
	"FallingFloorNearRun"
	]
const movingAnimations = ["Run", "Walk"]

var lastTopFallingSpeed: float = 0
var gravity: float = defaultGravity;
var hasDoubleJumped: bool = false
var vaultingDir: int
var vaultingPos: Vector3

var lastOnGround: float = 0

var bunnyHopTimer: float = 0
var isBunnyHopTimerActive: bool = false
var execJumpAction: bool = false

var flyingAnimationLength: float = 0
var flyingAnimationHalftime: float = 0

var eyesModel: MeshInstance3D
var mouthModel: MeshInstance3D

var blinking: bool = false
var blinkTimer: float = 0

var animMappings: Dictionary = {}
var currentAnimation: String

var activeEyes: CompressedTexture2D

var punchCollider: Area3D
	

# --- SYSTEM ---

func _ready():
	game = get_parent()
	
	# Colliders
	punchCollider = $rotating/Punch
	punchCollider.body_entered.connect(_on_punch_body_entered)
	
	# Animations
	animationPlayer = $rotating/modelo/AnimationPlayer
	animationPlayer.set_default_blend_time(blendTime)
	animationPlayer.set_speed_scale(animationSpeed)
	setAnimationBlendTimes()
	if animationPlayer.get_animation("Jump") != null:
		flyingAnimationLength = animationPlayer.get_animation("Jump").length
	else:
		flyingAnimationLength = 1
	flyingAnimationHalftime = flyingAnimationLength / 2
	
	# Particles
	runParticles = $"rotating/particles-run"
	jumpParticles = $"rotating/particles-jump"
	fallParticles = $"rotating/particles-falling"
	punchParticles = $"rotating/particles-punch"
	
	# Face Animations
	eyesModel = $"rotating/modelo/Character/Armature/Skeleton3D/Eyes"
	mouthModel = $"rotating/modelo/Character/Armature/Skeleton3D/Mouth"
	for faceAnim in $FaceAnimations.get_children():
		animMappings[faceAnim.animation] = faceAnim
	activeEyes = defaultEyes
	
	# Controls
	zPos = transform.origin.z
	if not canDoubleJump:
		hasDoubleJumped = true
	
	# State Machine
	$StateMachine.setup(self)

func _process(delta):
	transform.origin.z = zPos
	processJumpBuffering(delta)
	$StateMachine.evaluate(delta)
	randomlyBlink(delta)
	if animationPlayer.assigned_animation == "Jump":
		seekAirAnimation()
	manageFaces()



# --- FORCES ---

func setForce(force: Vector3):
	velocity = force

func applyForce(force: Vector3):
	velocity += force

func setVertForce(force: float):
	velocity.y = force

func setHorizForce(force: float):
	velocity.x = force

func applyHorizMovement(delta: float, direction: float):
	if abs(direction) < deadZoneMovement:
		direction = 0
	var targetSpeed = direction * runMaxSpeed
	var accelRate = runDeccelAmount
	if abs(targetSpeed) > 0.01:
		accelRate = runAccelAmount
	
	var movement = (targetSpeed - velocity.x) * accelRate * delta;
	applyForce(movement * Vector3.RIGHT)
	turn(sign(direction), delta)
	move_and_slide()

func applyHorizMovementAir(delta: float, direction: float):
	var targetSpeed = direction * runMaxSpeed
	var accelRate = runDeccelAmount * deccelInAirMult

	if abs(targetSpeed) > 0.01:
		accelRate = runAccelAmount * accelInAirMult
	if abs(velocity.y) < jumpHangTimeThreshold:
		accelRate *= jumpHangAccelMult
		targetSpeed *= jumpHangMaxSpeedMult
	if doConserveMomentum and abs(velocity.x) > abs(targetSpeed) and sign(velocity.x) == sign(targetSpeed) and abs(targetSpeed) > 0.01:
		accelRate = 0

	var movement = (targetSpeed - velocity.x) * accelRate * delta;
	applyForce(movement * Vector3.RIGHT)
	turn(sign(direction), delta)
	move_and_slide()



# --- CONTROLS ---

func isThinking():
	return trackInput and Input.is_action_pressed("Think")

func justPunched():
	return trackInput and Input.is_action_just_pressed("Punch")

func justJumped():
	return trackInput and Input.is_action_just_pressed("Jump")

func isJumping():
	return trackInput and Input.is_action_pressed("Jump")

func getMovingDir():
	return Input.get_axis("Left", "Right") if trackInput else 0

func getVaultingDirection():
	if $VaultRayLeft.is_colliding():
		vaultingPos = $VaultRayLeft.get_collider().get_parent().global_transform.origin
		vaultingDir = 1
	elif $VaultRayRight.is_colliding():
		vaultingPos = $VaultRayRight.get_collider().get_parent().global_transform.origin
		vaultingDir = -1
	else:
		vaultingDir = 0
	return vaultingDir

func processJumpBuffering(delta):
	lastOnGround = 0 if is_on_floor() else lastOnGround + delta
	if isBunnyHopTimerActive:
		bunnyHopTimer += delta
	else:
		bunnyHopTimer = 0
	execJumpAction = bunnyHopTimer >= bunnyHopTime



# --- TURNING ---

func turnFront(delta: float):
	if $rotating.rotation.y == 0:
		return
	$rotating.rotation.y = lerp_angle($rotating.rotation.y, 0, delta * turnSpeed)

func turn(direction: int, delta: float):
	if direction == 0:
		return
	var targetAngle = deg_to_rad(direction * 89)
	$rotating.rotation.y = lerp_angle($rotating.rotation.y, targetAngle, delta * turnSpeed)

func instantTurn(direction: int):
	$rotating.rotation.y = deg_to_rad(direction * 89)



# --- ANIMATION ---

func seekAirAnimation():
	var seek: float = 0
	if velocity.y < 0:
		var value: float = -velocity.y / maxFallSpeed
		seek = lerp(flyingAnimationHalftime, flyingAnimationLength, value)
	else:
		var value: float = 1 - (velocity.y / jumpSpeed)
		seek  = lerp(0.0, flyingAnimationHalftime, value)
	animationPlayer.seek(seek)

func executeAnimation(animation: String, blend = null, speedMult: float = 1):
	if blend == null:
		animationPlayer.play(animation)
	else:
		animationPlayer.play(animation, blend, speedMult)
	
func queueAnimation(animation: String, clearQueue: bool = true):
	if clearQueue:
		animationPlayer.clear_queue()
	animationPlayer.queue(animation)
		
func setAnimationBlendTimes():
	animationPlayer.set_blend_time("Run", "Idle", blendTime)
	animationPlayer.set_blend_time("Run", "Walk", blendTime)
	animationPlayer.set_blend_time("FallingFloor", "Run", blendTime * 2)
	animationPlayer.set_blend_time("FallingFloor", "Walk", blendTime * 2)
	animationPlayer.set_blend_time("FallingFloor", "Idle", slowBlendTime)
	animationPlayer.set_blend_time("FallingFloorNear", "Run", blendTime * 2)
	animationPlayer.set_blend_time("FallingFloorNear", "Walk", blendTime * 2)
	animationPlayer.set_blend_time("FallingFloorNear", "Idle", slowBlendTime)
	animationPlayer.set_blend_time("IdleAction", "Walk", blendTime / 3)
	animationPlayer.set_blend_time("IdleAction", "Run", blendTime / 3)
	animationPlayer.set_blend_time("IdleAction", "Idle", blendTime / 3)
	animationPlayer.set_blend_time("IdleAction", "Jump", blendTime / 3)
	
func randomlyBlink(delta):
	if blinking:
		blinkTimer += delta
		if blinkTimer < blinkDuration:
			return
		eyesModel.get_mesh().get("surface_0/material").set_texture(StandardMaterial3D.TEXTURE_ALBEDO, activeEyes)
		blinking = false
		blinkTimer = 0
	elif randf() < blinkChance * delta:
		eyesModel.get_mesh().get("surface_0/material").set_texture(StandardMaterial3D.TEXTURE_ALBEDO, blinkingEyes)
		blinking = true
	
func manageFaces():
	var currAnim = animationPlayer.current_animation
	if currAnim == "" or currAnim not in animMappings:
		return
	if currAnim != currentAnimation:
		if currentAnimation in animMappings:
			animMappings[currentAnimation].reset()
		currentAnimation = currAnim
	var animTimestamp = animationPlayer.current_animation_position
	var faceAnim = animMappings[currAnim]
	var active = faceAnim.execute(eyesModel, mouthModel, animTimestamp)
	if active != null:
		activeEyes = active



# --- GETTERS ---

func get_class(): 
	return "MainCharacter"

func getTarget():
	return $rotating/CamTarget



# --- STATE MACHINE ---

func forceState(state: String):
	$StateMachine.transition(state)

func getActiveState():
	return $StateMachine.activeStateName



# --- SIGNALS ---

func _on_punch_body_entered(body: Node3D):
	if body.get_parent().has_method("getPunched"):
		punchParticles.restart()
		punchParticles.emitting = true
		body.get_parent().getPunched()
