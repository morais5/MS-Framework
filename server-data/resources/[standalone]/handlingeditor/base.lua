-- this table houses all handling properties that can be used by scripts to modify the vehicles' handlings, this list may or may not be useless, but is kept for reference.
local handlingData = {
	-- generic handling data
	"handlingName",
	"fMass",
	"fInitialDragCoeff",
	"fPercentSubmerged",
	"vecCentreOfMassOffset",
	"vecInertiaMultiplier",
	"fDriveBiasFront",
	"nInitialDriveGears",
	"fInitialDriveForce",
	"fDriveInertia",
	"fClutchChangeRateScaleUpShift",
	"fClutchChangeRateScaleDownShift",
	"fInitialDriveMaxFlatVel",
	"fBrakeForce",
	"fBrakeBiasFront",
	"fHandBrakeForce",
	"fSteeringLock",
	"fTractionCurveMax",
	"fTractionCurveMin",
	"fTractionCurveLateral",
	"fTractionSpringDeltaMax",
	"fLowSpeedTractionLossMult",
	"fCamberStiffnesss",
	"fTractionBiasFront",
	"fTractionLossMult",
	"fSuspensionForce",
	"fSuspensionCompDamp",
	"fSuspensionReboundDamp",
	"fSuspensionUpperLimit",
	"fSuspensionLowerLimit",
	"fSuspensionRaise",
	"fSuspensionBiasFront",
	"fTractionCurveMax",
	"fAntiRollBarForce",
	"fAntiRollBarBiasFront",
	"fRollCentreHeightFront",
	"fRollCentreHeightRear",
	"fCollisionDamageMult",
	"fWeaponDamageMult",
	"fDeformationDamageMult",
	"fEngineDamageMult",
	"fPetrolTankVolume",
	"fOilVolume",
	"fSeatOffsetDistX",
	"fSeatOffsetDistY",
	"fSeatOffsetDistZ",
	"nMonetaryValue",
	"strModelFlags",
	"strHandlingFlags",
	"strDamageFlags",
	"AIHandling",
	
	-- CFlyingHandlingData
	
	"fThrust",
	"fThrustFallOff",
	"fThrustVectoring",
	"fYawMult",
	"fYawStabilise",
	"fSideSlipMult",
	"fRollMult",
	"fRollStabilise",
	"fPitchMult",
	"fPitchStabilise",
	"fFormLiftMult",
	"fAttackLiftMult",
	"fAttackDiveMult",
	"fGearDownDragV",
	"fGearDownLiftMult",
	"fWindMult",
	"fMoveRes",
	"vecTurnRes",
	"vecSpeedRes",
	"fGearDoorFrontOpen",
	"fGearDoorRearOpen",
	"fGearDoorRearOpen2",
	"fGearDoorRearMOpen",
	"fTurublenceMagnitudeMax",
	"fTurublenceForceMulti",
	"fTurublenceRollTorqueMulti",
	"fTurublencePitchTorqueMulti",
	"fBodyDamageControlEffectMult",
	"fInputSensitivityForDifficulty",
	"fOnGroundYawBoostSpeedPeak",
	"fOnGroundYawBoostSpeedCap",
	"fEngineOffGlideMulti",
	"handlingType",
	"fThrustFallOff",
	"fThrustFallOff",
	
	-- CCarHandlingData
	
	"fBackEndPopUpCarImpulseMult",
	"fBackEndPopUpBuildingImpulseMult",
	"fBackEndPopUpMaxDeltaSpeed",
	
	
	-- CBikeHandlingData
	
	"fLeanFwdCOMMult",
	"fLeanFwdForceMult",
	"fLeanBakCOMMult",
	"fLeanBakForceMult",
	"fMaxBankAngle",
	"fFullAnimAngle",
	"fDesLeanReturnFrac",
	"fStickLeanMult",
	"fBrakingStabilityMult",
	"fInAirSteerMult",
	"fWheelieBalancePoint",
	"fStoppieBalancePoint",
	"fWheelieSteerMult",
	"fRearBalanceMult",
	"fFrontBalanceMult",
	"fBikeGroundSideFrictionMult",
	"fBikeWheelGroundSideFrictionMult",
	"fBikeOnStandLeanAngle",
	"fBikeOnStandSteerAngle",
	"fJumpForce",
}


-- note: i will not document things twice.

Citizen.CreateThread(function()

	function SetVehicleHandlingData(Vehicle,Data,Value) -- sets the vehicle handling data, useful for setting single values
		if DoesEntityExist(Vehicle) and Data and Value then
			for theKey,property in pairs(handlingData) do 
				if property == Data then
					local intfind = string.find(property, "n" )  -- these find whether or not the handling properties use floats, numbers, "strings" or vectors
					local floatfind = string.find(property, "f" )
					local strfind = string.find(property, "str" )
					local vecfind = string.find(property, "vec" )
					
					
					if intfind ~= nil and intfind == 1 then -- this makes sure that it's not "nil" and 1, otherwise it may not be correct
						SetVehicleHandlingInt( Vehicle, "CHandlingData", Data, tonumber(Value) ) -- set value of the specified field with the correct type
					elseif floatfind ~= nil and floatfind == 1 then
						local Value = tonumber(Value)+.0
						SetVehicleHandlingFloat( Vehicle, "CHandlingData", Data, tonumber(Value) )
					elseif strfind ~= nil and strfind == 1 then
						SetVehicleHandlingField( Vehicle, "CHandlingData", Data, Value )
					elseif vecfind ~= nil and vecfind == 1 then
						SetVehicleHandlingVector( Vehicle, "CHandlingData", Data, Value )
					else
						SetVehicleHandlingField( Vehicle, "CHandlingData", Data, Value )
					end
				end
			end
		end
	end
	
	
	function GetVehicleHandlingData(Vehicle,Data) -- this returns the data that, although not necesarilly needed, useful if you just want to get the value of one single property property
		if DoesEntityExist(Vehicle) then
			for theKey,property in pairs(handlingData) do 
				if property == Data then
					local intfind = string.find(property, "n" )
					local floatfind = string.find(property, "f" )
					local strfind = string.find(property, "str" )
					local vecfind = string.find(property, "vec" )
					
					if intfind ~= nil and intfind == 1 then
						return GetVehicleHandlingInt( Vehicle, "CHandlingData", Data )
					elseif floatfind ~= nil and floatfind == 1 then
						return GetVehicleHandlingFloat( Vehicle, "CHandlingData", Data )
					elseif vecfind ~= nil and vecfind == 1 then
						return GetVehicleHandlingVector( Vehicle, "CHandlingData", Data )
					else
						return false
					end
				end
			end
		end
	end
	
	function GetAllVehicleHandlingData(Vehicle) -- this returns **all** handling properties and their values in a table, the table will have following contents: "name" = the name of the property, "value" = a number, string or vector3, "type" = the type, int, float or vector3
		local VehicleHandlingData = {}
		if DoesEntityExist(Vehicle) then
			for i,theData in pairs(handlingData) do 
				local intfind = string.find(theData, "n" )
				local floatfind = string.find(theData, "f" )
				local strfind = string.find(theData, "str" )
				local vecfind = string.find(theData, "vec" )
				
				if intfind ~= nil and intfind == 1 and GetVehicleHandlingInt( Vehicle, "CHandlingData", theData ) then
					table.insert(VehicleHandlingData, { name = theData, value = GetVehicleHandlingInt( Vehicle, "CHandlingData", theData ), type = "int" }  )
				elseif floatfind ~= nil and floatfind == 1 and GetVehicleHandlingFloat( Vehicle, "CHandlingData", theData ) then
					table.insert(VehicleHandlingData, { name = theData, value = GetVehicleHandlingFloat( Vehicle, "CHandlingData", theData ), type = "float" } )
				elseif vecfind ~= nil and vecfind == 1 and GetVehicleHandlingVector( Vehicle, "CHandlingData", theData ) then
					table.insert(VehicleHandlingData, { name = theData, value = GetVehicleHandlingVector( Vehicle, "CHandlingData", theData ), type = "vector3" } )
				end
			end
			return VehicleHandlingData
		end
	end
	
		
	
	
end
)

