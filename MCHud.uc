//----------------------------------------------------------------------------
// MCHud
//
// Draw movies on the screen and even debug information here
// @TODO change to spawn menus from each flash mvie class isntead of here
//
// Gustav Knutsson 2014-06-18
//----------------------------------------------------------------------------
class MCHud extends MouseInterfaceHUD;

var GFxBattleUI GFxBattleUI;
var GFxBattleUI_PreLoad GFxBattleUI_PreLoad;
var GFxMainMenu GFxMainMenu;
var GFxSelectScreen GFxSelectScreen;
var GFxCreateScreen GFxCreateScreen;
var GFxTownMain cGFxTownMain;
var GFxTownShop cGFxTownShop;
var GFxWTPlayerItems cGFxWTPlayerItems;
var GFxWTPlayerInfo cGFxWTPlayerInfo;
//var GFxMultiplayer cGFxMultiplayer;
var MCCamera MyCamera;

// When create button is pushed it set's this Character as the one we will create
var MCPawn CreateThisCharacter;

simulated event PostBeginPlay()
{
	local MCCamera FindCamera;
	foreach DynamicActors(Class'MCCamera', FindCamera)
	{
		`log("----------------------------------------------------------");
		`log("MCHud - PostBeginPlay - Foreach search");
		`log("MyCamera =" @ FindCamera);
		MyCamera = FindCamera;
		`log("----------------------------------------------------------");
	}

	Super.PostBeginPlay();

	// Start by closing the MouseInterface Movie
	if (WorldInfo.GetMapName() == "movement_test16")
	{
		if (MouseInterfaceGFx != None)
			MouseInterfaceGFx.Close(true);
	}else
	{
		if (MouseInterfaceGFx != None)
			MouseInterfaceGFx.Close(true);
	}



	CheckMapForStartingVideo();		// Finding specific map name here
}

/*
// Play Battle Hud
*/
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
//	local Vector HitLocation, HitNormal;

	MCPR = MCGameReplication(WorldInfo.GRI);
	PC = MCPlayerController(PlayerOwner);

	super.DrawHUD();
	Super.PostRender();
	
//	HitLocation2 = HitLocation;
//	HitNormal2 = HitNormal;








//	CheckMapForStartingVideo();		// Finding specific map name here

	// Set up battle HUD
	if (GFxBattleUI == none && PC.MCPlayer != none && MCPR.MCPRIArray.Length >= 1)
	{
		// Close PreLoad Movie before we start battle
		if (GFxBattleUI_PreLoad != none)
			GFxBattleUI_PreLoad.Close(true);

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

	// If it's our battle map and if we don't have a preload flash, then show this.
	else if (GFxBattleUI_PreLoad == none && WorldInfo.GetMapName() == "movement_test16" && GFxBattleUI == none)
	{
		GFxBattleUI_PreLoad = new class'GFxBattleUI_PreLoad';
		if (GFxBattleUI_PreLoad != none)
		{
			/** Sets the timing mode of the movie to either advance with game time (respecting game pause and time dilation), or real time (disregards game pause and time dilation) */
			GFxBattleUI_PreLoad.SetTimingMode(TM_Real);
			/** If TRUE, this movie player will be allowed to accept focus events.  Defaults to TRUE */
			GFxBattleUI_PreLoad.bAllowFocus = true;

			/** TRUE after Start() is called, FALSE after Close() is called. */
			if (!GFxBattleUI_PreLoad.bMovieIsOpen)
			{
				GFxBattleUI_PreLoad.Start();
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

	// Render PlayerInfo
	if (cGFxWTPlayerInfo != none && cGFxWTPlayerInfo.bMovieIsOpen)
	{
		cGFxWTPlayerInfo.Tick(RenderDelta);
	}

	// Debug Area
	// -----------------------
	// Debug Multiplayer
//	TrackHeroes();
	TrackStatuses();
//	TrackCameraLocation();
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
			StartMovieTownMain();
		//	StartMovieTownShops();
			break;
		case "ShopTest":
			`log("Entered the SHOP");
			StartMovieTownShops();
			break;
		case "MultiplayerSearch":
			`log("Entered the Multiplayer");
		//	StartMultiplayer();
			break;
		default:
			
	}
}

/*
// Play Start Menu Hud
*/
function StartMovieMCStartMenu()
{
	if (GFxMainMenu == none)
	{
		// create new class
		GFxMainMenu = new class'GFxMainMenu';
		if (GFxMainMenu != none)
		{
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
// Play Town Main File
*/
exec function StartMovieTownMain()
{
	if (cGFxTownMain == none)
	{
		// create new class
		cGFxTownMain = new class'GFxTownMain';
		if (cGFxTownMain != none)
		{
			/** Sets the timing mode of the movie to either advance with game time (respecting game pause and time dilation), or real time (disregards game pause and time dilation) */
			cGFxTownMain.SetTimingMode(TM_Real);
			/** If TRUE, this movie player will be allowed to accept focus events.  Defaults to TRUE */
			cGFxTownMain.bAllowFocus = true;

			/** TRUE after Start() is called, FALSE after Close() is called. */
			if (!cGFxTownMain.bMovieIsOpen)
			{
				cGFxTownMain.Start();
			}
		}
	}
}
exec function CloseMovieTownMain()
{
	if (cGFxTownMain != None)
	{
		// Closes down movie
		cGFxTownMain.Close(true);
		// Sets the movie to none so it doesn't fail
		cGFxTownMain = none;
		`log("CLOSE CloseMovieTownMain");
	}
}
/*
// Play Town Shop File
*/
exec function StartMovieTownShops()
{
	if (cGFxTownShop == none)
	{
		// create new class
		cGFxTownShop = new class'GFxTownShop';
		if (cGFxTownShop != none)
		{
			/** Sets the timing mode of the movie to either advance with game time (respecting game pause and time dilation), or real time (disregards game pause and time dilation) */
			cGFxTownShop.SetTimingMode(TM_Real);
			/** If TRUE, this movie player will be allowed to accept focus events.  Defaults to TRUE */
			cGFxTownShop.bAllowFocus = true;

			/** TRUE after Start() is called, FALSE after Close() is called. */
			if (!cGFxTownShop.bMovieIsOpen)
			{
				cGFxTownShop.Start();
			}
		}
	}
}
exec function CloseMovieTownShops()
{
	if (cGFxTownShop != None)
	{
		// Closes down movie
		cGFxTownShop.Close(true);
		// Sets the movie to none so it doesn't fail
		cGFxTownShop = none;
		`log("CLOSE CloseMovieTownShops");
	}
}
/*
// Play Town Wizards Tower - Player Items
*/
exec function StartMovieWTPlayerItems()
{
	if (cGFxWTPlayerItems == none)
	{
		// create new class
		cGFxWTPlayerItems = new class'GFxWTPlayerItems';
		if (cGFxWTPlayerItems != none)
		{
			/** Sets the timing mode of the movie to either advance with game time (respecting game pause and time dilation), or real time (disregards game pause and time dilation) */
			cGFxWTPlayerItems.SetTimingMode(TM_Real);
			/** If TRUE, this movie player will be allowed to accept focus events.  Defaults to TRUE */
			cGFxWTPlayerItems.bAllowFocus = true;

			/** TRUE after Start() is called, FALSE after Close() is called. */
			if (!cGFxWTPlayerItems.bMovieIsOpen)
			{
				cGFxWTPlayerItems.Start();
			}
		}
	}
}
exec function CloseMovieWTPlayerItems()
{
	if (cGFxWTPlayerItems != None)
	{
		// Closes down movie
		cGFxWTPlayerItems.Close(true);
		// Sets the movie to none so it doesn't fail
		cGFxWTPlayerItems = none;
		`log("CLOSE CloseMovieTownShops");
	}
}
/*
// Play Town Wizards Tower - Player Info
*/
exec function StartMovieWTPlayerInfo()
{
	if (cGFxWTPlayerInfo == none)
	{
		// create new class
		cGFxWTPlayerInfo = new class'GFxWTPlayerInfo';
		if (cGFxWTPlayerInfo != none)
		{
			/** Sets the timing mode of the movie to either advance with game time (respecting game pause and time dilation), or real time (disregards game pause and time dilation) */
			cGFxWTPlayerInfo.SetTimingMode(TM_Real);
			/** If TRUE, this movie player will be allowed to accept focus events.  Defaults to TRUE */
			cGFxWTPlayerInfo.bAllowFocus = true;

			/** TRUE after Start() is called, FALSE after Close() is called. */
			if (!cGFxWTPlayerInfo.bMovieIsOpen)
			{
				cGFxWTPlayerInfo.Start();
			}
		}
	}
}
exec function CloseMovieWTPlayerInfo()
{
	if (cGFxWTPlayerInfo != None)
	{
		// Closes down movie
		cGFxWTPlayerInfo.Close(true);
		// Sets the movie to none so it doesn't fail
		cGFxWTPlayerInfo = none;
		`log("CLOSE CloseMovieTownShops");
	}
}












//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Change These to open from each script instead from kismet
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

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

/*
// Will open Multiplayer Menu
*/
/*
function StartMultiplayer()
{
	if (cGFxMultiplayer == none)
	{
		// create new class
		cGFxMultiplayer = new class'GFxMultiplayer';
		if (cGFxMultiplayer != none)
		{
			// Sets the timing mode of the movie to either advance with game time (respecting game pause and time dilation), or real time (disregards game pause and time dilation)
			cGFxMultiplayer.SetTimingMode(TM_Real);
			// If TRUE, this movie player will be allowed to accept focus events.  Defaults to TRUE 
			cGFxMultiplayer.bAllowFocus = true;

			// TRUE after Start() is called, FALSE after Close() is called.
			if (!cGFxMultiplayer.bMovieIsOpen)
			{
				cGFxMultiplayer.Start();
			}
		}
	}
}
*/



//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Debug Hud settings
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

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
			Canvas.DrawText("This Computer PawnName :" @ MyPawn.PawnName);
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
				Canvas.DrawText("PlayerUniqueID  :" @ MCPR.MCPRIArray[i].PlayerUniqueID);
				// HP
				Canvas.SetPos(5, 380);
				Canvas.DrawText("Health        :" @ MCPR.MCPRIArray[i].Health);
				// AP
				Canvas.SetPos(5, 395);
				Canvas.DrawText("Player AP     :" @ MCPR.MCPRIArray[i].APf);
				// Has AP
				Canvas.SetPos(5, 410);
				Canvas.DrawText("setCharacterSelect        :" @ MCPR.MCPRIArray[i].setCharacterSelect);
				Canvas.SetPos(5, 425);
				Canvas.DrawText("----------------------------------------------------------");
				Canvas.SetPos(5, 440);
				Canvas.DrawColor = WhiteColor;
				Canvas.Font = class'Engine'.Static.GetSmallFont();
				Canvas.DrawText("currentSpells01        :" @ MCPR.MCPRIArray[i].currentSpells01);
				Canvas.SetPos(5, 455);
				Canvas.DrawText("currentSpells02        :" @ MCPR.MCPRIArray[i].currentSpells02);
				Canvas.SetPos(5, 470);
				Canvas.DrawText("currentSpells03        :" @ MCPR.MCPRIArray[i].currentSpells03);
				Canvas.SetPos(5, 485);
				Canvas.DrawText("currentSpells04        :" @ MCPR.MCPRIArray[i].currentSpells04);
				Canvas.SetPos(5, 500);

				/*
				// Resistance
				Canvas.SetPos(5, 530);
				Canvas.DrawText("----------------------------------------------------------");
				Canvas.SetPos(5, 545);
				Canvas.DrawText("Res Fire =" @ MCPR.MCPRIArray[i].ResistanceValues[0]);
				Canvas.SetPos(5, 560);
				Canvas.DrawText("Res Ice  =" @ MCPR.MCPRIArray[i].ResistanceValues[1]);
				Canvas.SetPos(5, 575);
				Canvas.DrawText("Res Eart =" @ MCPR.MCPRIArray[i].ResistanceValues[2]);
				Canvas.SetPos(5, 590);
				Canvas.DrawText("Res Acid =" @ MCPR.MCPRIArray[i].ResistanceValues[3]);
				Canvas.SetPos(5, 605);
				Canvas.DrawText("Res Thun =" @ MCPR.MCPRIArray[i].ResistanceValues[4]);
				*/
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
				Canvas.DrawText("PlayerUniqueID  :" @ MCPR.MCPRIArray[i].PlayerUniqueID);
				// HP
				Canvas.SetPos(220, 380);
				Canvas.DrawText("Health        :" @ MCPR.MCPRIArray[i].Health);
				// Has AP
				Canvas.SetPos(220, 395);
				Canvas.DrawText("Player AP     :" @ MCPR.MCPRIArray[i].APf);
				Canvas.SetPos(220, 410);
				Canvas.DrawText("setCharacterSelect        :" @ MCPR.MCPRIArray[i].setCharacterSelect);
				//
				// line here
				Canvas.DrawColor = WhiteColor;
				Canvas.Font = class'Engine'.Static.GetSmallFont();
				Canvas.DrawText("currentSpells01        :" @ MCPR.MCPRIArray[i].currentSpells01);
				Canvas.SetPos(220, 455);
				Canvas.DrawText("currentSpells02        :" @ MCPR.MCPRIArray[i].currentSpells02);
				Canvas.SetPos(220, 470);
				Canvas.DrawText("currentSpells03        :" @ MCPR.MCPRIArray[i].currentSpells03);
				Canvas.SetPos(220, 485);
				Canvas.DrawText("currentSpells04        :" @ MCPR.MCPRIArray[i].currentSpells04);
				Canvas.SetPos(220, 500);
				/*
				// Resistance
				Canvas.SetPos(220, 545);
				Canvas.DrawText("Res Fire =" @ MCPR.MCPRIArray[i].ResistanceValues[0]);
				Canvas.SetPos(220, 560);
				Canvas.DrawText("Res Ice  =" @ MCPR.MCPRIArray[i].ResistanceValues[1]);
				Canvas.SetPos(220, 575);
				Canvas.DrawText("Res Eart =" @ MCPR.MCPRIArray[i].ResistanceValues[2]);
				Canvas.SetPos(220, 590);
				Canvas.DrawText("Res Acid =" @ MCPR.MCPRIArray[i].ResistanceValues[3]);
				Canvas.SetPos(220, 605);
				Canvas.DrawText("Res Thun =" @ MCPR.MCPRIArray[i].ResistanceValues[4]);
				*/
			}
		}
	}
}

// Debug screen for Multiplayer
function TrackStatuses()
{
	local MCGameReplication MCPR;
	local int i;
	local int bu;

	MCPR = MCGameReplication(WorldInfo.GRI);

	super.DrawHUD();

	if (MCPR != none)
	{
		Canvas.DrawColor = WhiteColor;
		Canvas.Font = class'Engine'.Static.GetSmallFont();


		if (MCPR.MCPRIArray.length < 0)
		{
	//		return;
		}

		for (i = 0; i < MCPR.MCPRIArray.length ; i++)
		{
			// Player 01 to the left
			if (MCPR.MCPRIArray[i].PlayerUniqueID == 1)
			{
				Canvas.DrawColor = WhiteColor;
				Canvas.Font = class'Engine'.Static.GetSmallFont();


				Canvas.SetPos(5, 230);
				Canvas.DrawText("");
				
				for (bu = 0; bu < 10 ; bu++)
				{
					if (MCPR.MCPRIArray[i].MyStatus[bu].StatusName != "")
					{
						Canvas.DrawText((bu+1)@"- StatusDur = " @ MCPR.MCPRIArray[i].MyStatus[bu].StatusDuration @ "-" @ MCPR.MCPRIArray[i].MyStatus[bu].StatusName );
						Canvas.SetPos(5, 260 + (15 * bu) );
					}
				}
			}
			// Player 02 to the right
			else if (MCPR.MCPRIArray[i].PlayerUniqueID == 2)
			{
				Canvas.DrawColor = WhiteColor;
				Canvas.Font = class'Engine'.Static.GetSmallFont();

				Canvas.SetPos(1000, 230);
				Canvas.DrawText("");
				
				for (bu = 0; bu < 10 ; bu++)
				{
					if (MCPR.MCPRIArray[i].MyStatus[bu].StatusName != "")
					{
						Canvas.DrawText((bu+1)@"- StatusDur = " @ MCPR.MCPRIArray[i].MyStatus[bu].StatusDuration @ "-" @ MCPR.MCPRIArray[i].MyStatus[bu].StatusName );
						Canvas.SetPos(1000, 260 + (15 * bu) );
					}	
				}
			}
		}
	}
}

function TrackCameraLocation()
{
	/*

	*/
	local MCPawn MyPawn;

	MyPawn = MCPawn(PlayerOwner.Pawn);


//	`log("Track My Camera " @ MyCamera);
	if (MyCamera != none)
	{
		Canvas.DrawColor = WhiteColor;
		Canvas.Font = class'Engine'.Static.GetSmallFont();

		// Name
		Canvas.SetPos(5, 350);
		Canvas.DrawText("Camera Location X:" @ MyCamera.Location.x);
		Canvas.SetPos(5, 365);
		Canvas.DrawText("Camera Location Y:" @ MyCamera.Location.y);
		Canvas.SetPos(5, 380);
		Canvas.DrawText("Camera Location Z:" @ MyCamera.Location.z);

if (MyPawn.MyDecal != none)
{
	

		Canvas.SetPos(5, 395);
		Canvas.DrawText("Decal Rotation  Roll:" @ MyPawn.MyDecal.Rotation.Roll);
		Canvas.SetPos(5, 410);
		Canvas.DrawText("Camera Rotation   Yaw:" @ MyPawn.MyDecal.Rotation.Yaw);
		Canvas.SetPos(5, 425);
		Canvas.DrawText("Camera Rotation Pitch:" @ MyPawn.MyDecal.Rotation.Pitch);
}

		Canvas.SetPos(5, 455);
		Canvas.DrawText("Camera DesiredCameraLocation:" @ MyCamera.DesiredCameraLocation);
		Canvas.SetPos(5, 470);
		Canvas.DrawText("Camera Camera.POV.Location:" @ MyCamera.PovLoc);
		Canvas.SetPos(5, 485);
		Canvas.DrawText("Camera CameraProperties.IsTrackingHeroPawn:" @ MyCamera.CameraProperties.IsTrackingHeroPawn);
	}
}

/*
// Debug for fighting characters
*/
function CheckTiles()
{
	local MCPlayerController PC;
	local int i;

	super.DrawHUD();

	foreach DynamicActors(class'MCPlayerController', PC)
	{
		break;
	}
	
	if (PC != none)
	{

		if (PC.MCPlayer != none)
		{
			Canvas.DrawColor = WhiteColor;
			Canvas.Font = class'Engine'.Static.GetSmallFont();

			for(i = 0; i < PC.TilesWeCanMoveOn.length ; i++)
			{
				Canvas.SetPos(5, 10 * i);
				Canvas.DrawText("Camera Hero          :" @ PC.TilesWeCanMoveOn[i]);
			}

		}
	}

}

defaultproperties
{
	
}