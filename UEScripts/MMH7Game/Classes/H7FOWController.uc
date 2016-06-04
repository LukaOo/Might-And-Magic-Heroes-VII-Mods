//=============================================================================
// H7FOWController
//=============================================================================
//
// Controller that handles fog of war logic for all players. Also governs the
// fog actors responsible for the visual representation of the fog.
//
//=============================================================================
// Copyright 2013 Limbic Entertainment All Rights Reserved.
//=============================================================================

class H7FOWController extends Actor
	implements( SaveGameStateInterface )
	native
	config(game)
	savegame;

var protected config bool cUseTrueFogOfWar;

var protected savegame array<PlayerFogInfo>     mPlayerFogInfos;
var protected savegame PlayerFogInfo            mNextPlayerInfo;
var protected RenderTargetMaterialEffect        mFOWPPBlur;
var protected MaterialEffect                    mFOWPP;
var protected MaterialInstanceConstant          mFOWPPBlurMat;
var protected MaterialInstanceConstant          mFOWPPMat;
var protected savegame int						mCellCount;
var protected savegame int						mCellSize;
var protected savegame int						mGridIndex;
var protected native H7AdventureGridManager     mGridManager;
var protected savegame bool						mPlayerChanged;
var protected savegame int						mCurrentPlayerNumber;


// for fog smoothing
var protected savegame float					mBufferingDelta;
var protected savegame float					mBlendingTime;
var protected savegame bool						mIsLerpingUp;
var protected savegame bool						mNeedsLerp;

// rendering variables
var transient protected Texture2DDynamic mDynamicFogTexture;
var protected array<byte> mPixelData;

var protected transient bool mRefreshMe;

// fog size variables
var protected savegame int mNumOfTilesX, mNumOfTilesY;

// for scripting
var protected H7PlayerEventParam mPlayerEventParam;

var protected bool				                mLoadGameKeepAlive;


var protected PostProcessChain                  mPostProcessFOW;

function bool IsMarkedForDeletion() { return !mLoadGameKeepAlive; }
function MarkForDeletion(bool val) { mLoadGameKeepAlive = !val; }

function int                        GetGridSizeX()                                                 { return mNumOfTilesX; }
function int                        GetGridSizeY()                                                 { return mNumOfTilesY; }
function int                        GetGridIndex()                                                 { return mGridIndex; }
function                            ResetHandledTiles( int dasPlayer )                              
{ 
	if( GetPlayerFogInfoIndexByPlayer( dasPlayer ) == INDEX_NONE ) 
	{ 
		return; 
	} 
	mPlayerFogInfos[GetPlayerFogInfoIndexByPlayer( dasPlayer )].handledTiles.Length = 0; 
}

function MaterialInstanceConstant   GetFogMaterial()                                               { return mFOWPPMat; }
function array<int>                 GetExploredTilesForPlayer( int playerId )                       
{ 
	local array<int> empty;
	if( GetPlayerFogInfoIndexByPlayer( playerId ) == INDEX_NONE ) 
	{ 
		empty = empty;
		return empty; 
	} 
	return mPlayerFogInfos[GetPlayerFogInfoIndexByPlayer( playerId )].exploredTiles;
}

native function int GetPlayerFogInfoIndexByPlayer( int playerNumber );

function OverrideNextPlayer( EPlayerNumber playerNumber )
{
	if( GetPlayerFogInfoIndexByPlayer( playerNumber ) == INDEX_NONE ) { return; }
	mNextPlayerInfo = mPlayerFogInfos[ GetPlayerFogInfoIndexByPlayer( playerNumber ) ];
	mPlayerFogInfos[ GetPlayerFogInfoIndexByPlayer( playerNumber ) ] = mPlayerFogInfos[ 0 ];
	ExploreFog();
}

function RestoreNextPlayer()
{
	if( GetPlayerFogInfoIndexByPlayer( mCurrentPlayerNumber ) == INDEX_NONE ) { return; }
	mPlayerFogInfos[ GetPlayerFogInfoIndexByPlayer( mCurrentPlayerNumber ) ] = mNextPlayerInfo;
	ExploreFog();
}

function native int GetNumberOfExploredTilesFor( int dasPlayer );

/**
 * Checks if a tile is already in the explored tile list, 
 * returns true if yes, false if no.
 * 
 * @param playerNumber  Which player's vision is being checked
 * @param point         Which location is being checked
 * 
 * */ 
function native bool CheckExploredTile( int playerNumber, IntPoint point );

function native bool HandleExploredTiles( int playerNumber, array<IntPoint> exploredPoints, optional bool init = false, optional bool cover = false );

function native RevealFog();

/**
 * Gets foliage at a cell by IntPoint.
 * 
 * @param cell     Which cell on the grid is being checked.
 * 
 * */ 
function native array<PrimitiveComponent> GetPrimitivesAtCell( H7AdventureMapCell cell );

function native array<PrimitiveComponent> GetIntersectingPrimitivesByBox( Box Boxer );

public function Texture2DDynamic    GetFogTexture()             { return mDynamicFogTexture; }

function Init( int gridIndex, optional bool fromSave )
{
	local int i, numOfPlayers;
	local LinearColor newOffset;
	local array<H7Player> players;
	local PostProcessChain playerPostProcess;

	mPlayerEventParam = new class'H7PlayerEventParam';

	mPlayerChanged = true;

	mCellSize = class'H7BaseCell'.const.CELL_SIZE;

	players = class'H7AdventureController'.static.GetInstance().GetPlayers();
	numOfPlayers = players.Length;
	mGridIndex = gridIndex;

	mGridManager = class'H7AdventureGridManager'.static.GetInstance();
	mGridManager.mGridList[ mGridIndex ].SetFogOfWarController( self );

	mNumOfTilesX = mGridManager.mGridList[ mGridIndex ].GetGridSizeX();
	mNumOfTilesY = mGridManager.mGridList[ mGridIndex ].GetGridSizeY();

	mCellCount = mNumOfTilesX * mNumOfTilesY;

	mDynamicFogTexture = class'Texture2DDynamic'.static.Create( mNumOfTilesX, mNumOfTilesY );
	mDynamicFogTexture.Filter = TF_Linear;
	mDynamicFogTexture.SRGB = false;

	mPixelData.Add( mCellCount * 4 );

	playerPostProcess = LocalPlayer(class'H7PlayerController'.static.GetPlayerController().Player).PlayerPostProcess;

	// initialize the new PostProcess fog of war
	mFOWPPBlur = RenderTargetMaterialEffect(playerPostProcess.FindPostProcessEffect('PPFoWBlur'));

	if (mFOWPPBlur != None)
	{
		mFOWPPBlurMat = new class'MaterialInstanceConstant';
		mFOWPPBlurMat.SetParent(mFOWPPBlur.ProcessMaterial);
		mFOWPPBlurMat.SetScalarParameterValue( 'GridNumCellsX',  GetGridSizeX() );
		mFOWPPBlurMat.SetScalarParameterValue( 'GridNumCellsY',  GetGridSizeY() );
		mFOWPPBlurMat.SetTextureParameterValue( 'CanvasTexture', mDynamicFogTexture );

		mFOWPPBlur.ProcessMaterial = mFOWPPBlurMat;
	}
	else
	{
		;
		class'H7MessageSystem'.static.GetInstance().CreateAndSendMessage("FOW PostProcess Blur not found",MD_QA_LOG);;
	}

	mFOWPP = MaterialEffect(playerPostProcess.FindPostProcessEffect('PPFoW'));

	if (mFOWPP != None)
	{
		mFOWPPMat = new( playerPostProcess ) class'MaterialInstanceConstant';
		mFOWPPMat.SetParent(mFOWPP.Material);
		mFOWPPMat.SetScalarParameterValue( 'GridNumCellsX',  GetGridSizeX() );
		mFOWPPMat.SetScalarParameterValue( 'GridNumCellsY',  GetGridSizeY() );
		newOffset.R = class'H7AdventureGridManager'.static.GetInstance().mGridList[ GetGridIndex() ].Location.X;
		newOffset.G = class'H7AdventureGridManager'.static.GetInstance().mGridList[ GetGridIndex() ].Location.Y;
		mFOWPPMat.SetVectorParameterValue( 'GridWorldPos', newOffset );

		mFOWPP.Material = mFOWPPMat;
	}
	else
	{
		;
		class'H7MessageSystem'.static.GetInstance().CreateAndSendMessage("FOW PostProcess not found",MD_QA_LOG);;
	}

	// initialize a PlayerFogInfo struct for each player
	if( !fromSave )
	{
		mPlayerFogInfos.Add( numOfPlayers );
		for( i = 0; i < mPlayerFogInfos.Length; ++i )
		{
			mPlayerFogInfos[i].exploredTiles.Add( mCellCount );	
			mPlayerFogInfos[i].visibleTiles.Add( mCellCount );
			mPlayerFogInfos[i].PlayerNumber = players[i].GetPlayerNumber();
			HandleExploredTiles( mPlayerFogInfos[i].PlayerNumber, mGridManager.mGridList[ mGridIndex ].GetUnFoggedTiles(), true );
		}

		// explore tiles at every army start location
		HandleInitSightRadius();
	}
	

	for( i = 0; i < mPlayerFogInfos.Length; ++i )
	{
		ResetHandledTiles( mPlayerFogInfos[i].PlayerNumber );
	}

	mIsLerpingUp = true;

	if( !fromSave )
	{
		ExploreFog();
	}
}

native function HandleInitSightRadius();

simulated event Destroyed()
{
	mDynamicFogTexture = none;
	mFOWPPBlur = none;
	mFOWPP = none;
	mFOWPPBlurMat = none;
	mFOWPPMat = none;

	super.Destroyed();
}

native function UpdateDrawing();

native function UpdateFog( array<int> handledTiles, optional bool cover );

native function ComputeAll();

native function UpdateFogVisibility();

event Native_ExploreFog() // used to bridge native to uc
{
	ExploreFog();
}

native function ExploreFogNative( optional bool cover = false );

function ExploreFog( optional bool cover = false )
{ 
	if( class'H7AdventureController'.static.GetInstance().GetGridController().GetCurrentGrid().GetIndex() == mGridIndex )
	{
		ExploreFogNative( cover );

		if( class'H7PlayerController'.static.GetPlayerController().GetAdventureHud() != none )
		{
			class'H7AdventureHudCntl'.static.GetInstance().GetMinimap().Update();
		}
	}
}

function Tick( float DeltaTime )
{
	super.Tick( DeltaTime );

	if( mNeedsLerp )
	{
		// SMOOTHING LOGIC START
		// Lerp from 0 -> 1 or 1 -> 0 based on which texture is currently used in the Post-Process
		if( mBufferingDelta < 1.0f && mIsLerpingUp && mNeedsLerp )
		{
			mBlendingTime += DeltaTime;
			mBufferingDelta = FClamp( Lerp( 0.0f, 1.0f, mBlendingTime * class'H7ReplicationInfo'.static.GetInstance().GetGameSpeed() ), 0.0f, 1.0f );
		}
		else if( mBufferingDelta > 0.0f && !mIsLerpingUp && mNeedsLerp )
		{
			mBlendingTime += DeltaTime;
			mBufferingDelta = FClamp( Lerp( 1.0f, 0.0f, mBlendingTime * class'H7ReplicationInfo'.static.GetInstance().GetGameSpeed() ), 0.0f, 1.0f );
		}

		if( mBufferingDelta == 1.0f )
		{
			mIsLerpingUp = false;
			mNeedsLerp = false;
			mBlendingTime = 0;
			ComputeAll();
		}
		if( mBufferingDelta == 0.0f )
		{
			mIsLerpingUp = true;
			mNeedsLerp = false;
			mBlendingTime = 0;
			ComputeAll();
		}
		// SMOOTHING LOGIC END

		if( mFOWPPBlurMat != none )
		{
			mFOWPPBlurMat.SetScalarParameterValue( 'BufferingDelta', mBufferingDelta );
		}
		if( mFOWPPMat != none )
		{
			mFOWPPMat.SetScalarParameterValue( 'BufferingDelta', mBufferingDelta );
		}
	}

	if(mRefreshMe)
	{
		ExploreFog();
		mRefreshMe = false;
	}
}

/**
 * Serializes the actor's data into JSon
 *
 * @return    JSon data representing the state of this actor
 */
function String Serialize()
{
	local JSonObject JSonObject;
	local int i, j;
	local string fogString;
	local array<int> fogInfoArray;
	
	// Instance the JSonObject, abort if one could not be created
	JSonObject = new () class'JSonObject';
	if (JSonObject == None)
	{
		;
		return "";
	}

	// Serialize the path name so that it can be looked up later
	JSonObject.SetStringValue("Name", PathName(Self));

	// Serialize the object archetype, in case this needs to be spawned
	JSonObject.SetStringValue("ObjectArchetype", PathName(ObjectArchetype));

	// Save the Fog Info arrays
	for( i = 0; i < mPlayerFogInfos.Length; ++i )
	{
		GetFogInfoArray( i, fogInfoArray );

		foreach fogInfoArray( j )
		{
			fogString = fogString @ j;
		}
		
		JSonObject.SetStringValue( "P"$i, fogString );
		fogString = "";
	}

	JSonObject.SetIntValue( "index", mGridIndex );

	// Send the encoded JSonObject
	return class'JSonObject'.static.EncodeJson(JSonObject);
}

native function GetFogInfoArray( int playerIndex, out array<int> outArray );

/**
 * Deserializes the actor from the data given
 *
 * @param    Data    JSon data representing the differential state of this actor
 */
function Deserialize(JSonObject Data)
{
	mGridIndex = Data.GetIntValue( "index" );
}


event PostSerialize()
{
	Init( mGridIndex, true );
	if( mGridIndex == mGridManager.GetCurrentGridIndex() )
	{
		mPlayerChanged = true; // force the showing of the new player fog info
		mRefreshMe = true;
	}
}
/**
 * Deserializes the references of the actor from the data given
 *
 * @param		Data		JSon data representing the differential state of this actor
 * @param		saveGame	SaveGameState used to search actors by id
*/
function DeserializeReferences(JSonObject Data, SaveGameState saveGame)
{
	local string fogString;
	local int i, j, k, l, kounter;
	local array<string> pieces;
	local int current;
	local string checksum;

	// this needs to be done here and not in the Deserialize because we need to be sure that all the armies are already created
	Init( mGridIndex );

	for( i = 0; i < mPlayerFogInfos.Length; ++i )
	{
		fogString = Data.GetStringValue( "P"$i );
		ParseStringIntoArray( fogString, pieces, " ", false );
		current = int( pieces[0] );
		
		kounter = 0;
		for( l = 1; l < pieces.Length; ++l )
		{
			j = int( pieces[ l ] );
			
			checksum = checksum @ j;
			for( k = 0; k < j; ++k )
			{
				mPlayerFogInfos[i].exploredTiles[kounter++] = current == 0 ? 1 : 0;
			}
			if( current == 0 )
			{
				current = 1;
			}
			else
			{
				current = 0;
			}
			
		}
		
		
		checksum = "";
		
	}

	mCurrentPlayerNumber = INDEX_NONE; // force the showing of the new player fog info
	ExploreFog();
}

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

