_specIndex = _this select 0;
_obj = _this select 1;
_arsenalType = _this select 2;
_specItems = _obj getVariable ["CHSA_specItems", []];

_itemsArray = _specItems select _specIndex;
/*
_allItems = []; 

{
	_arraySelected = _x; {
		_allItems pushBack _x;
	} forEach _arraySelected;
} forEach (_specItems - _itemsArray);

_restrictedItems = _allItems - _itemsArray;

{
	_item = _x;
	switch (true) do {
		case (_item in weapons player): {
			player removeWeapon _item;		
		};
		case (_item in items player): {
			player removeItems _item;	
		};
		case (headgear player == _item): {
			removeHeadgear player;		
		};
		case (goggles player == _item): {
			removeGoggles player;		
		};
		case (vest player == _item): {
			removeVest player;		
		};
		case (backpack player == _item): {
			removeBackpack player;		
		};
		case (uniform player == _item): {
			removeUniform player;		
		};
		case ({_x select 0 == _item} count (magazinesAmmoFull player) > 0): {
			player removeMagazines _item;
			if (_item in (primaryWeaponMagazine player + secondaryWeaponMagazine player + handgunMagazine player)) then {
				player removePrimaryWeaponItem _item;
				player removeSecondaryWeaponItem _item;
				player removeHandgunItem _item;
			};
		};
		case default {
			player removePrimaryWeaponItem _item;
			player removeSecondaryWeaponItem _item;
			player removeHandgunItem _item;
			player unlinkItem _item;
			player unassignItem _item;
		};
	};
} forEach _restrictedItems;
*/

if(_arsenalType == "main") exitWith {
	_obj addAction ["<img image='\A3\Ui_f\data\Logos\a_64_ca.paa' width='64' height='64' /> " + localize "STR_A3_Arsenal", "[arsenal_database, player] call ace_arsenal_fnc_openBox;"];
	[arsenal_database, _itemsArray] call ace_arsenal_fnc_addVirtualItems;
};

if(_arsenalType == "medical") exitWith {
	_obj addAction ["<img image='\A3\Ui_f\data\Logos\a_64_ca.paa' width='64' height='64' /> " + localize "STR_A3_Arsenal", "[medical_arsenalDatabase, player] call ace_arsenal_fnc_openBox;"];
	[medical_arsenalDatabase, _itemsArray] call ace_arsenal_fnc_addVirtualItems;
};