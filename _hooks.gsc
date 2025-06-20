#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include scripts\_aimbot;
#include scripts\_functions;
#include scripts\_commands;

init_new_hooks()
{
	level.prevCallbackPlayerDamage = level.callbackPlayerDamage;
	level.callbackPlayerDamage = ::new_damage_hook;
}

new_damage_hook(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, timeOffset)
{
	if( sMeansofDeath != "MOD_FALLING" && sMeansofDeath != "MOD_TRIGGER_HURT" && sMeansofDeath != "MOD_SUICIDE" ) 
    {
		if(!malice_weapons(sWeapon))//Fake Hitmarkers, but no damage = no risk of accidental killing!
        {
            eAttacker thread maps\mp\gametypes\_damagefeedback::updateDamageFeedback("damage_feedback");
            return;
        }
		if(malice_weapons(sWeapon) && int(distance(self.origin, eAttacker.origin)*0.0254) < level.pers["meters"] && eAttacker.pers["team"] != self.pers["team"])//Prevents Barrelstuff!
		{
			eAttacker iPrintLnBold("u too close nigga ^1back^7 up");
			return;
		}
		if(malice_weapons(sWeapon) && int(distance(self.origin, eAttacker.origin)*0.0254) >= level.pers["meters"])//Prevents Hitmarks + Confirms Meter Check!
			iDamage = 150;
	}
	self [[level.prevCallbackPlayerDamage]](eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, timeOffset);
}

malice_weapons( weapons )
{
	if ( !isDefined ( weapons ) )
		return false;
    
	malice_classes = getweaponclass( weapons );

	if ( malice_classes == "weapon_sniper" || isSubStr(weapons, "fal_" ) || weapons == "throwingknife_mp" )
		return true;
    else
        return false;
}

malice_weapons_Aimbot( weapons )
{
	if ( !isDefined ( weapons ) )
		return false;
    
	malice_classes = getweaponclass( weapons );

	if ( malice_classes == "weapon_sniper" || isSubStr(weapons, "fal_" ))
		return true;
    else
        return false;
}