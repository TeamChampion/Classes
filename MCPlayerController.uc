class MCPlayerController extends MouseInterfacePlayerController;

// Player Mouse Input links
var MouseInterfaceInteractionInterface LastMouseInteractionInterface;
// Cached mouse world origin
var Vector CachedMouseWorldOrigin;
// Cached mouse world direction
var Vector CachedMouseWorldDirection;
// The Camera Properties link
var const MCCameraProperties CameraProperties;

simulated event PostBeginPlay()
{
    super.PostBeginPlay();
    SetTimer(2.0f, false, 'CheckPawnFast');
}

function CheckPawnFast()
{
	`log("-----------------------------------------------");
    `log("-----------------------------------------------");
    `log("-----------------------------------------------");
	if (Pawn != none)
	{
		`log(GetALocalPlayerController());
		`log(GetALocalPlayerController().Pawn);
		`log(GetALocalPlayerController().Pawn.Health);
		//`log(NewPawn.Health);
	}else
	{
		`log("no Pawn Here");
	}
    `log("-----------------------------------------------");
    `log("-----------------------------------------------");
    `log("-----------------------------------------------");
}

event Possess( Pawn aPawn, bool bVehicleTransition )
{
    `log("Possess:"@ aPawn);

    super.Possess(aPawn, bVehicleTransition);
}

function AcknowledgePossession( Pawn P )
{
    `log("AcknowledgePossession:"@ P);

    super.AcknowledgePossession(P);
}

state PlayerWalking
{
	function BeginState(Name PreviousStateName)
	{
		`log("We made it this far ------------------------------------");
	}

	function Tick(float DeltaTime)
	{
		
	}

	exec function StartFire(optional byte FireModeNum)
	{
		local MouseInterfaceHUD MouseInterfaceHUD;
		local Vector HitLocation, HitNormal;
		//local MouseInterfacePlayerInput MouseInterfacePlayerInput;

		// Type cast to get our HUD
		MouseInterfaceHUD = MouseInterfaceHUD(myHUD);
		// Get the current mouse interaction interface
		//MouseInteractionInterface = MouseInterfaceHUD.GetMouseActor(HitLocation, HitNormal);
		//MouseInterfaceHUD.GetMouseActor(HitLocation,HitNormal);



		//////////////////////////////////////////////////////////////////////////////////////////////////
		HandleMouseInput((FireModeNum == 0) ? LeftMouseButton : RightMouseButton, IE_Pressed);
		Super.StartFire(FireModeNum);
		//////////////////////////////////////////////////////////////////////////////////////////////////


		`log("PlayerController Pressed!!!");
		`log(MouseInterfaceHUD.CachedMouseWorldOrigin);
		`log(MouseInterfaceHUD.CachedMouseWorldDirection);
		`log(HitLocation);
		`log(HitNormal);
		`log("PlayerController Pressed!!!");
	}
}

simulated function startMoving()
{
	//local MCPawn Mover;


}

//	Camera Functions for the game 
///////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////

exec function MCZoomIn()
{
	CameraProperties.MovementPlane.Z -= CameraProperties.ZoomSpeed;
	//`log("Zooming IN NOW!!!!");
	`log(CameraProperties.MovementPlane.Z);
}

exec function MCZoomOut()
{
	CameraProperties.MovementPlane.Z += CameraProperties.ZoomSpeed;
	//`log("Zooming OUT NOW!!!!");
	`log(CameraProperties.MovementPlane.Z);
}

exec function MCRotationLeft()
{
	CameraProperties.Rotation.Roll += CameraProperties.RoationSpeed;
}

exec function MCRotationRight()
{
	CameraProperties.Rotation.Roll -= CameraProperties.RoationSpeed;
}

// Will move Camera to The Hero When pressed
exec function MCTrackHero()
{
	if (CameraProperties.IsTrackingHeroPawn)
	{
		CameraProperties.IsTrackingHeroPawn = false;
		`log("Setting to false");
		return;
	}else
	{
		CameraProperties.IsTrackingHeroPawn = true;
		`log("Setting to true");
		return;
	}
}

defaultproperties
{
	CameraClass=class'MystrasChampion.MCCamera'
	CameraProperties=MCCameraProperties'mystraschampionsettings.Camera.CameraProperties'
}