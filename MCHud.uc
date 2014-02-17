class MCHud extends MouseInterfaceHUD;

var GFxBattleUI GFxBattleUI;

var GFxMainMenu GFxMainMenu;
var GFxSelectScreen GFxSelectScreen;
var GFxCreateScreen GFxCreateScreen;


// When create button is pushed it set's this Character as the one we will create
var MCPawn CreateThisCharacter;

simulated event PostBeginPlay()
{
	Super.PostBeginPlay();

	// If we are using ScaleForm, then create the ScaleForm movie

	if (MouseInterfaceGFx != None)
	{
		MouseInterfaceGFx.Close(true);
	}

	//SpawnBattleHud();
}

function SpawnBattleHud()
{
	if (GFxBattleUI == none)
	{
		GFxBattleUI = new class'GFxBattleUI';
		if (GFxBattleUI != none)
		{
			GFxBattleUI.MouseInterfaceHUD = self;

			GFxBattleUI.Init(class'Engine'.static.GetEngine().GamePlayers[GFxBattleUI.LocalPlayerOwnerIndex]);
		}
	}
}

event PostRender()
{
	local MCPlayerController PC;
	local MCGameReplication MCPR;

	MCPR = MCGameReplication(WorldInfo.GRI);
	// Get the PlayerController
	PC = MCPlayerController(PlayerOwner);

	Super.PostRender();

//	CheckMapForStartingVideo();

	// Set up battle HUD
	if (GFxBattleUI == none && PC.MCPlayer != none && MCPR.MCPRIArray.Length >= 1)
	{
		// create new class
		GFxBattleUI = new class'GFxBattleUI';
		if (GFxBattleUI != none)
		{

			GFxBattleUI.MouseInterfaceHUD = self;
			/** Sets the timing mode of the movie to either advance with game time (respecting game pause and time dilation), or real time (disregards game pause and time dilation) */
			GFxBattleUI.SetTimingMode(TM_Real);
			/** If TRUE, this movie player will be allowed to accept focus events.  Defaults to TRUE */
			GFxBattleUI.bAllowFocus = true;

			/** TRUE after Start() is called, FALSE after Close() is called. */
			if (!GFxBattleUI.bMovieIsOpen)
			{
				GFxBattleUI.Start();
			}
		}

	}

	// Tick BattleHud Movie
	if (GFxBattleUI != None && GFxBattleUI.bMovieIsOpen)
	{
		GFxBattleUI.Tick(RenderDelta);
	//	debugMenuHUD();
	}

	// Select Screen Tick
	if (GFxSelectScreen != None && GFxSelectScreen.bMovieIsOpen)
	{
		GFxSelectScreen.Tick(RenderDelta);
	}



}

/*
// Function that checks what map we are on so we can start the correct map with the correct Scaleform Video
*/
function CheckMapForStartingVideo()
{
	switch (WorldInfo.GetMapName())
	{
		case "MCStartMenu":
			`log("I luckely got here to the Menu");
			StartMovieMCStartMenu();
			break;
		case "town01":
			`log("Entered the town");
			break;
			
		default:
			
	}
}

function StartMovieMCStartMenu()
{

	if (GFxMainMenu == none)
	{
		// create new class
		GFxMainMenu = new class'GFxMainMenu';
		if (GFxMainMenu != none)
		{
		//	GFxMainMenu.MouseInterfaceHUD = self;
			/** Sets the timing mode of the movie to either advance with game time (respecting game pause and time dilation), or real time (disregards game pause and time dilation) */
			GFxMainMenu.SetTimingMode(TM_Real);
			/** If TRUE, this movie player will be allowed to accept focus events.  Defaults to TRUE */
			GFxMainMenu.bAllowFocus = true;

			/** TRUE after Start() is called, FALSE after Close() is called. */
			if (!GFxMainMenu.bMovieIsOpen)
			{
				GFxMainMenu.Start();
			}
		}
	}
}
















/*
// Will open the select screen
*/
exec function StartSelectScreen()
{
	if (GFxSelectScreen == none)
	{
		// create new class
		GFxSelectScreen = new class'GFxSelectScreen';
		if (GFxSelectScreen != none)
		{
			/** Sets the timing mode of the movie to either advance with game time (respecting game pause and time dilation), or real time (disregards game pause and time dilation) */
			GFxSelectScreen.SetTimingMode(TM_Game);
			/** If TRUE, this movie player will be allowed to accept focus events.  Defaults to TRUE */
			GFxSelectScreen.bAllowFocus = true;

			/** TRUE after Start() is called, FALSE after Close() is called. */
			if (!GFxSelectScreen.bMovieIsOpen)
			{
				GFxSelectScreen.Start();
			}
		}
	}
}
exec function CloseSelectScreen()
{
	if (GFxSelectScreen != None)
	{
		// Closes down movie
		GFxSelectScreen.Close(true);
		// Sets the movie to none so it doesn't fail
		GFxSelectScreen = none;
	}
}

//
/*
// Will open the select screen
*/
exec function StartCreateScreen()
{
	if (GFxCreateScreen == none)
	{
		// create new class
		GFxCreateScreen = new class'GFxCreateScreen';
		if (GFxCreateScreen != none)
		{
			/** Sets the timing mode of the movie to either advance with game time (respecting game pause and time dilation), or real time (disregards game pause and time dilation) */
			GFxCreateScreen.SetTimingMode(TM_Game);
			/** If TRUE, this movie player will be allowed to accept focus events.  Defaults to TRUE */
			GFxCreateScreen.bAllowFocus = true;

			/** TRUE after Start() is called, FALSE after Close() is called. */
			if (!GFxCreateScreen.bMovieIsOpen)
			{
				GFxCreateScreen.Start();
			}
		}
	}
}

exec function CloseCreateScreen()
{
	if (GFxCreateScreen != None)
	{
		// Closes down movie
		GFxCreateScreen.Close(true);
		// Sets the movie to none so it doesn't fail
		GFxCreateScreen = none;
	}
}




















///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// Debug for fighting characters
function debugMenuHUD()
{
	local MCPlayerController PC;
	local MCPawn MyPawn;
	local MCGameReplication MCPR;

	MCPR = MCGameReplication(WorldInfo.GRI);
	MyPawn = MCPawn(PlayerOwner.Pawn);

	super.DrawHUD();

	foreach DynamicActors(class'MCPlayerController', PC)
	{
		break;
	}
	
	if (MCPR != none)
	{
		Canvas.DrawColor = WhiteColor;
		Canvas.Font = class'Engine'.Static.GetSmallFont();
		Canvas.SetPos(5, 290);
		Canvas.DrawText("PRI :" @ MCPR.PRIArray.length);
		Canvas.SetPos(5, 305);
		Canvas.DrawText("MC PRI :" @ MCPR.MCPRIArray.length);
	}

	if(MyPawn != none && PC != none)
	{
			Canvas.SetPos(5, 260);
			Canvas.DrawText("This Computer PawnName :" @ MyPawn.PlayerName);
			Canvas.SetPos(5, 275);
			Canvas.DrawText("This Computer Pawn        :" @ MyPawn);
	}

	if (PC != none)
	{
		TrackHeroes();
		//`log("String or variable" @ PC.Pawn.APf);

		Canvas.DrawColor = WhiteColor;
		Canvas.Font = class'Engine'.Static.GetSmallFont();

		Canvas.SetPos(5, 595);
		Canvas.DrawText("MCPawn                                MCEnemy");
		Canvas.SetPos(5, 610);
		Canvas.DrawText("----------------------------------------------------------");

		if (PC.MCPlayer != none)
		{
			Canvas.DrawColor = RedColor;
			Canvas.Font = class'Engine'.Static.GetSmallFont();
			Canvas.SetPos(5, 625);
			Canvas.DrawText("Camera Hero          :" @ PC.CameraProperties.IsTrackingHeroPawn);

			Canvas.SetPos(5, 640);
			Canvas.DrawText("Player Name   :" @ PC.MCPlayer.PawnName);

			Canvas.SetPos(5, 655);
			Canvas.DrawText("Player AP       :" @ PC.MCPlayer.APf);

			Canvas.SetPos(5, 670);
			Canvas.DrawText("Unique ID       :" @ PC.MCPlayer.PlayerUniqueID);

			Canvas.SetPos(5, 685);
			Canvas.DrawText("Current State :" @ PC.GetStateName());

			Canvas.SetPos(5, 700);
			Canvas.DrawText("Health           :" @ PC.MCPlayer.Health);
		}

		if (PC.MCEnemy != none)
		{
			Canvas.DrawColor = GreenColor;
			Canvas.Font = class'Engine'.Static.GetSmallFont();
			Canvas.SetPos(220, 625);
			Canvas.DrawText("Camera Enemy          :" @ PC.CameraProperties.IsTrackingEnemyPawn);

			Canvas.SetPos(220, 640);
			Canvas.DrawText("Player Name   :" @ PC.MCEnemy.PawnName);

			Canvas.SetPos(220, 655);
			Canvas.DrawText("Player AP       :" @ PC.MCEnemy.APf);

			Canvas.SetPos(220, 670);
			Canvas.DrawText("Unique ID       :" @ PC.MCEnemy.PlayerUniqueID);

			Canvas.SetPos(220, 685);
			Canvas.DrawText("Current State :" @ PC.MCEnemy.GetStateName());

			Canvas.SetPos(220, 700);
			Canvas.DrawText("Health           :" @ PC.MCEnemy.Health);
		}
	}
}

// Debug screen for Multiplayer
function TrackHeroes()
{
	local MCGameReplication MCPR;
	local int i;
	//local MCPlayerController PC;

	MCPR = MCGameReplication(WorldInfo.GRI);

	super.DrawHUD();

	if (MCPR != none)
	{
		Canvas.DrawColor = WhiteColor;
		Canvas.Font = class'Engine'.Static.GetSmallFont();

		Canvas.SetPos(5, 320);
		Canvas.DrawText("Replication");
		Canvas.SetPos(5, 335);
		Canvas.DrawText("----------------------------------------------------------");

		if (MCPR.MCPRIArray.length < 0)
		{
			return;
		}

		for (i = 0; i < MCPR.MCPRIArray.length ; i++)
		{
			// Player 01 to the left
			if (MCPR.MCPRIArray[i].PlayerUniqueID == 1)
			{
				Canvas.DrawColor = GreenColor;
				Canvas.Font = class'Engine'.Static.GetSmallFont();

				// Name
				Canvas.SetPos(5, 350);
				Canvas.DrawText("PawnName   :" @ MCPR.MCPRIArray[i].PawnName);
				// PC Name
				Canvas.SetPos(5, 365);
				Canvas.DrawText("PlayerName  :" @ MCPR.MCPRIArray[i].PlayerName);
				// HP
				Canvas.SetPos(5, 380);
				Canvas.DrawText("Health        :" @ MCPR.MCPRIArray[i].Health);
				// AP
				Canvas.SetPos(5, 395);
				Canvas.DrawText("Player        :" @ MCPR.MCPRIArray[i].APf);
				// Has AP
				Canvas.SetPos(5, 410);
				Canvas.DrawText("Player        :" @ MCPR.MCPRIArray[i].bHaveAp);
			}
			// Player 02 to the right
			if (MCPR.MCPRIArray[i].PlayerUniqueID == 2)
			{
				Canvas.DrawColor = GreenColor;
				Canvas.Font = class'Engine'.Static.GetSmallFont();

				// Name
				Canvas.SetPos(220, 350);
				Canvas.DrawText("PawnName   :" @ MCPR.MCPRIArray[i].PawnName);
				// PC Name
				Canvas.SetPos(220, 365);
				Canvas.DrawText("PlayerName  :" @ MCPR.MCPRIArray[i].PlayerName);
				// HP
				Canvas.SetPos(220, 380);
				Canvas.DrawText("Health        :" @ MCPR.MCPRIArray[i].Health);
				// Has AP
				Canvas.SetPos(220, 395);
				Canvas.DrawText("Player        :" @ MCPR.MCPRIArray[i].APf);
				Canvas.SetPos(220, 410);
				Canvas.DrawText("Player        :" @ MCPR.MCPRIArray[i].bHaveAp);
			}
		}
	}
}

defaultproperties
{
	
}