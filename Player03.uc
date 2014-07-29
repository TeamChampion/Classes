//----------------------------------------------------------------------------
// Player03
//
// Third Selectable Player and his stats
//
// Gustav Knutsson 2014-06-18
//----------------------------------------------------------------------------
class Player03 extends MCPawn;

//var(Inventory) array<MCInventory_Player03> MyInventory;

simulated event PostBeginPlay()
{
	`log("-------------------"); 
	`log("Player 03 is active");
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
	*/
	super.PostBeginPlay();
}

defaultproperties
{
	MyInventory = MCInventory_Player03'mystraschampionsettings.Character.P03_Inventory'
	Health=100 // Bots HP
//	Name=Player03_Pawn
}