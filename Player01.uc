
//----------------------------------------------------------------------------
// Player01
//
// First Selectable Player and his stats
//
// Gustav Knutsson 2014-06-18
//----------------------------------------------------------------------------
class Player01 extends MCPawn;

//var(Inventory) array<MCInventory_Player01> MyInventory;

simulated event PostBeginPlay()
{
	`log("-------------------"); 
	`log("Player 01 is active");
	`log("PlayerName: "   @ PawnName); 
	`log("-------------------"); 
	/*
	`log("Spells"); 
	`log("-------------------"); 
	`log("Archetype spells 01" @ MyArchetypeSpells[0].spellNumber);
	`log("Archetype spells 02" @ MyArchetypeSpells[1].spellNumber);
	`log("Archetype spells 03" @ MyArchetypeSpells[2].spellNumber);
	`log("Archetype spells 04" @ MyArchetypeSpells[3].spellNumber);
	`log("-------------------"); 
	`log("FirePoints: "   @ FirePoints);
	`log("IcePoints: "   @ IcePoints);
	`log("EarthPoints: "   @ EarthPoints);
	`log("AcidPoints: "   @ AcidPoints);
	`log("ThunderPoints: "   @ ThunderPoints);
	`log("-------------------"); 
	`log("currentSpells01: "   @ currentSpells01);
	`log("currentSpells02: "   @ currentSpells02);
	`log("currentSpells03: "   @ currentSpells03);
	`log("currentSpells04: "   @ currentSpells04);
	`log("-------------------"); 
	*/

	super.PostBeginPlay();
}

defaultproperties
{
	MyInventory = MCInventory_Player01'mystraschampionsettings.Character.P01_Inventory'
	Health=100 // Bots HP
//	Name=Player01_Pawn
}