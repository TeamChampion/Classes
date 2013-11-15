/*******************************************************************************
	HDPCGame
*******************************************************************************/

class HDPCGame extends GameInfo;

defaultproperties
{
	DefaultPawnClass = class'HDPointclick.HDPawn'
	PlayerControllerClass = class'HDPointclick.HDPlayerController'
	HUDType = class'HDPointclick.HDHUD'

	bRestartLevel=False
	bDelayedStart=False
	bUseSeamlessTravel=true
}

