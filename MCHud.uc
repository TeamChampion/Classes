class MCHud extends MouseInterfaceHUD;

event PostRender()
{
	local MCPlayerReplication MCRep;
	local MCPlayerController PC;
	local MCPawn MyPawn;

	MCRep = MCPlayerReplication(WorldInfo.GRI);
	MyPawn = MCPawn(PlayerOwner.Pawn);

	foreach DynamicActors(class'MCPlayerController', PC)
	{
		break;
	}

	super.DrawHUD();

	Canvas.DrawColor = RedColor;
	Canvas.Font = class'Engine'.Static.GetSmallFont();

	if(MCPlayerReplication(WorldInfo.GRI) != none)
	{
		Canvas.SetPos(5, 95);
		Canvas.DrawText("Current Round              :" @ MCRep.GameRound);
	}

//	var	const	color	WhiteColor, GreenColor, RedColor;




	if(MyPawn != none && PC != none)
	{
			Canvas.SetPos(650, 110);
			Canvas.DrawText("This Player Comp   :" @ MyPawn.PlayerName @ "and computer is" @ MyPawn);
			Canvas.SetPos(650, 125);
			Canvas.DrawText("This Player Comp   :" @ PC.GetStateName());
	}

	if (PC != none)
	{

		//`log("String or variable" @ PC.Pawn.APf);
		if (PC.MyPlayers[0] != none)
		{
			Canvas.DrawColor = RedColor;
			Canvas.Font = class'Engine'.Static.GetSmallFont();
			Canvas.SetPos(5, 150);
			Canvas.DrawText("Player Name   :" @ PC.MyPlayers[0]);
			Canvas.SetPos(5, 165);
			Canvas.DrawText("Player AP      :" @ PC.MyPlayers[0].APf);
			Canvas.SetPos(5, 180);
			Canvas.DrawText("Current State :" @ PC.MyPlayers[0].GetStateName());
		}

		Canvas.SetPos(5, 110);
		Canvas.DrawText("Whoose turn :" @ PC.CurrentTurnPawn);

		if (PC.MyPlayers[1] != none)
		{

			Canvas.DrawColor = GreenColor;
			Canvas.Font = class'Engine'.Static.GetSmallFont();
			Canvas.SetPos(300, 150);
			Canvas.DrawText("Player Name   :" @ PC.MyPlayers[1]);
			Canvas.SetPos(300, 165);
			Canvas.DrawText("Player AP      :" @ PC.MyPlayers[1].APf);
			Canvas.SetPos(300, 180);
			Canvas.DrawText("Current State :" @ PC.MyPlayers[1].GetStateName());
		}

		
	}

	Super.PostRender();
}
defaultproperties
{
	
}