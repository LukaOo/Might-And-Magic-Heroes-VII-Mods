//=============================================================================
// H7EvokeFX
//=============================================================================
// 
//=============================================================================
// Copyright 1998-2013 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7EvokeFX extends Actor
	hideCategories(Object, Movement, Display, Attachment, Collision, Physics, Advanced, Debug, Mobile);

var(FX) protected AKEvent mParticleSound<DisplayName=Particle Sound>;
var(FX) protected ParticleSystem mParticleFX<DisplayName=Particle FX>;

function SpawnEffect( vector target )
{
	local ParticleSystemComponent partSystem;

    if( mParticleFX != None )
	{			
		partSystem = WorldInfo.MyEmitterPool.SpawnEmitter(mParticleFX, target);
		partSystem.CustomTimeDilation = class'H7ReplicationInfo'.static.GetInstance().GetGameSpeed();
		class'H7CombatMapGridController'.static.GetInstance().AddParticleSystemToMonitorList( partSystem );
	}			

	if( mParticleSound != None && !class'H7SpectatorHUDCntl'.static.GetInstance().GetPopup().IsVisible())
	{
		class'H7SoundManager'.static.PlayAkEventOnActor( self, mParticleSound,true,true, self.Location );
	}
}
