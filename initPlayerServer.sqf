//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ Zues Global Server Settings ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//

{
	_x addCuratorEditableObjects [[player],true ];
} forEach AllCurators;

{
	if (!isnull (getassignedcuratorunit _x)) then {
		_unit = getassignedcuratorunit _x;
		if (isnull (getassignedcuratorlogic _unit)) then {
			unassignCurator _x;
			sleep 1;
			_unit assignCurator _x;
		};
	};
} foreach allcurators;
