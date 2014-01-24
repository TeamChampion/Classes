class MCProjectile extends UTProjectile;

/*
simulated event Touch (Actor Other, PrimitiveComponent OtherComp, Object.Vector HitLocation, Object.Vector HitNormal)
{
	`log( "touched" );
}
*/

DefaultProperties
{
	MaxEffectDistance=7000.0

	NetCullDistanceSquared=+144000000.0

	bCollideWorld=true
}