class GFxEnchantmentShop extends GFxMain;


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
    `log("------------------------------ Enchantment Shop");
    `log("-----------------------------------------------------------------------");
    
	SetUpInventory(MCP);
	return true;
}




DefaultProperties
{
    bDisplayWithHudOff=false
    TimingMode=TM_Game
	//MovieInfo=SwfMovie'UDNHud.array_test'
    MovieInfo=SwfMovie'MouseInterfaceContent.EnchantmentsShop'
}
