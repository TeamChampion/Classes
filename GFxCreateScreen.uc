class GFxCreateScreen extends GFxMain;

function bool Start(optional bool StartPaused = false)
{
    super.Start();
    Advance(0.f);

    RootMC = GetVariableObject("root");

    if (!bInitialized)
    {
        ConfigHUD();
    `log("-----------------------------------------------------------------------");
    `log("----------------------------GFxCreateScreen----------------------------");
    `log("-----------------------------------------------------------------------");
    }
    
    return true;
}

/*
// We start off by setting the initial settings
// @network                 Client
*/
function ConfigHUD()
{

    ConfigSelectMenu();
    bInitialized = true;
}

function ConfigSelectMenu()
{
    // Future settings
}

/*
// Function that Saves the character
// @param       GfXName         PlayerName
// @param       GfxAcademy      Academy
// @param       GfxFire         Fire Skill Points
// @param       GfxIce          Ice Skill Points
// @param       GfxEarth        Earth Skill Points
// @param       GfxPoison       Poison Skill Points
// @param       GfxThunder      Thunder Skill Points
// @param       GfxSpell01      First Spell
// @param       GfxSpell02      Second Spell
// @param       GfxSpell03      Third Spell
// @param       GfxSpell04      Forth Spell
*/
function SaveChar(string GfXName, int GfxAcademy, int GfxFire, int GfxIce, int GfxEarth, int GfxPoison, int GfxThunder, int GfxSpell01, int GfxSpell02, int GfxSpell03, int GfxSpell04)
{
    local MCHud MCHudAccess;

    MCHudAccess = MCHud(GetPC().MyHUD);

// Names & Schools
    MCHudAccess.CreateThisCharacter.PlayerName    = GfxName;
    MCHudAccess.CreateThisCharacter.PawnName      = GfxName;
//  MCHudAccess.CreateThisCharacter.School        = GfxAcademy;

// Skill Points
    MCHudAccess.CreateThisCharacter.FirePoints    =   GfxFire;
    MCHudAccess.CreateThisCharacter.IcePoints     =   GfxIce;
    MCHudAccess.CreateThisCharacter.EarthPoints   =   GfxEarth;
    MCHudAccess.CreateThisCharacter.PosionPoints  =   GfxPoison;
    MCHudAccess.CreateThisCharacter.ThunderPoints =   GfxThunder;
// Current Spells
    MCHudAccess.CreateThisCharacter.currentSpells01   = GfxSpell01;
    MCHudAccess.CreateThisCharacter.currentSpells02   = GfxSpell02;
    MCHudAccess.CreateThisCharacter.currentSpells03   = GfxSpell03;
    MCHudAccess.CreateThisCharacter.currentSpells04   = GfxSpell04;
// Set him Active so he spawns, save stats and remove his Hud character link
    MCHudAccess.CreateThisCharacter.bSetLevelLoadChar = true;
    MCHudAccess.CreateThisCharacter.SaveConfig();
    MCHudAccess.CreateThisCharacter = none;
}

DefaultProperties
{
    // Sets s that you can type names correctly
    bCaptureInput=true

    bDisplayWithHudOff=false
    TimingMode=TM_Game
	//MovieInfo=SwfMovie'UDNHud.array_test'
    MovieInfo=SwfMovie'MystrasChampionFlash.CreateCharacter.Create'
}
