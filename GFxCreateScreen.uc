//----------------------------------------------------------------------------
// GFxCreateScreen
//
// Create Character Movie, saves a new character information and stores it in
// MCPawn config file
// @TODO add buttons to go back & finish character
//
// Gustav Knutsson 2014-06-18
//----------------------------------------------------------------------------
class GFxCreateScreen extends GFxMain;

var archetype MCSpellArchetypeList SpellList;

function bool Start(optional bool StartPaused = false)
{
	super.Start();
	Advance(0.0f);

	RootMC = GetVariableObject("root");

	if (!bInitialized)
	{
		ConfigHUD();
	}

	return true;
}

/*
// We start off by setting the initial settings
*/
function ConfigHUD()
{
	bInitialized = true;
}

/*
// Function that Saves the character
// @param	GfXName			PlayerName
// @param	GfxAcademy		Academy
// @param	GfxFire			Fire Skill Points
// @param	GfxIce			Ice Skill Points
// @param	GfxEarth		Earth Skill Points
// @param	GfxPoison		Poison Skill Points
// @param	GfxThunder		Thunder Skill Points
// @param	GfxSpell01		First Spell
// @param	GfxSpell02		Second Spell
// @param	GfxSpell03		Third Spell
// @param	GfxSpell04		Forth Spell
*/
function SaveChar(string GfXName, int GfxAcademy, int GfxFire, int GfxIce, int GfxEarth, int GfxPoison, int GfxThunder, int GfxSpell01, int GfxSpell02, int GfxSpell03, int GfxSpell04)
{
	local MCHud cMCHud;
	local MCPlayerController cMyPC;

	cMCHud = MCHud(GetPC().MyHUD);
	cMyPC = MCPlayerController(GetPC());

	// Names & Schools
	cMCHud.CreateThisCharacter.PawnName = GfxName;
	`log("CreateThisCharacter=" @ cMCHud.CreateThisCharacter.name @ "or" @ cMCHud.CreateThisCharacter.class @ "or" @ cMCHud.CreateThisCharacter);

//	cMyPC.PlayerStruct01.PawnName = GfxName;
//	cMCHud.CreateThisCharacter.School = GfxAcademy;

	// Skill Points
	cMCHud.CreateThisCharacter.FirePoints = GfxFire;
	cMCHud.CreateThisCharacter.IcePoints = GfxIce;
	cMCHud.CreateThisCharacter.EarthPoints = GfxEarth;
	cMCHud.CreateThisCharacter.PosionPoints = GfxPoison;
	cMCHud.CreateThisCharacter.ThunderPoints = GfxThunder;

	// Current Spells
	cMCHud.CreateThisCharacter.currentSpells01 = GfxSpell01;
	cMCHud.CreateThisCharacter.currentSpells02 = GfxSpell02;
	cMCHud.CreateThisCharacter.currentSpells03 = GfxSpell03;
	cMCHud.CreateThisCharacter.currentSpells04 = GfxSpell04;

	// Add spells
	GetSpellArchetype(GfxSpell01, 0);
	GetSpellArchetype(GfxSpell02, 1);
	GetSpellArchetype(GfxSpell03, 2);
	GetSpellArchetype(GfxSpell04, 3);

	// Set him Active so he spawns, save stats and remove his Hud character link
	cMCHud.CreateThisCharacter.bSetLevelLoadChar = true;
	cMCHud.CreateThisCharacter.SaveConfig();

	// Add character to him as well
	//

	if(cMCHud.CreateThisCharacter.name == 'P01')
	{
		cMyPC.PlayerStruct01.PawnName = GfxName;
		cMyPC.PlayerStruct01.FirePoints = GfxFire;
		cMyPC.PlayerStruct01.IcePoints = GfxIce;
		cMyPC.PlayerStruct01.EarthPoints = GfxEarth;
		cMyPC.PlayerStruct01.PosionPoints = GfxPoison;
		cMyPC.PlayerStruct01.ThunderPoints = GfxThunder;

		cMyPC.PlayerStruct01.currentSpells01 = GfxSpell01;
		cMyPC.PlayerStruct01.currentSpells02 = GfxSpell02;
		cMyPC.PlayerStruct01.currentSpells03 = GfxSpell03;
		cMyPC.PlayerStruct01.currentSpells04 = GfxSpell04;

		cMyPC.SaveConfig();
	}
	else if(cMCHud.CreateThisCharacter.name == 'P02')
	{
		cMyPC.PlayerStruct02.PawnName = GfxName;
		cMyPC.PlayerStruct02.FirePoints = GfxFire;
		cMyPC.PlayerStruct02.IcePoints = GfxIce;
		cMyPC.PlayerStruct02.EarthPoints = GfxEarth;
		cMyPC.PlayerStruct02.PosionPoints = GfxPoison;
		cMyPC.PlayerStruct02.ThunderPoints = GfxThunder;

		cMyPC.PlayerStruct02.currentSpells01 = GfxSpell01;
		cMyPC.PlayerStruct02.currentSpells02 = GfxSpell02;
		cMyPC.PlayerStruct02.currentSpells03 = GfxSpell03;
		cMyPC.PlayerStruct02.currentSpells04 = GfxSpell04;

		cMyPC.SaveConfig();
	}
	else if(cMCHud.CreateThisCharacter.name == 'P03')
	{
		
	}
	else if(cMCHud.CreateThisCharacter.name == 'P04')
	{
		
	}





	// Set HUD archetype to null
	cMCHud.CreateThisCharacter = none;
}

/*
// Sets Spell Data for Character, also MCPawn has this called AddSpells
// @param	SpellNumber		What Spell we add
// @param	SpellSlot		What Slot we add it to
*/
function GetSpellArchetype(int SpellNumber, int SpellSlot)
{
	local MCSpell SpellName;
	local MCHud cMCHud;
	cMCHud = MCHud(GetPC().MyHUD);

	// Search for Spells in List we have in an Archetype
	foreach SpellList.AllArchetypeSpells(SpellName)
	{
		// If searched result is the same as created spell, save it in the character
		if (SpellName.spellNumber == SpellNumber)
		{
			cMCHud.CreateThisCharacter.MyArchetypeSpells[SpellSlot] = SpellName;
		}
	}
}

defaultproperties
{
	SpellList = MCSpellArchetypeList'MystrasChampionSpells.SpellList.AllArchetypeSpells'

	// Sets s that you can type names correctly
	bCaptureInput=true
	bDisplayWithHudOff=false
	TimingMode=TM_Game

	MovieInfo=SwfMovie'MystrasChampionFlash.CreateCharacter.Create'
}