
void () player_pain;
void () player_stand1;
void (vector org) spawn_tfog;
void (vector org, entity death_owner) spawn_tdeath;

float modelindex_eyes;
float modelindex_player;
float modelindex_null;

void () TeamFortress_CheckTeamCheats;
void (entity Viewer, float pc, float rpc) TeamFortress_PrintClassName;
void () TeamFortress_RemoveTimers;
void (float Suicided) TeamFortress_SetupRespawn;
float (float pc) IsLegalClass;
void () SetupTeamEqualiser;
void () CeaseFire_think;
void (entity eng) Engineer_RemoveBuildings;
void (string halias, float himpulse1, float himpulse2) TeamFortress_Alias;
void (entity p) CheckAutoKick;
void (entity p) KickCheater;
void (entity p) TeamFortress_ExecClassScript;
void (entity p) TeamFortress_ExecMapScript;
void () PreMatch_Think;
void () DumpClanScores;
void (entity p) SetTeamName;
void () autokick_think;
float (float tno, float pc) ClassIsRestricted;
void () Service_Grapple;
void (entity AD) ParseTFDetect;
entity (float ino) Finditem;
void (entity Item, entity AP, entity Goal) tfgoalitem_GiveToPlayer;
void () CTF_FlagCheck;
float (float tno) TeamFortress_TeamGetColor;

string nextmap;
float intermission_running;
float intermission_exittime;

void () info_intermission =
{
 if (!CheckExistence()) {
  dremove(self);
  return;
 }
};

void () SetChangeParms =
{
 if (self.health <= 0) {
  SetNewParms();
  return;
 }
 self.items = self.items - (self.items & (#IT_KEY1 | #IT_KEY2 | #IT_INVISIBILITY | #IT_INVULNERABILITY | #IT_SUIT | #IT_QUAD));
 if (self.health > 100) 
  self.health = 100;
 if (self.health < 50) 
  self.health = 50;
 parm1 = self.items;
 parm2 = self.health;
 parm3 = self.armorvalue;
 if (self.ammo_shells < 25) 
  parm4 = 25;
 else 
  parm4 = self.ammo_shells;
 parm5 = self.ammo_nails;
 parm6 = self.ammo_rockets;
 parm7 = self.ammo_cells;
 parm8 = self.current_weapon;
 parm9 = self.armortype * 100;
 parm10 = 0;
 parm11 = 0;
 parm12 = 0;
 parm13 = self.StatusBarRes;
 parm14 = self.StatusBarSize;
 parm15 = self.is_admin;
};

void () SetNewParms =
{
 parm1 = 0;
 parm2 = 100;
 parm3 = 0;
 parm4 = 25;
 parm5 = 0;
 parm6 = 0;
 parm6 = 0;
 parm8 = 1;
 parm9 = 0;
 parm10 = 0;
 parm11 = 0;
 parm12 = 0;
 parm13 = 0;
 parm14 = 0;
 parm15 = 0;
};

void () autoteam_think =
{
 toggleflags = toggleflags | 64;
 dremove(self);
};

void () autokick_think =
{
 self.owner.teamkills = 0;
 dremove(self);
};

void () DecodeLevelParms =
{
 local string st;
 local entity ent;
 local entity te;
 local float ti;
 // local "21?TeamFortress"
 // local "info_player_team1"
 // local "Mapname: "
 // local "temp1"
 local float autoteam_time;

 if (serverflags) {
  if (world.model == "maps/start.bsp") 
   SetNewParms();
 }
 self.items = parm1;
 self.health = parm2;
 self.armorvalue = parm3;
 self.ammo_shells = parm4;
 self.ammo_nails = parm5;
 self.ammo_rockets = parm6;
 self.ammo_cells = parm7;
 self.current_weapon = parm8;
 self.armortype = parm9 * 0.01;
 if (!(toggleflags & 256)) {
  toggleflags = parm10;
  flagem_checked = 0;
  allow_hook = 0;
  invis_only = 0;
  if (coop || !deathmatch) 
   toggleflags = toggleflags | 1;
  nextmap = mapname;
  allow_hook = 1;
  ent = find(world, classname, "info_tfdetect");
  if (ent != world) {
   if (!teamplay) 
    cvar_set("teamplay", "21?TeamFortress");
   ParseTFDetect(ent);
   if (number_of_teams <= 0 || number_of_teams >= 5) 
    number_of_teams = 4;
  }
  else {
   ent = find(world, classname, "info_player_team1");
   if (ent != world || CTF_Map == 1) {
    CTF_Map = 1;
    if (!teamplay) 
     cvar_set("teamplay", "21?TeamFortress");
    ent = spawn();
    ent.nextthink = time + 30;
    ent.think = CTF_FlagCheck;
    number_of_teams = 2;
   }
   else 
    number_of_teams = 4;
   team1lives = -1;
   team2lives = -1;
   team3lives = -1;
   team4lives = -1;
   illegalclasses1 = 0;
   illegalclasses2 = 0;
   illegalclasses3 = 0;
   illegalclasses4 = 0;
   team1maxplayers = 100;
   team2maxplayers = 100;
   team3maxplayers = 100;
   team4maxplayers = 100;
   civilianteams = 0;
  }
  bprint(2, "Mapname: ");
  bprint(2, mapname);
  bprint(2, "\n");
  SetupTeamEqualiser();
  team4frags = 0;
  team3frags = 0;
  team2frags = 0;
  team1frags = 0;
  team4score = 0;
  team3score = 0;
  team2score = 0;
  team1score = 0;
  autokick_kills = 0;
  autokick_time = 0;
  cease_fire = 0;
  if (1) 
   toggleflags = toggleflags - (toggleflags & 128);
  if (0) 
   toggleflags = toggleflags | 128;
  toggleflags = toggleflags - (toggleflags & 2);
  st = infokey(world, "temp1");
  toggleflags = toggleflags | 256 | stof(st);
  autoteam_time = 30;
  st = infokey(world, "bd");
  if (st == string_null) 
   st = infokey(world, "birthday");
  if (st == "on") {
   birthday = 1;
   te = spawn();
   te.weapon = 10;
   te.nextthink = time + 60;
   te.think = BirthdayTimer;
  }
  else {
   if (st == "off") 
    birthday = 0;
  }
  st = infokey(world, "c");
  if (st == string_null) 
   st = infokey(world, "clan");
  if (st == "on") {
   clanbattle = 1;
   clan_scores_dumped = 0;
   game_locked = 0;
   st = infokey(world, "pm");
   if (st == string_null) 
    st = infokey(world, "prematch");
   cb_prematch_time = time + stof(st) * 60;
   if (timelimit && time + timelimit < cb_prematch_time) {
    timelimit = timelimit + cb_prematch_time;
    ti = ceil(timelimit / 60);
    st = ftos(ti);
    cvar_set("timelimit", st);
   }
   if (cb_prematch_time > time) {
    cb_prematch_time = cb_prematch_time + 5;
    ent = spawn();
    ent.think = PreMatch_Think;
    ent.nextthink = time + 5;
   }
   st = infokey(world, "cft");
   if (st == string_null) 
    st = infokey(world, "ceasefire_time");
   cb_ceasefire_time = stof(st);
   if (cb_ceasefire_time) {
    cb_ceasefire_time = time + cb_ceasefire_time * 60;
    if (cb_prematch_time < cb_ceasefire_time) {
     cb_prematch_time = cb_ceasefire_time + 5;
     if (timelimit && time + timelimit < cb_prematch_time) {
      timelimit = timelimit + cb_ceasefire_time;
      ti = ceil(timelimit / 60);
      st = ftos(ti);
      cvar_set("timelimit", st);
     }
    }
    cease_fire = 1;
    bprint(2, "CEASE FIRE\n");
    te = find(world, classname, "player");
    while (te) {
     centerprint(te, "CEASE FIRE\n");
//     te.immune_to_check = time + 10;
     te.tfstate = te.tfstate | 65536;
     TeamFortress_SetSpeed(te);
     te = find(te, classname, "player");
    }
    te = spawn();
    te.classname = "ceasefire";
    te.think = CeaseFire_think;
    te.nextthink = time + 5;
    te.weapon = 1;
   }
   st = infokey(world, "lg");
   if (st == string_null) 
    st = infokey(world, "locked_game");
   if (st == "on") 
    game_locked = 1;
  }
  else 
   clanbattle = 0;
  st = infokey(world, "a");
  if (st == string_null) 
   st = infokey(world, "autoteam");
  if (st == "on") 
   toggleflags = toggleflags | 64;
  else {
   if (st == "off") 
    toggleflags = toggleflags - (toggleflags & 64);
   else {
    if (stof(st)) {
     toggleflags = toggleflags | 64;
     autoteam_time = stof(st);
    }
   }
  }
  st = infokey(world, "akt");
  if (st == string_null) 
   st = infokey(world, "autokick_time");
  autokick_time = stof(st);
  if (autokick_time) {
   st = infokey(world, "akk");
   if (st == string_null) 
    st = infokey(world, "autokick_kills");
   autokick_kills = stof(st);
  }
  st = infokey(world, "t");
  if (st == string_null) 
   st = infokey(world, "teamfrags");
  if (st == "on") 
   toggleflags = toggleflags | 128;
  else {
   if (st == "off") 
    toggleflags = toggleflags - (toggleflags & 128);
  }
  st = infokey(world, "fts");
  if (st == string_null) 
   st = infokey(world, "fullteamscore");
  if (st == "on") 
   toggleflags = toggleflags | 2048;
  st = infokey(world, "g");
  if (st == string_null) 
   st = infokey(world, "grapple");
  if (st == "off") 
   allow_hook = 0;
  if (!(toggleflags & 1024) && st != "on") 
   allow_hook = 0;
  st = infokey(world, "og");
  if (st == string_null) 
   st = infokey(world, "old_grenades");
  if (st == string_null) 
   st = infokey(world, "old_grens");
  if (st == "on") 
   old_grens = 1;


  st = infokey(world, "spy");
  if (st == "off") 
   spy_off = 1;
  st = infokey(world, "s");
  if (st == string_null) 
   st = infokey(world, "spyinvis");
  if (st == "on" || (toggleflags & 512)) 
   invis_only = 1;
  else {
   if (st == "off") 
    invis_only = 0;
  }

                cheat_pause=1;
                st=infokey(world, "cp");
                if(st != string_null)
                {
                 cheat_pause=stof(st);
                 cheat_pause=ceil(ti);
                 if(cheat_pause<=0)cheat_pause=1;
                }
                topcolor_check=0;
                tc1 = TeamFortress_TeamGetColor(1) - 1;
                st=infokey(world, "tc1");
                if(st != string_null)
                {
                  ti=stof(st);
                  ti=ceil(ti);
                  if(ti>=0 && ti<=15 )
                  {
                   tc1=ti;
                   topcolor_check=1;
                  }
                }
                tc2 = TeamFortress_TeamGetColor(2) - 1;
                st=infokey(world, "tc2");
                if(st != string_null)
                {
                  ti=stof(st);
                  ti=ceil(ti);
                  if(ti>=0 && ti<=15 )
                  {
                   tc2=ti;
                   topcolor_check=1;
                  }
                }
                tc3 = TeamFortress_TeamGetColor(3) - 1;
                st=infokey(world, "tc3");
                if(st != string_null)
                {
                  ti=stof(st);
                  ti=ceil(ti);
                  if(ti>=0 && ti<=15 )
                  {
                   tc3=ti;
                   topcolor_check=1;
                  }
                }
                tc4 = TeamFortress_TeamGetColor(4) - 1;
                st=infokey(world, "tc4");
                if(st != string_null)
                {
                  ti=stof(st);
                  ti=ceil(ti);
                  if(ti>=0 && ti<=15 )
                  {
                   tc4=ti;
                   topcolor_check=1;
                  }
                }

  st = infokey(world, "adg");
  if (st == string_null) 
   st = infokey(world, "allow_drop_goal");
  if (st == "on") 
   allow_drop_goal=1;
   else  allow_drop_goal=0;
  st = infokey(world, "nf");
  if (st == string_null) 
   st = infokey(world, "new_flash");
  if (st == "on") 
   new_flash = 1;
   else new_flash = 0;

    st = infokey(world, "sg");
    if (st == "old") {
            sentry_type = #SENTRY_OLD;
    }
    else {
            if (st == "fix") 
                    sentry_type = #SENTRY_FIX;
            else 
            {
            if (st == "new") 
                   sentry_type = #SENTRY_NEW;
              else{
               if (st == "mtflf") 
                      sentry_type = #SENTRY_MTFL_NEWFIND;
                 else{
               if (st == "oldf") 
                      sentry_type = #SENTRY_OLD_NEWFIND;
                 else{
                    sentry_type = #SENTRY_MTFL;
    }}}}}
    st = infokey(world, "sgppl");
    if(st == string_null)
     sgppl=12;
    else
    {
     sgppl=rint(stof(st));
     if(sgppl<0)sgppl=0;
    }
#ifdef TG
  sg_allow_fire=1;
  sg_allow_find=#TG_SG_FIND_IGNORE_TEAM;
  sg_fire_type=#TG_SG_FIRE_NORMAL;
  gren_time=0;
  gren_effect=1;
  detpack_disarm=1;
  detpack_drop=0;
  fullflash_for_self=0;
#endif
  st = infokey(world, "dg");
  if (st == string_null) 
      st = infokey(world, "disable_grens");
  disable_grens=stof(st);
  st = infokey(world, "dtpb");
  if(st == "off")
   detpack_block=0;
   else detpack_block=1;

  st = infokey(world, "dp");
  if (st == string_null) 
      st = infokey(world, "disable_powerups");
  if(st == "on")
   disable_powerups=1;

  st = infokey(world, "ft");
  if (st == string_null) 
      st = infokey(world, "flag_timer");
  if(st == "on")
   flag_timer=1;

                st = infokey(world, "sf");
  if (st == string_null) 
      st = infokey(world, "snip_fps");
  snip_fps=stof(st);
  if(snip_fps<0)snip_fps=0;

                st = infokey(world, "srf");
  if (st == string_null) 
      st = infokey(world, "snip_range_fix");
  if(st == "on")
  snip_range_fix=1;

                st = infokey(world, "g2b");
  gren2box=stof(st);
  if(gren2box<0)gren2box=0;


                st = infokey(world, "rts");
  if (st == string_null) 
      st = infokey(world, "random_team_spawn");
  if(st == "on")
   random_tf_spawn = 1;

//////////////

  st = infokey(world, "rd");
  if (st == string_null) 
   st = infokey(world, "respawn_delay");
  respawn_delay_time = stof(st);
  if (respawn_delay_time) 
   toggleflags = toggleflags | 4;
  if ((toggleflags & 4) && !respawn_delay_time) 
   respawn_delay_time = 5;
  if (toggleflags & 64) {
   toggleflags = toggleflags - (toggleflags & 64);
   ent = spawn();
   ent.nextthink = time + autoteam_time;
   ent.think = autoteam_think;
  }
 }
 if (parm11) 
  self.tfstate = parm11;
 if (!self.playerclass) 
  self.playerclass = parm12;
/* if (parm13) 
  self.StatusBarRes = parm13;
 if (parm14) 
  self.StatusBarSize = parm14;*/
 if (parm15) {
  self.is_admin = parm15;
 }
};

entity () FindIntermission =
{
 local entity spot;
 local float cyc;

 spot = find(world, classname, "info_intermission");
 if (spot) {
  cyc = random() * 1;
  return spot;
 }
 spot = find(world, classname, "info_player_start");
 if (spot) 
  return spot;
 spot = find(world, classname, "info_player_deathmatch");
 if (spot) {
  cyc = random() * 6;
  while (cyc > 1) {
   spot = find(spot, classname, "info_player_deathmatch");
   if (!spot) 
    spot = find(spot, classname, "info_player_deathmatch");
   cyc = cyc - 1;
  }
  return spot;
 }
 objerror("FindIntermission: no spot");
};

entity (entity start_point) FindNextIntermission =
{
 local entity spot;
 local float cyc;

 if (deathmatch) {
  if (start_point.classname == "info_intermission" || start_point == world) {
   spot = find(start_point, classname, "info_intermission");
   if (spot) 
    return spot;
   else 
    start_point = world;
  }
  if (start_point.classname == "info_player_deathmatch" || start_point == world) {
   spot = find(start_point, classname, "info_player_deathmatch");
   if (spot) 
    return spot;
  }
  spot = find(world, classname, "info_intermission");
  if (spot) 
   return spot;
  spot = find(world, classname, "info_player_deathmatch");
  if (spot) 
   return spot;
 }
 else {
  spot = find(world, classname, "info_player_start");
  if (spot) 
   return spot;
 }
 return FindIntermission();
};

void () TF_MovePlayer =
{
 local entity place;

 place = FindNextIntermission(self.observer_list);
 self.observer_list = place;
 setorigin(self, place.origin + '0 0 1');
 self.angles = place.angles;
 self.fixangle = 1;
};

void () GotoNextMap =
{
 local float nextlevel;
 local string sl;
 local string st;
 local entity te;

 if (nextmap != mapname) {
  changelevel(nextmap);
  already_chosen_map = 1;
 }
 sl = infokey(world, mapname);
 if (sl != string_null) {
  nextmap = sl;
  already_chosen_map = 1;
  return;
 }
 if (!already_chosen_map) {
  sl = infokey(world, "n");
  nextlevel = stof(sl);
  nextlevel = nextlevel + 1;
  sl = ftos(nextlevel);
  localcmd("serverinfo n ");
  localcmd(sl);
  localcmd("\n");
  st = infokey(world, "cd");
  if (st == string_null) 
   st = infokey(world, "cycledir");
  if (st != string_null) {
   localcmd("exec ");
   localcmd(st);
   localcmd("/map");
  }
  else 
   localcmd("exec qwmcycle/map");
  localcmd(sl);
  localcmd(".cfg\n");
  already_chosen_map = 1;
 }
 if (infokey(world, "n") == "0") 
  already_chosen_map = 0;
};

void () ExitIntermission =
{
 dprint("Exiting intermission...\n");
 if (deathmatch) {
  dprint("Exit Intermission in Deathmatch.\n");
  GotoNextMap();
  return;
 }
 intermission_exittime = time + 1;
 intermission_running = intermission_running + 1;
 if (intermission_running == 2) {
  if (world.model == "maps/e1m7.bsp") {
   WriteByte(2, 32);
   WriteByte(2, 2);
   WriteByte(2, 3);
   if (!cvar("registered")) {
    WriteByte(2, 31);
    WriteString(2, "As the corpse of the monstrous entity\nChthon sinks back into the lava whence\nit rose, you grip the Rune of Earth\nMagic tightly. Now that you have\nconquered the Dimension of the Doomed,\nrealm of Earth Magic, you are ready to\ncomplete your task in the other three\nhaunted lands of Quake. Or are you? If\nyou don't register Quake, you'll never\nknow what awaits you in the Realm of\nBlack Magic, the Netherworld, and the\nElder World!");
   }
   else {
    WriteByte(2, 31);
    WriteString(2, "As the corpse of the monstrous entity\nChthon sinks back into the lava whence\nit rose, you grip the Rune of Earth\nMagic tightly. Now that you have\nconquered the Dimension of the Doomed,\nrealm of Earth Magic, you are ready to\ncomplete your task. A Rune of magic\npower lies at the end of each haunted\nland of Quake. Go forth, seek the\ntotality of the four Runes!");
   }
   return;
  }
  else {
   if (world.model == "maps/e2m6.bsp") {
    WriteByte(2, 32);
    WriteByte(2, 2);
    WriteByte(2, 3);
    WriteByte(2, 31);
    WriteString(2, "The Rune of Black Magic throbs evilly in\nyour hand and whispers dark thoughts\ninto your brain. You learn the inmost\nlore of the Hell-Mother; Shub-Niggurath!\nYou now know that she is behind all the\nterrible plotting which has led to so\nmuch death and horror. But she is not\ninviolate! Armed with this Rune, you\nrealize that once all four Runes are\ncombined, the gate to Shub-Niggurath's\nPit will open, and you can face the\nWitch-Goddess herself in her frightful\notherworld cathedral.");
    return;
   }
   else {
    if (world.model == "maps/e3m6.bsp") {
     WriteByte(2, 32);
     WriteByte(2, 2);
     WriteByte(2, 3);
     WriteByte(2, 31);
     WriteString(2, "The charred viscera of diabolic horrors\nbubble viscously as you seize the Rune\nof Hell Magic. Its heat scorches your\nhand, and its terrible secrets blight\nyour mind. Gathering the shreds of your\ncourage, you shake the devil's shackles\nfrom your soul, and become ever more\nhard and determined to destroy the\nhideous creatures whose mere existence\nthreatens the souls and psyches of all\nthe population of Earth.");
     return;
    }
    else {
     if (world.model == "maps/e4m7.bsp") {
      WriteByte(2, 32);
      WriteByte(2, 2);
      WriteByte(2, 3);
      WriteByte(2, 31);
      WriteString(2, "Despite the awful might of the Elder\nWorld, you have achieved the Rune of\nElder Magic, capstone of all types of\narcane wisdom. Beyond good and evil,\nbeyond life and death, the Rune\npulsates, heavy with import. Patient and\npotent, the Elder Being Shub-Niggurath\nweaves her dire plans to clear off all\nlife from the Earth, and bring her own\nfoul offspring to our world! For all the\ndwellers in these nightmare dimensions\nare her descendants! Once all Runes of\nmagic power are united, the energy\nbehind them will blast open the Gateway\nto Shub-Niggurath, and you can travel\nthere to foil the Hell-Mother's plots\nin person.");
      return;
     }
    }
   }
  }
  GotoNextMap();
 }
 if (intermission_running == 3) {
  if (!cvar("registered")) {
   WriteByte(2, 33);
   return;
  }
  if ((serverflags & 15) == 15) {
   WriteByte(2, 31);
   WriteString(2, "Now, you have all four Runes. You sense\ntremendous invisible forces moving to\nunseal ancient barriers. Shub-Niggurath\nhad hoped to use the Runes Herself to\nclear off the Earth, but now instead,\nyou will use them to enter her home and\nconfront her as an avatar of avenging\nEarth-life. If you defeat her, you will\nbe remembered forever as the savior of\nthe planet. If she conquers, it will be\nas if you had never been born.");
   return;
  }
 }
 dprint("Exit Intermission.\n");
 GotoNextMap();
};

void () IntermissionThink =
{
 local float minp;
 local float maxp;
 local float currp;
 local string sl;
 local string st;

 if (time < intermission_exittime) 
  return;
 if (!self.button0 && !self.button1 && !self.button2) 
  return;
 dprint("Intermission think.\n");
 GotoNextMap();
 sl = infokey(world, "nmap");
 if (sl != string_null) {
  st = infokey(world, "minp");
  minp = stof(st);
  st = infokey(world, "maxp");
  maxp = stof(st);
  currp = TeamFortress_GetNoPlayers();
  dprint("MAP CYCLING: Player Counting... ");
  if (currp >= minp && currp <= maxp) {
   dprint("within range. Changing maps...\n");
   st = infokey(world, "cd");
   if (st == string_null) 
    st = infokey(world, "cycledir");
   if (st != string_null) {
    localcmd("exec ");
    localcmd(st);
    localcmd("/");
   }
   else 
    localcmd("exec qwmcycle/");
   localcmd(sl);
   localcmd(".cfg\n");
  }
  else {
   dprint("outside range. Next map.\n");
   already_chosen_map = 0;
  }
  localcmd("localinfo minp \"\"\n");
  localcmd("localinfo maxp \"\"\n");
  localcmd("localinfo nmap \"\"\n");
 }
};

void () execute_changelevel =
{
 local entity pos;

 dprint("execute_changelevel()\n");
 intermission_running = 1;
 intermission_exittime = time + 5;
 pos = FindIntermission();
 WriteByte(2, 32);
 WriteByte(2, 3);
 WriteByte(2, 30);
 WriteCoord(2, pos.origin_x);
 WriteCoord(2, pos.origin_y);
 WriteCoord(2, pos.origin_z);
 WriteAngle(2, pos.mangle_x);
 WriteAngle(2, pos.mangle_y);
 WriteAngle(2, pos.mangle_z);
 other = find(world, classname, "player");
 while (other != world) {
  other.takedamage = 0;
  other.solid = 0;
  other.movetype = 0;
  other.modelindex = 0;
  other = find(other, classname, "player");
 }
 if (!clan_scores_dumped) {
  DumpClanScores();
  clan_scores_dumped = 1;
 }
};

void () changelevel_touch =
{
 local entity pos;
 local float ne;
 local string st;

 if (other.classname != "player") 
  return;
 if (cvar("samelevel") == 2 || (cvar("samelevel") == 3 && mapname != "start")) 
  return;
 bprint(2, other.netname);
 bprint(2, " exited the level\n");
 nextmap = self.map;
 SUB_UseTargets();
 if ((self.spawnflags & 1) && !deathmatch) {
  GotoNextMap();
  return;
 }
 self.touch = SUB_Null;
 self.think = execute_changelevel;
 self.nextthink = time + 0.1;
};

void () trigger_changelevel =
{
 if (!CheckExistence()) {
  dremove(self);
  return;
 }
 if (!self.map) 
  objerror("changelevel trigger doesn't have map");
 InitTrigger();
 self.touch = changelevel_touch;
};


void () set_suicide_frame;

void () respawn =
{
 if (self.has_disconnected == 1) 
  return;
 if (cease_fire) 
  return;
 if (coop) {
  CopyToBodyQue(self);
  setspawnparms(self);
  PutClientInServer();
 }
 else {
  if (deathmatch) {
   CopyToBodyQue(self);
   SetNewParms();
   PutClientInServer();
  }
  else 
   localcmd("restart\n");
 }
};

void () ClientKill =
{
 local entity te;

 if (self.has_disconnected == 1) 
  return;
 if (self.suicide_time > time) 
  return;
 if (self.deadflag) 
  return;
 if (!self.playerclass) 
  return;
 self.suicide_time = time + 5 + random() * 5;
 bprint(1, self.netname);
 bprint(1, " suicides\n");
 set_suicide_frame();
 self.modelindex = modelindex_player;
 if (self.tfstate & 16) {
  te = find(world, classname, "timer");
  while (te) {
   if (te.owner == self && te.think == BioInfection_Decay) {
    logfrag(te, self);
    TF_AddFrags(te.enemy, 1);
   }
   te = find(te, classname, "timer");
  }
 }
 else 
  logfrag(self, self);
 TF_AddFrags(self, -1);
 self.weaponmodel = "";
 self.view_ofs = '0 0 -8';
 self.movetype = 0;
 TeamFortress_RemoveTimers();
 TeamFortress_SetupRespawn(1);
 self.health = -1;
 self.th_die();
 self.deadflag = 3;
 self.tfstate = self.tfstate | 8192;
 self.takedamage = 0;
};

entity lastspawn_team1;
entity lastspawn_team2;
entity lastspawn_team3;
entity lastspawn_team4;

entity (float team_num) FindTeamSpawnPoint =
{
 local entity spot;
 local entity at_spot;
 local float spot_found;
 local float attempts;

 if (team_num == 1) {
  spot = lastspawn_team1;
  attempts = 0;
  while (1) {
   attempts = attempts + 1;
   spot = find(spot, team_str_home, "ts1");
   if (spot == world) 
    spot = find(world, team_str_home, "ts1");
   if (spot == world) 
    return world;
   at_spot = findradius(spot.origin, 40);
   spot_found = 1;
   while (at_spot != world) {
    if (at_spot.classname == "player" && !at_spot.deadflag) 
     spot_found = 0;
    at_spot = at_spot.chain;
   }
   if (!Activated(spot, self)) 
    spot_found = 0;
   if (spot_found || attempts >= 30) {
    lastspawn_team1 = spot;
    return spot;
   }
  }
 }
 else {
  if (team_num == 2) {
   spot = lastspawn_team2;
   attempts = 0;
   while (1) {
    attempts = attempts + 1;
    spot = find(spot, team_str_home, "ts2");
    if (spot == world) 
     spot = find(world, team_str_home, "ts2");
    if (spot == world) 
     return world;
    at_spot = findradius(spot.origin, 40);
    spot_found = 1;
    while (at_spot != world) {
     if (at_spot.classname == "player" && !at_spot.deadflag) 
      spot_found = 0;
     at_spot = at_spot.chain;
    }
    if (!Activated(spot, self)) 
     spot_found = 0;
    if (spot_found || attempts >= 30) {
     lastspawn_team2 = spot;
     return spot;
    }
   }
  }
  else {
   if (team_num == 3) {
    spot = lastspawn_team3;
    attempts = 0;
    while (1) {
     attempts = attempts + 1;
     spot = find(spot, team_str_home, "ts3");
     if (spot == world) 
      spot = find(world, team_str_home, "ts3");
     if (spot == world) 
      return world;
     at_spot = findradius(spot.origin, 40);
     spot_found = 1;
     while (at_spot != world) {
      if (at_spot.classname == "player" && !at_spot.deadflag) 
       spot_found = 0;
      at_spot = at_spot.chain;
     }
     if (!Activated(spot, self)) 
      spot_found = 0;
     if (spot_found || attempts >= 30) {
      lastspawn_team3 = spot;
      return spot;
     }
    }
   }
   else {
    if (team_num == 4) {
     spot = lastspawn_team4;
     attempts = 0;
     while (1) {
      attempts = attempts + 1;
      spot = find(spot, team_str_home, "ts4");
      if (spot == world) 
       spot = find(world, team_str_home, "ts4");
      if (spot == world) 
       return world;
      at_spot = findradius(spot.origin, 40);
      spot_found = 1;
      while (at_spot != world) {
       if (at_spot.classname == "player" && !at_spot.deadflag) 
        spot_found = 0;
       at_spot = at_spot.chain;
      }
      if (!Activated(spot, self)) 
       spot_found = 0;
      if (spot_found || attempts >= 30) {
       lastspawn_team4 = spot;
       return spot;
      }
     }
    }
   }
  }
 }
 return world;
};

void (entity e) ValidateUser =
{
};

entity () SelectSpawnPoint =
{
 local entity spot;
 local entity at_spot;
 local float spot_found;
 local float attempts;

 if (self.team_no) {
         if(random_tf_spawn)
  spot = FindRandomTeamSpawnPoint(self.team_no);
  else 
  spot = FindTeamSpawnPoint(self.team_no);
  if (spot != world) 
   return spot;
 }
 if (coop) {
  lastspawn = find(lastspawn, classname, "info_player_coop");
  if (lastspawn == world) 
   lastspawn = find(world, classname, "info_player_coop");
  if (lastspawn != world) 
   return lastspawn;
 }
 else {
  if (deathmatch) {
   spot = find(lastspawn, classname, "info_player_deathmatch");
   if (spot == world) 
    spot = find(world, classname, "info_player_deathmatch");
   attempts = 0;
   while (spot != world && attempts < 100) {
    attempts = attempts + 1;
    at_spot = findradius(spot.origin, 40);
    spot_found = 1;
    while (at_spot) {
     if (at_spot.classname == "player" && !at_spot.deadflag) 
      spot_found = 0;
     at_spot = at_spot.chain;
    }
    if (spot_found || attempts >= 10) {
     lastspawn = spot;
     return spot;
    }
    spot = find(spot, classname, "info_player_deathmatch");
    if (spot == world) 
     spot = find(world, classname, "info_player_deathmatch");
   }
  }
 }
 if (serverflags) {
  spot = find(world, classname, "info_player_start2");
  if (spot) 
   return spot;
 }
 spot = find(world, classname, "info_player_start");
 if (!spot) 
  error("PutClientInServer: no info_player_start on level\n");
 return spot;
};


void () PlayerDie;
void () TeamFortress_SetHealth;
void () TeamFortress_SetEquipment;
void () player_touch;

void () PutClientInServer =
{
 local string st;
 local float iszoom;
 local float oldclass;
 local entity spot;
 local entity te;

 self.touch = player_touch;
 self.classname = "player";
 self.health = 100;
 self.solid = 3;
 self.movetype = 3;
 self.show_hostile = 0;
 self.FlashTime = 0;
 self.max_health = 100;
 self.flags = 8;
 self.air_finished = time + 12;
 self.dmg = 2;
 self.super_damage_finished = 0;
 self.radsuit_finished = 0;
 self.invisible_finished = 0;
 self.invincible_finished = 0;
 self.effects = 0;
 self.invincible_time = 0;
 self.reload_shotgun = 0;
 self.reload_super_shotgun = 0;
 self.reload_grenade_launcher = 0;
 self.reload_rocket_launcher = 0;
// self.immune_to_check = time + 10;
 self.immune_to_check = time + cheat_pause;
 self.on_hook = 0;
 self.hook_out = 0;
 self.fire_held_down = 0;
 DecodeLevelParms();
 if (!self.playerclass) {
  if (TeamFortress_TeamIsCivilian(self.team_no)) {
   self.impulse = 1;
   TeamFortress_ChangeClass();
  }
 }
 if (deathmatch == 3 && self.nextpc) {
  self.playerclass = self.nextpc;
  self.nextpc = 0;
  if (self.playerclass == 10) 
   self.tfstate = self.tfstate | 8;
  else {
   self.tfstate = self.tfstate - (self.tfstate & 8);
   TeamFortress_ExecClassScript(self);
  }
 }
 iszoom = 0;
 if (self.tfstate & 4096) 
  iszoom = 1;
 if (self.tfstate & 8) {
  oldclass = self.playerclass;
  self.playerclass = 1 + floor(random() * (10 - 1));
  while (!IsLegalClass(self.playerclass) || self.playerclass == oldclass || ClassIsRestricted(self.team_no, self.playerclass)) 
   self.playerclass = 1 + floor(random() * (10 - 1));
  self.tfstate = 8;
  TeamFortress_ExecClassScript(self);
 }
 else 
  self.tfstate = 0;
 if (iszoom == 1) 
  self.tfstate = self.tfstate | 4096;
#ifndef TG
 if (self.playerclass != 9) 
  Engineer_RemoveBuildings(self);
#endif
 self.takedamage = 2;
 TeamFortress_PrintClassName(self, self.playerclass, self.tfstate & 8);
 TeamFortress_SetEquipment();
 TeamFortress_SetHealth();
 TeamFortress_SetSpeed(self);
 TeamFortress_SetSkin(self);
 stuffcmd(self, "v_idlescale 0\nfov 90\n");
 stuffcmd(self, "v_cshift; wait; bf\n");
 SetTeamName(self);
 W_SetCurrentAmmo();
 self.attack_finished = time + 0.3;
 self.th_pain = player_pain;
 self.th_die = PlayerDie;
 if (self.height) {
  self.height = 0;
  TF_zoom(90);
 }
 self.deadflag = 0;
 self.pausetime = 0;
 spot = SelectSpawnPoint();
 if (self.playerclass) 
  spawn_tdeath(spot.origin, self);
 self.observer_list = spot;
 self.origin = spot.origin + '0 0 1';
 self.angles = spot.angles;
 self.fixangle = 1;
 if (spot.classname == "info_player_teamspawn" && cb_prematch_time < time) {
  if (spot.items) {
   te = Finditem(spot.items);
   if (te) 
    tfgoalitem_GiveToPlayer(te, self, self);
   if (!(spot.goal_activation & 1)) 
    spot.items = 0;
  }
  if (spot.message) {
   CenterPrint(self, spot.message);
   if (!(spot.goal_activation & 2)) 
    spot.message = string_null;
  }
  if (spot.activate_goal_no) {
   te = Findgoal(spot.activate_goal_no);
   if (te) 
    AttemptToActivate(te, self, spot);
  }
  if (spot.goal_effects == 1) {
   spot.classname = "deadpoint";
   spot.team_str_home = string_null;
   spot.nextthink = time + 1;
   spot.think = SUB_Remove;
  }
 }
 setmodel(self, string_null);
 modelindex_null = self.modelindex;
 setmodel(self, "progs/eyes.mdl");
 modelindex_eyes = self.modelindex;
 setmodel(self, "progs/player.mdl");
 modelindex_player = self.modelindex;
 if (!self.playerclass) {
  self.modelindex = modelindex_null;
  self.current_menu = 1;
 }
 setsize(self, '-16 -16 -24', '16 16 32');
 self.view_ofs = '0 0 22';
 self.velocity = '0 0 0';
 player_stand1();
 if (deathmatch || coop) {
  makevectors(self.angles);
  if (self.playerclass) 
   spawn_tfog(self.origin + v_forward * 20);
 }
 if (stof(infokey(world, "rj"))) 
  rj = stof(infokey(world, "rj"));
 else 
  rj = 1;
 if (cease_fire) {
  sprint(self, 2, "\n\nCEASE FIRE MODE\n");
//  self.immune_to_check = time + 10;
  self.tfstate = self.tfstate | 65536;
  TeamFortress_SetSpeed(self);
 }
};

void () info_player_start =
{
 if (!CheckExistence()) {
  dremove(self);
  return;
 }
};

void () info_player_start2 =
{
 if (!CheckExistence()) {
  dremove(self);
  return;
 }
};

void () testplayerstart =
{
 if (!CheckExistence()) {
  dremove(self);
  return;
 }
};

void () info_player_deathmatch =
{
 if (!CheckExistence()) {
  dremove(self);
  return;
 }
};

void () info_player_coop =
{
 if (!CheckExistence()) {
  dremove(self);
  return;
 }
};

void (entity c) PrintClientScore =
{
 if (c.frags > -10 && c.frags < 0) 
  bprint(1, " ");
 else {
  if (c.frags >= 0) {
   if (c.frags < 100) 
    bprint(1, " ");
   if (c.frags < 10) 
    bprint(1, " ");
  }
 }
 bprint(c.frags, ftos(c.frags));
 bprint(1, " ");
 bprint(1, c.netname);
 bprint(1, "\n");
};

void () DumpScore =
{
 local entity e;
 local entity sort;
 local entity walk;

 if (world.chain) 
  error("DumpScore: world.chain is set");
 e = find(world, classname, "player");
 sort = world;
 while (e) {
  if (!sort) {
   sort = e;
   e.chain = world;
  }
  else {
   if (e.frags > sort.frags) {
    e.chain = sort;
    sort = e;
   }
   else {
    walk = sort;
    do {
     if (!walk.chain) {
      e.chain = world;
      walk.chain = e;
     }
     else {
      if (walk.chain.frags < e.frags) {
       e.chain = walk.chain;
       walk.chain = e;
      }
      else 
       walk = walk.chain;
     }
    } while (walk.chain != e);
   }
  }
  e = find(e, classname, "player");
 }
 bprint(1, "\n");
 while (sort) {
  PrintClientScore(sort);
  sort = sort.chain;
 }
 bprint(1, "\n");
};

float already_cycled;

void () NextLevel =
{
 local entity o;
 local string st;

 if (already_cycled) 
  return;
 already_cycled = 1;
 o = spawn();
 o.map = nextmap;
 o.think = execute_changelevel;
 o.nextthink = time + 0.1;
};

void () CheckRules =
{
 if (timelimit && time >= timelimit) 
  NextLevel();
 else {
  if (fraglimit && self.frags >= fraglimit) 
   NextLevel();
 }
};

void () PlayerDeathThink =
{
 local entity old_self;
 local float forward;

 if (self.flags & 512) {
  forward = vlen(self.velocity);
  forward = forward - 20;
  if (forward <= 0) 
   self.velocity = '0 0 0';
  else 
   self.velocity = forward * normalize(self.velocity);
 }
 if (self.deadflag == 2) {
  if (self.button2 || self.button1 || self.button0) 
   return;
  self.deadflag = 3;
  self.tfstate = self.tfstate - (self.tfstate & 8192);
  return;
 }
 if (!self.button2 && !self.button1 && !self.button0) {
  if (self.tfstate & 8192) {
   if (self.respawn_time <= time) {
    self.button0 = 0;
    self.button1 = 0;
    self.button2 = 0;
    respawn();
   }
  }
  return;
 }
 else {
  self.tfstate = self.tfstate | 8192;
  if (self.respawn_time <= time) {
   self.button0 = 0;
   self.button1 = 0;
   self.button2 = 0;
   respawn();
  }
  return;
 }
};

void () PlayerJump =
{
 local vector start;
 local vector end;

 if (self.has_disconnected == 1) 
  return;
 if (self.flags & 2048) 
  return;
 if (self.waterlevel >= 2) {
  if (self.watertype == -3) 
   self.velocity_z = 100;
  else {
   if (self.watertype == -4) 
    self.velocity_z = 80;
   else 
    self.velocity_z = 50;
  }
  if (self.swim_flag < time) {
   self.swim_flag = time + 1;
   if (random() < 0.5) 
    sound(self, 4, "misc/water1.wav", 1, 1);
   else 
    sound(self, 4, "misc/water2.wav", 1, 1);
  }
/*  if (self.fire_held_down && self.current_weapon == 32768) {
   stuffcmd(self, "v_idlescale 0\n");
   self.tfstate = self.tfstate - (self.tfstate & 2048);
   TeamFortress_SetSpeed(self);
   self.weaponframe = 0;
   self.heat = 0;
   self.count = 1;
   player_assaultcannondown1();
  }*/

  return;
 }
 if (!(self.flags & 512)) 
  return;
 if (!(self.flags & 4096)) 
  return;
 self.flags = self.flags - (self.flags & 4096);
 self.button2 = 0;
 sound(self, 4, "player/plyrjmp8.wav", 1, 1);
/* if (self.fire_held_down && self.current_weapon == 32768) {
  stuffcmd(self, "v_idlescale 0\n");
  sprint(self, 1, "You cannot fire the assault cannon without your feet on the ground...\n");
  self.tfstate = self.tfstate - (self.tfstate & 2048);
  TeamFortress_SetSpeed(self);
  self.weaponframe = 0;
  self.count = 1;
  self.heat = 0;
  player_assaultcannondown1();
 }*/

};


.float dmgtime;

void () WaterMove =
{
 if (self.movetype == 8) 
  return;
 if (self.health < 0) 
  return;
 if (self.waterlevel != 3) {
  if (self.air_finished < time) 
   sound(self, 2, "player/gasp2.wav", 1, 1);
  else {
   if (self.air_finished < time + 9) 
    sound(self, 2, "player/gasp1.wav", 1, 1);
  }
  self.air_finished = time + 12;
  self.dmg = 2;
 }
 else {
  if (self.air_finished < time) {
   if (self.pain_finished < time) {
    self.dmg = self.dmg + 2;
    if (self.dmg > 15) 
     self.dmg = 10;
    TF_T_Damage(self, world, world, self.dmg, 1, 0);
    self.pain_finished = time + 1;
   }
  }
 }
 if (!self.waterlevel) {
  if (self.flags & 16) {
   sound(self, 4, "misc/outwater.wav", 1, 1);
   self.flags = self.flags - 16;
  }
  return;
 }
 if (self.watertype == -5) {
  if (self.dmgtime < time) {
   if (self.radsuit_finished > time) 
    self.dmgtime = time + 1;
   else 
    self.dmgtime = time + 0.2;
   TF_T_Damage(self, world, world, 10 * self.waterlevel, 0, 16);
  }
 }
 else {
  if (self.watertype == -4) {
   if (self.dmgtime < time && self.radsuit_finished < time) {
    self.dmgtime = time + 1;
    T_Damage(self, world, world, 4 * self.waterlevel);
   }
  }
 }
 if (!(self.flags & 16)) {
  if (self.watertype == -5) 
   sound(self, 4, "player/inlava.wav", 1, 1);
  if (self.watertype == -3) 
   sound(self, 4, "player/inh2o.wav", 1, 1);
  if (self.watertype == -4) 
   sound(self, 4, "player/slimbrn2.wav", 1, 1);
  self.flags = self.flags + 16;
  self.dmgtime = 0;
 }
};

void () CheckWaterJump =
{
 local vector start;
 local vector end;

 makevectors(self.angles);
 start = self.origin;
 start_z = start_z + 8;
 v_forward_z = 0;
 normalize(v_forward);
 end = start + v_forward * 24;
 traceline(start, end, 1, self);
 if (trace_fraction < 1) {
  start_z = start_z + self.maxs_z - 8;
  end = start + v_forward * 24;
  self.movedir = trace_plane_normal * -50;
  traceline(start, end, 1, self);
  if (trace_fraction == 1) {
   self.flags = self.flags | 2048;
   self.velocity_z = 225;
   self.flags = self.flags - (self.flags & 4096);
   self.teleport_time = time + 2;
   return;
  }
 }
};

void () PlayerPreThink =
{
 local float mspeed;
 local float aspeed;
 local float r;
 local vector src;

 if (self.is_feigning && self.waterlevel == 1) {
  self.watertype = -3;
  self.waterlevel = 3;
 }
 if (self.cheat_level > 0) 
  self.cheat_level = self.cheat_level - 1;
 if (intermission_running) {
  IntermissionThink();
  return;
 }
 makevectors(self.v_angle);
 if (!self.playerclass) {
  if (self.button2 && self.current_menu == 2 && !self.team_no) {
   if (TeamFortress_TeamPutPlayerInTeam()) {
    self.current_menu = 3;
    self.menu_count = 25;
   }
  }
 }
 if (self.view_ofs == '0 0 0') 
  return;
 CheckRules();
 if (self.playerclass) 
  WaterMove();
 if (self.deadflag >= 2) {
  PlayerDeathThink();
  return;
 }
 if (self.undercover_team || self.undercover_skin || self.is_undercover) {
  if (self.effects & (8 | 4)) {
   sprint(self, 1, "The glowing removes your disguise.\n");
   Spy_RemoveDisguise(self);
  }
 }
 if (self.deadflag == 1) 
  return;
 if (!self.is_feigning) {
  if (self.button2) 
   PlayerJump();
  else 
   self.flags = self.flags | 4096;
 }
 else {
  if (self.waterlevel) 
   self.velocity_z = -100;
 }
 if (time < self.pausetime || cease_fire == 1) 
  self.velocity = '0 0 0';
 if (time > self.attack_finished && !self.currentammo && self.weapon > 16) {
  self.weapon = W_BestWeapon();
  W_SetCurrentAmmo();
 }
 if (self.on_hook) 
  Service_Grapple();
};

void () CheckPowerups =
{
 local float lighton;
 local entity te;

 if (self.health <= 0) 
  return;
 if (!self.playerclass) 
  self.modelindex = modelindex_null;
 else {
  if (self.is_undercover == 1 && invis_only == 1) {
   self.frame = 0;
   self.modelindex = modelindex_eyes;
  }
  else {
   if (self.invisible_finished) {
    if (self.tfstate & 64) {
     if (self.invisible_finished < time + 10) 
      self.invisible_finished = time + 666;
    }
    if (self.invisible_sound < time) {
     sound(self, 0, "items/inv3.wav", 0.5, 2);
     self.invisible_sound = time + random() * 3 + 1;
    }
    if (self.invisible_finished < time + 3) {
     if (self.invisible_time == 1) {
      sprint(self, 2, "Ring of Shadows magic is fading\n");
      stuffcmd(self, "bf\n");
      sound(self, 0, "items/inv2.wav", 1, 1);
      self.invisible_time = time + 1;
     }
     if (self.invisible_time < time) {
      self.invisible_time = time + 1;
      stuffcmd(self, "bf\n");
     }
    }
    if (self.invisible_finished < time) {
     self.items = self.items - 524288;
     self.invisible_finished = 0;
     self.invisible_time = 0;
    }
    self.frame = 0;
    self.modelindex = modelindex_eyes;
   }
   else 
    self.modelindex = modelindex_player;
  }
 }
 if (self.invincible_finished) {
  if (self.tfstate & 32) {
   if (self.invincible_finished < time + 10) 
    self.invincible_finished = time + 666;
  }
  if (self.invincible_finished < time + 3) {
   if (self.invincible_time == 1) {
    sprint(self, 2, "Protection is almost burned out\n");
    stuffcmd(self, "bf\n");
    sound(self, 0, "items/protect2.wav", 1, 1);
    self.invincible_time = time + 1;
   }
   if (self.invincible_time < time) {
    self.invincible_time = time + 1;
    stuffcmd(self, "bf\n");
   }
  }
  if (self.invincible_finished < time) {
   self.items = self.items - 1048576;
   self.invincible_time = 0;
   self.invincible_finished = 0;
  }
  if (self.invincible_finished > time) {
   self.effects = self.effects | 8;
   self.effects = self.effects | 128;
  }
  else {
   lighton = 0;
   te = find(world, classname, "item_tfgoal");
   while (te) {
    if (te.owner == self) {
     if (te.goal_activation & 1) 
      lighton = 1;
    }
    te = find(te, classname, "item_tfgoal");
   }
   if (!lighton) {
    self.effects = self.effects - (self.effects & 8);
    self.effects = self.effects - (self.effects & 128);
   }
  }
 }
 if (self.super_damage_finished) {
  if (self.tfstate & #TFSTATE_QUAD) {
   if (self.super_damage_finished == time + 10) 
    self.super_damage_finished = time + 666;
  }
  if (self.super_damage_finished < time + 3) {
   if (self.super_time == 1) {
    sprint(self, 2, "Quad Damage is wearing off\n");
    stuffcmd(self, "bf\n");
    sound(self, 0, "items/damage2.wav", 1, 1);
    self.super_time = time + 1;
   }
   if (self.super_time < time) {
    self.super_time = time + 1;
    stuffcmd(self, "bf\n");
   }
  }
  if (self.super_damage_finished < time) {
   self.items = self.items - #IT_QUAD;
   self.super_damage_finished = 0;
   self.super_time = 0;
  }
  if (self.super_damage_finished > time) {
   self.effects = self.effects | 8;
   self.effects = self.effects | 64;
  }
  else {
   lighton = 0;
   te = find(world, classname, "item_tfgoal");
   while (te) {
    if (te.owner == self) {
     if (te.goal_activation & 1) 
      lighton = 1;
    }
    te = find(te, classname, "item_tfgoal");
   }
   if (!lighton) {
    self.effects = self.effects - (self.effects & 8);
    self.effects = self.effects - (self.effects & 64);
   }
  }
 }
 if (self.radsuit_finished) {
  self.air_finished = time + 12;
  if (self.tfstate & 256) {
   if (self.radsuit_finished == time + 10) 
    self.radsuit_finished = time + 666;
  }
  if (self.radsuit_finished < time + 3) {
   if (self.rad_time == 1) {
    sprint(self, 2, "Air supply in Biosuit expiring\n");
    stuffcmd(self, "bf\n");
    sound(self, 0, "items/suit2.wav", 1, 1);
    self.rad_time = time + 1;
   }
   if (self.rad_time < time) {
    self.rad_time = time + 1;
    stuffcmd(self, "bf\n");
   }
  }
  if (self.radsuit_finished < time) {
   self.items = self.items - 2097152;
   self.rad_time = 0;
   self.radsuit_finished = 0;
  }
 }
};

void () PlayerPostThink =
{
 local float mspeed;
 local float aspeed;
 local float r;
 local float fdmg;
 local string st;

 if (self.view_ofs == '0 0 0') 
  return;
 if (self.deadflag) {
  DeadImpulses();
  self.impulse = 0;
  return;
 }
 if (self.jump_flag < -300 && (self.flags & 512) && self.health > 0) {
  if (self.watertype == -3) 
   sound(self, 4, "player/h2ojump.wav", 1, 1);
  else {
   if (self.jump_flag < -650) {
    fdmg = 5;
    fdmg = fdmg * self.jump_flag / 300 * -1;
    if (self.playerclass == 1) 
     fdmg = fdmg / 2;
    else {
     if (self.playerclass == 6) 
      fdmg = fdmg * 1.5;
    }
    fdmg = rint(fdmg);
    TF_T_Damage(self, world, world, fdmg, 1, 0);
    sound(self, 2, "player/land2.wav", 1, 1);
    self.deathtype = "falling";
   }
   else 
    sound(self, 2, "player/land.wav", 1, 1);
  }
 }
 self.jump_flag = self.velocity_z;
 CheckPowerups();
 W_WeaponFrame();
 if (self.motd <= 95) 
  TeamFortress_MOTD();
 else {
  if (!self.cheat_check) 
   self.cheat_check = time + 5;
  else {
  if(time > self.StatusRefreshTime)
  {
   if (self.StatusBarSize) 
    RefreshStatusBar(self);
   }
  }
 }
 if (self.cheat_check <= time) {
  TeamFortress_CheckTeamCheats();
  self.cheat_check = time + 3;
 }
};

void () ClientConnect =
{
 local entity te;
 local string st;
 local string st2;
 local float got_one;

 bprint(2, self.netname);
 bprint(2, " entered the game\n");
 if (!0) 
  self.tfstate = self.tfstate | 4096;
 self.motd = 0;
 self.got_aliases = 0;
 if (self.netname == string_null) 
  KickCheater(self);
 st = infokey(self, "sbr");
 if (st == string_null) 
  st = infokey(self, "sbar_res");
// if(st != string_null) {
  if (st == "768") 
   self.StatusBarRes = 8;
  else {
   if (st == "600") 
    self.StatusBarRes = 7;
   else {
    if (st == "480") 
     self.StatusBarRes = 6;
   else {
    if (st == "400") 
     self.StatusBarRes = 5;
    else {
     if (st == "384") 
      self.StatusBarRes = 4;
     else {
      if (st == "350") 
       self.StatusBarRes = 3;
      else {
       if (st == "300") 
        self.StatusBarRes = 2;
       else {
        if (st == "240") 
         self.StatusBarRes = 1;
        else 
         self.StatusBarRes = 0;
       }
      }
     }
    }
   }
  }
 }
// }
 st = infokey(self, "sbs");
 if (st == string_null) 
  st = infokey(self, "sbar_size");
// if(st!=string_null) {
  self.StatusBarSize = stof(st);
  if (self.StatusBarSize > 2 || self.StatusBarSize < 0) 
   self.StatusBarSize = 0;
// }
 TeamFortress_ExecMapScript(self);
 self.has_disconnected = 0;
 if (self.netname == string_null) 
  KickCheater(self);
 if (intermission_running) 
  GotoNextMap();
 st2 = infokey(world, "apw");
 if (st2 == string_null) 
  st2 = infokey(world, "adminpwd");
 st = infokey(self, "adminpwd");
 if (st2 != string_null && st != string_null && st == st2) {
  self.is_admin = 1;
  stuffcmd(self, "setinfo apw \"");
  stuffcmd(self, "\"\n");
  TeamFortress_Alias("countplayers", 192, 0);
  TeamFortress_Alias("kick", 190, 0);
  TeamFortress_Alias("yes", 191, 0);
  TeamFortress_Alias("no", 195, 0);
  TeamFortress_Alias("ceasefire", 193, 0);
 }
 else 
  self.is_admin = 0;
 if (clanbattle && self.has_disconnected != 1) {
  got_one = 0;
  st = infokey(self, "tf_id");
  self.tf_id = stof(st);
  if (st != string_null && self.tf_id) {
   sprint(self, 2, "Welcome back!\n");
   te = find(world, classname, "ghost");
   while (te) {
    if (te.tf_id == self.tf_id) {
     got_one = 1;
     TeamFortress_TeamSet(te.team_no);
     self.frags = te.frags;
     self.real_frags = te.real_frags;
     if (!(toggleflags & 128) && !(toggleflags & 2048)) 
      self.frags = self.real_frags;
     self.playerclass = te.playerclass;
     self.tfstate = te.tfstate;
     dremove(te);
     te = world;
    }
    else 
     te = find(te, classname, "ghost");
   }
  }
  if (!got_one) {
   if (game_locked && cb_prematch_time < time) {
    sprint(self, 2, "Closed Server. Clan Battle in progress.\n");
    KickCheater(self);
    return;
   }
   last_id = last_id + 20 + random() * 10;
   self.tf_id = rint(random() * 10 + last_id);
   st = ftos(self.tf_id);
   stuffcmd(self, "setinfo tf_id ");
   stuffcmd(self, st);
   stuffcmd(self, "\n");
   sprint(self, 2, "Your Battle ID is ", st, "\n");
  }
 }
 if (cb_prematch_time > time) 
  sprint(self, 2, "CURRENTLY IN PREMATCH TIME\n");
};

void () ClientDisconnect =
{
 local entity te;
 local string st;
 local float fr;

 fr = rint(self.frags);
 st = ftos(fr);
 bprint4(2, self.netname, " left the game with ", st, " frags\n");
 sound(self, 4, "player/tornoff2.wav", 1, 0);
 self.has_disconnected = 1;
 TeamFortress_RemoveTimers();
 Engineer_RemoveBuildings(self);
 te = find(world, classname, "detpack");
 while (te) {
#ifndef TG
  if (te.owner == self) {
#else
  if (te.real_owner == self) {
#endif
   if (te.weaponmode == 1) {
    TeamFortress_SetSpeed(te.enemy);
    dremove(te.oldenemy);
    dremove(te.observer_list);
   }
   dremove(te);
   te = world;
  }
  te = find(te, classname, "detpack");
 }
 if (clanbattle && self.tf_id) {
  te = spawn();
  te.classname = "ghost";
  te.tf_id = self.tf_id;
  te.team_no = self.team_no;
  te.frags = self.frags;
  te.real_frags = self.real_frags;
  te.netname = self.netname;
  te.playerclass = self.playerclass;
  if (self.tfstate & 8) 
   te.tfstate = 8;
 }
 set_suicide_frame();
 self.netname = string_null;
 self.team_no = 0;
 self.solid = 0;
 setsize(self, '0 0 0', '0 0 0');
};

void (entity targ, entity attacker) ClientObituary =
{
 local float rnum;
 local string deathstring;
 local string deathstring2;
 local float attackerteam;
 local float targteam;
 local entity te;

 rnum = random();
 if (cb_prematch_time + 3 > time) 
  return;
 if (targ.classname == "player") {
  if (attacker.classname == "teledeath") {
   bprint(1, targ.netname);
   bprint(1, " was telefragged by ");
   bprint(1, attacker.owner.netname);
   bprint(1, "\n");
   if (attacker.owner.team_no != targ.team_no || attacker.owner.team_no < 1) 
    TF_AddFrags(attacker.owner, 1);
   return;
  }
  if (attacker.classname == "teledeath2") {
   bprint(1, "Satan's power deflects ");
   bprint(1, targ.netname);
   bprint(1, "'s telefrag\n");
   TF_AddFrags(targ, -1);
   logfrag(targ, targ);
   return;
  }
  if (deathmsg == 37) {
   bprint(1, targ.netname);
   bprint(1, " shoots his teammate one too many times.\n");
   return;
  }
  if (attacker.classname == "info_tfgoal" || attacker.classname == "item_tfgoal") {
   if (attacker.deathtype != "") {
    bprint(1, targ.netname);
    bprint(1, attacker.deathtype);
   }
   logfrag(targ, targ);
   return;
  }
  if (attacker.classname == "player" || attacker.classname == "bot") {
   if (targ == attacker) {
    TF_AddFrags(attacker, -1);
    if (birthday == 1 && random() < 0.3) {
     if (random() < 0.1) {
      bprint(1, "It's ");
      bprint(1, targ.netname);
      bprint(1, "'s party and he'll cry if he wants to!\n");
      return;
     }
     bprint(1, targ.netname);
     if (random() < 0.5) 
      bprint(1, " gets too selfish with his gifts\n");
     else 
      bprint(1, " wasn't born so beautiful after all\n");
     return;
    }
    bprint(1, targ.netname);
    if (deathmsg == 8) {
     if (targ.playerclass == 2) 
      deathstring = " got splattered by his own grenade\n";
     else {
      if (targ.playerclass == 3) 
       deathstring = " sat on his own grenade\n";
      else {
       if (targ.playerclass == 4) 
        deathstring = " got to know his grenade too well\n";
       else {
        if (targ.playerclass == 5) 
         deathstring = " caught the end of his own grenade\n";
        else {
         if (targ.playerclass == 6) 
          deathstring = " got too close to his own grenade\n";
         else {
          if (targ.playerclass == 7) 
           deathstring = " let his own grenade get the best of him\n";
          else {
           if (targ.playerclass == 8) 
            deathstring = " tiptoed over his own grenade\n";
           else {
            if (targ.playerclass == 9) 
             deathstring = " stared at his grenade too long\n";
            else 
             deathstring = " grenades himself\n";
           }
          }
         }
        }
       }
      }
     }
    }
    else {
     if (deathmsg == 9) 
      deathstring = " hammers himself\n";
     else {
      if (deathmsg == 10) {
       if (targ.playerclass == 4) 
        deathstring = " practiced his own Mirv dance\n";
       else {
        if (targ.playerclass == 6) 
         deathstring = " allowed his Mirv to turn against him\n";
        else 
         deathstring = " goes to pieces\n";
       }
      }
      else {
       if (deathmsg == 11) 
        deathstring = " ambushes himself with his own pipebombs\n";
       else {
        if (deathmsg == 40) 
         deathstring = " tried to juggle his own pipebombs\n";
        else {
         if (deathmsg == 24) 
          deathstring = " chokes on his own gas\n";
         else {
          if (deathmsg == 30) 
           deathstring = " explodes his ammo and body\n";
          else {
           if (deathmsg == 41) 
            deathstring = " stepped on too many of his own caltrops\n";
           else {
            if (deathmsg == 35) 
             deathstring = " is charred by his own flash grenade\n";
            else {
             if (deathmsg == 31) 
              deathstring = " detonates an ammo box too close to him\n";
             else {
              if (deathmsg == 12) 
               deathstring = " set the detpack and forgot to run\n";
              else {
               if (deathmsg == 13) 
                deathstring = " died impossibly!\n";
               else {
                if (deathmsg == 6) {
                 if (rnum) 
                  deathstring = " becomes bored with life\n";
                 else 
                  deathstring = " checks if his weapon is loaded\n";
                }
                else {
                 if (deathmsg == 33) 
                  deathstring = " chars himself with an incendiary rocket\n";
                 else {
                  if (deathmsg == 5) 
                   deathstring = " tries to put the pin back in\n";
                  else {
                   if (deathmsg == 15) 
                    deathstring = " torches himself\n";
                   else {
                    if (deathmsg == 7 && targ.waterlevel > 1) {
                     bprint(1, " discharges into the water.\n");
                     return;
                    }
                    else {
                     if (deathmsg == 38) 
                      deathstring = " gets too friendly with his sentrygun.\n";
                     else {
                      if (deathmsg == 39) 
                       deathstring = " dispenses with himself.\n";
                     }
                    }
                   }
                  }
                 }
                }
               }
              }
             }
            }
           }
          }
         }
        }
       }
      }
     }
    }
    bprint(1, deathstring);
    return;
   }
   else {
    if (teamplay && attacker.team_no == targ.team_no && attacker.team_no > 0) {
     TF_AddFrags(attacker, -1);
     if (!targ.undercover_team) 
      attacker.teamkills = attacker.teamkills + 1;
     if (birthday == 1 && random() < 0.3) {
      if (random() < 0.3) 
       bprint2(1, targ.netname, " is a party-pooper!\n");
      else 
       bprint2(1, targ.netname, " gives gifts to his teammates!\n");
      return;
     }
     deathstring2 = "\n";
     if (rnum < 0.25) {
      deathstring = " mows down teammate ";
      deathstring2 = "\n";
     }
     else {
      if (rnum < 0.5) {
       deathstring = " checks his glasses after killing ";
       deathstring2 = "\n";
      }
      else {
       if (rnum < 0.75) {
        deathstring = " gets a frag for the other team with ";
        deathstring2 = "'s death\n";
       }
       else {
        deathstring = " killed his supposed friend ";
        deathstring2 = "\n";
       }
      }
     }
     if (deathmsg == 23) {
      bprint(1, targ.netname);
      bprint(1, " didn't survive the operation by ");
      bprint(1, attacker.netname);
      bprint(1, "\n");
      return;
     }
     bprint(1, attacker.netname);
     bprint(1, deathstring);
     bprint(1, targ.netname);
     bprint(1, deathstring2);
     CheckAutoKick(attacker);
     return;
    }
    else {
     TF_AddFrags(attacker, 1);
     logfrag(attacker, targ);
     if (birthday == 1 && random() < 0.5) {
      if (deathmsg == 9) {
       deathstring = " chews on ";
       deathstring2 = "'s nails!\n";
      }
      else {
       if (deathmsg == 10) {
        deathstring = " gathers the darling buds of ";
        deathstring2 = "'s Mirv grenade\n";
       }
       else {
        if (deathmsg == 30) {
         deathstring = "'s presents go up in ";
         deathstring2 = "'s EMP presence.\n";
        }
        else {
         if (deathmsg == 35) {
          bprint(1, targ.netname);
          bprint(1, " goes POP!\n");
          return;
         }
         else {
          if (deathmsg == 31) {
           deathstring = " stands to near ";
           deathstring2 = "'s birthday surprise\n";
          }
          else {
           if (deathmsg == 12) {
            deathstring = " eats ";
            deathstring2 = "'s good cheer!\n";
            if (random() < 0.1) 
             bprint(1, "Damn that jokey smurf!\n");
           }
           else {
            if (deathmsg == 16) {
             deathstring = " cut the red ribbon of ";
             deathstring2 = "'s detpack\n";
            }
            else {
             if (deathmsg == 5) {
              deathstring = " recieves a gift from ";
              deathstring2 = "\n";
              if (targ.health < -40) {
               deathstring = " plays pass-the-parcel with ";
               deathstring2 = "\n";
              }
             }
             else {
              if (deathmsg == 6) {
               deathstring = " rides ";
               deathstring2 = "'s firecracker\n";
               if (targ.health < -40) {
                bprint(1, targ.netname);
                bprint(1, " gets turned into little ");
                bprint(1, targ.netname);
                bprint(1, "'s by ");
                bprint(1, attacker.netname);
                bprint(1, deathstring2);
                return;
               }
              }
              else {
               if (deathmsg == 15) {
                if (rnum < 0.5) {
                 deathstring = " gets too close to ";
                 deathstring2 = "'s kitchen\n";
                }
                else {
                 deathstring = " plays with ";
                 deathstring2 = "'s fire\n";
                }
               }
               else {
                if (deathmsg == 18) {
                 if (rnum <= 0.3) {
                  deathstring = " blocks ";
                  deathstring2 = "'s birthday bullet with his chest\n";
                 }
                 else {
                  deathstring = " gets party popped by ";
                  deathstring2 = "\n";
                 }
                }
                else {
                 if (deathmsg == 29) {
                  if (rnum <= 0.5) {
                   deathstring = " ALMOST catches ";
                   deathstring2 = "'s bullet between his teeth!\n";
                  }
                  else {
                   deathstring = " loves snipers like ";
                   deathstring2 = "\n";
                  }
                 }
                 else {
                  if (deathmsg == 28) {
                   deathstring = " won't run crying to ";
                   deathstring2 = " anymore\n";
                  }
                  else {
                   if (deathmsg == 19) {
                    deathstring = " collects ";
                    deathstring2 = "'s highspeed gifts.\n";
                   }
                   else {
                    if (deathmsg == 20) {
                     deathstring = " died. I blame ";
                     deathstring2 = "\n";
                    }
                    else {
                     if (deathmsg == 22) {
                      deathstring = " gets a gift in the back from ";
                      deathstring2 = "\n";
                     }
                     else {
                      if (deathmsg == 2) {
                       deathstring = " gets a double of ";
                       deathstring2 = "'s buck\n";
                      }
                      else {
                       if (deathmsg == 25) {
                        deathstring = " is all partied out by ";
                        deathstring2 = "\n";
                       }
                       else {
                        if (deathmsg == 26) {
                         deathstring = " gets derailed by ";
                         deathstring2 = "\n";
                        }
                        else {
                         if (deathmsg == 3) {
                          deathstring = " gets no say in it, no say in it at all! sings ";
                          deathstring2 = "\n";
                         }
                         else {
                          if (deathmsg == 33) {
                           deathstring = " gets all fired up by ";
                           deathstring2 = "\n";
                          }
                          else {
                           if (random() < 0.5) 
                            deathstring = " recieves a gift from ";
                           else 
                            deathstring = " has a happy birthday, thanks to ";
                           deathstring2 = "\n";
                          }
                         }
                        }
                       }
                      }
                     }
                    }
                   }
                  }
                 }
                }
               }
              }
             }
            }
           }
          }
         }
        }
       }
      }
      bprint(1, targ.netname);
      bprint(1, deathstring);
      bprint(1, attacker.netname);
      bprint(1, deathstring2);
      return;
     }
     if (deathmsg == 8) {
      if (attacker.playerclass == 2) {
       deathstring = " got up-close and personal with ";
       deathstring2 = "'s grenade\n";
      }
      else {
       if (attacker.playerclass == 3) {
        deathstring = " played catch with ";
        deathstring2 = "'s grenade\n";
       }
       else {
        if (attacker.playerclass == 4) {
         deathstring = " received a pineapple enema from ";
         deathstring2 = "\n";
        }
        else {
         if (attacker.playerclass == 5) {
          deathstring = " fetched ";
          deathstring2 = "'s pineapple\n";
         }
         else {
          if (attacker.playerclass == 6) {
           deathstring = " caught too much shrapnel from ";
           deathstring2 = "'s grenade\n";
          }
          else {
           if (attacker.playerclass == 7) {
            deathstring = " tried to pick up ";
            deathstring2 = "'s hot potato\n";
           }
           else {
            if (attacker.playerclass == 8) {
             deathstring = " thought ";
             deathstring2 = " was tossing him a spare grenade\n";
            }
            else {
             if (attacker.playerclass == 9) {
              deathstring = " stops to ponder the technical details of ";
              deathstring2 = "'s grenade\n";
             }
             else {
              deathstring = " surfs on a grenade from ";
              deathstring2 = "\n";
             }
            }
           }
          }
         }
        }
       }
      }
     }
     else {
      if (deathmsg == 9) {
       deathstring = " gets flayed by ";
       deathstring2 = "'s nail grenade\n";
      }
      else {
       if (deathmsg == 10) {
        if (attacker.playerclass == 4) {
         deathstring = " does a dance on ";
         deathstring2 = "'s Mirv grenade\n";
        }
        else {
         deathstring = " gets spammed by ";
         deathstring2 = "'s Mirv grenade\n";
        }
       }
       else {
        if (deathmsg == 11) {
         deathstring = " is caught by ";
         deathstring2 = "'s pipebomb trap\n";
        }
        else {
         if (deathmsg == 40) {
          deathstring = " fell victim to ";
          deathstring2 = "'s fireworks\n";
         }
         else {
          if (deathmsg == 24) {
           deathstring = " gags on ";
           deathstring2 = "'s noxious gasses\n";
          }
          else {
           if (deathmsg == 30) {
            deathstring = "'s ammo detonates him as ";
            deathstring2 = "'s EMP fries it\n";
           }
           else {
            if (deathmsg == 41) {
             deathstring = " stepped on too many of ";
             deathstring2 = "'s caltrops\n";
            }
            else {
             if (deathmsg == 35) {
              deathstring = " is charred by ";
              deathstring2 = "'s flash grenade\n";
             }
             else {
              if (deathmsg == 31) {
               deathstring = " stands near some ammo as ";
               deathstring2 = "'s EMP nukes it\n";
              }
              else {
               if (deathmsg == 12) {
                deathstring = " reaches orbit via ";
                deathstring2 = "'s detpack\n";
               }
               else {
                if (deathmsg == 16) {
                 deathstring = " cut the red wire of ";
                 deathstring2 = "'s detpack\n";
                }
                else {
                 if (deathmsg == 13) {
                  deathstring = " dies from ";
                  deathstring2 = "'s mysterious tropical disease\n";
                 }
                 else {
                  if (deathmsg == 14) {
                   deathstring = " escapes infection from ";
                   deathstring2 = " by dying first\n";
                  }
                  else {
                   if (deathmsg == 5) {
                    deathstring = " eats ";
                    deathstring2 = "'s pineapple\n";
                    if (targ.health < -40) {
                     deathstring = " was gibbed by ";
                     deathstring2 = "'s grenade\n";
                    }
                   }
                   else {
                    if (deathmsg == 6) {
                     deathstring = " rides ";
                     deathstring2 = "'s rocket\n";
                     if (targ.health < -40) {
                      deathstring = " was gibbed by ";
                      deathstring2 = "'s rocket\n";
                     }
                    }
                    else {
                     if (deathmsg == 15) {
                      if (rnum < 0.2) {
                       deathstring = " is burnt up by ";
                       deathstring2 = "'s flame\n";
                      }
                      else {
                       if (rnum < 0.4) {
                        deathstring = " is fried by ";
                        deathstring2 = "'s fire\n";
                       }
                       else {
                        if (rnum < 0.6) {
                         deathstring = " feels ";
                         deathstring2 = "'s fire of wrath\n";
                        }
                        else {
                         if (rnum < 0.8) {
                          deathstring = " is reduced to ashes by ";
                          deathstring2 = "\n";
                         }
                         else {
                          deathstring = " is grilled by ";
                          deathstring2 = "'s flame\n";
                         }
                        }
                       }
                      }
                     }
                     else {
                      if (deathmsg == 17) {
                       deathstring2 = "\n";
                       if (attacker.playerclass == 8) 
                        deathstring = " was knife-murdered by ";
                       else {
                        if (attacker.playerclass == 1) 
                         deathstring = "'s mellon was split by ";
                        else {
                         if (attacker.playerclass == 2) 
                          deathstring = " was put on the chop block by ";
                         else {
                          if (attacker.playerclass == 3) {
                           deathstring = " was sliced and diced by ";
                           deathstring2 = "'s blade\n";
                          }
                          else {
                           if (attacker.playerclass == 4) {
                            deathstring = " is split from crotch to sternum by ";
                            deathstring2 = "'s axe swing\n";
                           }
                           else {
                            if (attacker.playerclass == 6) 
                             deathstring = " is split in two with a powerful axe blow from ";
                            else {
                             if (attacker.playerclass == 7) {
                              deathstring = "'s death put another notch on ";
                              deathstring2 = "'s axe\n";
                             }
                             else 
                              deathstring = " was ax-murdered by ";
                            }
                           }
                          }
                         }
                        }
                       }
                      }
                      else {
                       if (deathmsg == 32) {
                        deathstring = " was spanner-murdered by ";
                        deathstring2 = "\n";
                       }
                       else {
                        if (deathmsg == 1) {
                         if (attacker.playerclass == 1) {
                          deathstring = " got too close to ";
                          deathstring2 = "'s muzzleflash\n";
                         }
                         else {
                          if (attacker.playerclass == 3) {
                           deathstring = " practices being ";
                           deathstring2 = "'s clay pigeon\n";
                          }
                          else {
                           if (attacker.playerclass == 4) {
                            deathstring = " was on the receiving end of ";
                            deathstring2 = "'s shotgun barrel\n";
                           }
                           else {
                            if (attacker.playerclass == 5) {
                             deathstring = " was fed a lead diet by ";
                             deathstring2 = "\n";
                            }
                            else {
                             if (attacker.playerclass == 6) {
                              deathstring = " got blasted by ";
                              deathstring2 = "'s last resort\n";
                             }
                             else {
                              if (attacker.playerclass == 7) {
                               deathstring = " got more than a powderburn from ";
                               deathstring2 = "'s shotgun blast\n";
                              }
                              else {
                               deathstring = " chewed on ";
                               deathstring2 = "'s boomstick\n";
                              }
                             }
                            }
                           }
                          }
                         }
                        }
                        else {
                         if (deathmsg == 2) {
                          if (attacker.playerclass == 3) {
                           deathstring = " was turned into swiss cheese by ";
                           deathstring2 = "'s buckshot\n";
                          }
                          else {
                           if (attacker.playerclass == 5) {
                            deathstring = " got a double-dose of ";
                            deathstring2 = "'s buckshot\n";
                           }
                           else {
                            if (attacker.playerclass == 6) {
                             deathstring = " unfortunately forgot ";
                             deathstring2 = " carried a super-shotgun\n";
                            }
                            else {
                             if (attacker.playerclass == 8) {
                              deathstring = " gets ventilated by ";
                              deathstring2 = "'s super-shotgun blast\n";
                             }
                             else {
                              if (attacker.playerclass == 9) {
                               deathstring = "'s body got chuck full of ";
                               deathstring2 = "'s lead pellets\n";
                              }
                              else {
                               deathstring = " ate 2 loads of ";
                               deathstring2 = "'s buckshot\n";
                              }
                             }
                            }
                           }
                          }
                         }
                         else {
                          if (deathmsg == 3) {
                           if (attacker.playerclass == 1) {
                            deathstring = " caught one too many nails from ";
                            deathstring2 = "\n";
                           }
                           else {
                            if (attacker.playerclass == 2) {
                             deathstring = " ran into ";
                             deathstring2 = "'s nails\n";
                            }
                            else {
                             if (attacker.playerclass == 8) {
                              deathstring = " was turned into ";
                              deathstring2 = "'s pin-cushion\n";
                             }
                             else {
                              deathstring = " was nailed by ";
                              deathstring2 = "\n";
                             }
                            }
                           }
                          }
                          else {
                           if (deathmsg == 4) {
                            deathstring = " was punctured by ";
                            deathstring2 = "\n";
                           }
                           else {
                            if (deathmsg == 7) {
                             deathstring = " accepts ";
                             if (attacker.waterlevel > 1) 
                              deathstring2 = "'s discharge\n";
                             else 
                              deathstring2 = "'s shaft\n";
                            }
                            else {
                             if (deathmsg == 21) {
                              deathstring = " grappled with ";
                              deathstring2 = "\n";
                             }
                             else {
                              if (deathmsg == 18) {
                               if (rnum <= 0.3) {
                                deathstring = " takes a bullet in the chest from ";
                                deathstring2 = "\n";
                               }
                               else {
                                deathstring = " succumbs to sniperfire from ";
                                deathstring2 = "\n";
                               }
                              }
                              else {
                               if (deathmsg == 29) {
                                if (rnum <= 0.5) {
                                 deathstring = " gets a third eye from ";
                                 deathstring2 = "\n";
                                }
                                else {
                                 deathstring = " gets his head blown off by ";
                                 deathstring2 = "\n";
                                }
                               }
                               else {
                                if (deathmsg == 28) {
                                 if (rnum <= 0.5) {
                                  deathstring = " is made legless by ";
                                  deathstring2 = "\n";
                                 }
                                 else {
                                  deathstring = " gets his legs blown off by ";
                                  deathstring2 = "\n";
                                 }
                                }
                                else {
                                 if (deathmsg == 19) {
                                  deathstring = " collects ";
                                  deathstring2 = "'s bullet spray.\n";
                                 }
                                 else {
                                  if (deathmsg == 20) {
                                   deathstring = " gets sawn in half by ";
                                   deathstring2 = "\n";
                                  }
                                  else {
                                   if (deathmsg == 22) {
                                    deathstring = " gets knifed from behind by ";
                                    deathstring2 = "\n";
                                   }
                                   else {
                                    if (deathmsg == 25) {
                                     deathstring = " is put to sleep by ";
                                     deathstring2 = "\n";
                                    }
                                    else {
                                     if (deathmsg == 26) {
                                      deathstring = " gets a hole in his heart from ";
                                      deathstring2 = "'s railgun\n";
                                     }
                                     else {
                                      if (deathmsg == 33) {
                                       deathstring = " gets well done by ";
                                       deathstring2 = "'s incendiary rocket\n";
                                      }
                                      else {
                                       if (deathmsg == 38) {
                                        deathstring = " gets destroyed by ";
                                        deathstring2 = "'s exploding sentrygun\n";
                                       }
                                       else {
                                        if (deathmsg == 39) {
                                         deathstring = " didn't insert the correct change into ";
                                         deathstring2 = "'s dispenser.\n";
                                        }
                                       }
                                      }
                                     }
                                    }
                                   }
                                  }
                                 }
                                }
                               }
                              }
                             }
                            }
                           }
                          }
                         }
                        }
                       }
                      }
                     }
                    }
                   }
                  }
                 }
                }
               }
              }
             }
            }
           }
          }
         }
        }
       }
      }
     }
     bprint(1, targ.netname);
     bprint(1, deathstring);
     bprint(1, attacker.netname);
     bprint(1, deathstring2);
    }
   }
   return;
  }
  else {
   if (attacker.classname == "building_sentrygun") {
    if (targ == attacker.real_owner) {
     if (deathmsg == 34) 
      deathstring = " intercepts his sentry gun's rocket\n";
     else {
      if (deathmsg == 27) 
       deathstring = " crossed his sentry gun's line of fire\n";
     }
     bprint(1, targ.netname);
     bprint(1, deathstring);
    }
    else {
     if (teamplay && attacker.team_no == targ.team_no && attacker.team_no > 0) {
      bprint(1, targ.netname);
      bprint(1, " obstructs his team's sentry gun\n");
     }
     else {
      TF_AddFrags(attacker.real_owner, 1);
      logfrag(attacker.real_owner, targ);
      if (deathmsg == 34) {
       deathstring = " hates ";
       deathstring2 = "'s sentry gun\n";
      }
      else {
       if (deathmsg == 27) {
        deathstring = " is mown down by ";
        deathstring2 = "'s sentry gun\n";
       }
      }
      bprint(1, targ.netname);
      bprint(1, deathstring);
      bprint(1, attacker.real_owner.netname);
      bprint(1, deathstring2);
     }
    }
   }
   else {
    logfrag(targ, targ);
    TF_AddFrags(targ, -1);
    rnum = targ.watertype;
    bprint(2, targ.netname);
    if (rnum == -3) {
     if (birthday == 1) {
      if (random() < 0.5) 
       deathstring = " bobs for apples\n";
      else 
       deathstring = " drowns in the punch\n";
     }
     else {
      if (random() < 0.5) 
       deathstring = " sleeps with the fishes\n";
      else 
       deathstring = " sucks it down\n";
     }
    }
    else {
     if (rnum == -4) {
      if (random() < 0.5) 
       deathstring = " gulped a load of slime\n";
      else 
       deathstring = " can't exist on slime alone\n";
     }
     else {
      if (rnum == -5) {
       if (targ.health < -15) 
        deathstring = " burst into flames\n";
       else {
        if (random() < 0.5) 
         deathstring = " turned into hot slag\n";
        else 
         deathstring = " visits the Volcano God\n";
       }
      }
      else {
       if (attacker.classname == "explo_box") 
        deathstring = " blew up\n";
       else {
        if (attacker.solid == 4 && attacker != world) 
         deathstring = " was squished\n";
        else {
         if (targ.deathtype == "falling") {
          targ.deathtype = string_null;
          deathstring = " fell to his death\n";
         }
         else {
          if (attacker.classname == "trap_shooter" || attacker.classname == "trap_spikeshooter") 
           deathstring = " was spiked\n";
          else {
           if (attacker.classname == "fireball") 
            deathstring = " ate a lavaball\n";
           else {
            if (attacker.classname == "trigger_changelevel") 
             deathstring = " tried to leave\n";
            else 
             deathstring = " died\n";
           }
          }
         }
        }
       }
      }
     }
    }
    bprint(1, deathstring);
   }
  }
 }
 else {
  if (targ.classname == "building_sentrygun") {
   if (attacker.classname == "teledeath") {
    bprint(1, targ.real_owner.netname);
    bprint(1, "'s sentrygun was telefragged by ");
    bprint(1, attacker.owner.netname);
    bprint(1, "\n");
    return;
   }
   if (attacker.classname == "player") {
    if (attacker == targ.real_owner) {
     bprint(1, targ.real_owner.netname);
     bprint(1, " destroys his sentrygun\n");
     return;
    }
    bprint(1, targ.real_owner.netname);
    bprint(1, "'s sentrygun was destroyed by ");
    bprint(1, attacker.netname);
    bprint(1, "\n");
    if (attacker.team_no > 0 && attacker.team_no == targ.real_owner.team_no) {
     TF_AddFrags(attacker, -1);
     attacker.teamkills = attacker.teamkills + 1;
     CheckAutoKick(attacker);
    }
    else 
     TF_AddFrags(attacker, 1);
    return;
   }
  }
  else {
   if (targ.classname == "building_dispenser") {
    if (attacker.team_no > 0 && attacker.team_no == targ.real_owner.team_no) {
     TF_AddFrags(attacker, -1);
     attacker.teamkills = attacker.teamkills + 1;
     CheckAutoKick(attacker);
    }
   }
  }
 }
};

