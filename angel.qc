/*
 *  QW-TF2003-qc
 *  Copyright (C) 2003-2004  [sd] angel
 *
 *
 *  This program is free software; you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation; either version 2 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program; if not, write to the Free Software
 *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 *
 */

string (float pc) TeamFortress_GetClassName;
float (entity Goal, entity AP) Activated;
float (float tno) TeamFortress_TeamGetTopColor;
string (float tno) TeamFortress_TeamGetColorString;
/////////////////////////////////////////////////////////////
string (float col) TeamFortress_GetColorString =
{
 if (col == 0) 
  return "White";
 if (col == 1) 
  return "Brown";
 if (col == 2) 
  return "Blue";
 if (col == 3) 
  return "Green";
 if (col == 4) 
  return "Red";
 if (col == 5) 
  return "Tan";
 if (col == 6) 
  return "Pink";
 if (col == 7) 
  return "Orange";
 if (col == 8) 
  return "Purple";
 if (col == 9 ) 
  return "DarkPurple";
 if (col == 10) 
  return "Grey";
 if (col == 11) 
  return "DarkGreen";
 if (col == 12) 
  return "Yellow";

 return "DarkBlue";

};

/////////////////////////////////////////////////////////////

float (entity spot)CheckTelefragSpot=
{
  local entity at_spot;
  at_spot = findradius(spot.origin, 40);
  while (at_spot != world) {
   if (at_spot.classname == "player" && !at_spot.deadflag && at_spot.team_no == self.team_no && at_spot != self) 
    return 0;
   at_spot = at_spot.chain;
  }
 return 1;
};


entity (float team_num) FindRandomTeamSpawnPoint =
{
 local entity spot;
 local entity at_spot;
 local float numspots;
 local float rndspot;
 local string teststr;

 if (team_num == 1)
     teststr="ts1";
  else if (team_num == 2) 
         teststr="ts2";
  else if (team_num == 3) 
         teststr="ts3";
  else if (team_num == 4) 
         teststr="ts4";
         else  return world;

  spot = find(world, team_str_home, teststr);
   if (spot == world) 
    return world;
   numspots=0;
   while(spot != world)
   {
     if( CheckTelefragSpot(spot) && Activated(spot, self))
       numspots=numspots+1;
     spot = find(spot, team_str_home, teststr);
   }
   if(numspots != 0){
   rndspot = rint(random() * (numspots - 1));

   spot = find(world, team_str_home, teststr);
   while(spot != world)
   {
    if( CheckTelefragSpot(spot) && Activated(spot, self))
    {
     if(!rndspot)return spot;
     rndspot = rndspot - 1;
    }
    spot = find(spot, team_str_home, teststr);
   }
  }
   numspots=0;
   spot = find(world, team_str_home, teststr);
   while(spot != world)
   {
     if(Activated(spot, self))
       numspots=numspots+1;
     spot = find(spot, team_str_home, teststr);
   }
  if(numspots == 0) return world;
  rndspot = rint(random() * (numspots - 1));

  spot = find(world, team_str_home, teststr);
  while(spot != world)
  {
   if( Activated(spot, self))
   {
    if(!rndspot)return spot;
    rndspot = rndspot - 1;
   }
   spot = find(spot, team_str_home, teststr);
  }

  return spot;
};


/////////////////////////////////////////////////////////////
void (entity pl) Angel_PrintRules =
{
 local string st;
 local string st1;
 local float fl;

 if (clanbattle == 1) {
  st = infokey(world, "pm");
  if (!st) 
   st = infokey(world, "prematch");
  fl = stof(st) * 60;
  st = ftos(fl);
  sprint(pl, 2, "Clan battle: œŒ\nPrematch: ", st, " seconds\n");
  st = infokey(world, "cft");
  if (!st) 
    st = infokey(world, "ceasefire_time");
  fl = stof(st) * 60;
  st = ftos(fl);
  sprint(pl, 2, "Cease fire: ", st, " seconds\n");
 }
 else 
  sprint(pl, 2, "Clan battle: œ∆∆\n");
 st=ftos(cheat_pause);
 sprint3(pl, 2, "Cheat pause: ",st,"\n");
 if (old_grens) 
  sprint(pl, 2, "œÃƒ grenades\n");
 else 
  sprint(pl, 2, "Œ≈◊ grenades\n");

 if(topcolor_check)
 {
   sprint(pl, 2, "Topcolor checking enabled\n");
  fl = TeamFortress_TeamGetTopColor(1);
  st=ftos(fl);
  st1 = TeamFortress_GetColorString(fl);
  sprint(pl, 2, " Team 1 topcolor: ",st," ",st1,"\n");
  
  if(number_of_teams >=2)
  {
   fl = TeamFortress_TeamGetTopColor(2);
   st=ftos(fl);
   st1 = TeamFortress_GetColorString(fl);
   sprint(pl, 2, " Team 2 topcolor: ",st," ",st1,"\n");
  }
  if(number_of_teams >=3)
  {
   fl = TeamFortress_TeamGetTopColor(3);
   st=ftos(fl);
   st1 = TeamFortress_GetColorString(fl);
   sprint(pl, 2, " Team 3 topcolor: ",st," ",st1,"\n");
  }
  if(number_of_teams >=4)
  {
   fl = TeamFortress_TeamGetTopColor(4);
   st=ftos(fl);
   st1 = TeamFortress_GetColorString(fl); 
   sprint(pl, 2, " Team 4 topcolor: ",st," ",st1,"\n");
  }

 }else
  sprint(pl, 2, "Topcolor checking disabled\n");
 if (sentry_type == #SENTRY_MTFL) 
  sprint(pl, 2, "Sentry: 2.8.1 fixed(mtfl)\n");
 if (sentry_type == #SENTRY_OLD) 
  sprint(pl, 2, "Sentry: 2.8.1\n");
 if (sentry_type == #SENTRY_FIX) 
  sprint(pl, 2, "Sentry: 2.8.1 fixed new\n");
 if (sentry_type == #SENTRY_NEW) 
   {
     st=ftos(sgppl);
     sprint3(pl, 2, "Sentry: NEW ",st," ppl\n");
   }
 if (sentry_type == #SENTRY_MTFL_NEWFIND) 
   {
     st=ftos(sgppl);
     sprint3(pl, 2, "Sentry: MTFL new find ",st," ppl\n");
   }
 if (sentry_type == #SENTRY_OLD_NEWFIND) 
   {
     st=ftos(sgppl);
     sprint3(pl, 2, "Sentry: 2.8.1 new find ",st," ppl\n");
   }

 if(new_build_check)
         sprint(pl, 2, "New Build Check: œŒ\n");
        else 
         sprint(pl, 2, "New Build Check: œ∆∆\n");
 if(new_gas){
   sprint(pl, 2, "New Gas Options:\n");
   if((new_gas & #GAS_MASK_COLOR) && !(new_gas & #GAS_MASK_ALLSPYS))
   {
     sprint(pl, 2, " Players Colors: ");
     if(new_gas & #GAS_MASK_ALLCOLORS)
     {
       sprint(pl, 2, "16\n");
     }else
     {
       if(new_gas & #GAS_MASK_4COLORS)
       {
        sprint(pl, 2, "4\n");       
       }else
       {
         st = ftos(number_of_teams);       
         sprint(pl, 2, st,"\n");       
       }
     }
   }
   if(new_gas & #GAS_MASK_ALLSPYS)
   {
     sprint(pl, 2, " Players Skins: Spys\n");
   }else{
    if(new_gas & #GAS_MASK_SKIN)
     sprint(pl, 2, " Players Skins: Random\n");
   }
  if(new_gas & #GAS_MASK_PALETTE)
         sprint(pl, 2, " Palette: œŒ\n");
        else 
         sprint(pl, 2, " Palette: œ∆∆\n");
 
  if(new_gas & #GAS_MASK_NEWGREN_EFFECTS)
         sprint(pl, 2, " New Gren Effects: œŒ\n");
        else 
         sprint(pl, 2, " New Gren Effects: œ∆∆\n");

  if(new_gas & #GAS_MASK_NEWGREN_TIMES)
         sprint(pl, 2, " New Gren Times: œŒ\n");
        else 
         sprint(pl, 2, " New Gren Times: œ∆∆\n");
  if(new_gas & #GAS_MASK_NEWGREN_DMG)
         sprint(pl, 2, " New Gren DMG: œŒ\n");
        else 
         sprint(pl, 2, " New Gren DMG: œ∆∆\n");


  if(!(new_gas & #GAS_MASK_DISABLE_ID))
         sprint(pl, 2, " ID: œŒ\n");
        else 
         sprint(pl, 2, " ID: œ∆∆\n");

 }

 if(new_flash)
         sprint(pl, 2, "New Flash: œŒ\n");
        else 
         sprint(pl, 2, "New Flash: œ∆∆\n");

 if(sv262)
         sprint(pl, 2, "2.62 server extension: œŒ\n");
        else 
         sprint(pl, 2, "2.62 server extension: œ∆∆\n");

 if(!disable_powerups)
         sprint(pl, 2, "Powerups: œŒ\n");
        else 
         sprint(pl, 2, "Powerups: œ∆∆\n");

 if(flag_timer)
         sprint(pl, 2, "Flag Timer: œŒ\n");
        else 
         sprint(pl, 2, "Flag Timer: œ∆∆\n");

 if(snip_fps)
 {
              sprint(pl, 2, "Sniper FPS: ");
              st=ftos(snip_fps);
              sprint(pl, 2, st);
              sprint(pl, 2, "\n");

        } else 
         sprint(pl, 2, "Sniper FPS: œ∆∆\n");

 if(snip_range_fix)
         sprint(pl, 2, "Sniper Range Fix: œŒ\n");
        else 
         sprint(pl, 2, "Sniper Range Fix: œ∆∆\n");
  sprint(pl, 2, "Sniper ammo cost: ");
  st=ftos(snip_ammo);
  sprint(pl, 2, st);
  sprint(pl, 2, "\n");

  sprint(pl, 2, "Sniper Reload Time: ");
  st=ftos(snip_time);
  sprint(pl, 2, st);
  sprint(pl, 2, "\n");

 if(random_tf_spawn)
         sprint(pl, 2, "Random Team Spawn: œŒ\n");
        else 
         sprint(pl, 2, "Random Team Spawn: œ∆∆\n");

 if(allow_drop_goal)
         sprint(pl, 2, "Drop Goals: œŒ\n");
        else 
         sprint(pl, 2, "Drop Goals: œ∆∆\n");

 if(add_pipe)
         sprint(pl, 2, "Additional pipebomb: œŒ\n");
        else 
         sprint(pl, 2, "Additional pipebomb: œ∆∆\n");

 if (gren2box) 
 {
   sprint(pl, 2, "Extended Backpack:\n");
   if(gren2box & #BP_TYPE_HEALTH)
           sprint(pl, 2, " Drop Health   : œŒ\n");
     else  sprint(pl, 2, " Drop Health   : œ∆∆\n");

   if(gren2box & #BP_TYPE_ARMOR)
           sprint(pl, 2, " Drop Armor    : œŒ\n");
     else  sprint(pl, 2, " Drop Armor    : œ∆∆\n");

   if(gren2box & #BP_GREN_BYTYPE)
           sprint(pl, 2, " Drop Grenades : Type-depend\n");
     else  {
      if(gren2box & #BP_GREN_BYTYPE)
           sprint(pl, 2, " Drop Grenades : œŒ\n");
     
           sprint(pl, 2, " Drop Grenades : œ∆∆\n");
     }
   if(gren2box & #BP_TYPE_DETPACK)
           sprint(pl, 2, " Drop Detpack  : œŒ\n");
     else  sprint(pl, 2, " Drop Detpack  : œ∆∆\n");
 }else {     
 sprint(pl, 2, "Extended Backpack: œ∆∆\n"); 
 }
 if(disable_grens) 
 {
  sprint(pl, 2, "Disabled Grenade Types:\n"); 
  if(disable_grens & #DG_TYPE_NORMAL)
   sprint(pl, 2, " Normal\n"); 
  if(disable_grens & #DG_TYPE_CONCUSSION)
   sprint(pl, 2, " Concussion\n"); 
  if(disable_grens & #DG_TYPE_NAIL)
   sprint(pl, 2, " Nail\n"); 
  if(disable_grens & #DG_TYPE_MIRV)
   sprint(pl, 2, " Mirv\n"); 
  if(disable_grens & #DG_TYPE_NAPALM)
   sprint(pl, 2, " Napalm\n"); 
  if(disable_grens & #DG_TYPE_FLARE)
   sprint(pl, 2, " Flare\n"); 
  if(disable_grens & #DG_TYPE_GAS)
   sprint(pl, 2, " Gas\n"); 
  if(disable_grens & #DG_TYPE_EMP)
   sprint(pl, 2, " Emp\n"); 
  if(disable_grens & #DG_TYPE_FLASH)
   sprint(pl, 2, " Flash\n"); 
  if(disable_grens & #DG_TYPE_CALTROPS)
   sprint(pl, 2, " Caltrops\n"); 
  if(disable_grens & #DG_TYPE_DETPACK)
   sprint(pl, 2, " Detpack\n"); 

//   sprint(pl, 2, "\n"); 
 }else
  sprint(pl, 2, "All Grenades Enabled\n"); 
 if(mtfl)
  sprint(pl, 2, "MTFL Settings ON\n"); 
#ifdef TG
#ifdef LAN_SERVER
 sprint(pl, 2, "TF2003(QWLAN TF) Training Ground by êsdë angel for Õ‘∆Ã\n"); 
#else
 sprint(pl, 2, "TF2003 Training Ground by êsdë angel for Õ‘∆Ã\n"); 
#endif
#else
#ifdef LAN_SERVER
 sprint(pl, 2, "TF2003(QWLAN TF) by êsdë angel for Õ‘∆Ã\n"); 
#else
 sprint(pl, 2, "TF2003 by êsdë angel for Õ‘∆Ã\n"); 
#endif
#endif 
 sprint(pl, 2, #ANGEL_VERSION); 

};

/////////////////////////////////////////////////////////////
void (entity Player) TeamFortress_TeamShowMemberClasses_New =
{
 local entity e;
 local entity te;
 local float found;
 local string st;
 local float stf;
 found = 0;
 st = infokey(Player, "s");
 stf=0;
 if(st != string_null)
 {
  stf=stof(st);
 }
 e = find(world, classname, "player");
 while (e) {
  if ((e.team_no == Player.team_no || !e.team_no) && e != Player) {
   if (e.model != string_null) {
    if (!found) {
     found = 1;
     sprint(Player, 2, "The other members of your team are:\n");
    }
//    sprint(Player, 2, "\"");
    sprint(Player, 2, e.netname);
//    sprint(Player, 2, "\"");
    sprint(Player, 2, " : ");
                          st = TeamFortress_GetClassName(e.playerclass);
                          sprint(Player, 2, st);
                          if ( e.tfstate & 8) 
                           sprint(Player, 2, " (Random)");

//    TeamFortress_PrintClassName(Player, e.playerclass, e.tfstate & 8);
   if(e.playerclass)
   {
    if((stf & #TF_STATUS_STATS_MASK) ==0)
    {
     if(e.armortype == 0.8)
     sprint(Player, 2, " R");
     else if(e.armortype == 0.6)
     sprint(Player, 2, " Y");
     else if(e.armortype == 0.3)
     sprint(Player, 2, " G");
     else 
      sprint(Player, 2, "  ");
      st=ftos(rint(e.armorvalue));
      sprint(Player,2, st);
      sprint(Player, 2, "/");
      st=ftos(rint(e.health));
      sprint(Player,2, st);
     }
      if((e.playerclass == #PC_SPY) && ((stf & #TF_STATUS_SPY_MASK) ==0))
      {
       if(e.undercover_team == 1)
        sprint(Player, 2, " Blue");
       if(e.undercover_team == 2)
        sprint(Player, 2, " Red");
       if(e.undercover_team == 3)
        sprint(Player, 2, " Yellow");
       if(e.undercover_team == 4)
        sprint(Player, 2, " Green");

       if(e.undercover_skin == 1)
        sprint(Player, 2, " Scout");
       if(e.undercover_skin == 2)
        sprint(Player, 2, " Sniper");
       if(e.undercover_skin == 3)
        sprint(Player, 2, " Soldier");
       if(e.undercover_skin == 4)
        sprint(Player, 2, " Demoman");
       if(e.undercover_skin == 5)
        sprint(Player, 2, " Medic");
       if(e.undercover_skin == 6)
        sprint(Player, 2, " Hwguy");
       if(e.undercover_skin == 7)
        sprint(Player, 2, " Pyro");
       if(e.undercover_skin == 8)
        sprint(Player, 2, " Spy");
       if(e.undercover_skin == 9)
        sprint(Player, 2, " Engineer");
      }
    if((e.playerclass == #PC_DEMOMAN) && ((stf & #TF_STATUS_DETPACK_MASK) !=0))
    {
     te = find(world, classname, "detpack");
      while (te) {
      if (te.owner == e) {
                           st=ftos(rint(te.nextthink - time));
                           sprint2(Player, 2, " DTP:", st);
                          }
                  te = find(te, classname, "detpack");
                 }
    }
    if((e.playerclass == #PC_ENGINEER) && ((stf & #TF_STATUS_SENTRY_MASK) !=0))
    {
     if(e.has_sentry)
     {
      te = find(world, classname, "building_sentrygun");
       while (te) {
       if (te.real_owner == e) {
             st=ftos(te.weapon);
             sprint2(Player, 2, " SENTRY:", st);
                                }
       te = find(te, classname, "building_sentrygun");
                 }
     }else{
      sprint(Player, 2, " NOSENTRY");
     }
    }
    if((stf & #TF_STATUS_COORD_MASK) !=0)
    {
       st = vtos(e.origin);
       sprint2(Player, 2, " ", st);
    }
   }
    sprint(Player, 2, "\n");
   }
  }
  e = find(e, classname, "player");
 }
 if (!found) 
  sprint(Player, 2, "There are no other players on your team.\n");
};
