private ["_box"];

_box = _this select 0;

[west, 500, false] call acex_fortify_fnc_updateBudget;
deleteVehicle _box;