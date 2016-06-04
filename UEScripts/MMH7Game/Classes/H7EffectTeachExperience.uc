//=============================================================================
// H7EffectTeachExperience
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7EffectTeachExperience extends Object 
	implements( H7IEffectDelegate )
	hidecategories(Object)
	native(Tussi);


var(Experience) protected int mExperienceCap<DisplayName=% of our XP to which a friendly hero can be raised|ClampMin=1|ClampMax=100>;

function Initialize( H7Effect effect ) {}

function Execute( H7Effect effect, H7EventContainerStruct container, optional bool isSimulated = false )
{
	local H7ICaster caster; 
	local array<H7IEffectTargetable>  targets, validTargets;
	local H7IEffectTargetable target, abilityTarget;
	local H7AdventureHero hero;
	local int experienceDifference;
	local string fctMessage;

	if( isSimulated ) return;

	caster = effect.GetSource().GetCaster().GetOriginal();
	abilityTarget = container.Targetable;
	targets = container.TargetableTargets;
	if( targets.Find( abilityTarget ) == INDEX_NONE )
	{
		targets.AddItem( abilityTarget );
	}

	if( targets.Length <= 0 ) 
	{
		return; 
	}
   
	effect.GetValidTargets( targets, validTargets );
	targets = validTargets;
	if( caster != none )
	{
		foreach targets( target )
		{
			hero = H7AdventureHero( target );
			if( hero != none && hero.IsHero() )
			{
				experienceDifference = H7AdventureHero( caster ).GetExperiencePoints() * mExperienceCap / 100 - hero.GetExperiencePoints();
				if( experienceDifference > 0 )
				{ 	
					fctMessage = class'H7Loca'.static.LocalizeSave("FCT_EXPIERENCE_FROM","H7FCT");
					fctMessage = Repl(fctMessage, "%owner", hero.GetName() );
					fctMessage = Repl(fctMessage, "%value", experienceDifference );
					fctMessage = Repl(fctMessage, "%target", caster.GetName() );
					class'H7FCTController'.static.GetInstance().StartFCT( FCT_XP, hero.Location, hero.GetPlayer(), fctMessage,MakeColor(0,255,0,255));
					hero.AddXp( experienceDifference );
				}
			}
		}
	}
}


function String GetTooltipReplacement() 
{
	local string ttMessage;
	ttMessage = class'H7Loca'.static.LocalizeSave("TTR_XP_CAP","H7TooltipReplacement");
	ttMessage = Repl(ttMessage, "%XPcap", mExperienceCap);

	return ttMessage;
}

function string GetDefaultString()
{
	return string(mExperienceCap);
}
