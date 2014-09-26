//----------------------------------------------------------------------------
// GFxWTPlayerInfo
//
// Wizards Tower - Show info about weapons and stuff
//
// @fscommand - GoWizzardTower - back button
//
// Gustav Knutsson 2014-09-10
//----------------------------------------------------------------------------
class GFxWTPlayerInfo extends GFxMain;

// Button Clicks for Selecting
var GFxCLIKWidget wReturnButton;
var MCPlayerController MyPC;

// Wizzard MC
var GFxObject WizzardMC, WNameTitleMC, WAcademyTitleMC, WAbilityTitleMC, WExperienceTitleMC;
var GFxObject NameTextMC, AcademyTextMC, AbilityTextMC, ExperienceTextMC;
// Magic MC
var GFxObject MagicMC, MPointTitleMC, MSpellsTitleMC;
var GFxObject FireTextMC, IceTextMC, EarthTextMC, AcidTextMC, ThunderTextMC, Spell1TextMC, Spell2TextMC, Spell3TextMC, Spell4TextMC;
// Items MC
var GFxObject ItemsMC, IMoneyTitleMC, IWeaponTitleMC, IAccessoryTitleMC, IResearchTitleMC;
var GFxObject MoneyTextMC, WeaponTextMC, AccessoryTextMC, Research1TextMC;
// Buttons
var GFxObject TopLeftBtnMC, TopRightBtnMC;

// Weapon Shop
var archetype MCShop MCShopArche;
var MCItem_Weapon CurrentWeapon;
// Text Things
var localized string Titles[10];
var localized string SpellPoints[5];


function bool Start(optional bool StartPaused = false)
{
	super.Start();
	Advance(0.f);

	RootMC = GetVariableObject("root");

	MCP = MCPawn(GetPC().Pawn);
	MyPC= MCPlayerController(GetPC());
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
	// Text Information
	ConfigWizard();
	ConfigMagic();
	ConfigItem();


	bInitialized = true;
}

function ConfigWizard()
{
	WizzardMC = RootMC.GetObject("WizzardINS");
	if (WizzardMC != none)
	{
		// Titles

		WNameTitleMC = WizzardMC.GetObject("WNameTitleINS").GetObject("textField");
		WAcademyTitleMC = WizzardMC.GetObject("WAcademyTitleINS").GetObject("textField");
		WAbilityTitleMC = WizzardMC.GetObject("WAbilityTitleINS").GetObject("textField");
		WExperienceTitleMC = WizzardMC.GetObject("WExperienceTitleINS").GetObject("textField");

		// Texts
		NameTextMC = WizzardMC.GetObject("NameTextINS");
		AcademyTextMC = WizzardMC.GetObject("AcademyTextINS");
		AbilityTextMC = WizzardMC.GetObject("AbilityTextINS");
		ExperienceTextMC = WizzardMC.GetObject("ExperienceTextINS");
	}
}

function TickWizzard()
{
	if (WizzardMC != none && MyPC != none)
	{

		if (WNameTitleMC != none)
			WNameTitleMC.SetString("text", Titles[0]);
		if (WAcademyTitleMC != none)
			WAcademyTitleMC.SetString("text", Titles[1]);
		if (WAbilityTitleMC != none)
			WAbilityTitleMC.SetString("text", Titles[2]);
		if (WExperienceTitleMC != none)
			WExperienceTitleMC.SetString("text", Titles[3]);

		if (NameTextMC != none)
			NameTextMC.SetString("text", MyPC.PlayerEmpty.PawnName);
	//	if (AcademyTextMC != none)
	//		AcademyTextMC.SetString("text", MyPC.PlayerEmpty.PawnName);
	//	if (AbilityTextMC != none)
	//		AbilityTextMC.SetString("text", MyPC.PlayerEmpty.PawnName);
		if (ExperienceTextMC != none)
			ExperienceTextMC.SetInt("text", MyPC.PlayerEmpty.Experience);
	}
}

function ConfigMagic()
{
	MagicMC = RootMC.GetObject("MagicINS");
	if (MagicMC != none)
	{
/*
		// Titles
		MPointTitleMC = MagicMC.GetObject("MPointTitleINS").GetObject("textField");
		MSpellsTitleMC = MagicMC.GetObject("MSpellsTitleINS").GetObject("textField");
*/
		// Point Texts
		FireTextMC = MagicMC.GetObject("FireTextINS");
		IceTextMC = MagicMC.GetObject("IceTextINS");
		EarthTextMC = MagicMC.GetObject("EarthTextINS");
		AcidTextMC = MagicMC.GetObject("AcidTextINS");
		ThunderTextMC = MagicMC.GetObject("ThunderTextINS");

		// Spells Text
		Spell1TextMC = MagicMC.GetObject("Spell1TextINS");
		Spell2TextMC = MagicMC.GetObject("Spell2TextINS");
		Spell3TextMC = MagicMC.GetObject("Spell3TextINS");
		Spell4TextMC = MagicMC.GetObject("Spell4TextINS");
	}
}

function TickMagic()
{
	if (MagicMC != none && MyPC != none)
	{
/*
		// Titles
		if (MPointTitleMC != none)
			MPointTitleMC.SetString("text", Titles[4]);
		if (MSpellsTitleMC != none)
			MSpellsTitleMC.SetString("text", Titles[5]);
*/
		// Point Texts
		if (FireTextMC != none)
			FireTextMC.SetInt("text", MyPC.PlayerEmpty.FirePoints);
		if (IceTextMC != none)
			IceTextMC.SetInt("text", MyPC.PlayerEmpty.IcePoints);
		if (EarthTextMC != none)
			EarthTextMC.SetInt("text", MyPC.PlayerEmpty.EarthPoints);
		if (AcidTextMC != none)
			AcidTextMC.SetInt("text", MyPC.PlayerEmpty.AcidPoints);
		if (ThunderTextMC != none)
			ThunderTextMC.SetInt("text", MyPC.PlayerEmpty.ThunderPoints);

		// Spells Text
		if (Spell1TextMC != none && MyPC.MyArchetypeSpells[0] != none)
			Spell1TextMC.SetString("text", MyPC.MyArchetypeSpells[0].spellName);	// MyPC.MyArchetypeSpells[0].spellName[MyPC.MyArchetypeSpells[0].spellNumber]
		if (Spell2TextMC != none && MyPC.MyArchetypeSpells[1] != none)
			Spell2TextMC.SetString("text", MyPC.MyArchetypeSpells[1].spellName);	// MyPC.MyArchetypeSpells[1].spellName[MyPC.MyArchetypeSpells[1].spellNumber]
		if (Spell3TextMC != none && MyPC.MyArchetypeSpells[2] != none)
			Spell3TextMC.SetString("text", MyPC.MyArchetypeSpells[2].spellName);	// MyPC.MyArchetypeSpells[2].spellName[MyPC.MyArchetypeSpells[2].spellNumber]
		if (Spell4TextMC != none && MyPC.MyArchetypeSpells[3] != none)
			Spell4TextMC.SetString("text", MyPC.MyArchetypeSpells[3].spellName);	// MyPC.MyArchetypeSpells[3].spellName[MyPC.MyArchetypeSpells[3].spellNumber]
	}
}

function ConfigItem()
{
	ItemsMC = RootMC.GetObject("ItemsINS");
	if (ItemsMC != none)
	{
/*
		// Titles
		IMoneyTitleMC = ItemsMC.GetObject("IMoneyTitleINS").GetObject("textField");
		IWeaponTitleMC = ItemsMC.GetObject("IWeaponTitleINS").GetObject("textField");
		IAccessoryTitleMC = ItemsMC.GetObject("IAccessoryTitleINS").GetObject("textField");
		IResearchTitleMC = ItemsMC.GetObject("IResearchTitleINS").GetObject("textField");
*/
		// Texts
		MoneyTextMC = ItemsMC.GetObject("MoneyTextINS");
		WeaponTextMC = ItemsMC.GetObject("WeaponTextINS");
		AccessoryTextMC = ItemsMC.GetObject("AccessoryTextINS");
		Research1TextMC = ItemsMC.GetObject("Research1TextINS");
	}
}

function TickItems()
{
	local string EqWeapon;
	if (ItemsMC != none && MyPC != none && MCPawn(MyPC.Pawn) != none)
	{
/*
		// Titles
		if (IMoneyTitleMC != none)
			IMoneyTitleMC.SetString("text", Titles[6]);
		if (IWeaponTitleMC != none)
			IWeaponTitleMC.SetString("text", Titles[7]);
		if (IAccessoryTitleMC != none)
			IAccessoryTitleMC.SetString("text", Titles[8]);
		if (IResearchTitleMC != none)
			IResearchTitleMC.SetString("text", Titles[9]);
*/
		// Texts
		if (MoneyTextMC != none)
			MoneyTextMC.SetInt("text", MyPC.PlayerEmpty.Money);
		if (MCPawn(MyPC.Pawn) != none)
		{
			EqWeapon = GetCurrentWeapon(MCPawn(MyPC.Pawn));
			if (WeaponTextMC != none)
				WeaponTextMC.SetString("text", EqWeapon);
		}
	}
}

function string GetCurrentWeapon(MCPawn MyPawn)
{
	local int i;
	local int ItemNumber;

	// Find weapon
	for (i = 0; i < MyPawn.MyInventory.ConfigWeapons.Active.length ; i++)
	{
		if (MyPawn.MyInventory.ConfigWeapons.Active[i] == 1)
		{
			ItemNumber= MyPawn.MyInventory.ConfigWeapons.ItemNumber[i];
			break;
		}
	}
	
	// Add Item and return item
	for (i = 0; i < MCShopArche.AllWeapons.length; i++)
	{
		if (MCShopArche.AllWeapons[i].ID == ItemNumber)
		{
			CurrentWeapon = MCShopArche.AllWeapons[i];
			return CurrentWeapon.sItemName;
		}
	}

	return "";
}



/*
// Updates the The Hud the entire time
// @network                 Client
*/
function Tick(float DeltaTime)
{
	// Menu buttons
	TickWizzard();
	TickMagic();
	TickItems();

}

// Callback automatically called for each object in the movie with enableInitCallback enabled
event bool WidgetInitialized(name WidgetName, name WidgetPath, GFxObject Widget)
{
	// Determine which widget is being initialized and handle it accordingly
	switch(Widgetname)
	{
		case 'backButtonsIns':	// Ins name i flash
			wReturnButton = GFxCLIKWidget(Widget);
			// Set switch for next GoToFrame function
			wReturnButton.AddEventListener('CLIK_click', ReturnButton);
			break;
		default:
			break;
	}
	return true;
}

function ReturnButton(EventData data)
{
	
}


defaultproperties
{
	WidgetBindings.Add((WidgetName="backButtonsIns",    WidgetClass=class'GFxCLIKWidget'))

	MCShopArche = MCShop'MystrasChampionContent.TownShops.MCShop'

	bDisplayWithHudOff=false
	TimingMode=TM_Game
	MovieInfo=SwfMovie'MystrasChampionFlash.WizardsTower.WizzardInformation'
}