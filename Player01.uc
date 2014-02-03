class Player01 extends MCPawn;

simulated event PostBeginPlay()
{
  `log("Player 01 is active");
  `log(" --------------------------------------------------------- Player 01 is active");
/*
  `log("Player 01 Current stats"); 

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
*/
}

defaultproperties
{
   Health=100 // Bots HP
   Name=Player01_Pawn

  MySpells[0] = "kaleidoscope"
  MySpells[1] = "firefan"
  MySpells[2] = "fireball"
  MySpells[3] = "firefountain"

  MyDynamicSpells[0] = "kaleidoscope"
  MyDynamicSpells[1] = "firefan"
  MyDynamicSpells[2] = "fireball"
  MyDynamicSpells[3] = "firefountain"
}