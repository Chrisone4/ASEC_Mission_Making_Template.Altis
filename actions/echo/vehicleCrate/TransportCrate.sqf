/*
Script by Thunderbolt (chrisone4)

Example: Add the follow to init to set as repair bay
Eden:	[this] execVM "actions\echo\vehicleCrate\TransportCrate.sqf";
Zeus:	[this] execVM "actions\echo\vehicleCrate\TransportCrate.sqf";
[
	_transportCrate, // Object to be set as a repair bay
] execVM "RepairBay.sqf";
*/
#define GREEN_CRATE_CLASSNAME "Land_Cargo20_military_green_F"
#define DESERT_CRATE_CLASSNAME "Land_Cargo20_yellow_F"
#define WINTER_CRATE_CLASSNAME "Land_Cargo20_white_F"

params [
	["_transportCrate", objNull, [objNull]],
	["_range", 50, [0]]
];

if (_range < 10) then { _range = 10; };
if (_range > 100) then { _range = 100; };

[_transportCrate, true, [0, 6, 1], 0] remoteExec ["ace_dragging_fnc_setCarryable", 0, true];

if (isNil "ASEC_fnc_ListVehicles_wreckLoading" || isNil "ASEC_fnc_Transport_Wreck") then {
	ASEC_fnc_ListVehicles_wreckLoading = {
		params ["_transportCrate", "", "_this"];
		params ["_range"];

		private _nearObjects = nearestObjects [_transportCrate, ["All"], _range];
		private _actions = [];
		
		//systemChat format["Attached Objects: %1", count attachedObjects _transportCrate > 0];
		//systemChat format["1: %1", _transportCrate];
		//systemChat format["2: %1", _this];

		{
			if (!alive _x) then {
				private _class = typeOf _x;
				private _name = getText (configfile >> "CfgVehicles" >> _class >> "displayName");
				_actions pushBack [[
					format ["REPAIR_%1", _forEachIndex],
					_name,
					getText (configfile >> "CfgVehicles" >> _class >> "icon"),
					{_this call ASEC_fnc_Transport_Wreck},
					{true},
					{},
					[_x, _name, _transportCrate]
				] call ace_interact_menu_fnc_createAction, [], _range];
			};
		} forEach _nearObjects;

		_actions
	};

	ASEC_fnc_Transport_Wreck = {
		(_this select 2) params ["_vehicle", "_name", "_transportCrate"];
		
		private _timer = 30;
		private _animation = getText (ConfigFile >> "ACE_Repair" >> "Actions" >> "MiscRepair" >> "animationCaller");
		player playMoveNow _animation;
		
		[
			_timer, [_vehicle, _transportCrate], {
				(_this select 0) params ["_vehicle", "_transportCrate"];
				
				player switchMove '';
				_vehicle attachTo [_transportCrate, [0, 0, 1]];
				
			},
			{
				player switchMove '';
			},
			format ["Loading Wreck...", _name]
		] call ace_common_fnc_progressBar;
		
		//_transportCrate enableVehicleCargo false;
		//systemChat format["VIV: %1", count attachedObjects _transportCrate];
		
		/*
		private _position = getPosATL _transportCrate;
		
		if(count attachedObjects _transportCrate == 0) then {
			_vehicle attachTo [_transportCrate, [0, 0, 1]];
			_transportCrate enableVehicleCargo false;
			//[_transportCrate] remoteExec "fnc_transport_wreck";
		} else {
			detach _vehicle;
			_vehicle setPosATL [(getPosATL _transportCrate select 0) + 10, getPosATL _transportCrate select 1, getPosATL _transportCrate select 2];
		};
		*/
	};
};

if (isNil "ASEC_fnc_wreckUnloading" || isNil "ASEC_fnc_Transport_Wreck_Unload") then {
	ASEC_fnc_wreckUnloading = {
		params ["_transportCrate", "", "_this"];
		private _actions = [];
		
		//systemChat format["VIV: %1", count attachedObjects _transportCrate > 0];

		private _class = (attachedObjects _transportCrate) select 0;
		_actions pushBack [[
			"unload_wreck",
			"Unload Wreck",
			"\A3\ui_f\data\igui\cfg\actions\unloadVehicle_ca.paa",
			{_this call ASEC_fnc_Transport_Wreck_Unload},
			{true},
			{},
			[_class, _transportCrate]
		] call ace_interact_menu_fnc_createAction, [], _range];

		_actions
	};

	ASEC_fnc_Transport_Wreck_Unload = {
		(_this select 2) params ["_vehicle", "_transportCrate"];
		
		private _timer = 30;
		private _animation = getText (ConfigFile >> "ACE_Repair" >> "Actions" >> "MiscRepair" >> "animationCaller");
		player playMoveNow _animation;
		
		[
			_timer, [_vehicle, _transportCrate], {
				(_this select 0) params ["_vehicle", "_transportCrate"];
				
				player switchMove '';
				private _position = getPosATL _transportCrate;

				detach _vehicle;
				_vehicle setPosATL [(getPosATL _transportCrate select 0) + 10, getPosATL _transportCrate select 1, getPosATL _transportCrate select 2];
		
				_transportCrate enableVehicleCargo true;
				
			},
			{
				player switchMove '';
			},
			format ["Unloading Wreck...", _name]
		] call ace_common_fnc_progressBar;
	};
};

if (isNil "ASEC_fnc_Repack_TransportCrate_Option" || isNil "ASEC_fnc_Repack_TransportCrate") then {
	
	ASEC_fnc_Repack_TransportCrate_Option = {
			params ["_transportCrate"];
			
			private _repackChild = [];
			
			_repackChild pushBack [[
				"ASEC_transportCrate_Repack",
				"Repack Vehicle Crate",
				"\A3\ui_f\data\igui\cfg\actions\loadVehicle_ca.paa",
				{_this call ASEC_fnc_Repack_TransportCrate},
				{true},
				{},
				[_transportCrate]
			] call ace_interact_menu_fnc_createAction, [], 1];
		_repackChild
	};
	
	ASEC_fnc_Repack_TransportCrate = {
		
		(_this select 2) params ["_transportCrate", "", "_this"];
		
		// Determine where we should put the crate.
		private _position = getPosATL _transportCrate;
		private _direction = getDir _transportCrate;
		
		private _class = GREEN_CRATE_CLASSNAME;
		
		switch (typeOf _transportCrate) do {
			case "Transport_Crate_01_Desert": { _class = DESERT_CRATE_CLASSNAME; };
			case "Transport_Crate_02_Desert": { _class = DESERT_CRATE_CLASSNAME; };
			case "Transport_Crate_03_Desert": { _class = DESERT_CRATE_CLASSNAME; };
			case "Transport_Crate_04_Desert": { _class = DESERT_CRATE_CLASSNAME; };
			
			case "Transport_Crate_01_Winter": { _class = WINTER_CRATE_CLASSNAME; };
			case "Transport_Crate_02_Winter": { _class = WINTER_CRATE_CLASSNAME; };
			case "Transport_Crate_03_Winter": { _class = WINTER_CRATE_CLASSNAME; };
			case "Transport_Crate_04_Winter": { _class = WINTER_CRATE_CLASSNAME; };
			
			default { _class = GREEN_CRATE_CLASSNAME; }; 
		};
		
		private _unpackTimer = 3;
		private _animation = getText (ConfigFile >> "ACE_Repair" >> "Actions" >> "MiscRepair" >> "animationCaller");
		player playMoveNow _animation;
		
		[
			_unpackTimer, [_class, _position, _direction, _transportCrate], {
				(_this select 0) params ["_class", "_position", "_direction", "_transportCrate"];
				
				player switchMove '';
				
				deleteVehicle _transportCrate;
				[_class, _position, _direction] spawn {
					params ["_class", "_position", "_direction"];
					sleep 0.5;
					private _crate = createVehicle [_class, _position, [], 0, "NONE"];
					_crate setDir _direction;
					
					// Remove any items from the crate.
					clearWeaponCargoGlobal _crate;
					clearItemCargoGlobal _crate;
					clearMagazineCargoGlobal _crate;
					clearBackpackCargo _crate;
					
					[_crate] remoteExec ["fnc_packIntoBox_transportBox"];
				};
			},
			{
				player switchMove '';
			},
			format ["Packing Vehicle Crate...", _name]
			//{
			//	(_this select 0) params ["_transportCrate"];
			//	_transportCrate distance player < 5 && alive _transportCrate
			//}

		] call ace_common_fnc_progressBar;
	}; 
};

private _loadAction = [
	"ASEC_TransportCrate_load",
	"Load Destroyed Vehicle",
	"\A3\ui_f\data\igui\cfg\actions\repair_ca.paa",
	{},
	{(count attachedObjects (_this#0)) == 0},
	{_this call ASEC_fnc_ListVehicles_wreckLoading},
	[_range, _transportCrate]
] call ace_interact_menu_fnc_createAction;

[_transportCrate, 0, ["ACE_MainActions"], _loadAction] call ace_interact_menu_fnc_addActionToObject;

private _unloadAction = [
	"ASEC_TransportCrate_unload",
	"Unload Destroyed Vehicle",
	"\A3\ui_f\data\igui\cfg\actions\repair_ca.paa",
	{},
	//{player getVariable["ACE_isEngineer",0] > 1},
	//{(count attachedObjects (_this#1) > 0},
	{(count attachedObjects (_this#0)) > 0},
	{_this call ASEC_fnc_wreckUnloading},
	[_transportCrate]
] call ace_interact_menu_fnc_createAction;

[_transportCrate, 0, ["ACE_MainActions"], _unloadAction] call ace_interact_menu_fnc_addActionToObject;

private _repackAction = [
	"ASEC_transportCrate_repack_Option",
	"Repack Vehicle Crate",
	"\A3\ui_f\data\igui\cfg\actions\loadVehicle_ca.paa",
	{},
	{player getVariable["ACE_isEngineer",0] > 1},
	{_this call ASEC_fnc_Repack_TransportCrate_Option},
	[_transportCrate]
] call ace_interact_menu_fnc_createAction;
[_transportCrate, 0, ["ACE_MainActions"], _repackAction] call ace_interact_menu_fnc_addActionToObject;
