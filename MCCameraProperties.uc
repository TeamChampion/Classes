class MCCameraProperties extends Object
	HideCategories(Object);

// Rotation Start
var(Camera, Rotation) Rotator StartRotation;
// Constant camera rotation
var(Camera, Rotation) Rotator Rotation;
// Camera ZoomIn / ZoomOut speed
var(Camera, Rotation) const int RoationSpeed;


// Camera Start Plane
var(Camera, Location) Vector StartPlane;
// Camera plane
var(Camera, Location) Vector MovementPlane;
// Camera plane normal
var(Camera, Location) const Vector MovementPlaneNormal;


// Camera ZoomIn / ZoomOut speed
var(Camera, Zoom) const float ZoomSpeed;
// Camera ZoomIn / ZoomOut speed
var(Camera, Zoom) const float MaxZoom;
// Camera ZoomIn / ZoomOut speed
var(Camera, Zoom) const float MinZoom;


// Speed at which the camera blends from one place to another
var(Camera) const float BlendSpeed;

// Tracking hero
var bool IsTrackingHeroPawn;
// Tracking Enemy Pawn
var bool IsTrackingEnemyPawn;
// bool that controls if we can not use the camera for a match, if false then use regular camera
var bool bSetToMatch;
// bool that just resets Camera Location & Rotation
var bool bStartPosition;
// use MouseMovement to move camera
var bool bSetMouseMovement;
// use Keyboard to move camera
var bool bSetKeyboardMovement;


defaultproperties
{
	StartRotation=(Yaw=24576, Pitch=51883,Roll=0)
	RoationSpeed=100

	StartPlane=(X=0,Y=0,Z=1440)

	ZoomSpeed=5.0f
	MaxZoom=1500
	MinZoom=256

	BlendSpeed=3.125f

	IsTrackingEnemyPawn = false
	IsTrackingHeroPawn = false
	bSetToMatch = true
	bStartPosition = true
	bSetMouseMovement = false
	bSetKeyboardMovement = false
}