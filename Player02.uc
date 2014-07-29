//----------------------------------------------------------------------------
// Player02
//
// Second Selectable Player and his stats
//
// Gustav Knutsson 2014-06-18
//----------------------------------------------------------------------------
class Player02 extends MCPawn;

//var(Inventory) array<MCInventory_Player02> MyInventory;

simulated event PostBeginPlay()
{
	`log("-------------------"); 
	`log("Player 02 is active");
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
	MyInventory = MCInventory_Player02'mystraschampionsettings.Character.P02_Inventory'
	Health=100 // Bots HP
//	Name=Player02_Pawn
}