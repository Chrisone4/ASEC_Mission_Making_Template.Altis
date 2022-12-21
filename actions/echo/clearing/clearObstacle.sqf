/*
Script by Thunderbolt (chrisone4)

Example: Add the follow to init to set as repair bay
Eden:	[this] execVM "actions\echo\clearing\clearObstacle.sqf";
Zeus:	[_this] execVM "actions\echo\clearing\clearObstacle.sqf";
[
	_obstacle, // Object to be able to be removed.
] execVM "actions\echo\clearing\clearObstacle.sqf";
*/

//Todo 
//Make it possible for nearby obstacles to disappear too?

#define EXPLOSIVE_DEVICE "DemoCharge_Remote_Mag"
#define EXPLOSIVE_DEVICE_AMMO "DemoCharge_Remote_Ammo"
#define FIRING_DEVICE "ACE_M26_Clacker"

#define DIG_TIMER 60
#define EXPLOSION_TIMER 60

params [
	["_obstacle", objNull, [objNull]]
];

if (isNil "ASEC_fnc_canRemove" || isNil "ASEC_fnc_removeObs" || isNil "ASEC_fnc_detonateObs_rigged") then {
	ASEC_fnc_canRemove = {
		params ["_obstacle"];
		private _removeObstacleChild = [];
		
		_removeObstacleChild pushBack [[
			"ASEC_removeObstacle",
			"Tear Down",
			"\A3\ui_f\data\igui\cfg\actions\repair_ca.paa",
			{_this call ASEC_fnc_removeObs},
			{"ACE_EntrenchingTool" in (player call ace_common_fnc_uniqueItems)},
			{},
			[_obstacle]
		] call ace_interact_menu_fnc_createAction, [], 1];
		
		_removeObstacleChild pushBack [[
			"ASEC_detonateObstacle_rigged",
			"Place Demolition Charge and rig to Firing Device",
			"\A3\ui_f\data\igui\cfg\actions\settimer_ca.paa", //Change image?
			{_this call ASEC_fnc_detonateObs_rigged},
			{(EXPLOSIVE_DEVICE in magazines player) && (FIRING_DEVICE in (player call ace_common_fnc_uniqueItems)) && (player getVariable["ACE_isEngineer",0] > 1)},
			{},
			[_obstacle]
		] call ace_interact_menu_fnc_createAction, [], 1];
		
		_removeObstacleChild pushBack [[
			"ASEC_detonateObstacle_timer",
			"Place Demolition Charge and rig to Timer",
			"\A3\ui_f\data\igui\cfg\actions\settimer_ca.paa",
			{_this call ASEC_fnc_detonateObs_timer},
			{(EXPLOSIVE_DEVICE in magazines player) && (player getVariable["ACE_isEngineer",0] > 1)},
			{},
			[_obstacle]
		] call ace_interact_menu_fnc_createAction, [], 1];
		
		_removeObstacleChild;
	};
	
	ASEC_fnc_removeObs = {
		(_this select 2) params ["_obstacle", "", "_this"];
		
		/*
		Ideal _clearTimer = 120 (Which includes repair Facility time reduction AND Trench Like removal (Saves the relative time of the Obstacle if player leaves)
		_clearTimer = 120 (Which Includes Repair Facility time reduction)
		*/
		private _clearTimer = DIG_TIMER;
		if(player getVariable["ACE_isEngineer",0] > 1) then {
			_clearTimer = _clearTimer/2;
			
			/*
			if(ACE_isRepairFacility) then {
				_clearTimer = _clearTimer/2;
			};
			*/
		};
	
		private _animation = getText (ConfigFile >> "ACE_Repair" >> "Actions" >> "MiscRepair" >> "animationCaller");
		player playMoveNow _animation;
		
		[
			_clearTimer, [_obstacle], {
				(_this select 0) params ["_obstacle"];
				
				player switchMove '';
				
				deleteVehicle _obstacle;
			},
			{
				player switchMove '';
			},
			format ["Removing Obstacle...", _name]
		] call ace_common_fnc_progressBar;
	}; 
	
	ASEC_fnc_detonateObs_rigged = {
		(_this select 2) params ["_obstacle", "", "_this"];
		
		private _placeDemoTimer = 5;
		
		private _animation = getText (ConfigFile >> "ACE_Repair" >> "Actions" >> "MiscRepair" >> "animationCaller");
		player playMoveNow _animation;
		
		[
			_placeDemoTimer, [_obstacle], {
				(_this select 0) params ["_obstacle"];
				
				player switchMove '';
				
				player removeItem EXPLOSIVE_DEVICE;
				
				private _position = getPosATL _obstacle;
					
				_demoCharge = createVehicle [EXPLOSIVE_DEVICE_AMMO, _position];	
				[player, _demoCharge, FIRING_DEVICE] call ace_explosives_fnc_connectExplosive;	

				[
					{
						params ["_demoCharge",""];
						!alive _demoCharge
					}, 
					{		
						params ["","_obstacle"];
						"M_Mo_82mm_AT_LG" createVehicle (getPos _obstacle);
						deleteVehicle _obstacle;
					}, [_demoCharge, _obstacle]
				] call CBA_fnc_waitUntilAndExecute;				
			},
			{
				player switchMove '';
			},
			format ["Placing Charge...", _name]
		] call ace_common_fnc_progressBar;
	};
	
	ASEC_fnc_detonateObs_timer = {
		(_this select 2) params ["_obstacle", "", "_this"];
		
		private _placeDemoTimer = 5;
		
		private _animation = getText (ConfigFile >> "ACE_Repair" >> "Actions" >> "MiscRepair" >> "animationCaller");
		player playMoveNow _animation;
		
		[
			_placeDemoTimer, [_obstacle], {
				(_this select 0) params ["_obstacle"];
				
				player switchMove '';
				
				player removeItem EXPLOSIVE_DEVICE;		

				private _timeUntilDetonation = EXPLOSION_TIMER;
				private _output = format["Charge placed, %1 seconds until detonation", _timeUntilDetonation];
				[_output, 2, player] call ace_common_fnc_displayTextStructured;
				
				[
					{
						params ["_obstacle"];
						"M_Mo_82mm_AT_LG" createVehicle (getPos _obstacle);
						deleteVehicle _obstacle;
					}, [_obstacle], _timeUntilDetonation
				] call CBA_fnc_waitAndExecute;
			},
			{
				player switchMove '';
			},
			format ["Placing Charge...", _name]
		] call ace_common_fnc_progressBar;
	};
};

private _removeObstacleAction = [
	"ASEC_removeObstacle_Option",
	"Remove Obstacle", //Get name of classID
	"\A3\ui_f\data\igui\cfg\cursors\explosive_ca.paa", //Change images
	{},
	{true},
	{_this call ASEC_fnc_canRemove},
	[_obstacle]
] call ace_interact_menu_fnc_createAction;
[_obstacle, 0, ["ACE_MainActions"], _removeObstacleAction] call ace_interact_menu_fnc_addActionToObject;

/*
//Optional Blurry
//Place in CBA_fnc_waitAndExecute or CBA_fnc_waitUntilAndExecute
private _distance = (getPos _obstacle) distance getPos player;

//blurry screen with cam shake
if (_distance < 40) then {
	[] spawn {
		addCamShake [1, 3, 3];

		private _blur = ppEffectCreate ["DynamicBlur", 474];
		_blur ppEffectEnable true;
		_blur ppEffectAdjust [0];
		_blur ppEffectCommit 0;

		waitUntil {ppEffectCommitted _blur};

		_blur ppEffectAdjust [10];
		_blur ppEffectCommit 0;

		_blur ppEffectAdjust [0];
		_blur ppEffectCommit 5;

		waitUntil {ppEffectCommitted _blur};

		_blur ppEffectEnable false;
		ppEffectDestroy _blur;
	};
};
*/