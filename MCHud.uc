class MCHud extends MouseInterfaceHUD;

var GFxBattleUI GFxBattleUI;

simulated event PostBeginPlay()
{
	Super.PostBeginPlay();

	// If we are using ScaleForm, then create the ScaleForm movie

	if (MouseInterfaceGFx != None)
	{
		//MouseInterfaceGFx.Close(true);
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
	local MCGameReplication MCPR;
	local MCPlayerController PC;
	local MCPawn MyPawn;
	local MCPlayerReplication MCPRep;

	MCPR = MCGameReplication(WorldInfo.GRI);

	MyPawn = MCPawn(PlayerOwner.Pawn);

	foreach DynamicActors(class'MCPlayerController', PC)
	{
		break;
	}

	super.DrawHUD();

	if (GFxBattleUI != none)
	{
		GFxBattleUI.GetPlayerInformation();
	}
//	`log(MCRep.PRIArray);
	
	if (MCPR !=none)
	{
//		`log(MCPR.MCPRIArray[0]);
//		`log(MCPR.MCPRIArray[1]);
	}



	Canvas.DrawColor = RedColor;
	Canvas.Font = class'Engine'.Static.GetSmallFont();

	if(MCGameReplication(WorldInfo.GRI) != none)
	{
		Canvas.SetPos(5, 95);
		Canvas.DrawText("Current Round              :" @ MCPR.GameRound);
	}

//	var	const	color	WhiteColor, GreenColor, RedColor;


	if(MyPawn != none && PC != none)
	{
			Canvas.SetPos(650, 5);
			Canvas.DrawText("This Player Comp   :" @ MyPawn.PlayerName @ "and computer is" @ MyPawn);
	}

	if (PC != none)
	{
		TrackHeroes();
		//`log("String or variable" @ PC.Pawn.APf);
		if (PC.MCPlayer != none)
		{
			
			Canvas.DrawColor = RedColor;
			Canvas.Font = class'Engine'.Static.GetSmallFont();
			Canvas.SetPos(5, 150);
			Canvas.DrawText("Player        :" @ PC.MCPlayer);

			Canvas.SetPos(5, 165);
			Canvas.DrawText("Player Name    :" @ PC.MCPlayer.PawnName);

			Canvas.SetPos(5, 180);
			Canvas.DrawText("Player AP      :" @ PC.MCPlayer.APf);

			Canvas.SetPos(5, 195);
			Canvas.DrawText("Unique ID     :" @ PC.MCPlayer.PlayerUniqueID);

			Canvas.SetPos(5, 210);
			Canvas.DrawText("Current State :" @ PC.GetStateName());

			Canvas.SetPos(5, 225);
			Canvas.DrawText("Health      :" @ PC.MCPlayer.Health);


/*
			Canvas.SetPos(5, 225);
			Canvas.DrawText("BlueTiles  :" @ PC.BlueTiles.length);

			Canvas.SetPos(5, 240);
			Canvas.DrawText("bCanTurnBlue  :" @ PC.bCanTurnBlue);

			Canvas.SetPos(5, 255);
			Canvas.DrawText("PathCost :" @ PC.getPathAPCost());
*/
		}

	//	`log(PC.MyPlayers[1].PlayerUniqueID);
		if (PC.MCEnemy != none)
		{
			Canvas.DrawColor = GreenColor;
			Canvas.Font = class'Engine'.Static.GetSmallFont();
			Canvas.SetPos(300, 150);
			Canvas.DrawText("Player        :" @ PC.MCEnemy);

			Canvas.SetPos(300, 165);
			Canvas.DrawText("Player Name    :" @ PC.MCEnemy.PawnName);

			Canvas.SetPos(300, 180);
			Canvas.DrawText("Player AP      :" @ PC.MCEnemy.APf);

			Canvas.SetPos(300, 195);
			Canvas.DrawText("Unique ID     :" @ PC.MCEnemy.PlayerUniqueID);

			Canvas.SetPos(300, 210);
			Canvas.DrawText("Current State :" @ PC.MCEnemy.GetStateName());

			Canvas.SetPos(300, 225);
			Canvas.DrawText("Health      :" @ PC.MCEnemy.Health);

		}



	/*	
		Canvas.DrawColor = WhiteColor;
		Canvas.Font = class'Engine'.Static.GetSmallFont();

		Canvas.SetPos(1000, 85);
		Canvas.DrawText("RouteCache[0]:" @ PC.RouteCache[0]);
		Canvas.SetPos(1000, 100);
		Canvas.DrawText("RouteCache[1]:" @ PC.RouteCache[1]);
		Canvas.SetPos(1000, 115);
		Canvas.DrawText("RouteCache[2]:" @ PC.RouteCache[2]);
		Canvas.SetPos(1000, 130);
		Canvas.DrawText("RouteCache[3]:" @ PC.RouteCache[3]);
		Canvas.SetPos(1000, 145);
		Canvas.DrawText("RouteCache[4]:" @ PC.RouteCache[4]);
		Canvas.SetPos(1000, 160);
		Canvas.DrawText("RouteCache[5]:" @ PC.RouteCache[5]);


		Canvas.SetPos(1000, 175);
		Canvas.DrawText("----------------------------------");
		Canvas.SetPos(1000, 190);
		Canvas.DrawText("RouteCache[6]:" @ PC.RouteCache[6]);
		Canvas.SetPos(1000, 205);
		Canvas.DrawText("RouteCache[7]:" @ PC.RouteCache[7]);
		Canvas.SetPos(1000, 220);
		Canvas.DrawText("RouteCache[8]:" @ PC.RouteCache[8]);
	*/	
	}

	Super.PostRender();
}



function TrackHeroes()
{
	local MCGameReplication MCPR;
	local int i;
	//local MCPlayerController PC;

	MCPR = MCGameReplication(WorldInfo.GRI);

	
	if (MCPR != none)
	{
		for (i = 0; i < MCPR.MCPRIArray.length ; i++)
		{
			
			// Player 01 to the left
			if (MCPR.MCPRIArray[i].PlayerUniqueID == 1)
			{
				Canvas.DrawColor = GreenColor;
				Canvas.Font = class'Engine'.Static.GetSmallFont();

				// Name
				Canvas.SetPos(5, 350);
				Canvas.DrawText("PawnName      :" @ MCPR.MCPRIArray[i].PawnName);
				// PC Name
				Canvas.SetPos(5, 365);
				Canvas.DrawText("PlayerName    :" @ MCPR.MCPRIArray[i].PlayerName);
				// HP
				Canvas.SetPos(5, 380);
				Canvas.DrawText("Health        :" @ MCPR.MCPRIArray[i].Health);
				// AP
				Canvas.SetPos(5, 395);
				Canvas.DrawText("Player        :" @ MCPR.MCPRIArray[i].APf);
			}
			// Player 02 to the right
			if (MCPR.MCPRIArray[i].PlayerUniqueID == 2)
			{
				Canvas.DrawColor = GreenColor;
				Canvas.Font = class'Engine'.Static.GetSmallFont();

				// Name
				Canvas.SetPos(300, 350);
				Canvas.DrawText("PawnName      :" @ MCPR.MCPRIArray[i].PawnName);
				// PC Name
				Canvas.SetPos(300, 365);
				Canvas.DrawText("PlayerName    :" @ MCPR.MCPRIArray[i].PlayerName);
				// HP
				Canvas.SetPos(300, 380);
				Canvas.DrawText("Health        :" @ MCPR.MCPRIArray[i].Health);
				// AP
				Canvas.SetPos(300, 395);
				Canvas.DrawText("Player        :" @ MCPR.MCPRIArray[i].APf);
			}


		}
	}












/*
		Canvas.SetPos(5, 165);
		Canvas.DrawText("Player Name    :" @ PC.MCPlayer.PawnName);

		Canvas.SetPos(5, 180);
		Canvas.DrawText("Player AP      :" @ PC.MCPlayer.APf);

		Canvas.SetPos(5, 195);
		Canvas.DrawText("Unique ID     :" @ PC.MCPlayer.PlayerUniqueID);

		Canvas.SetPos(5, 210);
		Canvas.DrawText("Current State :" @ PC.GetStateName());




		Canvas.SetPos(5, 225);
		Canvas.DrawText("BlueTiles  :" @ PC.BlueTiles.length);

		Canvas.SetPos(5, 240);
		Canvas.DrawText("bCanTurnBlue  :" @ PC.bCanTurnBlue);

		Canvas.SetPos(5, 255);
		Canvas.DrawText("PathCost :" @ PC.getPathAPCost());
*/
	

}

defaultproperties
{
	
}