//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ Unconscious Camera Required Lines ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//

[false, false, false] call ace_spectator_fnc_setSpectator;

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ Global Respawn/Loadout Server Settings ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//

comment "Exported from Arsenal by ASEC";

comment "[!] UNIT MUST BE LOCAL [!]";
if (!local player) exitWith {};

comment "Remove existing items";

comment "Exported from Arsenal by ASEC";

comment "[!] UNIT MUST BE LOCAL [!]";
if (!local player) exitWith {};

// Removing all items in players' inventories

//comment "Remove existing items";
removeAllWeapons player;
removeAllItems player;
removeAllAssignedItems player;
removeUniform player;
removeVest player;
removeBackpack player;
removeHeadgear player;
removeGoggles player;

// Adding items to players' inventories upon load in and respawn. (Default kits)
player forceAddUniform "USP_G3C_MC";

// Adds Binoculars
//comment "Add binoculars";
player addWeapon "ACE_Vector";

// Uniform Loadout
//comment "Add items to containers"; 
for "_i" from 1 to 1 do {player addItemToUniform "ACE_EarPlugs";};
for "_i" from 1 to 4 do {player addItemToUniform "ACE_tourniquet";};
for "_i" from 1 to 4 do {player addItemToUniform "ACE_splint";};
for "_i" from 1 to 1 do {player addItemToUniform "ACE_MapTools";};
for "_i" from 1 to 1 do {player addItemToUniform "ACE_Flashlight_XL50";};
for "_i" from 1 to 3 do {player addItemToUniform "ACE_CableTie";};

// Misc Items
//comment "Add items";
//player linkItem "ItemMap";
//player linkItem "ItemCompass";
//player linkItem "ItemWatch";
//player linkItem "TFAR_anprc152";
//player linkItem "ItemGPS";