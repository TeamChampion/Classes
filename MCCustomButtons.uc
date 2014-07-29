//----------------------------------------------------------------------------
// MCCustomButtons
//
// Does the holding down a button event for zooming, rotating etc
//
// Gustav Knutsson 2014-06-18
//----------------------------------------------------------------------------
class MCCustomButtons extends MouseInterfacePlayerInput within MCPlayerController
    config(Input);

var bool bMyButton, bMyButtonPressed, bMyButtonHeld, bMyButtonWasHeld, bMyButtonReleased, bMyButtonDoubletapped, bOld_MyButton;
var float LastPressedMyButtonTime;

// The Camera Properties link
var const MCCameraProperties CameraProperties;
// Rotating buttons
var bool bCanRotateLeft;
var bool bCanRotateRight;


// test
var float velRotation;

function MyButtonActions(float DeltaTime)
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
   
    bOld_MyButton = bMyButton;
}

event PlayerInput( float DeltaTime )
{
    local float deltaRotation;
    local Rotator newRotation;

    if (bMyButton && MCPlayer != none && MCPlayer.MyDecal != none)
    {
        deltaRotation = velRotation * DeltaTime; 

        newRotation = MCPlayer.MyDecal.Rotation;

        newRotation.Yaw  += deltaRotation;  // round

        MCPlayer.MyDecal.SetRotation(newRotation);
    }


    Super.PlayerInput(DeltaTime);
   
    // handle my custom button
    MyButtonActions(DeltaTime);
}

/*
simulated exec function MyButton()
{
    bMyButton = true;
}

// FIXME - stop using 'Un' as a prefix for momentary inputs being released
simulated exec function UnMyButton()
{
    bMyButton = false;
}
*/


/*
// Function that rotates the camera depending on button
*/
function RotateCamera()
{
    if(bCanRotateLeft)
    {
        MCRotationLeft();
    }else if(bCanRotateRight)
    {
        MCRotationRight();
    }
}



simulated event Tick( float DeltaTime )
{


    Super.Tick(DeltaTime);
}

/*
// Rotate left functions
*/
function MCRotationLeft()
{
    velRotation = 0;
    velRotation = -5000;

//    CameraProperties.Rotation.Roll += CameraProperties.RoationSpeed;
}
exec function MCRotateLeftON(){
    bMyButton = true;
    bCanRotateLeft = true;
}
exec function MCRotateLeftOff(){
    bMyButton = false;
    bCanRotateLeft = false;
}




function MCRotationRight()
{
    velRotation = 0;
    velRotation = 5000;
//    CameraProperties.Rotation.Roll -= CameraProperties.RoationSpeed;
}
exec function MCRotateRightON(){
    bMyButton = true;
    bCanRotateRight = true;
}
exec function MCRotateRightOff(){
    bMyButton = false;
    bCanRotateRight = false;
}

defaultproperties
{
    CameraProperties=MCCameraProperties'mystraschampionsettings.Camera.CameraProperties'
}