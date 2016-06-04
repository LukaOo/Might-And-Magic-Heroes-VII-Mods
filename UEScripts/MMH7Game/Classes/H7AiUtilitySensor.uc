//=============================================================================
// H7AiUtilitySensor
//=============================================================================
// 
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7AiUtilitySensor extends H7AiUtilityBase;

var(AiUtility) protected EAiCombatSensor      mInSensor<DisplayName=Input Sensor C>;
var(AiUtility) protected EAiAdventureSensor   mInSensorAdv<DisplayName=Input Sensor A>;
var(AiUtility) protected EAiSensorIConst      mInSensorConst0<DisplayName=Input Constant 1>;
var(AiUtility) protected EAiSensorIConst      mInSensorConst1<DisplayName=Input Constant 2>;

function UpdateInput() {}
function UpdateOutput() {}
