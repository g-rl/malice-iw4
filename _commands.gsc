#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include scripts\_aimbot;
#include scripts\_functions;
#include scripts\_hooks;

Reloads()
{
    self endon("disconnect");
    for(;;)
    {
        self notifyOnPlayerCommand("r", "+r");
        self waittill("r");
        if(!self.pers["r"])
        {
		self thread AutoReloading();
		self iprintln("auto reloads ^2on");
		self.pers["r"] = true;
    	} else {
			self notify("notprone");
			self iprintln("no longer reloading");
			self.pers["r"] = false;
		}
	}
}


prones()
{
    self endon("disconnect");
    for(;;)
    {
        self notifyOnPlayerCommand("ap", "+ap");
        self waittill("ap");
        if(!self.pers["ap"])
        {
		self thread doRTProneShoot();
		self iprintln("auto prone ^2on");
		self.pers["ap"] = true;
    	} else {
			self notify("notprone");
			self iprintln("no longer autoproning");
			self.pers["ap"] = false;
		}
	}
}

alt_swap_cmd()
{
    self endon("disconnect");
    for(;;)
    {
        self notifyOnPlayerCommand("as", "+as");
        self waittill("as");
        if(!self.pers["alt_swap"])
        {
            self.pers["alt_swap"] = true;
            if(isSubStr(self.secondaryWeapon, "usp") || isSubStr(self.primaryWeapon, "usp"))
            {
                self giveWeapon("beretta_mp");
            } else {
                self giveWeapon("usp_mp");
            }
        } else {
            self.pers["alt_swap"] = false;
            if(isSubStr(self.secondaryWeapon, "usp") || isSubStr(self.primaryWeapon, "usp"))
            {
                self takeWeapon("beretta_mp");
            } else {
                self takeWeapon("usp_mp");
            }
        }
        self iPrintLn("alt swap " + bool_to_text(self.pers["alt_swap"]));
    }
}

allow_mara_mantle_cmd()
{
    self endon("disconnect");
    for(;;)
    {
        self notifyOnPlayerCommand("mantle", "+mantle");
        self waittill("mantle");
        if(!self.pers["allow_fast_mantle"])
        {
            self.pers["allow_fast_mantle"] = true;
            self maps\mp\perks\_perks::givePerk("specialty_fastmantle");
        } else {
            self.pers["allow_fast_mantle"] = false;
            self _unsetPerk("specialty_fastmantle");
        }
        self iPrintLn("fast mantle " + bool_to_text(self.pers["allow_fast_mantle"]));
    }
}

set0()
{
    for(;;)
    {
    self notifyOnPlayerCommand("set0", "+set0");
    self waittill("set0");   

	self setPlayerData( "experience" , 2516000 );
	self iPrintln("prestige set to ^6" + "none");
    }
}

set1()
{
    for(;;)
    {
    self notifyOnPlayerCommand("set1", "+set1");
    self waittill("set1");   
    
	self setPlayerData("prestige",1);
	self setPlayerData("experience",2516000);
	self iPrintln("prestige set to ^6" + "1");
}
}

set2()
{
    for(;;)
    {
    self notifyOnPlayerCommand("set2", "+set2");
    self waittill("set2");   
    
	self setPlayerData("prestige",2);
	self setPlayerData("experience",2516000);
	self iPrintln("prestige set to ^6" + "2");
    }
}

set3()
{
    for(;;)
    {
    self notifyOnPlayerCommand("set3", "+set3");
    self waittill("set3");   
    

	self setPlayerData("prestige",3);
	self setPlayerData("experience",2516000);
	self iPrintln("prestige set to ^6" + "3");
    }
}

set4()
{
    for(;;)
    {
    self notifyOnPlayerCommand("set4", "+set4");
    self waittill("set4");   
    
	self setPlayerData("prestige",4);
	self setPlayerData("experience",2516000);
	self iPrintln("prestige set to ^6" + "4");
}
}

set5()
{

    for(;;)
    {
    self notifyOnPlayerCommand("set5", "+set5");
    self waittill("set5");   
    

	self setPlayerData("prestige",5);
	self setPlayerData("experience",2516000);
	self iPrintln("prestige set to ^6" + "5");
}
}
set6()
{

        for(;;)
    {
    self notifyOnPlayerCommand("set6", "+set6");
    self waittill("set6");   
    


	self setPlayerData("prestige",6);
	self setPlayerData("experience",2516000);
	self iPrintln("prestige set to ^6" + "6");
}
}

set7()
{

    for(;;)
    {
    self notifyOnPlayerCommand("set7", "+set7");
    self waittill("set7");   
    
	self setPlayerData("prestige",7);
	self setPlayerData("experience",2516000);
	self iPrintln("prestige set to ^6" + "7");
}
}

set8()
{

    for(;;)
    {
    self notifyOnPlayerCommand("set8", "+set8");
    self waittill("set8");   
    


	self setPlayerData("prestige",8);
	self setPlayerData("experience",2516000);
	self iPrintln("prestige set to ^6" + "8");
    }
}

set9()
{

    for(;;)
    {
    self notifyOnPlayerCommand("set9", "+set9");
    self waittill("set9");   
    

	self setPlayerData("prestige",9);
	self setPlayerData("experience",2516000);
	self iPrintln("prestige set to ^6" + "9");
    }
}

set10()
{

    for(;;)
    {
    self notifyOnPlayerCommand("set10", "+set10");
    self waittill("set10");   
    
	self setPlayerData("prestige",10);
	self setPlayerData("experience",2516000);
	self iPrintln("prestige set to ^6" + "10");
}
}

set11()
{
    for(;;)
    {
    self notifyOnPlayerCommand("set11", "+set11");
    self waittill("set11");   
    
	self setPlayerData("prestige",11);
	self setPlayerData("experience",2516000);
	self iPrintln("prestige set to ^6" + "11");
}
}

allow_soh_cmd()
{
    self endon("disconnect");
    for(;;)
    {
        self notifyOnPlayerCommand("soh", "+soh");
        self waittill("soh");
        if(!self.pers["allow_soh"])
        {
            self.pers["allow_soh"] = true;
            if(!self _hasPerk("specialty_fastreload"))
                self _setperk("specialty_fastreload");
            if(!self _hasPerk("specialty_quickdraw"))
                self _setperk("specialty_quickdraw");
            self iPrintLn("sleight of hand ^2on");
        } else {
            self.pers["allow_soh"] = false;
            if(self _hasPerk("specialty_fastreload"))
                self _unsetperk("specialty_fastreload");
            if(self _hasPerk("specialty_quickdraw"))
                self _unsetperk("specialty_quickdraw");
            self iPrintLn("sleight of hand ^1off");
        }
    }
}

kill_cmd()
{
    self endon("disconnect");
    for(;;)
    {
        self notifyOnPlayerCommand("die", "+die");
        self waittill("die");
        self suicide();
    }
}

do_refill_all_cmd()
{
    self endon("disconnect");
    for(;;)
    {
        self notifyOnPlayerCommand("melee", "+melee");
        self waittill("melee");
        if(self getStance() == "crouch")
        {
            weapon_list = self GetWeaponsListAll();
            foreach ( weapon in weapon_list )
            {
                self giveMaxAmmo(weapon);
            }
        }
    }
}

DropBind()
{
	self endon("disconnect");
	for(;;)
	{
        self notifyOnPlayerCommand("melee", "+melee");
        self waittill("melee");
        if(self getStance() == "prone" && self adsButtonPressed())
        {
            self giveWeapon("mp5k_silencer_mp");
            self dropItem("mp5k_silencer_mp");
        }
	}
}

ResetRounds(){
    for(;;)
    {
    self notifyOnPlayerCommand("reset", "+reset");
    self waittill("reset");

	level.resetscores = true;
	allies = 0;
	game["roundsWon"]["axis"] = 0;
	game["roundsWon"]["allies"] = 0;
	game["roundsPlayed"] = 0;
	game["teamScores"]["allies"] = 0;
	game["teamScores"]["axis"] = 0;
	maps\mp\gametypes\_gamescore::updateTeamScore( "axis" );
	maps\mp\gametypes\_gamescore::updateTeamScore( "allies" );
	self iPrintln("^7rounds reset back to ^60^7.");
}
}

KickTheBots()
{
    for(;;)
    {
    self notifyOnPlayerCommand("kickbots", "+kickbots");
    self waittill("kickbots");
	foreach ( player in level.players )
	{
		if ( isDefined ( player.pers [ "isBot" ] ) && player.pers [ "isBot" ] ) kick ( player getEntityNumber(), "EXE_PLAYERKICKED" );
	}
}
}

Coords()
{
    self endon("disconnect");
    for(;;)
    {
        self notifyOnPlayerCommand("coords", "+coords");
        self waittill("coords");
        if(!self.pers["coords"])
        {
            self.pers["coords"] = true;
            self thread WatchCoords();
            self iPrintLnBold("now displaying ^6coordinates");
            self iprintln("unable to be turned off until ^6next round");
            self iprintln("origin ^1" + self.origin);
            self iprintln("angles ^1" + self.angles);
        wait 3;
        } else {
            self.pers["coords"] = false;
            self iPrintLnBold("no longer displaying ^6coordinates");
        }
    }
}

DoTimer()
{
    self endon("disconnect");
    for(;;)
    {
        self notifyOnPlayerCommand("timer", "+timer");
        self waittill("timer");
        if(!self.pers["timer"])
        {
            self.pers["timer"] = true;
	    self maps\mp\gametypes\_gamelogic::pauseTimer();
	    self.time = 1;
	    //self.stopmb = 1;
        self iPrintLnBold("timer has been ^6paused");
        wait 3;
        } else {
            self.pers["timer"] = false;
            self iPrintLnBold("no longer pausing ^6timer");
        }
    }
}

pred()
{
    self endon("disconnect");
    for(;;)
    {
        self notifyOnPlayerCommand("pred", "+pred");
        self waittill("pred");
        if(!self.pers["pred"])
        {
		self thread giveks("airdrop_predator_missile");
		self iprintln("pred missile ^2given");
    }
	}
}

sentry()
{
    self endon("disconnect");
    for(;;)
    {
        self notifyOnPlayerCommand("sentry", "+sentry");
        self waittill("sentry");
        if(!self.pers["sentry"])
        {
		self thread giveks("airdrop_sentry_minigun");
		self iprintln("sentry gun ^2given");
    }
	}
}

pckg()
{
    self endon("disconnect");
    for(;;)
    {
        self notifyOnPlayerCommand("pkg", "+pkg");
        self waittill("pkg");
        if(!self.pers["pkg"])
        {
		self thread giveks("airdrop");
		self iprintln("care package ^2given");
    }
	}
}

SpawnBots()
{
    self endon("disconnect");
    for(;;)
    {
        self notifyOnPlayerCommand("s", "+s");
        self waittill("s");
        if(!self.pers["s"])
        {
		exec("spawnbot");
    }
	}
}

QuickRestart()
{
    for(;;)
    {
    self notifyOnPlayerCommand("restart", "+restart");
    self waittill("restart");
	self thread KickTheBots();
	self iPrintln("^7kicked bots and ^3refreshing^7 map...");
	wait .2;
	self iPrintln("^3restarting^7 now...");
	map_restart(false);
	}
}

apply()
{
    self endon("disconnect");
    for(;;)
    {
        self notifyOnPlayerCommand("apply", "+a");
        self waittill("apply");
		self.camo = getDvarInt("camoindex");
		self thread SetCamo();
    }
}

CamoSet()
{
    self endon("disconnect");
    for(;;)
    {
        self notifyOnPlayerCommand("camo", "+c");
        self waittill("camo");
		i = randomintrange(0,8);
		setDvar("camoindex", i);
		self.camo = getDvarInt("camoindex");
		self thread SetCamo();
    }
}