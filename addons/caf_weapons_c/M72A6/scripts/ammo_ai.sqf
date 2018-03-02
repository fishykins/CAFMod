/*
	caf_disposable\s\ammo_ai.sqf
	by cafmpetent
	
	Main loop that runs indefinitely
	
	Executed from XEH_PostInit.sqf
*/

#define __cfgWeapon configFile >> "CfgWeapons" >> _weapon

waitUntil {
	_unitsArray = if (isServer) then {allUnits} else {units (group player)};
	{	// forEach loop
		if ((local _x) && !(isPlayer _x)) then
		{
			_weapon = secondaryWeapon _x;
			_weaponCfg = if ((getNumber (__cfgWeapon >> "caf_disposable")) == 1) then { 1 } else { 0 }; 
			_magazine = (getArray (__cfgWeapon >> "magazines")) select 0;
			if (_weaponCfg == 1) then
			{
				if !(_magazine in magazines _x) then
				{
					_x removeWeapon _weapon;
					_x addMagazine _magazine;
					_x addWeapon _weapon;
				};
			}
			else
			{
				{	// forEach loop
					if ((getNumber (configFile >> "CfgMagazines" >> _x >> "caf_disposable")) == 1) then
					{
						_unit removeMagazines _x;
					};
				} forEach magazines _x;
			};
		};
	} forEach _unitsArray;
	sleep (sqrt (count _unitsArray) + 10);
	false
};