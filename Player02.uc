class Player02 extends MCPawn;

simulated event PostBeginPlay()
{
  `log("Player 02 is active");

  `log("Player 02 Current stats"); 

  `log("PlayerName: "   @ PlayerName); 
  `log("PawnName: "     @ PawnName); 
  //`log("School: "       @ School); 
  `log("FirePoints: "   @ FirePoints); 
  `log("IcePoints: "    @ IcePoints); 
  `log("EarthPoints: "  @ EarthPoints); 
  `log("PosionPoints: " @ PosionPoints); 
  `log("ThunderPoints: " @ ThunderPoints); 

  `log("         -------------------          "); 

  `log("currentSpells01: " @ currentSpells01); 
  `log("currentSpells02: " @ currentSpells02); 
  `log("currentSpells03: " @ currentSpells03); 
  `log("currentSpells04: " @ currentSpells04); 
}

defaultproperties
{
   Health=100 // Bots HP
   Name=Player01_Pawn

  MySpells[0] = "stonewall"
  MySpells[1] = "rockandroll"
  MySpells[2] = "rockfang"
  MySpells[3] = "unearthmaterial"

  MyDynamicSpells[0] = "stonewall"
  MyDynamicSpells[1] = "rockandroll"
  MyDynamicSpells[2] = "rockfang"
  MyDynamicSpells[3] = "unearthmaterial"

}