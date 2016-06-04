//=============================================================================
// H7MeshBeaconClient
//
// This class is used to connect to a host mesh beacon in order to 
// establish a connected mesh network.
//
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7MeshBeaconClient extends MeshBeaconClient;

var protected int mPing;
var protected float mTimeRequestConnectionStarted;

function int GetPing() { return mPing == -1 ? 999 : mPing; }
function bool IsServerReachable() { return mPing != -1; }

function InitMeshBeaconClient( OnlineGameSearchResult DesiredHost )
{
	local ClientConnectionRequest clientConnection;

	UDP_Socket = true;
	HeartbeatTimeout = 5.f;
	SocketSendBufferSize = 4096;
	SocketReceiveBufferSize = 4096;
	MaxBandwidthTestBufferSize = 4096;
	MinBandwidthTestBufferSize = 4096;
	MaxBandwidthTestSendTime = 5.f;
	MaxBandwidthTestReceiveTime = 5.f;
	MaxBandwidthHistoryEntries = 100;
	ConnectionRequestTimeout = 5.f;
	MeshBeaconPort = 27015;

	ResolverClassName = "ClientBeaconAddressResolver";
	Resolver = new class'ClientBeaconAddressResolver';
	Resolver.BeaconName = 'H7ClientBeaconResolver';
	Resolver.BeaconPort = 27015;


	clientConnection.PlayerNetId = OnlineSubsystemUPlay(class'GameEngine'.static.GetOnlineSubsystem()).LoggedInPlayerId;
	clientConnection.bCanHostVs = false;
	clientConnection.GoodHostRatio = 0.5f;
	clientConnection.MinutesSinceLastTest = 0.f;
	clientConnection.NatType = NAT_Open;

	// delegates	
	OnConnectionRequestResult = H7OnConnectionRequestResult;
	OnReceivedBandwidthTestResults = H7OnReceivedBandwidthTestResults;
	OnReceivedBandwidthTestRequest = H7OnReceivedBandwidthTestRequest;

	if( !RequestConnection( DesiredHost, clientConnection, false ) )
	{
		class'H7ReplicationInfo'.static.PrintLogMessage("InitClientBeacon Failed to do the RequestConnection", 0);;
	}
	mTimeRequestConnectionStarted = class'WorldInfo'.static.GetWorldInfo().RealTimeSeconds;
	mPing = -1;
}

protected function H7OnConnectionRequestResult( EMeshBeaconConnectionResult ConnectionResult )
{
	class'H7ReplicationInfo'.static.PrintLogMessage("H7OnConnectionRequestResult" @ ConnectionResult, 0);;

	// They didnt implement the MB_BandwidthTestType_RoundtripLatency ... (we will do our own ping detection)
	//if( !BeginBandwidthTest( MB_BandwidthTestType_RoundtripLatency, 128 ) )
	//{
	//	`LOG_MP( "Failed trying to do a BeginBandwidthTest" );
	//}

	if( ConnectionResult != MB_ConnectionResult_Timeout && mPing == -1 )
	{
		mPing = ( class'WorldInfo'.static.GetWorldInfo().RealTimeSeconds - mTimeRequestConnectionStarted - class'WorldInfo'.static.GetWorldInfo().DeltaSeconds - class'WorldInfo'.static.GetWorldInfo().DeltaSeconds ) * 1000.f / 2.f;
		mPing -= 250;
		class'H7ReplicationInfo'.static.PrintLogMessage("mTimeRequestConnectionStarted:" @ mTimeRequestConnectionStarted @ "Current time:" @ class'WorldInfo'.static.GetWorldInfo().RealTimeSeconds @ "DeltaSeconds:" @ class'WorldInfo'.static.GetWorldInfo().DeltaSeconds, 0);;

		if( mPing <= 0 )
		{
			mPing = 1;
		}
	}
}

protected function H7OnReceivedBandwidthTestResults( EMeshBeaconBandwidthTestType TestType,	EMeshBeaconBandwidthTestResult TestResult, const out ConnectionBandwidthStats BandwidthStats )
{
	class'H7ReplicationInfo'.static.PrintLogMessage("H7OnReceivedBandwidthTestResults" @ TestType @ TestResult @ BandwidthStats.DownstreamRate @ BandwidthStats.UpstreamRate @ BandwidthStats.RoundtripLatency, 0);;
}

protected function H7OnReceivedBandwidthTestRequest( EMeshBeaconBandwidthTestType TestType )
{
	class'H7ReplicationInfo'.static.PrintLogMessage("H7OnReceivedBandwidthTestRequest" @ TestType, 0);;
}

