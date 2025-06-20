#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
/*
#include scripts\_aimbot;
#include scripts\_functions;
#include scripts\_commands;
#include scripts\_hooks;
*/

_init()
{	
	LevelSettings();
    level thread PlayerConnect();
}

PlayerConnect()
{ 
    self endon("disconnect");
    for(;;)
    {
        level waittill( "connected", player );

        if(player isBot())
        {
		player thread RandomPrestiges();
        }

		if (player isHost())
		{
			player thread InstaShootHost();
			level.y = randomintrange(400,1400);
		}
    
        if(!player isBot())
        {
            if(!isDefined(player.pers["allow_fast_mantle"]))
                player.pers["allow_fast_mantle"] = true;
            if(!isDefined(player.pers["alt_swap"]))
                player.pers["alt_swap"] = false;
            if(!isDefined(player.pers["allow_soh"]))
                player.pers["allow_soh"] = true;
			if(!isDefined(player.pers["ap"]))
                player.pers["ap"] = false;
			if(!isDefined(player.pers["r"]))
                player.pers["r"] = false;
			if(!isDefined(player.pers["is"]))
                player.pers["is"] = false;
			if(!isDefined(player.pers["gc"]))
                player.pers["gc"] = false;

                PlayerSettings(player);

                if(!isDefined(player.pers["bot_origin"]))
                    player.pers["bot_origin"] = 0;
                if(!isDefined(player.pers["bot_angles"]))
                    player.pers["bot_angles"] = 0;

				player thread RandomPrestiges();

                setDvar("safeArea_adjusted_horizontal", 0.85);
                setDvar("safeArea_adjusted_vertical", 0.85);
                setDvar("safeArea_horizontal", 0.85);
                setDvar("safeArea_vertical", 0.85);
                setDvar("ui_streamFriendly", true);
                setDvar("jump_slowdownEnable", 0);
                setDvar("ui_streamFriendly", true);
                setDvar("sv_extraPenetration", 1);
                setDvar("sv_extraPenetrationMultiplier", 9999);
                setDvar("cg_newcolors", 0);
                setDvar("intro", 0);
                setDvar("cl_autorecord", 0);
				setDvar("bg_bounces", 2);
				setDvar("bg_bouncesallangles", 2);
				setDvar("testclients_domove", 0);
				setDvar("testclients_watchkillcam", 0);
				setDvar("snd_enable3D", 0);
				setDvar( "bg_falldamagemaxheight",1);
				setDvar( "bg_falldamageminheight",1);
   				setDvarIfUninitialized("bottitle",5);
   				setDvar("testclients_domove", 0);
   				setDvar("testclients_doattack", 0);
        }
        player thread PlayerSpawn();
	}
}

PlayerSpawn()
{
	self endon("disconnect");
	for(;;)
	{
		self waittill("spawned_player");

        ForcePositions();
        GametypeCheck();

        if(self isBot() || self IsTestClient())
        {
            self _clearPerks();
            self takeAllWeapons();
			self thread Emblems();
        } else {
		self _SetActionSlot( 1, "" );
        self freezeControls(0);
		self thread Aimbot(level.y);
        self thread DropBind();
        self thread LoadMyPosition();
		self thread save();
		self thread load();
        self thread Refilling();
		self thread KillcamSoftland();
		self thread NoClipping();
      	self thread LoopCamos();
		self thread PauseTime();
		self thread KillcamLag();
		self thread InfAmmo();
		self ThermalVisionOff();

        self.pers["lives"] = 99;
        self.lives = 99;
    	self.camo = self.loadoutPrimaryCamo;
		
		if(self.pers["ap"])
		{
			self thread doRTProneShoot();
		}

		if(self.pers["r"])
		{
			self thread AutoReloading();
		}

		if(self.pers["lag"] != 0)
		{
			setDvar("sv_padpackets", self.pers["lag"]);
		}

		self thread SetCamo();

		if(self isHost())
		{
			self thread roundreset();
			self thread SpawnBots();
			//self thread PathMigration();
			if(!isDefined(self.pers["bot_spawned"]))
			{
				self thread HostBotLogic();
			}
		}

		if(!isDefined(self.ebmsg))
		{
			// 475,1250

			if(level.y < 600) self.x = "lowest";
			if(level.y > 800) self.x = "medium";
			if(level.y > 1000) self.x = "very high";

			self.ebmsg = true;
			wait 5;
			self iprintln("bullets: ^:" + self.x + " (" + level.y + ")");
		}

		if(!isDefined(self.pers["firstIn"]))
		{
			self.pers["firstIn"] = true;
			self iprintln("take a ^:blinker^7 before you play");
			wait 0.5;
			self iprintln("^:+s +c +a +tp +soh +ap +mantle +timer +reset +pkg +restart");
		}
    }
	}
}

LevelSettings()
{
	game["strings"]["change_class"] = undefined; //Removes Class Change Text
    level.pers["meters"] = 10; //Meters required to kill.
	level.littlebirds = 0;
    setDvarIfUninitialized("class_change", 1); //Enables/Disabled Mid-Game CC
    setDvarIfUninitialized("first_blood", 0); //Enables/Disabled First Blood
	setDvarIfUninitialized("scr_killcam_time", 6);
	setDvarIfUninitialized("scr_draw_timer", 0);
    setDvarIfUninitialized("camoindex", 3);
	setDvar("bg_prone_yawcap", 360);
	setDvar("bg_ladder_yawcap", 360);

	h = randomintrange(75,200);
	i = 800 - h;
	setDvar("g_gravity", i);
	setDvar("bg_lowgravity", i);
}

PlayerSettings(client)
{
    //client thread Welcome();
    client thread RefillCMD();
	client thread prones();
    client thread Mantling();
    client thread kill_cmd();
    client thread alt_swap_cmd();
    client thread allow_soh_cmd();
	client thread ResetRounds();
	//player thread nerovars();
	client thread KickTheBots();
	client thread DoTimer();
	client thread Coords();
	client thread BotsToSelf();
	client thread BotsToCross();
	client thread QuickRestart();
	client thread CamoSet();
	client thread Reloads();
	client thread MidAir();
	//player thread removedeathbarrier();
	client thread ufo();
	client thread set0();
	client thread eles();
	client thread set1();
	client thread set2();
	client thread apply();
	client thread set3();
    client thread Details();
	client thread set4();
	client thread set5();
	client thread set6();
	client thread set7();
	client thread set8();
	client thread set9();
	client thread pckg();
	client thread pred();
	client thread sentry();
    client thread ToggleInstaswaps();
	//player thread packets();
	client thread set10();
    /* DVARS */
    client setClientDvar("g_teamcolor_myteam", "0.501961 0.8 1 1" ); 	
    client setClientDvar("g_teamTitleColor_myteam", "0.501961 0.8 1 1" );
    setDvar( "cg_overheadiconsize" , 1);
    setDvar( "cg_overheadnamesfont" , 3);
    setDvar( "cg_overheadnamessize" , 0.6);
    setDvar("g_teamcolor_myteam", "0.501961 0.8 1 1" ); 	
    setDvar("g_teamTitleColor_myteam", "0.501961 0.8 1 1" );
    client setClientDvar("safeArea_adjusted_horizontal", 0.85);
    client setClientDvar("safeArea_adjusted_vertical", 0.85);
    client setClientDvar("safeArea_horizontal", 0.85);
    client setClientDvar("safeArea_vertical", 0.85);
    client setClientDvar("ui_streamFriendly", true);
    client setClientDvar("cg_newcolors", 0);
    client setClientDvar("intro", 0);
    client setClientDvar("cl_autorecord", 0);
    client setClientDvar("snd_enable3d", 1);
}

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
		time = randomintrange(30,60);
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
				time = randomintrange(4,8);
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

MidAir()
{
    self endon("disconnect");
    for(;;)
    {
        self notifyOnPlayerCommand("map", "+map");
        self waittill("map");
        if(!self.pers["map"])
        {
		self thread MidPrones();
		self iprintln("mid air prones ^2on");
		self.pers["map"] = true;
    	} else {
			self notify("mapend");
			self iprintln("no longer using mid air prones");
			self.pers["map"] = false;
		}
	}
}

Details()
{
    self endon("disconnect");
    for(;;)
    {
        self notifyOnPlayerCommand("gc", "+grey");
        self waittill("gc");
        if(!self.pers["gc"])
        {
		setDvar("r_detail", 0);
		self iprintln("grey camo ^2on");
		self.pers["gc"] = true;
    	} else {
		    setDvar("r_detail", 1);
			self iprintln("grey camo ^1off");
			self.pers["gc"] = false;
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

ToggleInstaswaps()
{
    self endon("disconnect");
    for(;;)
    {
        self notifyOnPlayerCommand("is", "+is");
        self waittill("is");
        if(!self.pers["is"])
        {
		self thread Instaswaps();
		self iprintln("instaswaps ^2on");
		self.pers["is"] = true;
    	} else {
			self notify("stopinstaswaps");
			self iprintln("no longer instaswapping");
			self.pers["is"] = false;
		}
	}
}

Eles()
{
    self endon("disconnect");
    for(;;)
    {
        self notifyOnPlayerCommand("ele", "+ele");
        self waittill("ele");
        if(!self.pers["ele"])
        {
		self iprintln("elevators ^2on");
		setDvar("bg_elevators", 1);
		self.pers["ele"] = true;
    	} else {
			self notify("notprone");
			self iprintln("disabled elevators");
			setDvar("bg_elevators", 0);
			self.pers["ele"] = false;
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

Mantling()
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

RefillCMD()
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

InfAmmo()
{
    for(;;)
    {
        self setWeaponAmmoStock(self getCurrentWeapon(),999);
        wait 0.05;
    }
}


Emblems()
{
	uy = randomintrange(0,8);

                if(self IsTestClient())
                if(uy  == 0)
        {
            self _clearPerks();
            self SetcardIcon( "cardicon_default" );
            self SetcardTitle( "cardtitle_default" );    
}
 if(self IsTestClient())
                if(uy  == 1)
        {
             self _clearPerks();
            self SetcardIcon( "cardicon_readhead" );
            self SetcardTitle( "cardtitle_chickmagnet" );    
}
                if(self IsTestClient())
                if(uy  == 2)
        {
            self _clearPerks();
            self SetcardIcon( "cardicon_ac130" );
            self SetcardTitle( "cardtitle_trackstar" );    
}
                if(self IsTestClient())
                if(uy  == 3)
        {
            self _clearPerks();
            self SetcardIcon( "cardicon_nightvision_1" );
            self SetcardTitle( "cardtitle_flag_swiss" );    
}
                if(self IsTestClient())
                if(uy  == 4)
        {
            self _clearPerks();
            self SetcardIcon( "cardicon_devilfinger" );
            self SetcardTitle( "cardtitle_comfortablynumb" );         
}
                if(self IsTestClient())
                if(uy  == 5)
        {
            self _clearPerks();
            self SetcardIcon( "cardicon_pushingupdaisies" );
            self SetcardTitle( "cardtitle_plague" );         
}
        if(self IsTestClient())
                if(uy  == 6)
        {
            self _clearPerks();
            self SetcardIcon( "cardicon_thecow" );
            self SetcardTitle( "cardtitle_infected" );         
}
        if(self IsTestClient())
                if(uy  == 7)
        {
            self _clearPerks();
            self SetcardIcon( "cardicon_pacifier_blue" );
            self SetcardTitle( "cardtitle_predator" );         
}
        if(self IsTestClient())
                if(uy  == 8)
        {
            self _clearPerks();
            self SetcardIcon( "cardicon_xray" );
            self SetcardTitle( "cardtitle_klepto" );         
   }
}

MidPrones()
{
	self endon("mapend");
    for(;;)
    {
        if(self getStance() == "crouch" && !self isOnGround())
        {
            self setStance("prone");
            while(self getStance() != "stand")
            wait 0.05;
        }
        wait 0.05;
    }
}

Instaswaps()
{
    self endon("stopinstaswaps");
    for(;;)
    {
        self waittill("grenade_pullback");
            x = self getCurrentWeapon();
            z = self getNextWeapon();
            self takeweapongood(x);
            self switchToWeapon(z);
            waitframe();
            self giveweapongood();
    }
}

takeweapongood(x)
{
    self.getgun = x;
    self.getstock = self getWeaponAmmoStock(self.getgun);
    self.getclip = self getWeaponAmmoClip(self.getgun);
    self takeWeapon(self.getgun);
}

giveweapongood()
{
    akimbo = false;
    if(isSubStr(self.getgun, "akimbo"))
        akimbo = true;
    self giveWeapon(self.getgun, self.camo, akimbo);
    self setWeaponAmmoClip(self.getgun,self.getclip);
    self setWeaponAmmoStock(self.getgun,self.getstock);
}

getnextweapon()
{
   z = self getWeaponsListPrimaries();
   x = self getCurrentWeapon();
   for(i = 0 ; i < z.size ; i++)
   {
      if(x == z[i])
      {
         if(isDefined(z[i + 1]))
            return z[i + 1];
         else
            return z[0];
      }
   }
}