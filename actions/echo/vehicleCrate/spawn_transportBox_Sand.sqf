#define SPAWN_DISTANCE -3 // Ensure spawn distance is negative if you want the crate to spawn on the correct side of the sign.
#define CRATE_CLASSNAME "Land_Cargo10_sand_F"

params ["_target", "_caller", "_actionId", "_arguments"];

// Determine where we should put the crate.
private _position = getPos _target;

// Spawn the crate at this location.
private _crate = CRATE_CLASSNAME createVehicle _position;
if (surfaceIsWater _spawn_pos) then {_crate setPosASL [((getPosASL _target) select 0) + (sizeOf (typeOf _target)),getPosASL _target select 1, getPosASL _target select 2];};

// Remove any items from the crate.
clearWeaponCargoGlobal _crate;
clearItemCargoGlobal _crate;
clearMagazineCargoGlobal _crate;
clearBackpackCargo _crate;

[_crate] remoteExec ["fnc_packIntoBox_transportBox"];

// Log the spawn. Just in case someone is trying to crash the server.
[[player, _position], {
	diag_log Format["[ASEC Spawners]: %1 spawned %2 at position %3", name (_this select 0), CRATE_CLASSNAME, _this select 1];
}] remoteExec ["call", 2, false];

systemChat "A crate was spawned near you.";

