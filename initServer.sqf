//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ Zeus Global Server Settings ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//

["Initialize", [true]] call BIS_fnc_dynamicGroups;

[west, -1] call BIS_fnc_respawnTickets;

if (!isServer) exitWith {};

	//--- Curator settings
	_curator = allcurators select 0;
	_curators = allcurators;
		{
			_x setcuratorcoef ["place",0];
			_x setcuratorcoef ["delete",0];
		} foreach _curators;
		

