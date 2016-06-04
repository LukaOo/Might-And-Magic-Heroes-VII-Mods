//=============================================================================
// H7MeshBeaconHost
//
// This class is used to handle connections from client mesh beacons in order to 
// establish a mesh network.
//
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7MeshBeaconHost extends MeshBeaconHost;

function InitMeshBeaconHost()
{
	ConnectionBacklog = 50;
	MeshBeaconPort = 27015;
	HeartbeatTimeout = 5.f;
	SocketSendBufferSize = 4096;
	SocketReceiveBufferSize = 4096;
	MaxBandwidthTestBufferSize = 4096;
	MinBandwidthTestBufferSize = 4096;
	MaxBandwidthTestSendTime = 5.f;
	MaxBandwidthTestReceiveTime = 5.f;
	MaxBandwidthHistoryEntries = 100;

	// delegates
	OnReceivedClientConnectionRequest = H7OnReceivedClientConnectionRequest;
	OnStartedBandwidthTest = H7OnStartedBandwidthTest;
	OnFinishedBandwidthTest = H7OnFinishedBandwidthTest;

	if( !InitHostBeacon( OnlineSubsystemUPlay(class'GameEngine'.static.GetOnlineSubsystem()).LoggedInPlayerId ) )
	{
		class'H7ReplicationInfo'.static.PrintLogMessage("InitHostBeacon failed to do the Init", 0);;
	}
}

protected function H7OnReceivedClientConnectionRequest( const out ClientMeshBeaconConnection NewClientConnection )
{
	class'H7ReplicationInfo'.static.PrintLogMessage("H7OnReceivedClientConnectionRequest" @ class'OnlineSubsystem'.static.UniqueNetIdToString(NewClientConnection.PlayerNetId) @ NewClientConnection.NatType, 0);;
}

protected function H7OnStartedBandwidthTest( UniqueNetId PlayerNetId,EMeshBeaconBandwidthTestType TestType )
{
	class'H7ReplicationInfo'.static.PrintLogMessage("H7OnStartedBandwidthTest" @ class'OnlineSubsystem'.static.UniqueNetIdToString(PlayerNetId) @ TestType, 0);;
}

protected function H7OnFinishedBandwidthTest( UniqueNetId PlayerNetId, EMeshBeaconBandwidthTestType TestType, EMeshBeaconBandwidthTestResult TestResult, const out ConnectionBandwidthStats BandwidthStats )
{
	class'H7ReplicationInfo'.static.PrintLogMessage("H7OnFinishedBandwidthTest" @ class'OnlineSubsystem'.static.UniqueNetIdToString(PlayerNetId) @ TestType @ TestResult @ BandwidthStats.DownstreamRate @ BandwidthStats.UpstreamRate @ BandwidthStats.RoundtripLatency, 0);;
}

