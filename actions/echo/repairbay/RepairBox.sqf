/*
Script by C.Yuri

Example: Add the follow to init to set as repair bay
Eden:	[this] execVM "actions\echo\repairbay\RepairBox.sqf";
Zeus:	[this] execVM "actions\echo\repairbay\RepairBox.sqf";
[
	_repairBox, // Object to be set as a repair bay
] execVM "RepairBox.sqf";
*/
//#define CRATE_CLASSNAME "Land_RepairDepot_01_green_F"

#define GREEN_REPAIRBAY_CLASSNAME "Land_RepairDepot_01_green_F"
#define DESERT_REPAIRBAY_CLASSNAME "Land_RepairDepot_01_tan_F"

params [ 
	["_repairBox", objNull, [objNull]]
];

[_repairBox, true, [0, 6, 1], 90] remoteExec ["ace_dragging_fnc_setCarryable", 0, true];
[_repairBox, 20] call ace_cargo_fnc_setSize;

if (isNil "OMM_RB_fnc_Unpack_Option" || isNil "OMM_RB_fnc_Unpack") then {
	OMM_RB_fnc_Unpack_Option = {
			params ["_repairBox"];
			
			private _unpackChild = [];
			
			_unpackChild pushBack [[
				"OMM_repairBox_Unpack",
				"Unpack Repair Bay",
				"\A3\ui_f\data\igui\cfg\actions\unloadVehicle_ca.paa",
				{_this call OMM_RB_fnc_Unpack},
				{true},
				{},
				[_repairBox]
			] call ace_interact_menu_fnc_createAction, [], 1];
		_unpackChild
	};
	
	OMM_RB_fnc_Unpack = {
		(_this select 2) params ["_repairBox", "", "_this"];
		
		// Determine where we should put the crate.
		private _position = getPosATL _repairBox;
		private _direction = getDir _repairBox;
		
		private _class = GREEN_REPAIRBAY_CLASSNAME;

		if(typeOf _repairBox == "UK3CB_BAF_MAN_HX58_Container_Sand") then {
			_class = DESERT_REPAIRBAY_CLASSNAME;
		};
		
		private _unpackTimer = 20;
		private _animation = getText (ConfigFile >> "ACE_Repair" >> "Actions" >> "MiscRepair" >> "animationCaller");
		player playMoveNow _animation;
		
		[
			_unpackTimer, [_class, _position, _direction, _repairBox], {
				(_this select 0) params ["_class", "_position", "_direction", "_repairBox"];
				
				player switchMove '';
				
				deleteVehicle _repairBox;
				[_class, _position, _direction] spawn {
					params ["_class", "_position", "_direction"];
					sleep 0.5;
					private _bay = createVehicle [_class, _position, [], 0, "NONE"];
					_bay setDir _direction;
					
					// Remove any items from the crate.
					clearWeaponCargoGlobal _bay;
					clearItemCargoGlobal _bay;
					clearMagazineCargoGlobal _bay;
					clearBackpackCargo _bay;
				
					//_bay addAction["Get Repair Box", "actions\echo\repairbay\spawn_repairBox.sqf"];
					[_bay, 50] remoteExec ["fnc_unpackIntoBay"];
					
					//[_bay, true, [0, 3, 1], 90] remoteExec ["ace_dragging_fnc_setCarryable", 0, true];
					//[_bay, 10] call ace_cargo_fnc_setSize;
				};
			},
			{
				player switchMove '';
			},
			format ["Unpacking Repair Bay...", _name]
			//{
			//	(_this select 0) params ["_repairBox"];
			//	_repairBox distance player < 5 && alive _repairBox
			//}

		] call ace_common_fnc_progressBar;
	}; 
};

private _unpackAction = [
	"OMM_repairBox_unpack_Option",
	"Unpack Repair Bay",
	"\A3\ui_f\data\igui\cfg\actions\unloadVehicle_ca.paa",
	{},
	{player getVariable["ACE_isEngineer",0] > 1},
	{_this call OMM_RB_fnc_Unpack_Option},
	[_repairBox]
] call ace_interact_menu_fnc_createAction;
[_repairBox, 0, ["ACE_MainActions"], _unpackAction] call ace_interact_menu_fnc_addActionToObject;
