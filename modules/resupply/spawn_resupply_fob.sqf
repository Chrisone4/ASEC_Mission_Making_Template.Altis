#define SPAWN_DISTANCE -3

params ["_resupplyName", "_target"];

// Get contents of the arsenal, and the type of crate we will be using
private _resupply = nil;

if (_resupplyName == "fobchq") then {
	_resupply = call compile preprocessFileLineNumbers "modules\resupply\resupply_fob_chq.sqf";
};

if (_resupplyName == "fobpl") then {
	_resupply = call compile preprocessFileLineNumbers "modules\resupply\resupply_fob_pl.sqf";
};

if (_resupplyName == "fobdelta") then {
	_resupply = call compile preprocessFileLineNumbers "modules\resupply\resupply_fob_delta.sqf";
};

if (_resupplyName == "fobecho") then {
	_resupply = call compile preprocessFileLineNumbers "modules\resupply\resupply_fob_echo.sqf";
};

if (_resupplyName == "fobfoxtrot") then {
	_resupply = call compile preprocessFileLineNumbers "modules\resupply\resupply_fob_foxtrot.sqf";
};

if (_resupplyName == "fobgolf") then {
	_resupply = call compile preprocessFileLineNumbers "modules\resupply\resupply_fob_golf.sqf";
};

if (_resupplyName == "fobhotel") then {
	_resupply = call compile preprocessFileLineNumbers "modules\resupply\resupply_fob_hotel.sqf";
};

if (_resupplyName == "fobmike") then {
	_resupply = call compile preprocessFileLineNumbers "modules\resupply\resupply_fob_mike.sqf";
};

private _arsenalContents = _resupply select 0;
private _crateClass = _resupply select 1;

// Determine where we'll be spawning the crate
private _spawn_offset = vectorDir _target vectorMultiply SPAWN_DISTANCE;
private _spawn_pos = getPos _target vectorAdd _spawn_offset;


// Spawn the crate
private _crate = _crateClass createVehicle _spawn_pos;

// Remove any items from the crate - small performance increase.
clearWeaponCargoGlobal _crate;
clearItemCargoGlobal _crate;
clearMagazineCargoGlobal _crate; 
clearBackpackCargo _crate;

// Set ACE Parameters
[_crate, true, [0, 2, 1], 0] remoteExec ["ace_dragging_fnc_setCarryable", 0, true];
[_crate, _arsenalContents, true] call ace_arsenal_fnc_initBox;
[_crate, 1] call ace_cargo_fnc_setSize;

// Log it
[[player, _crateClass, _spawn_pos], {
	diag_log Format["[ASEC Spawners]: %1 spawned %2 at position %3", name (_this select 0), _this select 1, _this select 2];
}] remoteExec ["call", 2, false];

systemChat "A crate was spawned near you.";

_crate