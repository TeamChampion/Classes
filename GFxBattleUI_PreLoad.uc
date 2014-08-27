//----------------------------------------------------------------------------
// GFxBattleUI_PreLoad
//
// Show a basic loading menu for the game before battle begins
//
// Gustav Knutsson 2014-07-18
//----------------------------------------------------------------------------
class GFxBattleUI_PreLoad extends GFxMoviePlayer;

var GFxObject RootMC;
var GFxObject BackgroundMC;	// Option Background

// Widget for Option Buttons
var GFxCLIKWidget OptionBtn;
var GFxCLIKWidget ContinueBtn;
var GFxCLIKWidget ReturnToTownBtn;

// Just check if it has started
var bool bInitialized;

function bool Start(optional bool StartPaused = false)
{
    super.Start();
    Advance(0.f);

	RootMC = GetVariableObject("root");

	if (!bInitialized)
	{
		ConfigHUD();
	}
	
	return true;
}

/*
// We start off by setting the initial settings
// @network					Client
*/
function ConfigHUD()
{
	// Background
	BackgroundMC = RootMC.GetObject("backgroundINS");
	BackgroundMC.SetVisible(false);

	ConfigOptionButton();

	bInitialized = true;
	// Stop at Main window in Flash and not Option
	RootMC.GotoAndStop("Main");
}

/*
// Config the AP Reset Button
// @network					Client
*/
function ConfigOptionButton()
{
	// Get the Widget
	// Main Option button
	OptionBtn = GFxClikWidget(RootMC.GetObject("optionINS",class'GFxClikWidget'));
	if (OptionBtn != none)
	{
		// Add button press, mouse over, mouse out
		OptionBtn.AddEventListener('CLIK_buttonPress', OptionButton);
	}
	// Continue Button
	ContinueBtn = GFxClikWidget(RootMC.GetObject("continueINS",class'GFxClikWidget'));
	if (ContinueBtn != none)
	{
		ContinueBtn.AddEventListener('CLIK_buttonPress', ContinueButton);
		ContinueBtn.SetVisible(false);
	}

	// Return To Town Button
	ReturnToTownBtn = GFxClikWidget(RootMC.GetObject("returntotownINS",class'GFxClikWidget'));
	if (ReturnToTownBtn != none)
	{
		ReturnToTownBtn.AddEventListener('CLIK_buttonPress', ReturnToTownButton);
		ReturnToTownBtn.SetVisible(false);
	}
	`log("GoodBye OptionButton");
}

/*
// Shop Our Option Menu
*/
function OptionButton(GFxClikWidget.EventData ev)
{
	if (OptionBtn != None)
	{
		// Show Buttons And Background
		BackgroundMC.SetVisible(true);
		ReturnToTownBtn.SetVisible(true);
		ContinueBtn.SetVisible(true);
	}
}

/*
// Return Back in to the game
*/
function ContinueButton(GFxClikWidget.EventData ev)
{
	if (ContinueBtn != None)
	{
		// Hide Buttons And Background
		BackgroundMC.SetVisible(false);
		ReturnToTownBtn.SetVisible(false);
		ContinueBtn.SetVisible(false);
	}
}

/*
// Function that will return to Town from a game
*/
function ReturnToTownButton(GFxClikWidget.EventData ev)
{
	local MCPlayerController cMCPC;

	cMCPC = MCPlayerController(GetPC());
	
	// Turn off Hud
	Close(true);
	// Go in to PC and reset Mu;tiplayer game
	cMCPC.QuitToMainMenu();
}

DefaultProperties
{
    bDisplayWithHudOff=false
    TimingMode=TM_Game
    MovieInfo=SwfMovie'MystrasChampionFlash.Battle.BattleHUD_PreLoad'

	bPauseGameWhileActive=false
}