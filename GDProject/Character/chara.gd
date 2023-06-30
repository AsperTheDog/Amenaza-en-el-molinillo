extends CharacterBody3D

class_name MainCharacter

@export var stateMachine: StateMachine = null

@export_group("Jump")
@export_subgroup("Basic")
@export var fallGravityMult: float = 1.2
@export var jumpSpeed: float = 10
@export var jumpCutGravityMult: float = 2
@export var maxFallSpeed: float = 50
@export var defaultGravity: float = 9.8
@export var bunnyHopTime: float = 0.15
@export_subgroup("Acceleration")
@export var accelInAirMult: float = 1.0
@export var deccelInAirMult: float = 1.0
@export_subgroup("Hang time")
@export var jumpHangTimeThreshold: float = 0.02
@export var jumpHangAccelMult: float = 1.2
@export var jumpHangMaxSpeedMult: float = 1.2
@export_subgroup("Touch Floor Thresholds")
@export var lightFallThreshold: float = 0.2
@export var strongFallThreshold: float = 0.7

@export_group("Run")
@export var runAccelAmount: float = 5
@export var runDeccelAmount: float = 5
@export var runMaxSpeed: float = 10
@export var doConserveMomentum = true
@export var deadZoneMovement: float = 0.25

@export_group("Animation")
@export var turnSpeed: float = 1
@export var animationSpeed: float = 10
@export var blendTime: float = 0.3
@export var slowBlendTime: float = 0.3

var animationPlayer: AnimationPlayer
var zPos: float
const landingAnimations = ["FallingFloor", "FallingFloorNear"]

var lastTopFallingSpeed: float = 0
var gravity: float = defaultGravity;
var hasDoubleJumped: bool = false
var vaultingDir: int
var vaultingPos: Vector3

var bunnyHopTimer: float = 0
var isBunnyHopTimerActive: bool = false
var execJumpAction: bool = false

var flyingAnimationLength: float = 0
var flyingAnimationHalftime: float = 0

func _ready():
	animationPlayer = $modelo/AnimationPlayer
	animationPlayer.set_default_blend_time(blendTime)
	animationPlayer.set_speed_scale(animationSpeed)
	stateMachine.setup(self)
	zPos = transform.origin.z
	flyingAnimationLength = animationPlayer.get_animation("Jump").length
	flyingAnimationHalftime = flyingAnimationLength / 2


func _physics_process(delta):
	processJumpBuffering(delta)
	if animationPlayer.assigned_animation == "Jump":
		seekAirAnimation()
	transform.origin.z = zPos
	stateMachine.evaluate(delta)


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


func turn(direction: int, delta: float):
	if direction == 0:
		return
	var targetAngle = deg_to_rad(direction * 89)
	$modelo.rotation.y = lerp_angle($modelo.rotation.y, targetAngle, delta * turnSpeed)


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
	if isBunnyHopTimerActive:
		bunnyHopTimer += delta
	else:
		bunnyHopTimer = 0
	if bunnyHopTimer >= bunnyHopTime:
		execJumpAction = true
	else:
		execJumpAction = false	

func seekAirAnimation():
	var seek: float = 0
	if velocity.y < 0:
		var value: float = -velocity.y / maxFallSpeed
		seek = lerp(flyingAnimationHalftime, flyingAnimationLength, value)
	else:
		var value: float = 1 - (velocity.y / jumpSpeed)
		seek  = lerp(0.0, flyingAnimationHalftime, value)
	animationPlayer.seek(seek)
