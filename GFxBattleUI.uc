class GFxBattleUI extends GFxMoviePlayer;

var GFxObject RootMC;
var MouseInterfaceHUD MouseInterfaceHUD;
var MCPlayerController MCPC;
var MCPawn MCP;



/*
// TF = TextField - texts, ints, floats etc
// MC = MovieClip - Areas, inside symbols etc
// Btn = Buttons
// CB = GFxClikWidget = Click button 	ButtonPress / RollOver / RollOut
// RB = GFxClikWidget = Roll button 	RollOver / RollOut
*/




// Player 01 things That we change on MovieClip symbols
/*
//	plyaer01area - 
//	
*/
var GFxObject P01areaMC;	// Player Area
var GFxObject P01APareaMC;	// Player AP Area
var GFxObject P01NameTF;	// Set Player Name
var GFxObject P01HPTextTF;	// Set Player HP
var GFxObject P01APNumbTF;	// Set His AP Number
var GFxObject P01APTextTF;	// Set His AP Text
// Send HP to code
// Send MAXHP to code
//	- Indicator checks if we have AP, IF AP is more then 0 then show it


// Player 02 things That we change on MovieClip symbols
var GFxObject P02areaMC;	// Player Area
var GFxObject P02APareaMC;	// Player AP Area
var GFxObject P02NameTF;	// Set Player Name
var GFxObject P02HPTextTF;	// Set Player HP
var GFxObject P02APNumbTF;	// Set His AP Number
var GFxObject P02APTextTF;	// Set His AP Text
// Send HP to code
// Send MAXHP to code
//	- Indicator checks if we have AP, IF AP is more then 0 then show it

var GFxObject GameRoundMC;
var GFxObject GameRoundTF; //roundINS



// Widgets for spells
var GFxCLIKWidget Earth01;
var GFxCLIKWidget Earth02;
var GFxCLIKWidget Earth03;
var GFxCLIKWidget Earth04;

var GFxCLIKWidget Fire01;
var GFxCLIKWidget Fire02;
var GFxCLIKWidget Fire03;
var GFxCLIKWidget Fire04;


/*
var GFxObject 
var GFxObject 
var GFxObject 
var GFxObject 
var GFxObject 
var GFxObject 
var GFxObject 
var GFxObject 
var GFxObject 
var GFxObject 
var GFxObject 
var GFxObject 
var GFxObject 
var GFxObject 
var GFxObject 
var GFxObject 
var GFxObject 
var GFxObject 
var GFxObject 
*/

var bool bInitialized;


function Init(optional LocalPlayer LocalPlayer)
{
	// Initialize the ScaleForm movie
	Super.Init(LocalPlayer);
	Start();
    Advance(0.f);

 	RootMC = GetVariableObject("root");
	`log("------------------------------------ Start Movie");
}

function bool Start(optional bool StartPaused = false)
{
    super.Start();
    Advance(0.f);

	RootMC = GetVariableObject("root");

	if (!bInitialized)
	{
		ConfigHUD();
    `log("-----------------------------------------------------------------------");
    `log("---------------------------------main----------------------------------");
    `log("-----------------------------------------------------------------------");
	}
	
	return true;
}

event UpdateMousePosition(float X, float Y)
{
	local MouseInterfacePlayerInput MouseInterfacePlayerInput;

	if (MouseInterfaceHUD != None && MouseInterfaceHUD.PlayerOwner != None)
	{
		MouseInterfacePlayerInput = MouseInterfacePlayerInput(MouseInterfaceHUD.PlayerOwner.PlayerInput);

		if (MouseInterfacePlayerInput != None)
		{
			MouseInterfacePlayerInput.SetMousePosition(X, Y);
		}
	}
}

function findThisInPC()
{
	`log("I found you from HUD and PC");
}

// Sent function from ActionScript
function getActionscript(int find)
{
	//`log(find);
	//`log("I GOT THE STUPID THING!!!!!!!!!!!!!!!!!");
}











function ConfigHUD()
{
	setPlayerLightUpIndicator();
	setAPButtonPosition();
	GetPlayerInformation();
}

function Tick(float DeltaTime)
{
	setPlayerLightUpIndicator();
	setAPButtonPosition();
	GetPlayerInformation();
}





/*
// Function that sets the indicator color, whos turn is red or blue
*/
function setPlayerLightUpIndicator()
{
	local MCGameReplication MyGMRep;
//	local MCPlayerController MyPC;
//	local MCPawn MyPawn;
	local int i;
	local int setTheNumber;

	// Get PlayerControoler
//	MyPC = MCPlayerController(GetPC());
	// Get Pawn
//	MyPawn = MCPawn(GetPC().Pawn);

	// Get GameReplication
	MyGMRep = MCGameReplication(class'WorldInfo'.static.GetWorldInfo().GRI);

	for (i = 0; i < MyGMRep.MCPRIArray.Length ; i++)
	{
		// If My Rep char has my current Characters AP then set indicator
		if (MyGMRep.MCPRIArray[i].bHaveAp)
		{
			setTheNumber = MyGMRep.MCPRIArray[i].PlayerUniqueID;
		}

		RootMC.SetInt("LightUPNumber", setTheNumber);
		ActionScriptVoid("root.LightUpIndicator");
	}
}	

/*
// Sets the position of AP button based on whos turn it is
//@TODO still being worked on, not finalized
*/
function setAPButtonPosition()
{
	local MCGameReplication MyGMRep;
	local int i;
	local int setTheNumber;
	local GFxObject ResetAPMC;
	local ASDisplayInfo ASDisplayInfo;

	ResetAPMC = RootMC.GetObject("resetapINS");
	ASDisplayInfo = ResetAPMC.GetDisplayInfo();

	// Get GameReplication
	MyGMRep = MCGameReplication(class'WorldInfo'.static.GetWorldInfo().GRI);

	for (i = 0; i < MyGMRep.MCPRIArray.Length ; i++)
	{
		// If My Rep char has my current Characters AP then set indicator
		if (MyGMRep.MCPRIArray[i].bHaveAp)
		{
			setTheNumber = MyGMRep.MCPRIArray[i].PlayerUniqueID;
		}
		/*
		// If The Player is number 1 then show his AP Reset Button
		if (MyGMRep.MCPRIArray[i].bHaveAp && MyGMRep.MCPRIArray[i].PlayerUniqueID == 1)
		{
			ASDisplayInfo.x = 5;
			ASDisplayInfo.y = 180;
			ResetAPMC.SetDisplayInfo(ASDisplayInfo);
		}else
		{
			// Otherwise hide it for player 2
			ResetAPMC.SetVisible(false);
			//break;
		}

		if (MyGMRep.MCPRIArray[i].bHaveAp && MyGMRep.MCPRIArray[i].PlayerUniqueID == 2)
		{
			ASDisplayInfo.x = 1158;
			ASDisplayInfo.y = 180;
			ResetAPMC.SetDisplayInfo(ASDisplayInfo);
		}else
		{
			ResetAPMC.SetVisible(false);
			//break;
		}
		*/

		RootMC.SetInt("LightUPNumber", setTheNumber);
		//ActionScriptVoid("root.SwitchAPResetButton");

		if (setTheNumber == 1) 
		{
			ASDisplayInfo.x = 5;
			ASDisplayInfo.y = 180;
			ResetAPMC.SetDisplayInfo(ASDisplayInfo);
			ResetAPMC.SetVisible(true);
		}else if (setTheNumber == 2)
		{
			// Otherwise hide it for player 2
			ResetAPMC.SetVisible(false);
			break;
		}

		if (setTheNumber == 2)
		{
			ASDisplayInfo.x = 1158;
			ASDisplayInfo.y = 180;
			ResetAPMC.SetDisplayInfo(ASDisplayInfo);
			ResetAPMC.SetVisible(true);
		}else if (setTheNumber == 1)
		{
			// Otherwise hide it for player 2
			ResetAPMC.SetVisible(false);
			break;
		}


	}



}	







/*
// Update function that will update player stats
*/
function GetPlayerInformation()
{
	local MCGameReplication MCGRep;
	local int i;


	// Get PlayerControoler
	MCPC = MCPlayerController(GetPC());
	// Get Pawn
	MCP = MCPawn(GetPC().Pawn);
	// Get GameReplication
	MCGRep = MCGameReplication(class'WorldInfo'.static.GetWorldInfo().GRI);



	// GameRound
	GameRoundTF = RootMC.GetObject("gameroundareaINS").GetObject("roundINS");
	if (GameRoundTF != none)
	{
		GameRoundTF.SetInt("text", MCGRep.GameRound);
	}
	// Players
	for (i = 0; i < MCGRep.MCPRIArray.Length ; i++)
	{

		// Player 1 Stats
		// if we have the same id then show our stuff
		// otherwise hide it for other player.
		P01areaMC = RootMC.GetObject("player01areaINS");
		if (P01areaMC != none && MCGRep.MCPRIArray[i].PlayerUniqueID == 1)
		{
			// Player 01 Name
			P01NameTF = P01areaMC.GetObject("playernameINS");
			if (P01NameTF != none)
			{
				P01NameTF.SetString("text", MCGRep.MCPRIArray[i].PawnName);
			}

			// Player 01 Health Text
			P01HPTextTF = P01areaMC.GetObject("healthbartextINS");
			if (P01HPTextTF != none && MCGRep.MCPRIArray[i].PlayerUniqueID == MCPC.PlayerUniqueID)
			{
				P01HPTextTF.SetInt("text", MCGRep.MCPRIArray[i].Health);
			}else
			{
				//P01HPTextTF.SetString("text", "");
				P01HPTextTF.SetVisible(false);
			}
			
			// Player 01 AP Text
			P01APareaMC = P01areaMC.GetObject("playerapareaINS");
			if (P01APareaMC != none)
			{
				// AP Number
				P01APNumbTF = P01APareaMC.GetObject("apINS");
				if (P01APNumbTF != none && MCGRep.MCPRIArray[i].PlayerUniqueID == MCPC.PlayerUniqueID)
				{
					P01APNumbTF.SetInt("text", MCGRep.MCPRIArray[i].APf);
				}else
				{
					//P01APNumbTF.SetString("text", "");
					P01APNumbTF.SetVisible(false);
				}

				// AP Text
				P01APTextTF = P01APareaMC.GetObject("aptextINS");
				if (P01APTextTF != none && MCGRep.MCPRIArray[i].PlayerUniqueID == MCPC.PlayerUniqueID)
				{
					//P01APTextTF.SetString("text", "AP");
				}else
				{
					P01APTextTF.SetString("text", "");
				}
			}
		}	

		// Player 2 Stats
		// if we have the same id then show our stuff
		// otherwise hide it for other player.
		P02areaMC = RootMC.GetObject("player02areaINS");
		if (P02areaMC != none && MCGRep.MCPRIArray[i].PlayerUniqueID == 2)
		{
			// Player 02 Name
			P02NameTF = P02areaMC.GetObject("playernameINS");
			if (P02NameTF != none)
			{
				P02NameTF.SetString("text", MCGRep.MCPRIArray[i].PawnName);
			}

			// Player 02 Health Text
			P02HPTextTF = P02areaMC.GetObject("healthbartextINS");
			if (P02HPTextTF != none && MCGRep.MCPRIArray[i].PlayerUniqueID == MCPC.PlayerUniqueID)
			{
				P02HPTextTF.SetInt("text", MCGRep.MCPRIArray[i].Health);
			}else
			{
				//P02HPTextTF.SetString("text", "");
				P02HPTextTF.SetVisible(false);
			}

			// Player 02 AP Text
			P02APareaMC = P02areaMC.GetObject("playerapareaINS");
			if (P02APareaMC != none)
			{
				// AP Number
				P02APNumbTF = P02APareaMC.GetObject("apINS");
				if (P02APNumbTF != none && MCGRep.MCPRIArray[i].PlayerUniqueID == MCPC.PlayerUniqueID)
				{
					P02APNumbTF.SetInt("text", MCGRep.MCPRIArray[i].APf);
				}else
				{
					//P02APNumbTF.SetString("text", "");
					P02APNumbTF.SetVisible(false);
				}

				// AP Text
				P02APTextTF = P02APareaMC.GetObject("aptextINS");
				if (P02APTextTF != none && MCGRep.MCPRIArray[i].PlayerUniqueID == MCPC.PlayerUniqueID)
				{
					//P02APTextTF.SetString("text", "AP");
				}else
				{
					P02APTextTF.SetString("text", "");
				}
			}
		}
	}



	// first page
//	TitleMC = RootMC.GetObject("test0101").GetObject("Title");
//	TitleMC.SetText(shopText[0]);
	// second page
	//RootMC.GotoAndStop("TimeShopText");
	//TitleMC = RootMC.GetObject("text_mc02").GetObject("TextFieldTitle");    
	//TitleMC.SetText(shopText[0]);
}















// Callback automatically called for each object in the movie with enableInitCallback enabled
event bool WidgetInitialized(name WidgetName, name WidgetPath, GFxObject Widget)
{
    // Determine which widget is being initialized and handle it accordingly
    switch(Widgetname)
    {
/*
        case 'InShop2':
            InShopButton = GFxCLIKWidget(Widget);
            InShopButton.SetString("label", menuButton[0]);
            //InShopButton.SetString("label", Localize("Hero", "Cathode", "UDKMOBA"));
            setSwitch = 0;
            InShopButton.AddEventListener('CLIK_click', GoToFrame);
    //CathodeBtn = GFxClikWidget(GetObject("cathodeBtn", class'GFxClikWidget'));
    //CathodeBtn.SetString("label", Localize("Hero", "Cathode", "UDKMOBA"));
	//CathodeBtn.AddEventListener('CLIK_buttonPress', OnCathodePress);

    //CathodeBtn.SetString("label", Localize("Hero", "Cathode", "UDKMOBA"));
	//Localize( string SectionName, string KeyName, string PackageName );
            break;

        case 'InShopReturn2':
            InShopReturnButton = GFxCLIKWidget(Widget);
            InShopReturnButton.SetString("label", menuButton[1]);
            setSwitch = 2;
            InShopReturnButton.AddEventListener('CLIK_click', GoToFrame);
            break;

        case 'InShopGo2':
            InShopGoButton = GFxCLIKWidget(Widget);
            InShopGoButton.SetString("label", menuButton[2]);
            setSwitch = 1;
            InShopGoButton.AddEventListener('CLIK_click', GoToFrame);
            break;
            
        case 'InShopReturnMain2':
            InShopReturnMainButton = GFxCLIKWidget(Widget);
            InShopReturnMainButton.SetString("label", menuButton[3]);
            setSwitch = 2;
            InShopReturnMainButton.AddEventListener('CLIK_click', GoToFrame);
            break;
*/
		case 'Earth01':
			`log("Earth01");
			break;
		case 'Earth02':
			`log("Earth02");
			break;
		case 'Earth03':
			`log("Earth03");
			break;
		case 'Earth04':
			`log("Earth04");
			break;

		case 'Fire01':
			`log("Fire01");
			break;
		case 'Fire02':
			`log("Fire02");
			break;
		case 'Fire03':
			`log("Fire03");
			break;
		case 'Fire04':
			`log("Fire04");
			break;










        default:
        	// Pass on if not a widget we are looking for
            return Super.WidgetInitialized(Widgetname, WidgetPath, Widget);
    }
    
    return false;
}





DefaultProperties
{
	// ScaleForm widgets being used for WidgetInitialized
	WidgetBindings.Add((WidgetName="InShop2",			WidgetClass=class'GFxCLIKWidget'))
	WidgetBindings.Add((WidgetName="InShopReturn2",		WidgetClass=class'GFxCLIKWidget'))
	WidgetBindings.Add((WidgetName="InShopGo2",			WidgetClass=class'GFxCLIKWidget'))
	WidgetBindings.Add((WidgetName="InShopReturnMain2",	WidgetClass=class'GFxCLIKWidget'))


	
    bDisplayWithHudOff=false
    TimingMode=TM_Game
    MovieInfo=SwfMovie'MystrasChampionFlash.Battle.BattleHUD'

	bPauseGameWhileActive=false
}
