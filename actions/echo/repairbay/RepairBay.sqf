/*
Script by C.Yuri

Example: Add the follow to init to set as repair bay
Eden:	[this, 50] execVM "actions\echo\repairbay\RepairBay.sqf";
Zeus:	[this, 50] execVM "actions\echo\repairbay\RepairBay.sqf";
[
	_repairBay, // Object to be set as a repair bay
	50          // Change the 50 in [this, 50] to x to change the range. I recommend 10-20.
] execVM "RepairBay.sqf";
*/
#define GREEN_CRATE_CLASSNAME "UK3CB_BAF_MAN_HX58_Container_Green"
#define DESERT_CRATE_CLASSNAME "UK3CB_BAF_MAN_HX58_Container_Sand"

params [
	["_repairBay", objNull, [objNull]],
	["_range", 50, [0]]
];

if (_range < 10) then { _range = 10; };
if (_range > 100) then { _range = 100; };

[_repairBay, true, [0, 6, 1], 0] remoteExec ["ace_dragging_fnc_setCarryable", 0, true];

if (isNil "OMM_RB_fnc_ListVehicles" || isNil "OMM_RB_fnc_Repair") then {
	OMM_RB_fnc_ListVehicles = {
		params ["_repairBay", "", "_this"];
		params ["_range"];

		private _nearObjects = nearestObjects [_repairBay, ["All"], _range];
		private _actions = [];

		{
			if (!alive _x) then {
				private _class = typeOf _x;
				private _name = getText (configfile >> "CfgVehicles" >> _class >> "displayName");
				_actions pushBack [[
					format ["REPAIR_%1", _forEachIndex],
					_name,
					getText (configfile >> "CfgVehicles" >> _class >> "icon"),
					{_this call OMM_RB_fnc_Repair},
					{true},
					{},
					[_x, _name, _repairBay, _range]
				] call ace_interact_menu_fnc_createAction, [], _range];
			};
		} forEach _nearObjects;

		_actions
	};

	OMM_RB_fnc_Repair = {
		(_this select 2) params ["_vehicle", "_name", "_repairBay", "_range"];

		private _repairTime = 100 * (linearConversion [1000, 60000, getMass _vehicle, 0.1, 1, true]);
		private _class = typeOf _vehicle;
		private _position = getPosATL _vehicle;
		private _direction = getDir _vehicle;


		private _animation = getText (ConfigFile >> "ACE_Repair" >> "Actions" >> "MiscRepair" >> "animationCaller");
		player playMoveNow _animation;

		[
			_repairTime,
			[_vehicle, _repairBay, _range, _class, _position, _direction],
			{
				(_this select 0) params ["_vehicle", "_repairBay", "_range", "_class", "_position", "_direction"];

				player switchMove '';

				deleteVehicle _vehicle;
				[_class, _position, _direction] spawn {
					params ["_class", "_position", "_direction"];
					sleep 0.5;
					private _vehicle = createVehicle [_class, _position, [], 0, "NONE"];
					_vehicle setDir _direction;

					private _hitPoints = ["HitFuel", "HitEngine"];
					_hitPoints append ((_vehicle call ace_repair_fnc_getWheelHitPointsWithSelections) select 0);
					for "_i" from 1 to 10 do {
						_vehicle setHitPointDamage [selectRandom _hitPoints, [0, 1] select (random 1 < 0.5)];
					};

					if (_vehicle isKindOf "Tank") then {
						_vehicle setHitPointDamage ["hitRtrack",1]; // Tanks are guranteed to have destroyed tracks and turret/gun for balance purposes
						_vehicle setHitPointDamage ["hitLtrack",1];
						_vehicle setHitPointDamage ["hitGun",1];
						_vehicle setHitPointDamage ["hitTurret",1];
					};

					_vehicle setFuel 0; // All repaired vehicles will have 0 fuel and ammo
					_vehicle setVehicleAmmo 0;
				};
			},
			{
				player switchMove '';
			},
			format ["Repairing %1...", _name],
			{
				(_this select 0) params ["_vehicle", "_repairBay", "_range", "_class", "_position", "_direction"];
				_repairBay distance _vehicle < _range && alive _repairBay && !alive _vehicle
			}
		] call ace_common_fnc_progressBar;
	};
};

if (isNil "OMM_RB_fnc_Repack_Option" || isNil "OMM_RB_fnc_Repack") then {
	
	OMM_RB_fnc_Repack_Option = {
			params ["_repairBay"];
			
			private _repackChild = [];
			
			_repackChild pushBack [[
				"OMM_RepairBay_Repack",
				"Repack Repair Bay",
				"\A3\ui_f\data\igui\cfg\actions\loadVehicle_ca.paa",
				{_this call OMM_RB_fnc_Repack},
				{true},
				{},
				[_repairBay]
			] call ace_interact_menu_fnc_createAction, [], 1];
		_repackChild
	};
	
	OMM_RB_fnc_Repack = {
		
		(_this select 2) params ["_repairBay", "", "_this"];
		
		// Determine where we should put the crate.
		private _position = getPosATL _repairBay;
		private _direction = getDir _repairBay;
		
		private _class = GREEN_CRATE_CLASSNAME;
		
		if(typeOf _repairBay == "Land_RepairDepot_01_tan_F") then {
			_class = DESERT_CRATE_CLASSNAME;
		};
		
		private _unpackTimer = 20;
		private _animation = getText (ConfigFile >> "ACE_Repair" >> "Actions" >> "MiscRepair" >> "animationCaller");
		player playMoveNow _animation;
		
		[
			_unpackTimer, [_class, _position, _direction, _repairBay], {
				(_this select 0) params ["_class", "_position", "_direction", "_repairBay"];
				
				player switchMove '';
				
				deleteVehicle _repairBay;
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
					
					[_crate] remoteExec ["fnc_packIntoBox"];
				
					//_crate addAction["Get Repair Box", "actions\echo\repairbay\spawn_repairBay.sqf"];
					//[_crate, true, [0, 3, 1], 90] remoteExec ["ace_dragging_fnc_setCarryable", 0, true];
					//[_crate, 10] call ace_cargo_fnc_setSize;
				};
			},
			{
				player switchMove '';
			},
			format ["Packing Repair Bay...", _name]
			//{
			//	(_this select 0) params ["_repairBay"];
			//	_repairBay distance player < 5 && alive _repairBay
			//}

		] call ace_common_fnc_progressBar;
	}; 
};

private _action = [
	"OMM_RepairBay",
	"Repair Destroyed Vehicles",
	"\A3\ui_f\data\igui\cfg\actions\repair_ca.paa",
	{},
	{player getVariable["ACE_isEngineer",0] > 1},
	{_this call OMM_RB_fnc_ListVehicles},
	[_range]
] call ace_interact_menu_fnc_createAction;

[_repairBay, 0, ["ACE_MainActions"], _action] call ace_interact_menu_fnc_addActionToObject;

private _repackAction = [
	"OMM_repairBay_repack_Option",
	"Repack Repair Bay",
	"\A3\ui_f\data\igui\cfg\actions\loadVehicle_ca.paa",
	{},
	{player getVariable["ACE_isEngineer",0] > 1},
	{_this call OMM_RB_fnc_Repack_Option},
	[_repairBay]
] call ace_interact_menu_fnc_createAction;
[_repairBay, 0, ["ACE_MainActions"], _repackAction] call ace_interact_menu_fnc_addActionToObject;
