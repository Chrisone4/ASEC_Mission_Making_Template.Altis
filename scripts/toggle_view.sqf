// On downed
["ace_unconscious", {
    params [["_unit", objNull],["_state", false]];
    if (!(isPlayer _unit) || (_unit != player)) exitWith {}; // only run if player or if downed is not THE player
    _isUp = player getVariable ["ACE_isUnconscious", true];
    
    // if player is down
    if (_state && _isUp) then {
        [true, false, false] call ace_spectator_fnc_setSpectator;
        [[2], [0,1]] call ace_spectator_fnc_updateCameraModes;
        [[], [west,east,civilian,independent]] call ace_spectator_fnc_updateSides;
        [[-2,-1,0,1], [2,3,4,5,6,7]] call ace_spectator_fnc_updateVisionModes;
        [2, _unit, -2, (player modelToWorld [0, 10, 10])] call ace_spectator_fnc_setCameraAttributes;
		
		_unit getVariable ["TFAR_forceSpectator",true];
    };

    // if player is up
    if (!_state && !_isUp) then {
        [false, false, false] call ace_spectator_fnc_setSpectator;
		
		_unit getVariable ["TFAR_forceSpectator",false];
    };
}] call CBA_fnc_addEventHandler;

// On death
["ace_killed", {
    params [["_unit", objNull],["_state", false]];
    
    if (!(isPlayer _unit) || (_unit != player)) exitWith {}; // only run if player or if downed is not THE player
    [false, false, false] call ace_spectator_fnc_setSpectator;
    //Resets the Unit to fix spectator -> Death -> Respawn Screen bug
    [_unit] call ace_common_fnc_resetAllDefaults;
	
	//_unit getVariable ["TFAR_forceSpectator",false];
}] call CBA_fnc_addEventHandler;