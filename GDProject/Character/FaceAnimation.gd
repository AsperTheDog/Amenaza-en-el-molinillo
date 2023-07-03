extends Node
class_name FaceAnimation

@export var animation: String

@export_group("Eyes")
@export var eyeTimes: Array[float]
@export var eyeFaces: Array[CompressedTexture2D]

@export_group("Mouth")
@export var mouthTimes: Array[float]
@export var mouthFaces: Array[CompressedTexture2D]

var prevEyesTime: float = -1.0
var prevMouthTime: float = -1.0

func execute(eyes, mouth, animationTimestamp):
	var newEyes = null
	for i in eyeTimes.size():
		if eyeTimes[i] > animationTimestamp or prevEyesTime >= eyeTimes[i]:
			continue
		print("Changing face for animation ", animation, " at timestamp ", animationTimestamp, " to eyes ", eyeFaces[i].get_load_path())
		eyes.get_mesh().get("surface_0/material").set_texture(StandardMaterial3D.TEXTURE_ALBEDO, eyeFaces[i])
		prevEyesTime = eyeTimes[i]
		newEyes = eyeFaces[i]
		break
	for i in mouthTimes.size():
		if mouthTimes[i] > animationTimestamp or prevMouthTime == mouthTimes[i]:
			break
		print("Changing face for animation ", animation, " at timestamp ", animationTimestamp, " to mouth ", mouthFaces[i].get_load_path())
		mouth.get_mesh().get("surface_0/material").set_texture(StandardMaterial3D.TEXTURE_ALBEDO, mouthFaces[i])
		prevMouthTime = mouthTimes[i]
		break
	return newEyes

func reset():
	prevEyesTime = -1.0
	prevMouthTime = -1.0
	
#func addEye(time: float, face: CompressedTexture2D):
#	eyeTimes.append(time)
#	eyeFaces.append(face)
#
#func addMouth(time: float, face: CompressedTexture2D):
#	mouthTimes.append(time)
#	mouthFaces.append(face)
