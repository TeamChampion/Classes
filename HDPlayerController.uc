//=============================================================================
// HDPointclickPlayerController
//=============================================================================

class HDPlayerController extends UDKPlayerController;

var Vector2D    PlayerMouse;                //Hold calculated mouse position (this is calculated in HUD)
var HDMouse     MouseCursor;                //This is the instance of the mouse we have created

var Actor TraceActor;       //this is the name of the object under the mouse cursor... if there is one.

//mouse locations and normalised vectors
var Vector  MouseHitWorldLocation;
var Vector  MouseHitWorldNormal;

var Vector  MousePositionWorldLocation;
var Vector  MousePositionWorldNormal;

//where our pawn was looking last
var Vector  LastLookLocation;

var vector PawnEyeLocation;

//ray tracing
var Vector rayDir;

var Vector StartTrace;
var Vector EndTrace;

var float DistanceRemaining;
var bool bPawnNearDestination;

//======================================================
// Mouse clicking variables

var bool bLeftMousePressed; //leftmouse button 
var bool bRightMousePressed; //rightmouse button

var float totalDeltaTime;

var float ClickSensitivity;

//======================================================
// Mouse rotation variables

var float totalRotationTime;
var bool bMouseMiddleCheck;
var Vector mouseCurrentRotation;
var Vector mouseRotationDifference;
var float mouseTotalXRotation;


//zoom in
exec function EAZoomIn()
{
	PlayerCamera.FreeCamDistance -= 32;
}

//zoom out - a little faster that zooming in
exec function EAZoomOut()
{
	PlayerCamera.FreeCamDistance += 64;
}


//allow the screen to be rotated
exec function EARotate()
{
	bMouseMiddleCheck = true;
}


//release the screen from being rotates
exec function EARotateStop()
{
	bMouseMiddleCheck = false;
}

//Spawn an instance of the mouse
simulated event postbeginplay()
{
	super.postbeginplay();
	MouseCursor = Spawn(class'HDMouse', self, 'Marker');
}

//reset the camera - for debugging purposes in case we get lost
exec function resetScrollCamera()
{
	if(HDCamera(PlayerCamera).bResetCameraLoc == false)
	{
		HDCamera(PlayerCamera).bResetCameraLoc = true;
	}
	else if (HDCamera(PlayerCamera).bResetCameraLoc == true)
	{
		HDCamera(PlayerCamera).bResetCameraLoc = false;
	}

}

//tick function
event PlayerTick( float deltaTime )
{
	super.PlayerTick( deltaTime );

	if(bMouseMiddleCheck == true)
	{
		mouseTotalXRotation = mouseCurrentRotation.X - PlayerMouse.X; //find the difference between mouse points.
		mouseTotalXRotation = mouseTotalXRotation / 100;
		//this works!!!! finally!
		HDCamera(PlayerCamera).rotateAdjust -= mouseTotalXRotation;
	}
	else if(bMouseMiddleCheck == false)
	{
		mouseCurrentRotation.X = PlayerMouse.X; // find current mouse co-ordinates, store them in 'current rotation'
	}

	MouseCursor.setLocation(MouseHitWorldLocation);

	if(bRightMousePressed)
	{
		totalDeltaTime += deltaTime;

		SetDestinationPosition(MouseHitWorldLocation);

		if(totalDeltaTime >= ClickSensitivity)
		{
			//hold mouse click function
		}
	}
	
	if(!isinstate('MoveMouseClick'))
	{
		Pawn.SetRotation(Rotator(LastLookLocation));
	}
}

exec function StartFire(optional byte FireModeNum)
{

	if(isinstate('MoveMouseClick'))
	{
		PopState(true); //removes all states
	}

	totalDeltaTime = 0; //clear delta timer
	SetDestinationPosition(MouseHitWorldLocation); //sets initial destination of location

	//begin our  target, this lets us know we are starting again
	bPawnNearDestination = false;

	// Initialise for the mouse over time funtionality
	bLeftMousePressed = FireModeNum == 0;
	bRightMousePressed = FireModeNum == 1;

	//for debug purposes - maybe call another function from here?
	if(bLeftMousePressed) `Log("Left Mouse Pressed");
	if(bRightMousePressed) `Log("Right Mouse Pressed");
}

//for long presses
simulated function Stopfire(optional byte FiremodeNum )
{
	if(bLeftMousePressed && FiremodeNum == 0)
	{
		bLeftMousePressed = false;
		`log("left mouse released");
	}
	if(bRightMousePressed && FiremodeNum == 1)
	{
		bRightMousePressed = false;
	}

	if(!bPawnNearDestination && totalDeltaTime < ClickSensitivity)
	{
		if(fastTrace(MouseHitWorldLocation, PawnEyeLocation,, true))
			{
				MovePawnToDestination();
			}
	}
	else
	{
	//	PopState();
	}

	if(bPawnNearDestination){PopState();}

	totalDeltaTime = 0;
}

function MovePawnToDestination()
{
	SetDestinationPosition(MouseHitWorldLocation);
	PushState('MoveMouseClick');
}


//BEGIN STATE BASED MOVEMENT HERE
state MoveMouseClick
{
	event PoppedState()
	{
		if(IsTimerActive(nameof(StopLingering)))
		{
			ClearTimer(nameof(StopLingering));
		}
	}

	event PushedState()
	{
		SetTimer(3, false, nameof(StopLingering));
		if (Pawn != none)
		{
			Pawn.SetMovementPhysics();
		}
	}


Begin:
	while(!bpawnNearDestination)
	{
		MoveTo(GetdestinationPosition());
	}
	PopState();

}

function StopLingering()
{

	`Log("Stopped Lingering");
	PopState(true);
}

//handle the move function
function PlayerMove(float deltatime)
{
	local Vector PawnXYLocation; //where our pawn is
	local Vector DestinationXYLocation; //where it is going to be
	local Vector Destination;
	local Vector2D DistanceCheck; //see how far it is away

	super.PlayerMove(deltatime);

	Destination = GetDestinationPosition();
	DistanceCheck.X = Destination.X - Pawn.Location.X;
	DistanceCheck.Y = Destination.Y - Pawn.Location.Y;

	//calculate the remaining distance using pythagorean theorum :D
	DistanceRemaining = Sqrt((DistanceCheck.X*DistanceCheck.X) + (DistanceCheck.Y*DistanceCheck.Y));

	//are we close?
	bPawnNearDestination = DistanceRemaining < 50.0f;

	//update our location locally with our pawns location
	PawnXYLocation.X = Pawn.Location.X;
	PawnXYLocation.Y = Pawn.Location.Y;

	DestinationXYLocation.X = GetDestinationPosition().X;
	DestinationXYLocation.Y = GetDestinationPosition().Y;
	
	//face the right direction
	LastLookLocation = DestinationXYLocation - PawnXYLocation;
	Pawn.SetRotation(Rotator(DestinationXYLocation - PawnXYLocation));
}

//just used to overwrite camera settings
function UpdateViewTarget(out TViewTarget OutVT, float DeltaTime){//
}
//overwrite camera adjust from key presses
function ProcessViewRotation(float DeltaTime, out rotator out_ViewRotation, rotator DeltaRot){//
}

defaultproperties
{
	//our new camera class
	CameraClass=class'HDPointclick.HDCamera'

	//our new input class
	InputClass=class'HDPointclick.HDPlayerInput'
	ClickSensitivity = 0.20f
}

