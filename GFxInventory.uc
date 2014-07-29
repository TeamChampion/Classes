//----------------------------------------------------------------------------
// GFxInventory
//
// Open Used to setup your Inventory of items
//
// Gustav Knutsson 2014-06-18
//----------------------------------------------------------------------------
class GFxInventory extends GFxMain;

function Init(optional LocalPlayer LocalPlayer)
{
	// Initialize the ScaleForm movie
	Super.Init(LocalPlayer);
	Start();
    Advance(0.f);
}

function bool Start(optional bool StartPaused = false)
{
    super.Start();
    Advance(0.f);

    `log("-----------------------------------------------------------------------");
    `log("------------------------------inventory--------------------------------");
    `log("-----------------------------------------------------------------------");
    
//	SetUpInventory(MCP);
	return true;
}

DefaultProperties
{
	bDisplayWithHudOff=false
	TimingMode=TM_Game
//	MovieInfo=SwfMovie'MystrasChampionFlash.shops.ShopWeapon'
}