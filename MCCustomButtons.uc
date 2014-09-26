//----------------------------------------------------------------------------
// MCCustomButtons
//
// Does the holding down a button event for zooming, rotating the Decal under
// the Character
//
// Gustav Knutsson 2014-08-17
//----------------------------------------------------------------------------
class MCCustomButtons extends MouseInterfacePlayerInput
	within MCPlayerController
	config(Input);

var bool bMyButton, bMyButtonPressed, bMyButtonHeld, bMyButtonWasHeld, bMyButtonReleased, bMyButtonDoubletapped, bOld_MyButton;
var float LastPressedMyButtonTime;

// The Camera Properties link
var const MCCameraProperties CameraProperties;
// Rotating buttons
var bool bCanRotateLeft;
var bool bCanRotateRight;
// Moving Camera
var bool bCanTurnUp, bCanTurnDown, bCanTurnLeft, bCanTurnRight;
// Rotatino Speed
var float velRotation;


function MyButtonActions()
{
	bMyButtonPressed = bMyButton && !bOld_MyButton;
	bMyButtonDoubletapped = false;
	if (bMyButtonPressed)
	{
		if (WorldInfo.TimeSeconds - LastPressedMyButtonTime < DoubleClickTime)
			bMyButtonDoubletapped = true;
	else
		LastPressedMyButtonTime = WorldInfo.TimeSeconds;
	}

	bMyButtonWasHeld = bMyButtonHeld;
	if (bMyButton && bOld_MyButton && (WorldInfo.TimeSeconds - LastPressedMyButtonTime >= DoubleClickTime))
			bMyButtonHeld = true;
	else
		bMyButtonHeld = false;

	bMyButtonReleased = !bMyButton && bOld_MyButton;

	if (bMyButtonDoubletapped)
	{
		// do something special
	}
	else if (bMyButtonPressed)
	{
		// do something
	}
	else if (bMyButtonHeld)
	{
		// do alternate something
		RotateCamera();
	}
	else if (bMyButtonReleased)
	{        
		if (!bMyButtonWasHeld)
		{
			// do another something
		}
		else
		{
			// do another alternate something
		}
	}

	// Saves setting for button to compare if we are holding it down
	bOld_MyButton = bMyButton;
}

event PlayerInput( float DeltaTime )
{
	local float deltaRotation;
	local Rotator newRotation;

	// If We have a button, Player && PlayerDecal
	if (bMyButton && MCPlayer != none && MCPlayer.MyDecal != none)
	{
		if (bCanRotateLeft || bCanRotateRight)
		{
			// Set rotation to Yaw only
			/*
			newRotation = MCPlayer.MyDecal.Rotation;
			deltaRotation = velRotation * DeltaTime; 
			newRotation.Yaw  += deltaRotation;

			MCPlayer.MyDecal.SetRotation(newRotation);
			*/


		}

		else if (bCanTurnUp || bCanTurnDown)
		{
			newRotation = MCPlayer.MyDecal.Rotation;
			deltaRotation = velRotation * DeltaTime; 
			newRotation.Pitch  += deltaRotation;

			MCPlayer.MyDecal.SetRotation(newRotation);

		}

		else if (bCanTurnLeft || bCanTurnRight)
		{
			// Set rotation to Yaw only
			newRotation = MCPlayer.MyDecal.Rotation;
			deltaRotation = velRotation * DeltaTime; 
			newRotation.Yaw  += deltaRotation;

			MCPlayer.MyDecal.SetRotation(newRotation);
		}

	}




	Super.PlayerInput(DeltaTime);

	// handle my custom button
	RotateCamera();
//	MyButtonActions();
}

/*
// Function that rotates the camera depending on button being pressed
*/
function RotateCamera()
{

	if (bMyButton)
	{
		if(bCanRotateLeft)
		{
			velRotation = -CameraProperties.RoationSpeed;
		}
		else if(bCanRotateRight)
		{
			velRotation = CameraProperties.RoationSpeed;
		}


		else if(bCanTurnUp)
		{
			velRotation = CameraProperties.RoationSpeed;
		}

		else if(bCanTurnDown)
		{
			velRotation = -CameraProperties.RoationSpeed;
		}
		else if(bCanTurnLeft)
		{
			velRotation = -CameraProperties.RoationSpeed;
		}
		else if(bCanTurnRight)
		{
			velRotation = CameraProperties.RoationSpeed;
		}
	}

}

// .Bindings=(Name="ThumbMouseButton",Command="MCRotateLeftON | onrelease MCRotateLeftOff")
// Press to Start to turn Left Rotation ON
exec function MCRotateLeftON()
{
	`log("Find MCRotateLeftON");
	bMyButton = true;
	bCanRotateLeft = true;
}
// Turn Off Rotation
exec function MCRotateLeftOff()
{
	bMyButton = false;
	bCanRotateLeft = false;
	velRotation = 0;
}

// .Bindings=(Name="ThumbMouseButton2",Command="MCRotateRightON | onrelease MCRotateRightOff")
// Press to Start to turn Right Rotation ON
exec function MCRotateRightON()
{
	bMyButton = true;
	bCanRotateRight = true;
}
// Turn Off Rotation
exec function MCRotateRightOff()
{
	bMyButton = false;
	bCanRotateRight = false;
	velRotation = 0;
}



///////////////////////////////////////////////////////////////////////////////////////////////////////

exec function MCTurnUpOn()
{
	`log("Find MCTurnUpOn");
	bMyButton = true;
	bCanTurnUp = true;
}

exec function MCTurnUpOff()
{
	bMyButton = false;
	bCanTurnUp = false;
	velRotation = 0;
}

///////////////////////////////////////////////////////////////////////////////////////////////////////

exec function MCTurnDownOn()
{
	`log("Find MCTurnDownOn");
	bMyButton = true;
	bCanTurnDown = true;
}

exec function MCTurnDownOff()
{
	bMyButton = false;
	bCanTurnDown = false;
	velRotation = 0;
}

///////////////////////////////////////////////////////////////////////////////////////////////////////

exec function MCTurnLeftOn()
{
	`log("Find MCTurnLeftOn");
	bMyButton = true;
	bCanTurnLeft = true;
}

exec function MCTurnLeftOff()
{
	bMyButton = false;
	bCanTurnLeft = false;
	velRotation = 0;
}

///////////////////////////////////////////////////////////////////////////////////////////////////////

exec function MCTurnRightOn()
{
	`log("Find MCTurnRightOn");
	bMyButton = true;
	bCanTurnRight = true;
}

exec function MCTurnRightOff()
{
	bMyButton = false;
	bCanTurnRight = false;
	velRotation = 0;
}



defaultproperties
{
	CameraProperties=MCCameraProperties'mystraschampionsettings.Camera.CameraProperties'
}