//=============================================================================
// H7AiSensorHeroCount
//=============================================================================
// 
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7AiSensorHeroCount extends H7AiSensorBase;

/// overrides ...

function float GetValue1( H7AiSensorParam param0  )
{
	local H7Player currentPlayer;
	local array<H7AdventureHero> playerHeroes;
	local float numHeroes;
	local H7AdventureHero hero;

	if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;

	if( param0.GetPType() == SP_PLAYER )
	{
		currentPlayer = param0.GetPlayer();
		if( currentPlayer == None )
		{
			// bad parameter
			return 0.0f;
		}
		playerHeroes = currentPlayer.GetHeroes();
		numHeroes = 0.0f;
		foreach playerHeroes(hero)
		{
			if(hero!=None && hero.IsHero()==true && hero.IsDead()==false)
			{
				numHeroes+=1.0f;
			}
		}
		
		if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
		return numHeroes;
	}
	// wrong parameter types
	return 0.0f;
}
