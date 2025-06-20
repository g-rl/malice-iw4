#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include scripts\_functions;
#include scripts\_commands;
#include scripts\_hooks;

GetTrace()
{
    x = bullettrace(self gettagorigin("j_head"), self gettagorigin("j_head") + anglesToForward(self getplayerangles()) * 1000000, 0, self)["position"];
    return x;
}

GetBulletTrace()
{
    start = self geteye();
    end = start + anglestoforward(self getplayerangles()) * 1000000;
    x = bullettrace(start, end, false, self)["position"];
    return x;
}

Aimbot(x)
{
    for(;;)
    {
        self waittill("weapon_fired");
        foreach(player in level.players)
        {
            if(player.pers["team"] != self.pers["team"])
            {
					//weaponclass = getweaponclass(self getCurrentWeapon());
					y = self getCurrentWeapon();
					if (malice_weapons_Aimbot(y))
					{
                        trace = getBulletTrace();

                        if(distance(player.origin,trace) < x)
                        {
                            self Hitmarker(); 
                            player thread  [[level.callbackPlayerDamage]]( self, self, 99999, 8, "MOD_RIFLE_BULLET", self getcurrentweapon(), player.origin + (0,0,0), (0,0,0), "neck", 0 );
                        
                }      
					}
					
			
            } 
        }
    }
}

Hitmarker()
{
    self thread maps\mp\gametypes\_damagefeedback::updateDamageFeedback();
    self playlocalsound("MP_hit_alert");
}