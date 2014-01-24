class MCTrigger extends Trigger
	hidecategories(Display, Attachment, Collision, Physics, Advanced, Debug, Mobile);

var float TriggerCost;

simulated event PostBeginPlay()
{
    `log("Mystras Champion Trigger spawned");
}

event Touch(Actor Other, PrimitiveComponent OtherComp, vector HitLocation, vector HitNormal)
{
	local MCPawn Pa;

	Pa = MCPawn(Other);
	//Pa.GetALocalPlayerController.CheckAP();

	`log("FIND ME!!!!!!----------------------------------------");
	if (Pa != none && Other.IsA('MCPawn'))
	{
		`log("He touches");
		Pa.TouchedATileWithCost(TriggerCost);
	}
}


defaultproperties
{
	TriggerCost = 0.f
}