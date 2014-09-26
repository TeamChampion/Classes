//----------------------------------------------------------------------------
// GFxTownMain
//
// Start Main Town shop select screen
// @TODO add buttons to go back, button to shop etc
//
// Gustav Knutsson 2014-06-18
//----------------------------------------------------------------------------
class GFxTownMain extends GFxMain;

function bool Start(optional bool StartPaused = false)
{
	super.Start();
	Advance(0.f);

	RootMC = GetVariableObject("root");

	MCP = MCPawn(GetPC().Pawn);
	
	if (!bInitialized)
	{
		ConfigHUD();
	}

	return true;
}

/*
// We start off by setting the initial settings
// @network                 Client
*/
function ConfigHUD()
{
//	ConfigSelectMenu();
	bInitialized = true;
}

/*
// Callback automatically called for each object in the movie with enableInitCallback enabled
event bool WidgetInitialized(name WidgetName, name WidgetPath, GFxObject Widget)
{
	// Determine which widget is being initialized and handle it accordingly
	switch(Widgetname)
	{
		case 'Player01':
			P01Button = GFxCLIKWidget(Widget);
			// Set switch for next GoToFrame function
			P01Button.AddEventListener('CLIK_click', ReturnPlayer01);
			break;
		case 'Player02':
			P02Button = GFxCLIKWidget(Widget);
			P02Button.AddEventListener('CLIK_click', ReturnPlayer02);
			break;
		case 'Player03':
			P03Button = GFxCLIKWidget(Widget);
			P03Button.AddEventListener('CLIK_click', ReturnPlayer03);
			break;
		case 'Player04':
			P04Button = GFxCLIKWidget(Widget);
			P04Button.AddEventListener('CLIK_click', ReturnPlayer04);
			break;
		default:
			break;
	}
	return true;
}
*/

DefaultProperties
{
	bDisplayWithHudOff=false
	TimingMode=TM_Game
	MovieInfo=SwfMovie'MystrasChampionFlash.Town.selectMap'
}