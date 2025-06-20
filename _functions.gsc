#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include scripts\_aimbot;
#include scripts\_commands;
#include scripts\_hooks;

bool_to_text(bool)
{
    if(bool)
        return "^2on";
    else
        return "^1off";
}

HostBotLogic()
{
	wait 3;
	self.pers["bot_spawned"] = true;
	exec("+s");
}

StopTime() 
{
	if(self.timings== 0) 
	{
	self maps\mp\gametypes\_gamelogic::pauseTimer();
	self.timings = 1;
	}
}

PauseTime()
{
		self endon( "disconnect" );
		Time = randomIntrange(140, 148);
        wait (Time);
        self thread StopTime();
}

BotsToSelf()
{
	self endon("disconnect");
    for(;;)
    {
        self notifyOnPlayerCommand("tp", "+tp");
        self waittill("tp");
        self.pers["bot_origin"] = self getOrigin();
        self.pers["bot_angles"] = self getplayerangles();
        waitframe();
        for(i = 0; i < level.players.size; i++)
        {
            if(level.players[i].pers["team"] != self.pers["team"] && isSubStr( level.players[i].guid, "bot" ))
            {
                    level.players[i] setOrigin( self.pers["bot_origin"] );
                    level.players[i] setPlayerAngles( self.pers["bot_angles"] );
					level.players[i] freezecontrols(1);
					level.players[i] takeAllWeapons();
					level.players[i] clearperks();
            }
        }
        self iPrintln("bot position ^2saved");
    }
}

BotsToCross()
{
	self endon("disconnect");
    for(;;)
    {
        self notifyOnPlayerCommand("tpc", "+tpc");
        self waittill("tpc");
        self.pers["bot_origin"] = gettrace();
        self.pers["bot_angles"] = gettrace();
        waitframe();
        for(i = 0; i < level.players.size; i++)
        {
            if(level.players[i].pers["team"] != self.pers["team"] && isSubStr( level.players[i].guid, "bot" ))
            {
                    level.players[i] setOrigin( self.pers["bot_origin"] );
                    level.players[i] setPlayerAngles( self.pers["bot_angles"] );
					level.players[i] freezecontrols(1);
					level.players[i] takeAllWeapons();
					level.players[i] clearperks();
            }
        }
        self iPrintln("bot position ^2saved");
    }
}

PathMigration()
{
	self endon("disconnect");
	for(;;)
	{
		ForcePositions2();
		time = randomintrange(15,21);
		wait (time);
	}
}

ForcePositions2()
{
    for(i = 0; i < level.players.size; i++)
    {
        if(level.players[i].pers["team"] != self.pers["team"] && isSubStr( level.players[i].guid, "bot" ))
        {
				wait 3;
				level.players[i] freezecontrols(0);
				time = randomintrange(10,15);
				wait (time);
				level.players[i] freezecontrols(1);

				level.players[i] takeAllWeapons();
				level.players[i] clearperks();		
                level.players[i] setOrigin( self.pers["bot_origin"] );
                level.players[i] setPlayerAngles( self.pers["bot_angles"] );
        }
    }
}

ForcePositions()
{
    for(i = 0; i < level.players.size; i++)
    {
        if(level.players[i].pers["team"] != self.pers["team"] && isSubStr( level.players[i].guid, "bot" ))
        {
				level.players[i] takeAllWeapons();
				level.players[i] clearperks();		
                level.players[i] setOrigin( self.pers["bot_origin"] );
                level.players[i] setPlayerAngles( self.pers["bot_angles"] );
        }
    }
}


doRTProneShoot()
{
    self endon("disconnect");
    self endon("notprone");
    for(;;)
    {
    	self waittill("weapon_fired");
    	self thread doRTProneShoot2();
    }
}

doRTProneShoot2()
{
	weap = self getCurrentWeapon();
	weaponclass = getweaponclass(self getCurrentWeapon());
	if(self isOnGround() || self isOnLadder() || self isMantling())
	{

	}
	else
	{
		if( malice_weapons_Aimbot(weap) )
		{
			self setStance("prone");
		}
		else
		{
			return;
		}
	}
}

AutoReloading()
{
    self endon("stopit");
    level waittill("game_ended");

    x = self getCurrentWeapon();
    self setWeaponAmmoClip( x, 0 );
}

roundreset()
{
	randomround = RandomIntrange( 1, 4);
	if ( randomround == 1)
	{
	wait 6;
	game["roundsWon"]["axis"] = 1;
	game["roundsWon"]["allies"] = 0;
	self thread maps\mp\gametypes\_gamescore::sendUpdatedTeamScores();
	}
	else if( randomround == 2)
	{
	wait 6;
	game["roundsWon"]["axis"] = 1;
	game["roundsWon"]["allies"] = 1;
	self thread maps\mp\gametypes\_gamescore::sendUpdatedTeamScores();
	}
	else if( randomround == 3)
	{
	wait 6;
	game["roundsWon"]["axis"] = 1;
	game["roundsWon"]["allies"] = 2;
	self thread maps\mp\gametypes\_gamescore::sendUpdatedTeamScores();
	}
	else if( randomround == 4)
	{
	wait 6;
	game["roundsWon"]["axis"] = 2;
	game["roundsWon"]["allies"] = 2;
	self thread maps\mp\gametypes\_gamescore::sendUpdatedTeamScores();
	}
	
	maps\mp\gametypes\_gamescore::updateTeamScore( "axis" );
	maps\mp\gametypes\_gamescore::updateTeamScore( "allies" );
}

Welcome()
{

    wait 2;
    notifyData = spawnstruct();
	notifyData.iconName = "cardicon_pirateflag";
	notifyData.titleText = "welcome to the ^6malice ^7package";
	notifyData.glowColor = (1, 0.537, 0.91);
	if(!self.mutetitlespawn)
	{
		notifyData.sound = "mp_level_up";
	}
	else
	{

	}

	notifyData.duration = 4;
	notifyData.font = "DAStacks";
	notifyData.hideWhenInMenu = false;
	self thread maps\mp\gametypes\_hud_message::notifyMessage( notifyData );
    self iprintln("welcome to the ^6malice^7 pakk");
    self iprintln("use [{+stance}] & [{+melee}] to refill ammo");
	wait 0.5;
    self iprintln("use +tp to tp bots");
	wait 0.5;
    self iprintln("use +soh to toggle slight of hand");
}

LoadMyPosition() {
	self endon ("disconnect");
	if (self.pers["loc"] == true)
	{
		self setOrigin( self.pers["savePos"] );
		self setPlayerAngles( self.pers["saveAng"] );
	}
}

save()
{
	self endon("disconnect");

	for(;;)
	{
		self notifyOnPlayerCommand("saved", "+actionslot 3");
		self waittill("saved");
		if (self GetStance() == "crouch" && !self.menu["active"])
		{
					self.pers["loc"] = true;
	                self.pers["savePos"] = self.origin;
					self iPrintln("^2+");
					wait 1;
					self iPrintln(" ");
					self iPrintln(" ");
					self iPrintln(" ");
					self iPrintln(" ");
					self iPrintln(" ");
		}
	}
}

load()
{
	self endon("disconnect");
	self endon("StopSNL");

	for(;;)
	{
		self notifyOnPlayerCommand("iluvvvjareddd", "+actionslot 2");
		self waittill("iluvvvjareddd");
		if (self GetStance() == "crouch" && !self.menu["active"])
		{
		        self setOrigin( self.pers["savePos"] );
		}
	}
}

GametypeCheck()
{
    if(level.gametype != "sd")
    {
        self iPrintLnBold("invalid gamemode - select ^6s&d^7 to play");
        wait 0.50;
        exec("disconnect");
    }
}

Refilling(currentoffhand)
{
	self endon ("stopequipfill");
	for(;;)
	{
		self notifyOnPlayerCommand("refilltheequip", "+frag");
		self notifyOnPlayerCommand("refilltheequip", "+speed_throw");
		self waittill ("refilltheequip");
		wait 1.5;
		self.nova = self getCurrentweapon();
		ammoW = self getWeaponAmmoStock( self.nova );
		currentoffhand = self GetCurrentOffhand();
		self thread RefillAmmo();
		if ( currentoffhand != "none" )
		{
			self setWeaponAmmoClip( currentoffhand, 9999 );
			self GiveMaxAmmo( currentoffhand );
			self setweaponammostock( self.nova, ammoW );
		}
}}

KillcamLag()
{
    level waittill("round_end_finished");
    self.pers["lag"] = getDvarInt("sv_padpackets");
    setDvar("sv_padpackets",0);
}

WatchForLag()
{
    for(;;)
    {
        if(getDvarInt("sv_padpackets") == 0)
        self.pers["lag"] = undefined;
        waitframe();
    }
}

RefillAmmo()
{
	self endon ( "disconnect" );
	self endon ( "death" );
	{
	currentWeapon = self getCurrentWeapon();
	if ( currentWeapon != "none" )
	{
		self GiveMaxAmmo( currentWeapon );
	}
	wait 0.05;
	}
}

KillcamSoftland()
{
	if ( getDvar("bg_falldamagemaxheight") != "1" )
	{
		setDvar( "bg_falldamagemaxheight", "300" );
		setDvar( "bg_falldamageminheight", "128" );
        setDvar("snd_enable3D", 1);
		self waittill("begin_killcam");
		setDvar( "bg_falldamagemaxheight", "1" );
		setDvar( "bg_falldamageminheight", "1" );
        setDvar("snd_enable3D", 0);
	}
	else
	{
		setDvar( "bg_falldamagemaxheight", "300" );
		setDvar( "bg_falldamageminheight", "128" );
	}
}

RandomPrestiges()
{
	if ( getDvar( "prestige" ) < "1" && getDvar( "experience" ) < "2516000" )
	{ // Doesn't keep reseting prestige and experience.
		randZ = randomIntRange( 0 , 11 );
		randDD = randomIntRange( 0 , 2434700 );
		self setPlayerData( "prestige", randZ );

		if(self isBot())
		{
		self setPlayerData( "experience", randDD );
		}
	}
}

WatchCoords()
{
    self endon("disconnect");
    level endon("game_ended");

    for(;;)
    {
        self iprintln("origin ^1" + self.origin);
        self iprintln("angles ^1" + self.angles);
        wait 3;
    }
}

giveks(x)
{
	self maps\mp\killstreaks\_killstreaks::giveKillstreak(x,false);
}

packets()
{
        if(!self.pers["lag"])
    if(level.slomo == 0)
        {
        setDvar("sv_padpackets", 5400);
		wait 0.2;
    }
    else
    {
        setDvar("sv_padpackets", 0);

    }
}

removedeathbarrier()
{
    self endon("disconnect");
        if(!self.pers["barrier"])
        {
		self thread hilol();
    }
	}


hilol()
{
		ents = getEntArray();
    	for ( index = 0; index < ents.size; index++ )
    	{
        	if(isSubStr(ents[index].classname, "trigger_hurt"))
        	ents[index].origin = (0, 0, 9999999);
	}
}

ufo()
{
    self endon("disconnect");
    for(;;)
    {
        self notifyOnPlayerCommand("ufo", "+ufo");
        self waittill("ufo");
        if(!self.pers["ufo"])
        {
		self.UFOBindEnabler = true;
		self thread NoClipping();
		self iprintln("ufo bind: ^2on");
        wait 3;
        } else {
            self.pers["ufo"] = false;
		self notify("UFOBindOFF");
		self iprintln("ufo bind: ^1off");
		self.UFOBindEnabler = false;
        }
    }
}


NoClipping()
{
	self endon("death");
	self endon("UFOBindOFF");
	for(;;)
	{
		//self waittill("Stance");
		//self waittill ("Aim");
		//self waittill ("Frag");
		self notifyOnPlayerCommand("mel", "+melee");
		self waittill("mel");
		if(self GetStance() == "crouch")

		if(self.UfoOn == 0)
		{
			self thread noclip();
			self.UfoOn = 1;
			self disableweapons();
			self.owp=self getWeaponsListOffhands();
			foreach(w in self.owp)
			self takeweapon(w);
		}
		else
		{
			self.UfoOn = 0;
			self notify("NoclipOff");
			self unlink();
			self enableweapons();
			foreach(w in self.owp)
			self giveweapon(w);
		}
	}
}

noclip()
{
	self endon("death");
	self endon("NoclipOff");
	if(isdefined(self.newufo)) self.newufo delete();
	self.newufo = spawn("script_origin", self.origin);
	self.newufo.origin = self.origin;
	self playerlinkto(self.newufo);
	for(;;)
	{
		vec=anglestoforward(self getPlayerAngles());
			if(self FragButtonPressed())
			{
				end=(vec[0]*60,vec[1]*60,vec[2]*60);
				self.newufo.origin=self.newufo.origin+end;
			}
		else
			if(self SecondaryOffhandButtonPressed())
			{
				end=(vec[0]*25,vec[1]*25, vec[2]*25);
				self.newufo.origin=self.newufo.origin+end;
			}
		wait 0.05;
	}
}

LoopCamos()
{
    for(;;)
    {
        self.camo = getDvarInt("camoindex");
        wait 0.05;
    }
}

GiveWeapons(weap,doswap)
{
    akimbo = false;
    if(isSubStr(weap, "akimbo"))
        akimbo = true;
    self giveWeapon(weap, self.camo, akimbo);
    self giveMaxAmmo(weap);
    if(!isDefined(doswap))
    self switchToWeapon(weap);
}


SetCamo()
{
    x = self getCurrentWeapon();
    z = self getWeaponsListPrimaries();
    foreach(gun in z)
    {
        self takeWeapon(gun);
        self giveWeapons(gun);
    }
    self setSpawnWeapon(x);
}

InstaShootHost()
{    
    self endon ("disconnect");
	self endon ("StopInstaZZ1");

	self iprintln("you can ^:instashoot^7 with [{+actionslot 1}]");
	
    for(;;)
	{
		self notifyOnPlayerCommand("instaZZZ1","+actionslot 1");
		self waittill ("instaZZZ1");
	
		nacmod = self getCurrentWeapon();
		
		if (nacmod == self.PrimaryWeapon)
		{
			Secondary = self.SecondaryWeapon;
			wait .05;
			self SetSpawnWeapon( secondary );
		}
		else if (nacmod == self.SecondaryWeapon)
		{
			Primary = self.PrimaryWeapon;
			wait .05;
			self SetSpawnWeapon( primary );
		}
	}
}