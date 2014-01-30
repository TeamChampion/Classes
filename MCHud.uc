class MCHud extends MouseInterfaceHUD;

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

	if (MCPR != none)
	{
		`log(MCPR.PRIArray[0]);
		`log(MCPR.PRIArray[1]);
	}
//	`log(MCRep.PRIArray);
	




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

		//`log("String or variable" @ PC.Pawn.APf);
		if (PC.MCPawn != none)
		{
			Canvas.DrawColor = RedColor;
			Canvas.Font = class'Engine'.Static.GetSmallFont();
			Canvas.SetPos(5, 150);
			Canvas.DrawText("Player        :" @ PC.MCPawn);

			Canvas.SetPos(5, 165);
			Canvas.DrawText("Player Name    :" @ PC.MCPawn.PawnName);

			Canvas.SetPos(5, 180);
			Canvas.DrawText("Player AP      :" @ PC.MCPawn.APf);

			Canvas.SetPos(5, 195);
			Canvas.DrawText("Unique ID     :" @ PC.MCPawn.PlayerUniqueID);

			Canvas.SetPos(5, 210);
			Canvas.DrawText("Current State :" @ PC.GetStateName());




			Canvas.SetPos(5, 225);
			Canvas.DrawText("BlueTiles  :" @ PC.BlueTiles.length);

			Canvas.SetPos(5, 240);
			Canvas.DrawText("bCanTurnBlue  :" @ PC.bCanTurnBlue);

			Canvas.SetPos(5, 255);
			Canvas.DrawText("PathCost :" @ PC.getPathAPCost());
			
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
	//local MCPlayerController PC;

	MCPR = MCGameReplication(WorldInfo.GRI);
/*
	foreach DynamicActors(class'MCPlayerController', PC)
	{
		break;
	}
*/
/*
	if (MCPR != none && MCPR.PRIArray[0].PlayerUniqueID == 1)
	{
		Canvas.DrawColor = GreenColor;
		Canvas.Font = class'Engine'.Static.GetSmallFont();
		Canvas.SetPos(5, 150);
		Canvas.DrawText("Player        :" @ MCPR);

		Canvas.SetPos(5, 165);
		Canvas.DrawText("Player Name    :" @ PC.MCPawn.PawnName);

		Canvas.SetPos(5, 180);
		Canvas.DrawText("Player AP      :" @ PC.MCPawn.APf);

		Canvas.SetPos(5, 195);
		Canvas.DrawText("Unique ID     :" @ PC.MCPawn.PlayerUniqueID);

		Canvas.SetPos(5, 210);
		Canvas.DrawText("Current State :" @ PC.GetStateName());




		Canvas.SetPos(5, 225);
		Canvas.DrawText("BlueTiles  :" @ PC.BlueTiles.length);

		Canvas.SetPos(5, 240);
		Canvas.DrawText("bCanTurnBlue  :" @ PC.bCanTurnBlue);

		Canvas.SetPos(5, 255);
		Canvas.DrawText("PathCost :" @ PC.getPathAPCost());
	}
*/
}

defaultproperties
{
	
}