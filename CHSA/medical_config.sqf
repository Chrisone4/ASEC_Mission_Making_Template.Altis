_arsenalType = "medical";
_target = sideUnknown;
_restrictionDistance = 5;
_specNames = ["Rifleman", "Officer", "Section Staff", "Section Medic", "Section MAAWS", "Light Machinegunner", "Medium Machinegunner", "Signaller/Radio Man", "Doctor", "Crewman", "Crewman Medic", "Marksman", "Engineer Section Staff", "Engineer", "Fixed Wing Pilot", "Golf Section Staff", "Gunner", "Mike Section Staff", "Mike Medic", "Hotel Pilot", "Heavy Anti-Tank", "Heavy Machinegunner", "Whiskey Staff", "Demolitions Technician"];
_specSlots = [-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1];
_specTypes = [
	["B_Soldier_lite_F"],
	["B_officer_F"],
	["B_Soldier_SL_F"],
	["B_medic_F"],
	["B_soldier_AT_F"],
	["B_soldier_AR_F"],
	["B_HeavyGunner_F"],
	["B_soldier_UAV_F"],
	["B_Patrol_Medic_F"],
	["B_crew_F"],
	["B_Soldier_A_F"],
	["B_soldier_M_F"],
	["B_soldier_exp_F"],
	["B_engineer_F"],
	["B_Pilot_F"],
	["B_support_MG_F"],
	["B_support_Mort_F"],
	["B_recon_medic_F"],
	["B_recon_medic_F"],
	["B_Helipilot_F"],
	["B_Patrol_Soldier_AT_F"],
	["B_Patrol_HeavyGunner_F"],
	["B_Patrol_Soldier_TL_F"]
];

//Medical Supplies
_infantryMedical = ["kat_crossPanel","ACE_fieldDressing","ACE_elasticBandage","ACE_packingBandage","ACE_quikclot","ACE_splint","ACE_tourniquet","kat_chestSeal","kat_bloodIV_A","kat_bloodIV_A_N","kat_bloodIV_AB","kat_bloodIV_AB_N","kat_bloodIV_B","kat_bloodIV_B_N","kat_bloodIV_A_250","kat_bloodIV_AB_250","kat_bloodIV_AB_250_N","kat_bloodIV_A_250_N","kat_bloodIV_B_250","kat_bloodIV_B_250_N","kat_bloodIV_A_500","kat_bloodIV_A_500_N","kat_bloodIV_AB_500","kat_bloodIV_AB_500_N","kat_bloodIV_B_500","kat_bloodIV_B_500_N","kat_Painkiller"];
_sectionMedical = ["kat_guedel","kat_Pulseoximeter","kat_stethoscope","ACE_surgicalKit","ACE_morphine","ACE_adenosine","KAT_IV_16","kat_carbonate","ACE_epinephrine","kat_IO_Fast"] + _infantryMedical;
_doctorMedical = ["kat_bloodIV_O_500_N","kat_bloodIV_O_N","kat_bloodIV_O_250_N","kat_aatKit","kat_accuvac","kat_X_AED","kat_AED","kat_larynx","ACE_personalAidKit","kat_X_AED","kat_larynx","kat_lidocaine","kat_naloxone","kat_nitroglycerin","kat_norepinephrine","kat_phenylephrine","kat_amiodarone","kat_atropine","kat_AED","kat_aatKit","kat_accuvac","ACE_personalAidKit","kat_TXA"] + _infantryMedical + _sectionMedical;

/***********************************************************************************************/

_specNames = ["Rifleman", "Officer", "Section Staff", "Section Medic", "Section MAAWS", "Light Machinegunner", "Medium Machinegunner", "Signaller/Radio Man", "Doctor", "Crewman", "Crewman Medic", "Marksman", "Engineer Section Staff", "Engineer", "Fixed Wing Pilot", "Golf Section Staff", "Gunner", "Mike Section Staff", "Mike Medic", "Hotel Pilot"];

_specItems = [_infantryMedical, _infantryMedical, _infantryMedical, _sectionMedical, _infantryMedical, _infantryMedical, _infantryMedical, _infantryMedical, _doctorMedical, _infantryMedical, _infantryMedical, _infantryMedical, _infantryMedical, _infantryMedical, _infantryMedical, _infantryMedical, _infantryMedical, _doctorMedical, _doctorMedical, _infantryMedical];

[_target, [_this select 0, _restrictionDistance, _specNames, _specSlots, _specTypes, _specItems, _arsenalType]] spawn CHSA_fnc_executeLocalArsenal;