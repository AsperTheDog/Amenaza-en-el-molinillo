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
@export_subgroup("Acceleration")
@export var accelInAirMult: float = 1.0
@export var deccelInAirMult: float = 1.0
@export_subgroup("Hang time")
@export var jumpHangTimeThreshold: float = 0.02
@export var jumpHangAccelMult: float = 1.2
@export var jumpHangMaxSpeedMult: float = 1.2

@export_group("Run")
@export var runAccelAmount: float = 5
@export var runDeccelAmount: float = 5
@export var runMaxSpeed: float = 10
@export var doConserveMomentum = true

@export_group("Animation")
@export var turnSpeed: float = 1
@export var animationSpeed: float = 10
@export var blendTime: float = 0.3
@export var slowBlendTime: float = 0.3

var gravity: float = defaultGravity;
var animationPlayer: AnimationPlayer
var hasDoubleJumped: bool = false
var vaultingDir: int
var vaultingPos: Vector3


func _ready():
	animationPlayer = $modelo/AnimationPlayer
	animationPlayer.set_default_blend_time(blendTime)
	animationPlayer.set_speed_scale(animationSpeed)
	animationPlayer.set_blend_time("Run Ro", "Idle Ro", slowBlendTime)
	stateMachine.setup(self)


func _process(_delta):
	if animationPlayer.assigned_animation == "Run Ro":
		var speedDiff = 1 - (runMaxSpeed - abs(velocity.x)) / runMaxSpeed
		animationPlayer.set_speed_scale(lerp(0.0, animationSpeed, speedDiff))
	else:
		animationPlayer.set_speed_scale(animationSpeed)


func _physics_process(delta):
	stateMachine.evaluate(delta)


func setForce(force: Vector3):
	velocity = force


func applyForce(force: Vector3):
	velocity += force


func setVertForce(force: float):
	velocity.y = force


func setHorizForce(force: float):
	velocity.x = force


func applyHorizMovement(delta: float):
	var moveDir = Input.get_action_strength("Right") - Input.get_action_strength("Left")
	var targetSpeed = moveDir * runMaxSpeed
	var accelRate = runDeccelAmount
	if abs(targetSpeed) > 0.01:
		accelRate = runAccelAmount
	
	var movement = (targetSpeed - velocity.x) * accelRate * delta;
	applyForce(movement * Vector3.RIGHT)
	turn(sign(moveDir), delta)
	move_and_slide()


func applyHorizMovementAir(delta: float):
	var moveDir = Input.get_action_strength("Right") - Input.get_action_strength("Left")
	var targetSpeed = moveDir * runMaxSpeed
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
	turn(sign(moveDir), delta)
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
		
