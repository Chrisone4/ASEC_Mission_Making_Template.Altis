/*
Script by C.Yuri

Example: Add the follow to init to set as repair bay
Eden:	[this] execVM "actions\echo\vehicleCrate\TransportBox.sqf";
Zeus:	[this] execVM "actions\echo\vehicleCrate\TransportBox.sqf";
[
	_transportBox, // Object to be set as a repair bay
] execVM "VicCrate.sqf";
*/

#define GREEN_CRATE_CLASSNAME_01 "Transport_Crate_01"
#define DESERT_CRATE_CLASSNAME_01 "Transport_Crate_01_Desert"
#define WINTER_CRATE_CLASSNAME_01 "Transport_Crate_01_Winter"

#define GREEN_CRATE_CLASSNAME_02 "Transport_Crate_02"
#define DESERT_CRATE_CLASSNAME_02 "Transport_Crate_02_Desert"
#define WINTER_CRATE_CLASSNAME_02 "Transport_Crate_02_Winter"

#define GREEN_CRATE_CLASSNAME_03 "Transport_Crate_03"
#define DESERT_CRATE_CLASSNAME_03 "Transport_Crate_03_Desert"
#define WINTER_CRATE_CLASSNAME_03 "Transport_Crate_03_Winter"

#define GREEN_CRATE_CLASSNAME_04 "Transport_Crate_04"
#define DESERT_CRATE_CLASSNAME_04 "Transport_Crate_04_Desert"
#define WINTER_CRATE_CLASSNAME_04 "Transport_Crate_04_Winter"

params [ 
	["_transportBox", objNull, [objNull]]
];

[_transportBox, true, [0, 6, 1], 90] remoteExec ["ace_dragging_fnc_setCarryable", 0, true];
[_transportBox, 20] call ace_cargo_fnc_setSize;

if (isNil "ASEC_fnc_Unpack_TransportBox_Option" || isNil "ASEC_fnc_Unpack_TransportBox_01" || isNil "ASEC_fnc_Unpack_TransportBox_02" || isNil "ASEC_fnc_Unpack_TransportBox_03" || isNil "ASEC_fnc_Unpack_TransportBox_04") then {
	ASEC_fnc_Unpack_TransportBox_Option = {
			params ["_transportBox"];
			
			private _unpackChild = [];
			
			_unpackChild pushBack [[
				"ASEC_transportBox_Unpack_01",
				"Unpack Vehicle Crate: 19x8",
				"\A3\ui_f\data\igui\cfg\actions\unloadVehicle_ca.paa",
				{_this call ASEC_fnc_Unpack_TransportBox},
				{true},
				{},
				[_transportBox, GREEN_CRATE_CLASSNAME_01, DESERT_CRATE_CLASSNAME_01, WINTER_CRATE_CLASSNAME_01]
			] call ace_interact_menu_fnc_createAction, [], 1];
			
			_unpackChild pushBack [[
				"ASEC_transportBox_Unpack_02",
				"Unpack Vehicle Crate: 19x10",
				"\A3\ui_f\data\igui\cfg\actions\unloadVehicle_ca.paa",
				{_this call ASEC_fnc_Unpack_TransportBox},
				{true},
				{},
				[_transportBox, GREEN_CRATE_CLASSNAME_02, DESERT_CRATE_CLASSNAME_02, WINTER_CRATE_CLASSNAME_02]
			] call ace_interact_menu_fnc_createAction, [], 1];
			
			_unpackChild pushBack [[
				"ASEC_transportBox_Unpack_03",
				"Unpack Vehicle Crate: 22x8",
				"\A3\ui_f\data\igui\cfg\actions\unloadVehicle_ca.paa",
				{_this call ASEC_fnc_Unpack_TransportBox},
				{true},
				{},
				[_transportBox, GREEN_CRATE_CLASSNAME_03, DESERT_CRATE_CLASSNAME_03, WINTER_CRATE_CLASSNAME_03]
			] call ace_interact_menu_fnc_createAction, [], 1];
			
			_unpackChild pushBack [[
				"ASEC_transportBox_Unpack_04",
				"Unpack Vehicle Crate: 24x8",
				"\A3\ui_f\data\igui\cfg\actions\unloadVehicle_ca.paa",
				{_this call ASEC_fnc_Unpack_TransportBox},
				{true},
				{},
				[_transportBox, GREEN_CRATE_CLASSNAME_04, DESERT_CRATE_CLASSNAME_04, WINTER_CRATE_CLASSNAME_04]
			] call ace_interact_menu_fnc_createAction, [], 1];
		_unpackChild
	};
		
	ASEC_fnc_Unpack_TransportBox = {
		(_this select 2) params ["_transportBox", "_transportCrate_Green", "_transportCrate_Sand", "_transportCrate_White", "_this"];
		
		// Determine where we should put the crate.
		private _position = getPosATL _transportBox;
		private _direction = getDir _transportBox;
		
		private _class = _transportCrate_Green;
		
		if(typeOf _transportBox == "Land_Cargo10_sand_F") then {
			_class = _transportCrate_Sand;
		}; 
		
		if (typeOf _transportBox == "Land_Cargo10_white_F") then {
			_class = _transportCrate_White;
		};
		
		private _unpackTimer = 30;
		private _animation = getText (ConfigFile >> "ACE_Repair" >> "Actions" >> "MiscRepair" >> "animationCaller");
		player playMoveNow _animation;
		
		[
			_unpackTimer, [_class, _position, _direction, _transportBox], {
				(_this select 0) params ["_class", "_position", "_direction", "_transportBox"];
				
				player switchMove '';
				
				deleteVehicle _transportBox;
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
				
					[_bay, 50] remoteExec ["fnc_unpackIntoCrate_transportCrate"];
					
				};
			},
			{
				player switchMove '';
			},
			format ["Unpacking Vehicle Crate...", _name]
			//{
			//	(_this select 0) params ["_transportBox"];
			//	_transportBox distance player < 5 && alive _transportBox
			//}

		] call ace_common_fnc_progressBar;
	};
};

private _unpackAction = [
	"ASEC_transportBox_unpack_Option",
	"Unpack Vehicle Crate",
	"\A3\ui_f\data\igui\cfg\actions\unloadVehicle_ca.paa",
	{},
	{player getVariable["ACE_isEngineer",0] > 0},
	{_this call ASEC_fnc_Unpack_TransportBox_Option},
	[_transportBox]
] call ace_interact_menu_fnc_createAction;
[_transportBox, 0, ["ACE_MainActions"], _unpackAction] call ace_interact_menu_fnc_addActionToObject;
