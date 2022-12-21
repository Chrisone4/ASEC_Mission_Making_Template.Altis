/*
Script by Thunderbolt (chrisone4)

Example: Add the follow to init to set as repair bay
Eden:	[this] execVM "actions\echo\fortify\echoPresets.sqf";
[
	_presetDatabase, // Object to be set as a repair bay
] execVM "actions\echo\fortify\echoPresets.sqf";
*/

params [ 
	["_presetDatabase", objNull, [objNull]]
];


if (isNil "FP_fnc_preset_options" || isNil "FP_fnc_preset_one" || isNil "FP_fnc_preset_two" || isNil "FP_fnc_preset_three" || isNil "FP_fnc_preset_four" ||  isNil "FP_fnc_preset_five" || isNil "FP_fnc_preset_six" || isNil "FP_fnc_preset_seven" || isNil "FP_fnc_preset_eight" || isNil "FP_fnc_preset_nine" || isNil "FP_fnc_preset_ten" || isNil "FP_fnc_preset_eleven" || isNil "FP_fnc_preset_twelve" || isNil "FP_fnc_preset_thirteen"|| isNil "FP_fnc_preset_fourteen"|| isNil "FP_fnc_preset_fifteen" ) then {
	FP_fnc_preset_options = {
			params ["_presetDatabase"];
			
			private _presetChild = [];
			
			_presetChild pushBack [[
				"preset_one",
				"Out In Field-Tan",
				"\A3\ui_f\data\igui\cfg\actions\ico_OFF_ca.paa",
				{_this call FP_fnc_preset_one},
				{true},
				{},
				[_presetDatabase]
			] call ace_interact_menu_fnc_createAction, [], 1];
			
			_presetChild pushBack [[
				"preset_two",
				"Out In Field-Green",
				"\A3\ui_f\data\igui\cfg\actions\ico_OFF_ca.paa",
				{_this call FP_fnc_preset_two},
				{true},
				{},
				[_presetDatabase]
			] call ace_interact_menu_fnc_createAction, [], 1];
			
			_presetChild pushBack [[
				"preset_three",
				"Defences",
				"\A3\ui_f\data\igui\cfg\actions\ico_OFF_ca.paa",
				{_this call FP_fnc_preset_three},
				{true},
				{},
				[_presetDatabase]
			] call ace_interact_menu_fnc_createAction, [], 1];
			
			_presetChild pushBack [[
				"preset_four",
				"CCP",
				"\A3\ui_f\data\igui\cfg\actions\ico_OFF_ca.paa",
				{_this call FP_fnc_preset_four},
				{true},
				{},
				[_presetDatabase]
			] call ace_interact_menu_fnc_createAction, [], 1];
			
			_presetChild pushBack [[
				"preset_five",
				"FOB Walls/Defences - Tan",
				"\A3\ui_f\data\igui\cfg\actions\ico_OFF_ca.paa",
				{_this call FP_fnc_preset_five},
				{true},
				{},
				[_presetDatabase]
			] call ace_interact_menu_fnc_createAction, [], 1];
			
			_presetChild pushBack [[
				"preset_six",
				"FOB Interior - Tan",
				"\A3\ui_f\data\igui\cfg\actions\ico_OFF_ca.paa",
				{_this call FP_fnc_preset_six},
				{true},
				{},
				[_presetDatabase]
			] call ace_interact_menu_fnc_createAction, [], 1];
			
			_presetChild pushBack [[
				"preset_seven",
				"FOB Walls/Defences - Green",
				"\A3\ui_f\data\igui\cfg\actions\ico_OFF_ca.paa",
				{_this call FP_fnc_preset_seven},
				{true},
				{},
				[_presetDatabase]
			] call ace_interact_menu_fnc_createAction, [], 1];
			
			_presetChild pushBack [[
				"preset_eight",
				"FOB Interior - Green",
				"\A3\ui_f\data\igui\cfg\actions\ico_OFF_ca.paa",
				{_this call FP_fnc_preset_eight},
				{true},
				{},
				[_presetDatabase]
			] call ace_interact_menu_fnc_createAction, [], 1];
			
			_presetChild pushBack [[
				"preset_nine",
				"FOB Extras",
				"\A3\ui_f\data\igui\cfg\actions\ico_OFF_ca.paa",
				{_this call FP_fnc_preset_nine},
				{true},
				{},
				[_presetDatabase]
			] call ace_interact_menu_fnc_createAction, [], 1];
			
			_presetChild pushBack [[
				"preset_ten",
				"Bridges",
				"\A3\ui_f\data\igui\cfg\actions\ico_OFF_ca.paa",
				{_this call FP_fnc_preset_ten},
				{true},
				{},
				[_presetDatabase]
			] call ace_interact_menu_fnc_createAction, [], 1];
			
			_presetChild pushBack [[
				"preset_eleven",
				"VCP - Tan",
				"\A3\ui_f\data\igui\cfg\actions\ico_OFF_ca.paa",
				{_this call FP_fnc_preset_eleven},
				{true},
				{},
				[_presetDatabase]
			] call ace_interact_menu_fnc_createAction, [], 1];
			
			_presetChild pushBack [[
				"preset_twelve",
				"VCP - Green",
				"\A3\ui_f\data\igui\cfg\actions\ico_OFF_ca.paa",
				{_this call FP_fnc_preset_twelve},
				{true},
				{},
				[_presetDatabase]
			] call ace_interact_menu_fnc_createAction, [], 1];
			
			_presetChild pushBack [[
				"preset_thirteen",
				"Camo Nets - Tan",
				"\A3\ui_f\data\igui\cfg\actions\ico_OFF_ca.paa",
				{_this call FP_fnc_preset_thirteen},
				{true},
				{},
				[_presetDatabase]
			] call ace_interact_menu_fnc_createAction, [], 1];
			
			_presetChild pushBack [[
				"preset_fourteen",
				"Camo Nets - Green",
				"\A3\ui_f\data\igui\cfg\actions\ico_OFF_ca.paa",
				{_this call FP_fnc_preset_fourteen},
				{true},
				{},
				[_presetDatabase]
			] call ace_interact_menu_fnc_createAction, [], 1];
			
			_presetChild pushBack [[
				"preset_fifteen",
				"CBRN Decon",
				"\A3\ui_f\data\igui\cfg\actions\ico_OFF_ca.paa",
				{_this call FP_fnc_preset_fifteen},
				{true},
				{},
				[_presetDatabase]
			] call ace_interact_menu_fnc_createAction, [], 1];
			
		_presetChild
	};
	
	FP_fnc_preset_one = {
		remoteExec ["fnc_preset_one"];
	}; 
	
	FP_fnc_preset_two = {
		remoteExec ["fnc_preset_two"];
	}; 
	
	FP_fnc_preset_three = {
		remoteExec ["fnc_preset_three"];
	};
	
	FP_fnc_preset_four = {
		remoteExec ["fnc_preset_four"];
	}; 
	
	FP_fnc_preset_five = {
		remoteExec ["fnc_preset_five"];
	}; 
	
	FP_fnc_preset_six = {
		remoteExec ["fnc_preset_six"];
	}; 
	
	FP_fnc_preset_seven = {
		remoteExec ["fnc_preset_seven"];
	};
	
	FP_fnc_preset_eight = {
		remoteExec ["fnc_preset_eight"];
	};
	
	FP_fnc_preset_nine = {
		remoteExec ["fnc_preset_nine"];
	};
	
	FP_fnc_preset_ten = {
		remoteExec ["fnc_preset_ten"];
	};
	
	FP_fnc_preset_eleven = {
		remoteExec ["fnc_preset_eleven"];
	};
	
	FP_fnc_preset_twelve = {
		remoteExec ["fnc_preset_twelve"];
	};
	
	FP_fnc_preset_thirteen = {
		remoteExec ["fnc_preset_thirteen"];
	};
	
	FP_fnc_preset_fourteen = {
		remoteExec ["fnc_preset_fourteen"];
	};
	
	FP_fnc_preset_fifteen = {
		remoteExec ["fnc_preset_fifteen"];
	};
};

private _choosePreset = [
	"choose_preset_Options",
	"Echo Fortify Presets",
	"\A3\ui_f\data\igui\cfg\actions\ico_OFF_ca.paa",
	{},
	{player getVariable["ACE_isEngineer",0] > 1},
	{_this call FP_fnc_preset_options},
	[_presetDatabase]
] call ace_interact_menu_fnc_createAction;
[_presetDatabase, 0, ["ACE_MainActions"], _choosePreset] call ace_interact_menu_fnc_addActionToObject;
