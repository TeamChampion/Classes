//----------------------------------------------------------------------------
// Player04
//
// Forth Selectable Player and his stats
//
// Gustav Knutsson 2014-06-18
//----------------------------------------------------------------------------
class Player04 extends MCPawn;

//
simulated event PostBeginPlay()
{
	`log("-------------------"); 
	`log("Player 04 is active");
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
	MyInventory = MCInventory_Player04'mystraschampionsettings.Character.P04_Inventory'
	Health=100 // Bots HP
//	Name=Player04_Pawn
}