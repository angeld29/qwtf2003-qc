void (entity Goal, entity Player, entity Item) DisplayItemStatus;
void (entity Item, entity AP, float method) tfgoalitem_RemoveFromPlayer;
void () TeamFortress_CheckClassStats;
void (entity Player, float Armorclass) TeamFortress_DescribeArmor;
void () TeamFortress_AmmoboxTouch;
float (float tno) num_team_ammoboxes;
void (float tno) RemoveOldAmmobox;
void (float tno) increment_team_ammoboxes;
void (float tno) decrement_team_ammoboxes;
void () TeamFortress_ExplodePerson;
void () TeamFortress_Regenerate;
void () TeamFortress_CheckforCheats;
void () TeamFortress_RegenerateCells;
void () TeamFortress_AutoID;
void () ScannerSwitch;
void () W_SetCurrentAmmo;

void () UseSpecialSkill =
{
 local vector src;

 self.impulse = 0;
 if (self.playerclass == 1) 
  self.impulse = 163;
//                ScannerSwitch();
 else {
  if (self.playerclass == 2) 
   self.impulse = 174;
  else {
   if (self.playerclass == 3) 
   {
          if (self.current_weapon != #WEAP_ROCKET_LAUNCHER && self.ammo_rockets > 0) 
           self.impulse = 7;
          else 
           self.impulse = 3;
//    self.impulse = 173;
   }
   else {
    if (self.playerclass == 4) 
     self.impulse = 170;
    else {
     if (self.playerclass == 5) 
          {
             if (self.current_weapon != #WEAP_MEDIKIT) 
              self.impulse = #TF_MEDIKIT;
             else 
                 if(self.ammo_nails >0)
              self.impulse = 5;
             else  
              self.impulse = 3;

//      self.impulse = 176;
          } 
     else {
      if (self.playerclass == #PC_HVYWEAP) 
      {
             if (self.current_weapon == #WEAP_SUPER_SHOTGUN) 
              self.impulse = 7;
             else 
              self.impulse = 3;
      }
      else {
       if (self.playerclass == 7) {
        if (self.current_weapon == #WEAP_FLAMETHROWER || self.ammo_cells == 0) 
         self.impulse = 7;
        else 
         self.impulse = 6;
       }
       else {
        if (self.playerclass == 8) 
         self.impulse = 177;
        else {
         if (self.playerclass == 9) 
          self.impulse = 179;
         else {
          if (!self.playerclass) {
           if (self.enemy == world) {
            src = self.origin + v_forward * 10;
            src_z = self.absmin_z + self.size_z * 0.7;
            traceline(src, src + v_forward * 2048, 0, self);
            if (trace_ent != world && trace_ent.origin != world.origin) {
             sprint3(self, 2, "Locked onto ", trace_ent.classname, "\n");
             self.enemy = trace_ent;
             self.camdist = vlen(self.enemy.origin - self.origin);
             self.camangle = self.origin - self.enemy.origin;
             self.camangle_z = 0 - self.camangle_z;
             self.camangle = vectoangles(self.camangle);
            }
           }
           else {
            sprint(self, 2, "Removed Lock\n");
            self.enemy = world;
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
};

void () TeamFortress_ChangeClass =
{
 local entity spot;
 local entity te;
 local float tc;
 local string st;

 if (self.playerclass) {
  if (deathmatch != 3 && cb_prematch_time < time) 
   return;
  if (TeamFortress_TeamIsCivilian(self.team_no)) {
   sprint(self, 2, "You cannot change class.\n");
   return;
  }
  if (!IsLegalClass(self.impulse - 100)) {
   sprint(self, 2, "Your team cannot play that class.\n");
   TeamFortress_DisplayLegalClasses();
   return;
  }
  if (spy_off == 1 && self.impulse - 100 == 8) {
   sprint(self, 2, "The spy class has been disabled on the server by the administrator.\n");
   return;
  }
  if (ClassIsRestricted(self.team_no, self.impulse - 100)) {
   sprint(self, 2, "Your team already has enough of that class.\n");
   return;
  }
  self.nextpc = self.impulse - 100;
  sprint(self, 2, "After dying, you will return as a ");
  TeamFortress_PrintClassName(self, self.nextpc, self.tfstate & 8);
  if(self.deadflag)
   self.immune_to_check = time + 10;
  return;
 }
 if (teamplay && !self.team_no) {
  if (toggleflags & 64) {
   if (!TeamFortress_TeamPutPlayerInTeam()) 
    return;
  }
  else {
   sprint(self, 2, "You must join a team first. \n");
   sprint(self, 2, "use imin1, imin2, imin3, or imin4\n");
   return;
  }
 }
 if (!self.lives) {
  sprint(self, 2, "You have no lives left.\n");
  return;
 }
 if (!IsLegalClass(self.impulse - 100) && self.impulse != 1) {
  sprint(self, 2, "You cannot play that playerclass on this map. \n");
  TeamFortress_DisplayLegalClasses();
  return;
 }
 if (spy_off == 1 && self.impulse - 100 == 8) {
  sprint(self, 2, "The spy class has been disabled on the server by the administrator.\n");
  return;
 }
 if (ClassIsRestricted(self.team_no, self.impulse - 100)) {
  sprint(self, 2, "Your team has enough of that class.\n");
  return;
 }
 TeamFortress_ExecClassScript(self);
 if (self.impulse != 1) 
  self.playerclass = self.impulse - 100;
 else 
  self.playerclass = 11;
 self.nextpc = 0;
 self.takedamage = 2;
 self.movetype = 3;
 self.flags = 8 | 512;
 self.waterlevel = 0;
 self.air_finished = time + 12;
 self.solid = 3;
 self.pausetime = 0;
 spot = SelectSpawnPoint();
 self.origin = spot.origin + '0 0 1';
 self.angles = spot.angles;
 self.fixangle = 1;
 setmodel(self, string_null);
 modelindex_null = self.modelindex;
 setmodel(self, "progs/eyes.mdl");
 modelindex_eyes = self.modelindex;
 setmodel(self, "progs/player.mdl");
 modelindex_player = self.modelindex;
 setsize(self, '-16 -16 -24', '16 16 32');
 self.view_ofs = '0 0 22';
 player_stand1();
 if (deathmatch || coop) {
  makevectors(self.angles);
  spawn_tfog(self.origin + v_forward * 20);
 }
 if (self.playerclass == 10) {
  sprint(self, 2, "Random Playerclass.\n");
  self.tfstate = self.tfstate | 8;
  self.playerclass = 1 + floor(random() * (10 - 1));
 }
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
 spot = find(world, classname, "player");
 while (spot) {
  if (spot.team_no == self.team_no && spot != self) {
   sprint(spot, 2, self.netname);
   sprint(spot, 2, " is playing as a ");
   TeamFortress_PrintClassName(spot, self.playerclass, self.tfstate & 8);
  }
  spot = find(spot, classname, "player");
 }
 TeamFortress_PrintClassName(self, self.playerclass, self.tfstate & 8);
 TeamFortress_SetEquipment();
 TeamFortress_SetHealth();
 TeamFortress_SetSpeed(self);
 TeamFortress_SetSkin(self);
 TeamFortress_ExecClassScript(self);
 if (cease_fire) {
  sprint(self, 2, "\n\nCEASE FIRE MODE\n");
//  self.immune_to_check = time + 10;
  self.tfstate = self.tfstate | 65536;
  TeamFortress_SetSpeed(self);
 }
};

void () TeamFortress_DisplayLegalClasses =
{
 local float gotone;
 local float ill;

 sprint(self, 2, "Legal Classes for your team are:\n");
 gotone = 0;
 ill = TeamFortress_TeamGetIllegalClasses(self.team_no);
 if (!(illegalclasses & 1) && !(ill & 1)) {
  if (gotone) 
   sprint(self, 2, ", ");
  gotone = 1;
  sprint(self, 2, "Scout");
 }
 if (!(illegalclasses & 2) && !(ill & 2)) {
  if (gotone) 
   sprint(self, 2, ", ");
  gotone = 1;
  sprint(self, 2, "Sniper");
 }
 if (!(illegalclasses & 4) && !(ill & 4)) {
  if (gotone) 
   sprint(self, 2, ", ");
  gotone = 1;
  sprint(self, 2, "Soldier");
 }
 if (!(illegalclasses & 8) && !(ill & 8)) {
  if (gotone) 
   sprint(self, 2, ", ");
  gotone = 1;
  sprint(self, 2, "Demolitions Man");
 }
 if (!(illegalclasses & 16) && !(ill & 16)) {
  if (gotone) 
   sprint(self, 2, ", ");
  gotone = 1;
  sprint(self, 2, "Combat Medic");
 }
 if (!(illegalclasses & 32) && !(ill & 32)) {
  if (gotone) 
   sprint(self, 2, ", ");
  gotone = 1;
  sprint(self, 2, "Heavy Weapons Guy");
 }
 if (!(illegalclasses & 64) && !(ill & 64)) {
  if (gotone) 
   sprint(self, 2, ", ");
  gotone = 1;
  sprint(self, 2, "Pyro");
 }
 if (!(illegalclasses & 256) && !(ill & 256)) {
  if (gotone) 
   sprint(self, 2, ", ");
  gotone = 1;
  sprint(self, 2, "Spy");
 }
 if (!(illegalclasses & 512) && !(ill & 512)) {
  if (gotone) 
   sprint(self, 2, ", ");
  gotone = 1;
  sprint(self, 2, "Engineer");
 }
 if (!(illegalclasses & 128) && !(ill & 128)) {
  if (gotone) 
   sprint(self, 2, ", ");
  gotone = 1;
  sprint(self, 2, "RandomPC");
 }
 sprint(self, 2, "\n");
};

void () TeamFortress_Inventory =
{
 local entity tg;
 local string ac;
 local float col;
 local entity te;

 col = TeamFortress_TeamGetColor(self.team_no);
 sprint(self, 2, "You're in team ");
 ac = ftos(self.team_no);
 sprint(self, 2, ac);
 sprint(self, 2, ", color ");
 ac = ftos(col);
 sprint(self, 2, ac);
 sprint(self, 2, ".\n");
 if (self.lives != -1) {
  ac = ftos(self.lives);
  sprint(self, 2, "You've got ");
  sprint(self, 2, ac);
  if (self.lives == 1) 
   sprint(self, 2, " life.\n");
  else 
   sprint(self, 2, " lives.\n");
 }
 if (self.no_grenades_1 > 0) {
  sprint(self, 2, "Gren.Type 1 : ");
  if (self.tp_grenades_1 == 1) 
   sprint(self, 2, " Normal(");
  else {
   if (self.tp_grenades_1 == 2) 
    sprint(self, 2, " Concussion(");
   else {
    if (self.tp_grenades_1 == 3) 
     sprint(self, 2, " Nail(");
    else {
     if (self.tp_grenades_1 == 4) 
      sprint(self, 2, " Mirv(");
     else {
      if (self.tp_grenades_1 == 5) 
       sprint(self, 2, " Napalm(");
      else {
       if (self.tp_grenades_1 == 6) 
        sprint(self, 2, " Flare(");
       else {
        if (self.tp_grenades_1 == 7) 
         sprint(self, 2, " Hallucinogenic(");
        else {
         if (self.tp_grenades_1 == 8) 
          sprint(self, 2, " EMP(");
         else {
          if (self.tp_grenades_1 == 10) 
           sprint(self, 2, " Caltrop(");
          else {
           if (self.tp_grenades_1 == 9) 
            sprint(self, 2, " Flash(");
           else 
            sprint(self, 2, "BUG(");
          }
         }
        }
       }
      }
     }
    }
   }
  }
  ac = ftos(self.no_grenades_1);
  sprint(self, 2, ac);
  sprint(self, 2, ")\n");
 }
 if (self.no_grenades_2 > 0) {
  sprint(self, 2, "Gren.Type 2 : ");
  if (self.tp_grenades_2 == 1) 
   sprint(self, 2, " Normal(");
  else {
   if (self.tp_grenades_2 == 2) 
    sprint(self, 2, " Concussion(");
   else {
    if (self.tp_grenades_2 == 3) 
     sprint(self, 2, " Nail(");
    else {
     if (self.tp_grenades_2 == 4) 
      sprint(self, 2, " Mirv(");
     else {
      if (self.tp_grenades_2 == 5) 
       sprint(self, 2, " Napalm(");
      else {
       if (self.tp_grenades_2 == 6) 
        sprint(self, 2, " Flare(");
       else {
        if (self.tp_grenades_2 == 7) 
         sprint(self, 2, " Hallucinogenic(");
        else {
         if (self.tp_grenades_2 == 8) 
          sprint(self, 2, " EMP(");
         else {
          if (self.tp_grenades_2 == 9) 
           sprint(self, 2, " Flash(");
          else 
           sprint(self, 2, "BUG(");
         }
        }
       }
      }
     }
    }
   }
  }
  ac = ftos(self.no_grenades_2);
  sprint(self, 2, ac);
  sprint(self, 2, ")\n");
 }
 if (self.tf_items & 1) 
  sprint(self, 2, "Scanner. ");
 if (self.weapons_carried & 4) {
  sprint(self, 2, "Medikit (");
  ac = ftos(self.ammo_medikit);
  sprint(self, 2, ac);
  sprint(self, 2, ") ");
 }
 if (self.weapons_carried & 131072) {
  if (self.ammo_detpack > 0) {
   ac = ftos(self.ammo_detpack);
   sprint(self, 2, ac);
   sprint(self, 2, " Detpack");
   if (self.ammo_detpack > 1) 
    sprint(self, 2, "s");
   sprint(self, 2, ". ");
  }
 }
 tg = find(world, classname, "item_tfgoal");
 while (tg) {
  if (tg.owner == self) {
   sprint(self, 2, tg.netname);
   sprint(self, 2, ". ");
  }
  tg = find(tg, classname, "item_tfgoal");
 }
 if (self.armorvalue > 0) 
  TeamFortress_DescribeArmor(self, self.armorclass);
 if (!invis_only) {
  if (self.playerclass == 8 && !invis_only) {
   sprint(self, 2, "Skin : ");
   if (self.undercover_skin) 
    TeamFortress_PrintClassName(self, self.undercover_skin, 0);
   else 
    sprint(self, 2, "Spy\n");
   sprint(self, 2, "Colors : Team ");
   if (self.undercover_team) 
    ac = ftos(self.undercover_team);
   else 
    ac = ftos(self.team_no);
   sprint(self, 2, ac);
  }
 }
 sprint(self, 2, "\n");
          te = find(world, classname, "detpack");
         while (te) {
           if (te.owner == self) {
            sprint(self, 2, "Detpack armed: ");
             ac = ftos(rint(te.nextthink - time));
             sprint(self, 2,ac );           
      sprint(self, 2, "\n");           
          }
    te = find(te, classname, "detpack");
          } 

};

void () TeamFortress_ShowTF =
{
 local string st;

 if (toggleflags & 1) 
  sprint(self, 2, "Class Persistence On.\n");
 else 
  sprint(self, 2, "Class Persistence Off.\n");
 if (toggleflags & 2) 
  sprint(self, 2, "Cheat Checking On.\n");
 else 
  sprint(self, 2, "Cheat Checking Off.\n");
 if (toggleflags & 64) 
  sprint(self, 2, "AutoTeam On.\n");
 else 
  sprint(self, 2, "AutoTeam Off.\n");
 if (toggleflags & 4) 
  st = ftos(respawn_delay_time);
 else 
  st = "No";
 sprint(self, 2, st);
 if (st != "No") 
  sprint(self, 2, " second");
 sprint(self, 2, " Respawn Delay.\n");
 if (toggleflags & 128) 
  sprint(self, 2, "TeamFrags On.\n");
 else 
  sprint(self, 2, "TeamFrags Off.\n");
 if (allow_hook) 
  sprint(self, 2, "Grapple On.\n");
 else 
  sprint(self, 2, "Grapple Off.\n");
 if (toggleflags & 2048) 
  sprint(self, 2, "Full TeamScore On.\n");
 else 
  sprint(self, 2, "Full TeamScore Off.\n");
        Angel_PrintRules(self);
};


void () TeamFortress_GrenadePrimed;

void () TeamFortress_PrimeGrenade =
{
 local float gtype;
 local string gs;
 local string ptime;
 local entity tGrenade;

 if ((self.tfstate & 1) || (self.tfstate & 1024)) 
  return;
 if (self.impulse == 150) {
  gtype = self.tp_grenades_1;
                if( (gtype == #GR_TYPE_NORMAL) && (disable_grens & #DG_TYPE_NORMAL)) return; 
                if( (gtype == #GR_TYPE_CONCUSSION) && (disable_grens & #DG_TYPE_CONCUSSION)) return;
                if( (gtype == #GR_TYPE_NAIL) && (disable_grens & #DG_TYPE_NAIL)) return; 
                if( (gtype == #GR_TYPE_MIRV) && (disable_grens & #DG_TYPE_MIRV)) return; 
                if( (gtype == #GR_TYPE_NAPALM) && (disable_grens & #DG_TYPE_NAPALM)) return; 
                if( (gtype == #GR_TYPE_FLARE) && (disable_grens & #DG_TYPE_FLARE)) return; 
                if( (gtype == #GR_TYPE_GAS) && (disable_grens & #DG_TYPE_GAS)) return; 
                if( (gtype == #GR_TYPE_EMP) && (disable_grens & #DG_TYPE_EMP)) return; 
                if( (gtype == #GR_TYPE_FLASH) && (disable_grens & #DG_TYPE_FLASH)) return; 
                if( (gtype == #GR_TYPE_CALTROPS) && (disable_grens & #DG_TYPE_CALTROPS)) return;

  if (self.tp_grenades_1 == 2) 
   gs = "Concussion grenade";
  else {
   if (self.tp_grenades_1 == 3) 
    gs = "Nail grenade";
   else {
    if (self.tp_grenades_1 == 4) 
     gs = "Mirv grenade";
    else {
     if (self.tp_grenades_1 == 5) 
      gs = "Napalm grenade";
     else {
      if (self.tp_grenades_1 == 6) 
       gs = "Flare";
      else {
       if (self.tp_grenades_1 == 7) 
        gs = "Gas grenade";
       else {
        if (self.tp_grenades_1 == 8) 
         gs = "EMP grenade";
        else {
         if (self.tp_grenades_1 == 10) 
          gs = "Caltrop canister";
         else {
          if (self.tp_grenades_1 == 9) 
           gs = "Flash grenade";
          else 
           gs = "Grenade";
         }
        }
       }
      }
     }
    }
   }
  }
  if (self.no_grenades_1 > 0) {
   self.no_grenades_1 = self.no_grenades_1 - 1;
   if (gtype == 6) {
    newmis = spawn();
    newmis.owner = self;
    newmis.movetype = 6;
    newmis.solid = 2;
    newmis.classname = "grenade";
    makevectors(self.v_angle);
    newmis.velocity = v_forward * 600 + v_up * 25;
    newmis.velocity = newmis.velocity * 700;
    newmis.angles = vectoangles(newmis.velocity);
    newmis.weapon = self.team_no;
    newmis.think = FlareGrenadeExplode;
    newmis.nextthink = time + 0.8;
    newmis.touch = FlareGrenadeTouch;
    newmis.skin = 1;
    newmis.mdl = "flare";
    setmodel(newmis, "progs/flare.mdl");
    setsize(newmis, '0 0 0', '0 0 0');
    setorigin(newmis, self.origin);
    return;
   }
   if (gtype == 10) {
    ptime = ftos(0.5);
    sprint(self, 2, "Opening ");
    sprint(self, 2, gs);
    sprint(self, 2, "...\n");
   }
   else {
    ptime = ftos(3);
    sprint(self, 2, gs);
    sprint(self, 2, " primed, ");
    sprint(self, 2, ptime);
    sprint(self, 2, " seconds...\n");
   }
  }
  else {
   sprint(self, 2, "No ");
   sprint(self, 2, gs);
   sprint(self, 2, "s left.\n");
   return;
  }
 }
 if (self.impulse == 151) {
  gtype = self.tp_grenades_2;
                if( (gtype == #GR_TYPE_NORMAL) && (disable_grens & #DG_TYPE_NORMAL)) return; 
                if( (gtype == #GR_TYPE_CONCUSSION) && (disable_grens & #DG_TYPE_CONCUSSION)) return;
                if( (gtype == #GR_TYPE_NAIL) && (disable_grens & #DG_TYPE_NAIL)) return; 
                if( (gtype == #GR_TYPE_MIRV) && (disable_grens & #DG_TYPE_MIRV)) return; 
                if( (gtype == #GR_TYPE_NAPALM) && (disable_grens & #DG_TYPE_NAPALM)) return; 
                if( (gtype == #GR_TYPE_FLARE) && (disable_grens & #DG_TYPE_FLARE)) return; 
                if( (gtype == #GR_TYPE_GAS) && (disable_grens & #DG_TYPE_GAS)) return; 
                if( (gtype == #GR_TYPE_EMP) && (disable_grens & #DG_TYPE_EMP)) return; 
                if( (gtype == #GR_TYPE_FLASH) && (disable_grens & #DG_TYPE_FLASH)) return; 
                if( (gtype == #GR_TYPE_CALTROPS) && (disable_grens & #DG_TYPE_CALTROPS)) return;

  if (self.tp_grenades_2 == 2) 
   gs = "Concussion grenade";
  else {
   if (self.tp_grenades_2 == 3) 
    gs = "Nail grenade";
   else {
    if (self.tp_grenades_2 == 4) 
     gs = "Mirv grenade";
    else {
     if (self.tp_grenades_2 == 5) 
      gs = "Napalm grenade";
     else {
      if (self.tp_grenades_2 == 6) 
       gs = "Flare";
      else {
       if (self.tp_grenades_2 == 7) 
        gs = "Gas grenade";
       else {
        if (self.tp_grenades_2 == 8) 
         gs = "EMP grenade";
        else {
         if (self.tp_grenades_2 == 9) 
          gs = "Flash grenade";
         else 
          gs = "Grenade";
        }
       }
      }
     }
    }
   }
  }
  if (self.no_grenades_2 > 0) {
   self.no_grenades_2 = self.no_grenades_2 - 1;
   if (gtype == 6) {
    newmis = spawn();
    newmis.owner = self;
    newmis.movetype = 6;
    newmis.solid = 2;
    newmis.classname = "grenade";
    makevectors(self.v_angle);
    if (self.v_angle_x) 
     newmis.velocity = v_forward * 1200 + v_up * 200;
    else {
     newmis.velocity = aim(self, 10000);
     newmis.velocity = newmis.velocity * 1200;
     newmis.velocity_z = 75;
    }
    newmis.angles = vectoangles(newmis.velocity);
    newmis.weapon = self.team_no;
    newmis.think = FlareGrenadeExplode;
    newmis.nextthink = time + 0.8;
    newmis.touch = FlareGrenadeTouch;
    newmis.skin = 1;
    newmis.mdl = "flare";
    setmodel(newmis, "progs/flare.mdl");
    setsize(newmis, '0 0 0', '0 0 0');
    setorigin(newmis, self.origin);
    return;
   }
   if (gtype == 10) {
    ptime = ftos(0.5);
    sprint(self, 2, "Opening ");
    sprint(self, 2, gs);
    sprint(self, 2, "...\n");
   }
   else {
    ptime = ftos(3);
    sprint(self, 2, gs);
    sprint(self, 2, " primed, ");
    sprint(self, 2, ptime);
    sprint(self, 2, " seconds...\n");
   }
  }
  else {
   sprint(self, 2, "No ");
   sprint(self, 2, gs);
   sprint(self, 2, "s left.\n");
   return;
  }
 }
 self.tfstate = self.tfstate | 1;
 tGrenade = spawn();
 tGrenade.owner = self;
 tGrenade.weapon = gtype;
 tGrenade.classname = "primer";
 tGrenade.impulse = self.impulse;
 tGrenade.nextthink = time + 0.8;
 if (gtype == 10) 
  tGrenade.heat = time + 0.5 + 0.5;
 else 
  tGrenade.heat = time + 3 + 0.8;
 tGrenade.think = TeamFortress_GrenadePrimed;
};

void () TeamFortress_GrenadePrimed =
{
 local entity user;
 local entity oldself;

 user = self.owner;
 if (!(user.tfstate & 1024) && !user.deadflag) {
  self.nextthink = time + 0.1;
  if (!self.think) 
   dremove(self);
  if (time > self.heat) 
   TeamFortress_ExplodePerson();
  return;
 }
 if (!(user.tfstate & 1)) 
  dprint("GrenadePrimed logic error\n");
 user.tfstate = user.tfstate - (user.tfstate & 1);
 user.tfstate = user.tfstate - (user.tfstate & 1024);
 sound(user, 1, "weapons/grenade.wav", 1, 1);
// sound(user, 1, "weapons/ax1.wav", 1, 1);
 KickPlayer(-1, user);
 newmis = spawn();
 newmis.owner = user;
 newmis.movetype = 10;
 newmis.solid = 2;
 newmis.classname = "grenade";
 makevectors(user.v_angle);
 if (user.deadflag) 
  newmis.velocity = '0 0 200';
 else {
  if (user.v_angle_x) 
   newmis.velocity = v_forward * 600 + v_up * 200 + crandom() * v_right * 10 + crandom() * v_up * 10;
  else {
   newmis.velocity = aim(user, 10000);
   newmis.velocity = newmis.velocity * 600;
   newmis.velocity_z = 200;
  }
 }
 newmis.angles = vectoangles(newmis.velocity);
 newmis.think = SUB_Null;
 newmis.nextthink = self.heat;
 if (self.weapon == 1) {
  newmis.touch = NormalGrenadeTouch;
  newmis.think = NormalGrenadeExplode;
  newmis.skin = 0;
  newmis.avelocity = '300 300 300';
  if (birthday == 1 && random() < 0.6) 
   setmodel(newmis, "progs/grenade3.mdl");
  else 
   setmodel(newmis, "progs/hgren2.mdl");
 }
 else {
  if (self.weapon == 2) {
   newmis.touch = ConcussionGrenadeTouch;
   newmis.think = ConcussionGrenadeExplode;
   newmis.skin = 1;
   newmis.avelocity = '300 300 300';
   if (birthday == 1 && random() < 0.6) 
    setmodel(newmis, "progs/grenade3.mdl");
   else 
    setmodel(newmis, "progs/hgren2.mdl");
  }
  else {
   if (self.weapon == 3) {
    newmis.touch = NailGrenadeTouch;
    newmis.think = NailGrenadeExplode;
    newmis.skin = 1;
    newmis.avelocity = '0 300 0';
    if (birthday == 1 && random() < 0.6) 
     setmodel(newmis, "progs/grenade3.mdl");
    else 
     setmodel(newmis, "progs/biggren.mdl");
   }
   else {
    if (self.weapon == 4) {
     newmis.touch = MirvGrenadeTouch;
     newmis.think = MirvGrenadeExplode;
     newmis.skin = 0;
     newmis.avelocity = '0 300 0';
     if (birthday == 1 && random() < 0.6) 
      setmodel(newmis, "progs/grenade3.mdl");
     else 
      setmodel(newmis, "progs/biggren.mdl");
    }
    else {
     if (self.weapon == 5) {
      newmis.touch = NapalmGrenadeTouch;
      newmis.think = NapalmGrenadeExplode;
      newmis.skin = 2;
      newmis.avelocity = '0 300 0';
      if (birthday == 1 && random() < 0.6) 
       setmodel(newmis, "progs/grenade3.mdl");
      else 
       setmodel(newmis, "progs/biggren.mdl");
     }
     else {
      if (self.weapon == 6) {
       newmis.touch = FlareGrenadeTouch;
       newmis.weapon = self.team_no;
       newmis.think = FlareGrenadeExplode;
       newmis.skin = 1;
       newmis.avelocity = '300 300 300';
       if (birthday == 1 && random() < 0.6) 
        setmodel(newmis, "progs/grenade3.mdl");
       else 
        newmis.mdl = "flare";
       setmodel(newmis, "progs/flare.mdl");
      }
      else {
       if (self.weapon == 7) {
        newmis.touch = GasGrenadeTouch;
        newmis.think = GasGrenadeExplode;
        newmis.skin = 3;
        newmis.avelocity = '300 300 300';
        if (birthday == 1 && random() < 0.6) 
         setmodel(newmis, "progs/grenade3.mdl");
        else 
         setmodel(newmis, "progs/grenade2.mdl");
       }
       else {
        if (self.weapon == 8) {
         newmis.touch = EMPGrenadeTouch;
         newmis.think = EMPGrenadeExplode;
         newmis.skin = 4;
         newmis.avelocity = '300 300 300';
         if (birthday == 1 && random() < 0.6) 
          setmodel(newmis, "progs/grenade3.mdl");
         else 
          setmodel(newmis, "progs/grenade2.mdl");
        }
        else {
         if (self.weapon == 10) {
          newmis.touch = CanisterTouch;
          newmis.think = ScatterCaltrops;
          newmis.skin = 0;
          newmis.avelocity = '0 0 0';
         }
         else {
          if (self.weapon == 9) {
           newmis.touch = FlashGrenadeTouch;
           newmis.think = FlashGrenadeExplode;
           newmis.skin = 2;
           newmis.avelocity = '300 300 300';
           if (birthday == 1 && random() < 0.6) 
            setmodel(newmis, "progs/grenade3.mdl");
           else {
            setmodel(newmis, "progs/hgren2.mdl");
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
 setsize(newmis, '0 0 0', '0 0 0');
 setorigin(newmis, user.origin);
 oldself = self;
 self = self.owner;
 self = oldself;
 dremove(self);
};

void () TeamFortress_ThrowGrenade =
{
 if (!(self.tfstate & 1)) 
  return;
 self.tfstate = self.tfstate | 1024;
};

float (float pc) IsLegalClass =
{
 local float bit;

 if (spy_off == 1 && pc == 8) 
  return 0;
 if (pc == 1) 
  bit = 1;
 else {
  if (pc == 2) 
   bit = 2;
  else {
   if (pc == 3) 
    bit = 4;
   else {
    if (pc == 4) 
     bit = 8;
    else {
     if (pc == 5) 
      bit = 16;
     else {
      if (pc == 6) 
       bit = 32;
      else {
       if (pc == 7) 
        bit = 64;
       else {
        if (pc == 8) 
         bit = 256;
        else {
         if (pc == 9) 
          bit = 512;
         else {
          if (pc == 10) 
           bit = 128;
         }
        }
       }
      }
     }
    }
   }
  }
 }
 if ((illegalclasses & bit) || (TeamFortress_TeamGetIllegalClasses(self.team_no) & bit)) 
  return 0;
 return 1;
};

void (entity p) TeamFortress_SetSpeed =
{
 local string sp;
 local float tf;
 local entity te;

 stuffcmd(p, "cl_movespeedkey 1\n");
 if (p.tfstate & 65536) {
  if (0 == 1) {
   stuffcmd(p, "m_forward 0\n");
   stuffcmd(p, "m_side 0\n");
  }
  p.velocity = '0 0 0';
  stuffcmd(p, "cl_backspeed 0\n");
  stuffcmd(p, "cl_forwardspeed 0\n");
  stuffcmd(p, "cl_sidespeed 0\n");
  p.maxspeed = 0;
  return;
 }
 else {
  if (0 == 1) {
   stuffcmd(p, "m_forward 1\n");
   stuffcmd(p, "m_side 0.8\n");
  }
 }
 if (p.playerclass == 1) {
  p.maxfbspeed = #PC_SCOUT_MAXSPEED;
  p.maxstrafespeed = #PC_SCOUT_MAXSTRAFESPEED;
 }
 else {
  if (p.playerclass == 2) {
   p.maxfbspeed = #PC_SNIPER_MAXSPEED;
   p.maxstrafespeed = #PC_SNIPER_MAXSTRAFESPEED;
  }
  else {
   if (p.playerclass == 3) {
    p.maxfbspeed = #PC_SOLDIER_MAXSPEED;
    p.maxstrafespeed = #PC_SOLDIER_MAXSTRAFESPEED;
   }
   else {
    if (p.playerclass == 4) {
     p.maxfbspeed = #PC_DEMOMAN_MAXSPEED;
     p.maxstrafespeed = #PC_DEMOMAN_MAXSTRAFESPEED;
    }
    else {
     if (p.playerclass == 5) {
      p.maxfbspeed = #PC_MEDIC_MAXSPEED;
      p.maxstrafespeed = #PC_MEDIC_MAXSTRAFESPEED;
     }
     else {
      if (p.playerclass == 6) {
       p.maxfbspeed = #PC_HVYWEAP_MAXSPEED;
       p.maxstrafespeed = #PC_HVYWEAP_MAXSTRAFESPEED;
      }
      else {
       if (p.playerclass == 7) {
        p.maxfbspeed = #PC_PYRO_MAXSPEED;
        p.maxstrafespeed = #PC_PYRO_MAXSTRAFESPEED;
       }
       else {
        if (p.playerclass == #PC_CIVILIAN) {
         p.maxfbspeed = #PC_CIVILIAN_MAXSPEED;
         p.maxstrafespeed = #PC_CIVILIAN_MAXSTRAFESPEED;
        }
        else {
         if (p.playerclass == 8) {
          p.maxfbspeed = #PC_SPY_MAXSPEED;
          p.maxstrafespeed = #PC_SPY_MAXSTRAFESPEED;
         }
         else {
          if (p.playerclass == 9) {
           p.maxfbspeed = #PC_ENGINEER_MAXSPEED;
           p.maxstrafespeed = #PC_ENGINEER_MAXSTRAFESPEED;
          }
          else {
           if (!p.playerclass) {
            p.maxfbspeed = 320;
            p.maxstrafespeed = 320;
            p.maxfbspeed = 0;
            p.maxstrafespeed = 0;
            p.maxspeed = 0;
            return;
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
 tf = 0;
 te = find(world, classname, "item_tfgoal");
 while (te != world && !tf) {
  if (te.owner == p) {
   if (te.goal_activation & 2) {
    tf = 1;
    p.maxfbspeed = p.maxfbspeed / 2;
    p.maxstrafespeed = p.maxstrafespeed / 2;
   }
  }
  te = find(te, classname, "item_tfgoal");
 }
 if (p.tfstate & 32768) {
  p.maxfbspeed = p.maxfbspeed / 2;
  p.maxstrafespeed = p.maxstrafespeed / 2;
 }
 if (p.leg_damage) {
  if (p.leg_damage > 6) 
   p.leg_damage = 6;
  p.maxfbspeed = p.maxfbspeed * (10 - p.leg_damage) / 10;
  p.maxstrafespeed = p.maxstrafespeed * (10 - p.leg_damage) / 10;
 }
 if (p.tfstate & 2048) {
  if (p.maxfbspeed > 80) 
   p.maxfbspeed = 80;
  if (p.maxstrafespeed > 80) 
   p.maxstrafespeed = 80;
 }

 sp = ftos(p.maxfbspeed);
 stuffcmd(p, "cl_backspeed ");
 stuffcmd(p, sp);
 stuffcmd(p, "\n");
 stuffcmd(p, "cl_forwardspeed ");
 stuffcmd(p, sp);
 stuffcmd(p, "\n");
 sp = ftos(p.maxstrafespeed);
 stuffcmd(p, "cl_sidespeed ");
 stuffcmd(p, sp);
 stuffcmd(p, "\n");
 p.maxspeed = p.maxfbspeed;
};

void () TeamFortress_SetHealth =
{
 if (self.playerclass == 1) 
  self.max_health = #PC_SCOUT_MAXHEALTH;
 else {
  if (self.playerclass == 2) 
   self.max_health = #PC_SNIPER_MAXHEALTH;
  else {
   if (self.playerclass == 3) 
    self.max_health = #PC_SOLDIER_MAXHEALTH;
   else {
    if (self.playerclass == 4) 
     self.max_health = #PC_DEMOMAN_MAXHEALTH;
    else {
     if (self.playerclass == 5) 
      self.max_health = #PC_MEDIC_MAXHEALTH;
     else {
      if (self.playerclass == 6) 
       self.max_health = #PC_HVYWEAP_MAXHEALTH;
      else {
       if (self.playerclass == 7) 
        self.max_health = #PC_PYRO_MAXHEALTH;
       else {
        if (self.playerclass == 11) 
         self.max_health = #PC_CIVILIAN_MAXHEALTH;
        else {
         if (self.playerclass == 8) 
          self.max_health = #PC_SPY_MAXHEALTH;
         else {
          if (self.playerclass == 9) 
           self.max_health = #PC_ENGINEER_MAXHEALTH;
          else {
           if (!self.playerclass) {
            self.max_health = 1;
            self.takedamage = 0;
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
 self.health = self.max_health;
};

string (entity p) TeamFortress_GetSkin =
{
 local float tn;
 local float pc;
 local string st;

 if (p.playerclass == 11 || !p.team_no) 
  return "base";
 tn = p.team_no;
 pc = p.playerclass;
 if (p.playerclass == 8) {
  if (p.undercover_team) 
   tn = p.undercover_team;
  if (p.undercover_skin) 
   pc = p.undercover_skin;
 }
 if (tn == 4) {
  if (pc == 1) {
   st = infokey(world, "sk_t4_scout");
   if (st != string_null) 
    return st;
   return "tf_scout";
  }
  else {
   if (pc == 2) {
    st = infokey(world, "sk_t4_sniper");
    if (st != string_null) 
     return st;
    return "tf_snipe";
   }
   else {
    if (pc == 3) {
     st = infokey(world, "sk_t4_soldier");
     if (st != string_null) 
      return st;
     return "tf_sold";
    }
    else {
     if (pc == 4) {
      st = infokey(world, "sk_t4_demoman");
      if (st != string_null) 
       return st;
      return "tf_demo";
     }
     else {
      if (pc == 5) {
       st = infokey(world, "sk_t4_medic");
       if (st != string_null) 
        return st;
       return "tf_medic";
      }
      else {
       if (pc == 6) {
        st = infokey(world, "sk_t4_hwguy");
        if (st != string_null) 
         return st;
        return "tf_hwguy";
       }
       else {
        if (pc == 7) {
         st = infokey(world, "sk_t4_pyro");
         if (st != string_null) 
          return st;
         return "tf_pyro";
        }
        else {
         if (pc == 8) {
          st = infokey(world, "sk_t4_spy");
          if (st != string_null) 
           return st;
          return "tf_spy";
         }
         else {
          if (pc == 9) {
           st = infokey(world, "sk_t4_engineer");
           if (st != string_null) 
            return st;
           return "tf_eng";
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
 else {
  if (tn == 3) {
   if (pc == 1) {
    st = infokey(world, "sk_t3_scout");
    if (st != string_null) 
     return st;
    return "tf_scout";
   }
   else {
    if (pc == 2) {
     st = infokey(world, "sk_t3_sniper");
     if (st != string_null) 
      return st;
     return "tf_snipe";
    }
    else {
     if (pc == 3) {
      st = infokey(world, "sk_t3_soldier");
      if (st != string_null) 
       return st;
      return "tf_sold";
     }
     else {
      if (pc == 4) {
       st = infokey(world, "sk_t3_demoman");
       if (st != string_null) 
        return st;
       return "tf_demo";
      }
      else {
       if (pc == 5) {
        st = infokey(world, "sk_t3_medic");
        if (st != string_null) 
         return st;
        return "tf_medic";
       }
       else {
        if (pc == 6) {
         st = infokey(world, "sk_t3_hwguy");
         if (st != string_null) 
          return st;
         return "tf_hwguy";
        }
        else {
         if (pc == 7) {
          st = infokey(world, "sk_t3_pyro");
          if (st != string_null) 
           return st;
          return "tf_pyro";
         }
         else {
          if (pc == 8) {
           st = infokey(world, "sk_t3_spy");
           if (st != string_null) 
            return st;
           return "tf_spy";
          }
          else {
           if (pc == 9) {
            st = infokey(world, "sk_t3_engineer");
            if (st != string_null) 
             return st;
            return "tf_eng";
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
  else {
   if (tn == 2) {
    if (pc == 1) {
     st = infokey(world, "sk_t2_scout");
     if (st != string_null) 
      return st;
     return "tf_scout";
    }
    else {
     if (pc == 2) {
      st = infokey(world, "sk_t2_sniper");
      if (st != string_null) 
       return st;
      return "tf_snipe";
     }
     else {
      if (pc == 3) {
       st = infokey(world, "sk_t2_soldier");
       if (st != string_null) 
        return st;
       return "tf_sold";
      }
      else {
       if (pc == 4) {
        st = infokey(world, "sk_t2_demoman");
        if (st != string_null) 
         return st;
        return "tf_demo";
       }
       else {
        if (pc == 5) {
         st = infokey(world, "sk_t2_medic");
         if (st != string_null) 
          return st;
         return "tf_medic";
        }
        else {
         if (pc == 6) {
          st = infokey(world, "sk_t2_hwguy");
          if (st != string_null) 
           return st;
          return "tf_hwguy";
         }
         else {
          if (pc == 7) {
           st = infokey(world, "sk_t2_pyro");
           if (st != string_null) 
            return st;
           return "tf_pyro";
          }
          else {
           if (pc == 8) {
            st = infokey(world, "sk_t2_spy");
            if (st != string_null) 
             return st;
            return "tf_spy";
           }
           else {
            if (pc == 9) {
             st = infokey(world, "sk_t2_engineer");
             if (st != string_null) 
              return st;
             return "tf_eng";
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
   else {
    if (pc == 1) {
     st = infokey(world, "sk_t1_scout");
     if (st != string_null) 
      return st;
     return "tf_scout";
    }
    else {
     if (pc == 2) {
      st = infokey(world, "sk_t1_sniper");
      if (st != string_null) 
       return st;
      return "tf_snipe";
     }
     else {
      if (pc == 3) {
       st = infokey(world, "sk_t1_soldier");
       if (st != string_null) 
        return st;
       return "tf_sold";
      }
      else {
       if (pc == 4) {
        st = infokey(world, "sk_t1_demoman");
        if (st != string_null) 
         return st;
        return "tf_demo";
       }
       else {
        if (pc == 5) {
         st = infokey(world, "sk_t1_medic");
         if (st != string_null) 
          return st;
         return "tf_medic";
        }
        else {
         if (pc == 6) {
          st = infokey(world, "sk_t1_hwguy");
          if (st != string_null) 
           return st;
          return "tf_hwguy";
         }
         else {
          if (pc == 7) {
           st = infokey(world, "sk_t1_pyro");
           if (st != string_null) 
            return st;
           return "tf_pyro";
          }
          else {
           if (pc == 8) {
            st = infokey(world, "sk_t1_spy");
            if (st != string_null) 
             return st;
            return "tf_spy";
           }
           else {
            if (pc == 9) {
             st = infokey(world, "sk_t1_engineer");
             if (st != string_null) 
              return st;
             return "tf_eng";
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
};

void (entity p) TeamFortress_SetSkin =
{
 local string st;
 local float tn;

 p.immune_to_check = time + cheat_pause;//10;
 if (p.playerclass == 8 && p.undercover_skin) 
  p.skin = p.undercover_skin;
 else 
  p.skin = p.playerclass;
 if (p.skin) {
  stuffcmd(p, "skin ");
  st = TeamFortress_GetSkin(p);
  stuffcmd(p, st);
  stuffcmd(p, "\n");
 }
 else 
  stuffcmd(p, "skin base\n");
};

void () TeamFortress_SetEquipment =
{
 local entity te;
 local string st;
 local float kept_items;
 local float tc;

 if (self.classname != "player") 
  return;
 kept_items = self.tf_items & (#IT_KEY1 | #IT_KEY2);
 self.items = 0;
 self.last_weaponmode = 0;
 self.last_weapon = 0;
 self.current_weapon = 0;
 self.weapons_carried = 0;
 self.tf_items = 0;
 if(self.playerclass != 1)
  self.tf_items_flags = 0;
 self.armorclass = 0;
 self.impulse = 0;
 self.undercover_skin = 0;
 if (self.undercover_team) {
  self.immune_to_check = time + cheat_pause;//10;
  self.undercover_team = 0;
  stuffcmd(self, "color ");

        tc = TeamFortress_TeamGetTopColor(self.team_no);
        st = ftos(tc);
        stuffcmd(self, st);
        stuffcmd(self, " ");

  tc=TeamFortress_TeamGetColor(self.team_no) - 1;
  st = ftos(tc);
  stuffcmd(self, st);

  stuffcmd(self, "\n");
 }
 self.is_building = 0;
 self.is_detpacking = 0;
 self.is_undercover = 0;
 self.is_feigning = 0;
 self.is_unabletospy = 0;
 self.ammo_medikit = 0;
 self.maxammo_medikit = 0;
 self.ammo_detpack = 0;
 self.maxammo_detpack = 0;
 self.items_allowed = 0;
 self.armor_allowed = 0;
 self.maxarmor = 0;
 self.weaponmode = 0;
 self.respawn_time = 0;
 self.heat = 0;
 self.tfstate = self.tfstate - (self.tfstate & #TFSTATE_RELOADING);
 if (!self.team_no) 
  self.lives = -1;
 self.items = self.items | kept_items;
//angel fix
        st = infokey(self, "autoid");
        if(st == string_null)
         {
           st = infokey(self, "s");
           if (stof(st)& #TF_AUTOID_MASK) 
           {
             st="on";
           }
         }
        if (st == "on")
        {
         te = spawn();
         te.nextthink = time + #TF_AUTOIDTIME;
         te.think = TeamFortress_AutoID;
         te.owner = self;
         te.classname = "timer";
         }
         self.ScannerOn = 0;
////////
 if (self.playerclass == 1) {
  self.weapons_carried = self.weapons_carried | #PC_SCOUT_WEAPONS;
  self.ammo_rockets = #PC_SCOUT_INITAMMO_ROCKET;
  self.ammo_nails = #PC_SCOUT_INITAMMO_NAIL;
  self.ammo_shells = #PC_SCOUT_INITAMMO_SHOT;
  self.ammo_cells = #PC_SCOUT_INITAMMO_CELL;
  self.maxammo_rockets = #PC_SCOUT_MAXAMMO_ROCKET;
  self.maxammo_nails = #PC_SCOUT_MAXAMMO_NAIL;
  self.maxammo_shells = #PC_SCOUT_MAXAMMO_SHOT;
  self.maxammo_cells = #PC_SCOUT_MAXAMMO_CELL;
  self.no_grenades_1 = #PC_SCOUT_GRENADE_INIT_1;
  self.no_grenades_2 = #PC_SCOUT_GRENADE_INIT_2;
  if (old_grens == 1) 
   self.tp_grenades_1 = #PC_SCOUT_GRENADE_TYPE_1;
  else 
   self.tp_grenades_1 = 10;
  self.tp_grenades_2 = #PC_SCOUT_GRENADE_TYPE_2;
  self.tf_items = #PC_SCOUT_TF_ITEMS;
                self.ScannerOn = 0;
                self.ScanRange = #DEFAULT_AUTOSCAN_RANGE;
                if(self.tf_items_flags <= 0)
   self.tf_items_flags = self.tf_items_flags | #NIT_SCANNER_ENEMY;
  self.armorclass = self.armorclass | #PC_SCOUT_INITARMORCLASS;
  self.armortype = #PC_SCOUT_INITARMORTYPE;
  self.armorvalue = #PC_SCOUT_INITARMOR;
  self.armor_allowed = #PC_SCOUT_MAXARMORTYPE;
  self.maxarmor = #PC_SCOUT_MAXARMOR;
  self.current_weapon = #WEAP_NAILGUN;
  self.items_allowed = #PC_SCOUT_WEAPONS;
  self.items = self.items | 1 | 4;
 }
 else {
  if (self.playerclass == 2) {
   self.weapons_carried = self.weapons_carried | #PC_SNIPER_WEAPONS; //32 | 64 | 16 | 512;
   self.ammo_rockets = #PC_SNIPER_INITAMMO_ROCKET;
   self.ammo_nails = #PC_SNIPER_INITAMMO_NAIL;
   self.ammo_shells = #PC_SNIPER_INITAMMO_SHOT;
   self.ammo_cells = #PC_SNIPER_INITAMMO_CELL;
   self.maxammo_rockets = #PC_SNIPER_MAXAMMO_ROCKET;
   self.maxammo_nails = #PC_SNIPER_MAXAMMO_NAIL;
   self.maxammo_shells = #PC_SNIPER_MAXAMMO_SHOT;
   self.maxammo_cells = #PC_SNIPER_MAXAMMO_CELL;
   self.no_grenades_1 = #PC_SNIPER_GRENADE_INIT_1;
   self.no_grenades_2 = #PC_SNIPER_GRENADE_INIT_2;
   self.tp_grenades_1 = #PC_SNIPER_GRENADE_TYPE_1;
   self.tp_grenades_2 = #PC_SNIPER_GRENADE_TYPE_2;
   self.tf_items = #PC_SNIPER_TF_ITEMS;
   self.armorclass = self.armorclass | #PC_SNIPER_INITARMORCLASS;
   self.armortype = #PC_SNIPER_INITARMORTYPE;
   self.armorvalue = #PC_SNIPER_INITARMOR;
   self.armor_allowed = #PC_SNIPER_MAXARMORTYPE;
   self.maxarmor = #PC_SNIPER_MAXARMOR;
   self.current_weapon = 32;
   self.items_allowed = 32 | 64 | 16 | 512;
   self.items = self.items | 1 | 2 | 4;
  }
  else {
   if (self.playerclass == 3) {
    self.weapons_carried = self.weapons_carried | #PC_SOLDIER_WEAPONS;//16 | 128 | 256 | 8192;
    self.ammo_rockets = #PC_SOLDIER_INITAMMO_ROCKET;
    self.ammo_nails = #PC_SOLDIER_INITAMMO_NAIL;
    self.ammo_shells = #PC_SOLDIER_INITAMMO_SHOT;
    self.ammo_cells = #PC_SOLDIER_INITAMMO_CELL;
    self.maxammo_rockets = #PC_SOLDIER_MAXAMMO_ROCKET;
    self.maxammo_nails = #PC_SOLDIER_MAXAMMO_NAIL;
    self.maxammo_shells = #PC_SOLDIER_MAXAMMO_SHOT;
    self.maxammo_cells = #PC_SOLDIER_MAXAMMO_CELL;
    self.no_grenades_1 = #PC_SOLDIER_GRENADE_INIT_1;
    self.no_grenades_2 = #PC_SOLDIER_GRENADE_INIT_2;
    self.tp_grenades_1 = #PC_SOLDIER_GRENADE_TYPE_1;
    self.tp_grenades_2 = #PC_SOLDIER_GRENADE_TYPE_2;
    self.tf_items = #PC_SOLDIER_TF_ITEMS;
    self.armorclass = self.armorclass | #PC_SOLDIER_INITARMORCLASS;
    self.armortype = #PC_SOLDIER_INITARMORTYPE;
    self.armorvalue = #PC_SOLDIER_INITARMOR;
    self.armor_allowed = #PC_SOLDIER_MAXARMORTYPE;
    self.maxarmor = #PC_SOLDIER_MAXARMOR;
    self.current_weapon = 8192;
    self.items_allowed = 16 | 128 | 256 | 8192;
    self.items = self.items | 1 | 2 | 32;
   }
   else {
    if (self.playerclass == 4) {
     self.weapons_carried = self.weapons_carried | #PC_DEMOMAN_WEAPONS;//16 | 128 | 2048 | 131072;
     self.ammo_rockets = #PC_DEMOMAN_INITAMMO_ROCKET;
     self.ammo_nails = #PC_DEMOMAN_INITAMMO_NAIL;
     self.ammo_shells = #PC_DEMOMAN_INITAMMO_SHOT;
     self.ammo_cells = #PC_DEMOMAN_INITAMMO_CELL;
     self.maxammo_rockets = #PC_DEMOMAN_MAXAMMO_ROCKET;
     self.maxammo_nails = #PC_DEMOMAN_MAXAMMO_NAIL;
     self.maxammo_shells = #PC_DEMOMAN_MAXAMMO_SHOT;
     self.maxammo_cells = #PC_DEMOMAN_MAXAMMO_CELL;
     self.no_grenades_1 = #PC_DEMOMAN_GRENADE_INIT_1;
     self.no_grenades_2 = #PC_DEMOMAN_GRENADE_INIT_2;
     self.tp_grenades_1 = #PC_DEMOMAN_GRENADE_TYPE_1;
     self.tp_grenades_2 = #PC_DEMOMAN_GRENADE_TYPE_2;
     self.tf_items = #PC_DEMOMAN_TF_ITEMS;
     self.ammo_detpack = 1;
     self.maxammo_detpack = 1;
     self.armorclass = self.armorclass | #PC_DEMOMAN_INITARMORCLASS;
     self.armortype = #PC_DEMOMAN_INITARMORTYPE;
     self.armorvalue = #PC_DEMOMAN_INITARMOR;
     self.armor_allowed = #PC_DEMOMAN_MAXARMORTYPE;
     self.maxarmor = #PC_DEMOMAN_MAXARMOR;
     self.current_weapon = 2048;
     self.items_allowed = 16 | 128 | 2048 | 131072;
     self.items = self.items | 1 | 16;
    }
    else {
     if (self.playerclass == 5) {
      self.weapons_carried = self.weapons_carried | #PC_MEDIC_WEAPONS;//2 | 4 | 128 | 256 | 1024;
      self.ammo_rockets = #PC_MEDIC_INITAMMO_ROCKET;
      self.ammo_nails = #PC_MEDIC_INITAMMO_NAIL;
      self.ammo_shells = #PC_MEDIC_INITAMMO_SHOT;
      self.ammo_cells = #PC_MEDIC_INITAMMO_CELL;
      self.maxammo_rockets = #PC_MEDIC_MAXAMMO_ROCKET;
      self.maxammo_nails = #PC_MEDIC_MAXAMMO_NAIL;
      self.maxammo_shells = #PC_MEDIC_MAXAMMO_SHOT;
      self.maxammo_cells = #PC_MEDIC_MAXAMMO_CELL;
      self.no_grenades_1 = #PC_MEDIC_GRENADE_INIT_1;
      self.no_grenades_2 = #PC_MEDIC_GRENADE_INIT_2;
      self.tp_grenades_1 = #PC_MEDIC_GRENADE_TYPE_1;
      self.tp_grenades_2 = #PC_MEDIC_GRENADE_TYPE_2;
      self.tf_items = #PC_MEDIC_TF_ITEMS;
      self.armorclass = self.armorclass | #PC_MEDIC_INITARMORCLASS;
                                                self.armortype = #PC_MEDIC_INITARMORTYPE;
      self.armorvalue = #PC_MEDIC_INITARMOR;
      self.armor_allowed = #PC_MEDIC_MAXARMORTYPE;
      self.maxarmor = #PC_MEDIC_MAXARMOR;
      self.current_weapon = 1024;
      self.ammo_medikit = #PC_MEDIC_INITAMMO_MEDIKIT;
      self.maxammo_medikit = #PC_MEDIC_MAXAMMO_MEDIKIT;
      te = spawn();
      te.nextthink = time + #PC_MEDIC_REGEN_TIME;
      te.think = TeamFortress_Regenerate;
      te.owner = self;
      te.classname = "timer";
      self.items_allowed = 2 | 4 | 128 | 256 | 1024;
      self.items = self.items | 1 | 2 | 8;
     }
     else {
      if (self.playerclass == 6) {
       self.weapons_carried = self.weapons_carried | #PC_HVYWEAP_WEAPONS;//32768 | 16 | 128 | 256;
       self.ammo_rockets = #PC_HVYWEAP_INITAMMO_ROCKET;
       self.ammo_nails = #PC_HVYWEAP_INITAMMO_NAIL;
       self.ammo_shells = #PC_HVYWEAP_INITAMMO_SHOT;
       self.ammo_cells = #PC_HVYWEAP_INITAMMO_CELL;
       self.maxammo_rockets = #PC_HVYWEAP_MAXAMMO_ROCKET;
       self.maxammo_nails = #PC_HVYWEAP_MAXAMMO_NAIL;
       self.maxammo_shells = #PC_HVYWEAP_MAXAMMO_SHOT;
       self.maxammo_cells = #PC_HVYWEAP_MAXAMMO_CELL;
       self.no_grenades_1 = #PC_HVYWEAP_GRENADE_INIT_1;
       self.no_grenades_2 = #PC_HVYWEAP_GRENADE_INIT_2;
       self.tp_grenades_1 = #PC_HVYWEAP_GRENADE_TYPE_1;
       self.tp_grenades_2 = #PC_HVYWEAP_GRENADE_TYPE_2;
       self.tf_items = #PC_HVYWEAP_TF_ITEMS;
       self.armorclass = self.armorclass | #PC_HVYWEAP_INITARMORCLASS;
       self.armortype = #PC_HVYWEAP_INITARMORTYPE;
       self.armorvalue = #PC_HVYWEAP_INITARMOR;
       self.armor_allowed = #PC_HVYWEAP_MAXARMORTYPE;
       self.maxarmor = #PC_HVYWEAP_MAXARMOR;
       self.current_weapon = 32768;
       self.items_allowed = 32768 | 16 | 128 | 256;
       self.items = self.items | 1 | 2 | 32;
      }
      else {
       if (self.playerclass == 7) {
        self.weapons_carried = self.weapons_carried | #PC_PYRO_WEAPONS;//16384 | 4096 | 16 | 128;
        self.ammo_rockets = #PC_PYRO_INITAMMO_ROCKET;
        self.ammo_nails = #PC_PYRO_INITAMMO_NAIL;
        self.ammo_shells = #PC_PYRO_INITAMMO_SHOT;
        self.ammo_cells = #PC_PYRO_INITAMMO_CELL;
        self.maxammo_rockets = #PC_PYRO_MAXAMMO_ROCKET;
        self.maxammo_nails = #PC_PYRO_MAXAMMO_NAIL;
        self.maxammo_shells = #PC_PYRO_MAXAMMO_SHOT;
        self.maxammo_cells = #PC_PYRO_MAXAMMO_CELL;
        self.no_grenades_1 = #PC_PYRO_GRENADE_INIT_1;
        self.no_grenades_2 = #PC_PYRO_GRENADE_INIT_2;
        self.tp_grenades_1 = #PC_PYRO_GRENADE_TYPE_1;
        self.tp_grenades_2 = #PC_PYRO_GRENADE_TYPE_2;
        self.tf_items = #PC_PYRO_TF_ITEMS;
        self.armorclass = self.armorclass | #PC_PYRO_INITARMORCLASS;
        self.armortype = #PC_PYRO_INITARMORTYPE;
        self.armorvalue = #PC_PYRO_INITARMOR;
        self.armor_allowed = #PC_PYRO_MAXARMORTYPE;
        self.maxarmor = #PC_PYRO_MAXARMOR;
        self.current_weapon = 4096;
        self.items_allowed = 16384 | 4096 | 16 | 128;
        self.items = self.items | 1 | 16 | 32;
       }
       else {
        if (self.playerclass == 11) {
         self.weapons_carried = self.weapons_carried | #PC_CIVILIAN_WEAPONS;//16;
         self.ammo_rockets = #PC_CIVILIAN_INITAMMO_ROCKET;
         self.ammo_nails = #PC_CIVILIAN_INITAMMO_NAIL;
         self.ammo_shells = #PC_CIVILIAN_INITAMMO_SHOT;
         self.ammo_cells = #PC_CIVILIAN_INITAMMO_CELL;
         self.maxammo_rockets = #PC_CIVILIAN_MAXAMMO_ROCKET;
         self.maxammo_nails = #PC_CIVILIAN_MAXAMMO_NAIL;
         self.maxammo_shells = #PC_CIVILIAN_MAXAMMO_SHOT;
         self.maxammo_cells = #PC_CIVILIAN_INITAMMO_CELL;
         self.no_grenades_1 = #PC_CIVILIAN_GRENADE_INIT_1;
         self.no_grenades_2 = #PC_CIVILIAN_GRENADE_INIT_2;
         self.tp_grenades_1 = #PC_CIVILIAN_GRENADE_TYPE_1;
         self.tp_grenades_2 = #PC_CIVILIAN_GRENADE_TYPE_2;
         self.tf_items = #PC_CIVILIAN_TF_ITEMS;
         self.armorclass = self.armorclass | #PC_CIVILIAN_INITARMORCLASS;
         self.armortype = #PC_CIVILIAN_INITARMORTYPE;
         self.armorvalue = #PC_CIVILIAN_INITARMOR;
         self.armor_allowed = #PC_CIVILIAN_MAXARMORTYPE;
         self.maxarmor = #PC_CIVILIAN_MAXARMOR;
         self.current_weapon = 16;
         self.items_allowed = 16;
         self.items = 0;
        }
        else {
         if (self.playerclass == 8) {
          self.weapons_carried = self.weapons_carried | #PC_SPY_WEAPONS;//16 | 262144 | 256 | 512;
          self.ammo_rockets = #PC_SPY_INITAMMO_ROCKET;
          self.ammo_nails = #PC_SPY_INITAMMO_NAIL;
          self.ammo_shells = #PC_SPY_INITAMMO_SHOT;
          self.ammo_cells = #PC_SPY_INITAMMO_CELL;
          self.maxammo_rockets = #PC_SPY_MAXAMMO_ROCKET;
          self.maxammo_nails = #PC_SPY_MAXAMMO_NAIL;
          self.maxammo_shells = #PC_SPY_MAXAMMO_SHOT;
          self.maxammo_cells = #PC_SPY_MAXAMMO_CELL;
          self.no_grenades_1 = #PC_SPY_GRENADE_INIT_1;
          self.no_grenades_2 = #PC_SPY_GRENADE_INIT_2;
          self.tp_grenades_1 = #PC_SPY_GRENADE_TYPE_1;
          self.tp_grenades_2 = #PC_SPY_GRENADE_TYPE_2;
          self.tf_items = #PC_SPY_TF_ITEMS;
          self.armorclass = self.armorclass | #PC_SPY_INITARMORCLASS;
          self.armortype = #PC_SPY_INITARMORTYPE;
          self.armorvalue = #PC_SPY_INITARMOR;
          self.armor_allowed = #PC_SPY_MAXARMORTYPE;
          self.maxarmor = #PC_SPY_MAXARMOR;
          self.current_weapon = 262144;
          self.items_allowed = 16 | 262144 | 256 | 512;
          self.items = self.items | 1 | 2 | 4;
          if (invis_only == 1) {
           te = spawn();
           te.nextthink = time + #PC_SPY_CELL_REGEN_TIME;
           te.think = TeamFortress_RegenerateCells;
           te.owner = self;
           te.classname = "timer";
          }
         }
         else {
          if (self.playerclass == 9) {
           self.weapons_carried = self.weapons_carried | #PC_ENGINEER_WEAPONS;//8 | 524288 | 256;
           
           self.ammo_rockets = #PC_ENGINEER_INITAMMO_ROCKET;
           self.ammo_nails = #PC_ENGINEER_INITAMMO_NAIL;
           self.ammo_shells = #PC_ENGINEER_INITAMMO_SHOT;
           self.ammo_cells = #PC_ENGINEER_INITAMMO_CELL;
           self.maxammo_rockets = #PC_ENGINEER_MAXAMMO_ROCKET;
           self.maxammo_nails = #PC_ENGINEER_MAXAMMO_NAIL;
           self.maxammo_shells = #PC_ENGINEER_MAXAMMO_SHOT;
           self.maxammo_cells = #PC_ENGINEER_MAXAMMO_CELL;
           self.no_grenades_1 = #PC_ENGINEER_GRENADE_INIT_1;
           self.no_grenades_2 = #PC_ENGINEER_GRENADE_INIT_2;
           self.tp_grenades_1 = #PC_ENGINEER_GRENADE_TYPE_1;
           self.tp_grenades_2 = #PC_ENGINEER_GRENADE_TYPE_2;
           self.tf_items = #PC_ENGINEER_TF_ITEMS;
           self.armorclass = self.armorclass | #PC_ENGINEER_INITARMORCLASS;
           self.armortype = #PC_ENGINEER_INITARMORTYPE;
           self.armorvalue = #PC_ENGINEER_INITARMOR;
           self.armor_allowed = #PC_ENGINEER_MAXARMORTYPE;
           self.maxarmor = #PC_ENGINEER_MAXARMOR;
           self.current_weapon = 524288;
           self.items_allowed = 8 | 524288 | 256;
           self.items = self.items | 1 | 2;
          }
          else {
           if (!self.playerclass) {
            self.items = 0;
            self.ammo_rockets = 0;
            self.ammo_nails = 0;
            self.ammo_shells = 0;
            self.ammo_cells = 0;
            self.no_grenades_1 = 0;
            self.no_grenades_2 = 0;
            self.tp_grenades_1 = 0;
            self.tp_grenades_2 = 0;
            self.armorclass = 0;
            self.armortype = 0;
            self.armorvalue = 0;
            self.weapon = 0;
            self.current_weapon = 0;
            self.weapons_carried = 0;
            self.flags = 8 | 128;
            self.waterlevel = 3;
            self.takedamage = 0;
            self.solid = 0;
            self.movetype = 8;
            self.model = string_null;
            self.mdl = string_null;
            self.modelindex = 0;
            self.weaponmodel = string_null;
            modelindex_player = 0;
            self.tfstate = self.tfstate | 2;
            setmodel(self, string_null);
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
 if (self.armortype >= 0.8) 
  self.items = self.items | 32768;
 else {
  if (self.armortype >= 0.6) 
   self.items = self.items | 16384;
  else {
   if (self.armortype >= 0.3) 
    self.items = self.items | 8192;
  }
 }
 if (allow_hook && self.playerclass) 
  self.weapons_carried = self.weapons_carried | 1;
 W_SetCurrentAmmo();
};

float (entity Retriever, float AmmoType) TeamFortress_GetMaxAmmo =
{
 if (AmmoType == 256) 
  return Retriever.maxammo_shells;
 else {
  if (AmmoType == 512) 
   return Retriever.maxammo_nails;
  else {
   if (AmmoType == 2048) 
    return Retriever.maxammo_cells;
   else {
    if (AmmoType == 1024) 
     return Retriever.maxammo_rockets;
    else {
     if (AmmoType == 4) 
      return Retriever.maxammo_medikit;
     else {
      if (AmmoType == 131072) 
       return Retriever.maxammo_detpack;
     }
    }
   }
  }
 }
 dprint("Error in TeamFortress_GetMaxAmmo()\n");
 dprint("Invalid ammo type passed.\n");
 return 0;
};

float (entity Retriever, float WeaponType) TeamFortress_CanGetWeapon =
{
 if (Retriever.items_allowed & WeaponType) 
  return 1;
 return 0;
};

void (entity Player, float Armorclass) TeamFortress_DescribeArmor =
{
 local string st;

 if (!Armorclass) 
  return;
 if (Armorclass & 16) 
  sprint(Player, 2, "Asbestos ");
 if (Armorclass & 2) 
  sprint(Player, 2, "Wooden ");
 if (Armorclass & 4) 
  sprint(Player, 2, "Blast ");
 if (Armorclass & 8) 
  sprint(Player, 2, "Shockproof ");
 if (Armorclass & 1) 
  sprint(Player, 2, "Kevlar ");
 sprint(Player, 2, "armor\n");
};

void (entity Retriever, entity Items) TeamFortress_AddBackpackItems =
{
 return;
};

string (float pc) TeamFortress_GetClassName =
{
 if (pc == 1) 
  return "Scout";
 else {
  if (pc == 2) 
   return "Sniper";
  else {
   if (pc == 3) 
    return "Soldier";
   else {
    if (pc == 4) 
     return "Demolitions Man";
    else {
     if (pc == 5) 
      return "Combat Medic";
     else {
      if (pc == 6) 
       return "Heavy Weapons Guy";
      else {
       if (pc == 7) 
        return "Pyro";
       else {
        if (pc == 8) 
         return "Spy";
        else {
         if (pc == 9) 
          return "Engineer";
         else {
          if (pc == 11) 
           return "Civilian";
          else {
           if (!pc) 
            return "Observer";
           else {
            if (pc == 10) 
             return "Random Playerclass";
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
};

void (entity Viewer, float pc, float rpc) TeamFortress_PrintClassName =
{
 local string st;

 st = TeamFortress_GetClassName(pc);
 sprint(Viewer, 2, st);
 if (rpc) 
  sprint(Viewer, 2, " (Random)");
 sprint(Viewer, 2, "\n");
};

void () TeamFortress_RemoveTimers =
{
 local entity te;

 self.leg_damage = 0;
 self.is_undercover = 0;
 self.is_building = 0;
 self.building = world;
 if (self.tfstate & 2048) {
  self.tfstate = self.tfstate - 2048;
  TeamFortress_SetSpeed(self);
  self.heat = 0;
 }
 if (self.tfstate & 16) 
  self.tfstate = self.tfstate - (self.tfstate & 16);
 if (self.tfstate & 16384) 
  self.tfstate = self.tfstate - (self.tfstate & 16384);
 te = find(world, classname, "timer");
 while (te != world) {
  if (te.owner == self) {
   dremove(te);
   te = find(world, classname, "timer");
  }
  else 
   te = find(te, classname, "timer");
 }
 te = find(world, classname, "item_tfgoal");
 while (te) {
  if (te.owner == self) {
   if (!(te.goal_activation & 256) || self.has_disconnected == 1) 
    tfgoalitem_RemoveFromPlayer(te, self, 0);
   if (CTF_Map == 1 && te.goal_no == 1) {
    bprint(2, self.netname);
    bprint(2, " лост the блуе flag!\n");
   }
   else {
    if (CTF_Map == 1 && te.goal_no == 2) {
     bprint(2, self.netname);
     bprint(2, " лост the ред flag!\n");
    }
   }
  }
  te = find(te, classname, "item_tfgoal");
 }
 te = find(world, classname, "detpack");
 while (te) {
  if (te.weaponmode == 1 && te.enemy == self) 
   te.weaponmode = 0;
  te = find(te, classname, "detpack");
 }
 TeamFortress_DetonatePipebombs();
 if (self.has_disconnected == 1) {
  te = find(world, classname, "grenade");
  while (te) {
   if (te.owner == self && te.model == "progs/caltrop.mdl") {
    dremove(te);
    te = find(world, classname, "grenade");
   }
   else 
    te = find(te, classname, "grenade");
  }
 }
 if (old_grens == 1) {
  stuffcmd(self, "v_idlescale 0\n");
  stuffcmd(self, "v_cshift; wait; bf\n");
  self.FlashTime = 0;
#ifdef ANTIANTIFLASH
          if(new_flash) 
                   disable_updates(self, -1); /* server-side flash */
#endif // antiantiflash
 }
 self.item_list = 0;
 CenterPrint(self, "\n");
 self.menu_count = 25;
 self.current_menu = 1;
 self.impulse = 0;
};

void (float Suicided) TeamFortress_SetupRespawn =
{
 local float restime;
 local string db;

 if (self.respawn_time > time) 
  return;
 if (toggleflags & 4) 
  restime = respawn_delay_time;
 else 
  restime = 0;
 if (cb_prematch_time < time) {
  if (Suicided) {
   if (self.lives > 0) 
    self.lives = self.lives - 1;
   restime = restime + 7;
  }
 }
 if (cb_prematch_time > time) {
  if (self.lives > 0) 
   self.lives = self.lives - 1;
  if (self.lives != -1) {
   if (!self.lives) {
    sprint(self, 2, "NO lives left, returning to Observer mode.\n");
    self.playerclass = 0;
    self.tfstate = self.tfstate - (self.tfstate & 8);
    self.movetype = 8;
    self.solid = 0;
    self.model = "";
    self.mdl = "";
    self.velocity = '0 0 0';
    self.avelocity = '0 0 0';
    self.enemy = world;
    setmodel(self, "");
    return;
   }
   if (self.lives == 1) 
    sprint(self, 2, "LAST life.\n");
   else {
    db = ftos(self.lives);
    sprint(self, 2, db);
    sprint(self, 2, " lives left.\n");
   }
  }
 }
 self.respawn_time = time + restime;
 if (restime > 3) {
  db = ftos(restime);
  sprint(self, 2, db);
  sprint(self, 2, " seconds till respawn.\n");
 }
};

void () TeamFortress_CheckClassStats =
{
 if (self.armortype > self.armor_allowed) 
  self.armortype = self.armor_allowed;
 if (self.armorvalue > self.maxarmor) 
  self.armorvalue = self.maxarmor;
 if (self.armortype < 0) 
  self.armortype = 0;
 if (self.armorvalue < 0) 
  self.armorvalue = 0;
 if (self.ammo_shells > TeamFortress_GetMaxAmmo(self, 256)) 
  self.ammo_shells = TeamFortress_GetMaxAmmo(self, 256);
 if (self.ammo_shells < 0) 
  self.ammo_shells = 0;
 if (self.ammo_nails > TeamFortress_GetMaxAmmo(self, 512)) 
  self.ammo_nails = TeamFortress_GetMaxAmmo(self, 512);
 if (self.ammo_nails < 0) 
  self.ammo_nails = 0;
 if (self.ammo_rockets > TeamFortress_GetMaxAmmo(self, 1024)) 
  self.ammo_rockets = TeamFortress_GetMaxAmmo(self, 1024);
 if (self.ammo_rockets < 0) 
  self.ammo_rockets = 0;
 if (self.ammo_cells > TeamFortress_GetMaxAmmo(self, 2048)) 
  self.ammo_cells = TeamFortress_GetMaxAmmo(self, 2048);
 if (self.ammo_cells < 0) 
  self.ammo_cells = 0;
 if (self.ammo_medikit > TeamFortress_GetMaxAmmo(self, 4)) 
  self.ammo_medikit = TeamFortress_GetMaxAmmo(self, 4);
 if (self.ammo_medikit < 0) 
  self.ammo_medikit = 0;
 if (self.ammo_detpack > TeamFortress_GetMaxAmmo(self, 131072)) 
  self.ammo_detpack = TeamFortress_GetMaxAmmo(self, 131072);
 if (self.ammo_detpack < 0) 
  self.ammo_detpack = 0;
 if (self.no_grenades_1 < 0) 
  self.no_grenades_1 = 0;
 if (self.no_grenades_2 < 0) 
  self.no_grenades_2 = 0;
 if (self.health > self.max_health && !(self.items & 65536)) 
  TF_T_Damage(self, world, world, self.max_health - self.health, 0, 256);
 if (self.health < 0) 
  T_Heal(self, self.health - self.health, 0);
 self.items = self.items - (self.items & (8192 | 16384 | 32768));
 if (self.armortype >= 0.8) 
  self.items = self.items | 32768;
 else {
  if (self.armortype >= 0.6) 
   self.items = self.items | 16384;
  else {
   if (self.armortype >= 0.3) 
    self.items = self.items | 8192;
  }
 }
};

void (float type) TeamFortress_DropAmmo =
{
 local float ammo;

 if (type == 1) {
  ammo = #DROP_SHELLS;
  if (self.ammo_shells < ammo) {
   if (self.playerclass == 9) {
    if (self.ammo_cells / #AMMO_COST_SHELLS > ammo - self.ammo_shells) {
     sprint(self, 2, "you make some shells.\n");
     self.ammo_cells = self.ammo_cells - (ammo - self.ammo_shells) * #AMMO_COST_SHELLS;
     self.ammo_shells = ammo;
    }
   }
   if (self.ammo_shells < ammo) 
    return;
  }
  self.ammo_shells = self.ammo_shells - ammo;
 }
 else {
  if (type == 2) {
   ammo = #DROP_NAILS;
   if (self.ammo_nails < ammo) {
    if (self.playerclass == 9) {
     if (self.ammo_cells / #AMMO_COST_NAILS > ammo - self.ammo_nails) {
      sprint(self, 2, "you make some nails.\n");
      self.ammo_cells = self.ammo_cells - (ammo - self.ammo_nails) * #AMMO_COST_NAILS;
      self.ammo_nails = ammo;
     }
    }
    if (self.ammo_nails < ammo) 
     return;
   }
   self.ammo_nails = self.ammo_nails - ammo;
  }
  else {
   if (type == 3) {
    ammo = #DROP_ROCKETS;
    if (self.ammo_rockets < ammo) {
     if (self.playerclass == 9) {
      if (self.ammo_cells / #AMMO_COST_ROCKETS > ammo - self.ammo_rockets) {
       sprint(self, 2, "you make some rockets.\n");
       self.ammo_cells = self.ammo_cells - (ammo - self.ammo_rockets) * #AMMO_COST_ROCKETS;
       self.ammo_rockets = ammo;
      }
     }
     if (self.ammo_rockets < ammo) 
      return;
    }
    self.ammo_rockets = self.ammo_rockets - ammo;
   }
   else {
    if (type == 4) {
     ammo = #DROP_CELLS;
     if (self.ammo_cells < ammo) {
      if (self.playerclass == 9) {
       if (self.ammo_cells / #AMMO_COST_CELLS > ammo - self.ammo_cells) {
        sprint(self, 2, "you make some cells.\n");
        self.ammo_cells = self.ammo_cells - (ammo - self.ammo_cells) * #AMMO_COST_CELLS;
        self.ammo_cells = ammo;
       }
      }
      if (self.ammo_cells < ammo) 
       return;
     }
     self.ammo_cells = self.ammo_cells - ammo;
    }
   }
  }
 }
 W_SetCurrentAmmo();
 if (self.team_no) {
  increment_team_ammoboxes(self.team_no);
  if (num_team_ammoboxes(self.team_no) > 20 / number_of_teams) 
   RemoveOldAmmobox(self.team_no);
 }
 else {
  num_world_ammoboxes = num_world_ammoboxes + 1;
  if (num_world_ammoboxes > 20) 
   RemoveOldAmmobox(0);
 }
 newmis = spawn();
 newmis.aflag = ammo;
 newmis.weapon = type;
 if (newmis.weapon == 1) 
  newmis.ammo_shells = ammo;
 else {
  if (newmis.weapon == 2) 
   newmis.ammo_nails = ammo;
  else {
   if (newmis.weapon == 3) 
    newmis.ammo_rockets = ammo;
   else {
    if (newmis.weapon == 4) 
     newmis.ammo_cells = ammo;
   }
  }
 }
 newmis.enemy = self;
 newmis.health = time;
 newmis.movetype = 6;
 newmis.solid = 1;
 newmis.classname = "ammobox";
 newmis.team_no = self.team_no;
 makevectors(self.v_angle);
 if (self.v_angle_x) 
  newmis.velocity = v_forward * 400 + v_up * 200;
 else {
  newmis.velocity = aim(self, 10000);
  newmis.velocity = newmis.velocity * 400;
  newmis.velocity_z = 200;
 }
 newmis.avelocity = '0 300 0';
 setsize(newmis, '0 0 0', '0 0 0');
 setorigin(newmis, self.origin);
 newmis.nextthink = time + 30;
 newmis.think = SUB_Remove;
 newmis.touch = TeamFortress_AmmoboxTouch;
 newmis.skin = type - 1;
 if (birthday == 1 && random() < 0.6) 
  setmodel(newmis, "progs/grenade3.mdl");
 else 
  setmodel(newmis, "progs/ammobox.mdl");
};

void () TeamFortress_AmmoboxTouch =
{
 local float took;
 local string quantity;

 took = 0;
 if (other == self.enemy && time < self.health + 2) 
  return;
 if ((other.tfstate & 65536) || (other.tfstate & 2048)) 
  return;
 if (other.classname != "player") 
  return;
 if (other.health <= 0) 
  return;
 num_world_ammoboxes = num_world_ammoboxes - 1;
 decrement_team_ammoboxes(self.team_no);
 if (!self.weapon) {
  sprint(other, 2, "You got ");
  if (self.ammo_shells > 0) {
   other.ammo_shells = other.ammo_shells + self.ammo_shells;
   quantity = ftos(self.ammo_shells);
   sprint2(other, 2, quantity, " shells  ");
  }
  if (self.ammo_nails > 0) {
   other.ammo_nails = other.ammo_nails + self.ammo_nails;
   quantity = ftos(self.ammo_nails);
   sprint2(other, 2, quantity, " nails  ");
  }
  if (self.ammo_rockets > 0) {
   other.ammo_rockets = other.ammo_rockets + self.ammo_rockets;
   quantity = ftos(self.ammo_rockets);
   sprint2(other, 2, quantity, " rockets  ");
  }
  if (self.ammo_cells > 0) {
   other.ammo_cells = other.ammo_cells + self.ammo_cells;
   quantity = ftos(self.ammo_cells);
   sprint2(other, 2, quantity, " cells  ");
  }
  sprint3(other, 2, " from ", self.enemy.netname, "'s discarded pack.\n");
 }
 else {
  if (self.weapon == 1) {
   if (other.ammo_shells >= TeamFortress_GetMaxAmmo(other, 256)) 
    return;
   other.ammo_shells = other.ammo_shells + self.aflag;
   self.netname = "shells";
  }
  else {
   if (self.weapon == 2) {
    if (other.ammo_nails >= TeamFortress_GetMaxAmmo(other, 512)) 
     return;
    other.ammo_nails = other.ammo_nails + self.aflag;
    self.netname = "nails";
   }
   else {
    if (self.weapon == 3) {
     if (other.ammo_rockets >= TeamFortress_GetMaxAmmo(other, 1024)) 
      return;
     other.ammo_rockets = other.ammo_rockets + self.aflag;
     self.netname = "rockets";
    }
    else {
     if (self.weapon == 4) {
      if (other.ammo_cells >= TeamFortress_GetMaxAmmo(other, 2048)) 
       return;
      other.ammo_cells = other.ammo_cells + self.aflag;
      self.netname = "cells";
     }
    }
   }
  }
 }
 bound_other_ammo(other);
 if (self.weapon > 0) {
  quantity = ftos(self.aflag);
  sprint5(other, 0, "You picked up ", quantity, " ", self.netname, "\n");
 }
 sound(other, 3, "weapons/lock4.wav", 1, 1);
 stuffcmd(other, "bf\n");
 dremove(self);
 self = other;
 W_SetCurrentAmmo();
};

float (float tno) num_team_ammoboxes =
{
 if (tno == 1) 
  return num_team_ammoboxes_1;
 else {
  if (tno == 2) 
   return num_team_ammoboxes_2;
  else {
   if (tno == 3) 
    return num_team_ammoboxes_3;
   else {
    if (tno == 4) 
     return num_team_ammoboxes_4;
   }
  }
 }
 return 0;
};

void (float tno) RemoveOldAmmobox =
{
 local float index;

 if (tno) {
  index = num_team_ammoboxes(tno);
  index = index - 20 / number_of_teams;
 }
 else 
  index = num_world_ammoboxes - 20;
 old = find(world, classname, "ammobox");
 while (index > 0) {
  if (old == world) 
   return;
  if (old.team_no == tno || !tno) {
   old.think = SUB_Remove;
   old.nextthink = time + 0.1;
   index = index - 1;
   num_world_ammoboxes = num_world_ammoboxes - 1;
   decrement_team_ammoboxes(old.team_no);
  }
  old = find(old, classname, "ammobox");
 }
};

void (float tno) increment_team_ammoboxes =
{
 if (tno == 1) 
  num_team_ammoboxes_1 = num_team_ammoboxes_1 + 1;
 else {
  if (tno == 2) 
   num_team_ammoboxes_2 = num_team_ammoboxes_2 + 1;
  else {
   if (tno == 3) 
    num_team_ammoboxes_3 = num_team_ammoboxes_3 + 1;
   else {
    if (tno == 4) 
     num_team_ammoboxes_4 = num_team_ammoboxes_4 + 1;
   }
  }
 }
};

void (float tno) decrement_team_ammoboxes =
{
 if (tno == 1) 
  num_team_ammoboxes_1 = num_team_ammoboxes_1 - 1;
 else {
  if (tno == 2) 
   num_team_ammoboxes_2 = num_team_ammoboxes_2 - 1;
  else {
   if (tno == 3) 
    num_team_ammoboxes_3 = num_team_ammoboxes_3 - 1;
   else {
    if (tno == 4) 
     num_team_ammoboxes_4 = num_team_ammoboxes_4 - 1;
   }
  }
 }
};

void () TeamFortress_AssaultWeapon =
{
 local float it;

 self.impulse = 0;
 if (self.tfstate & 2) 
  return;
 if (!(self.weapons_carried & 32768)) 
  return;
 if (self.heat > 0) {
  sprint(self, 2, "the assault cannon is still overheated.\n");
  return;
 }
 if (self.ammo_shells < 1) {
  sprint(self, 2, "not enough ammo.\n");
  return;
 }
 if (self.ammo_cells < 6) {
  sprint(self, 2, "not enough cells to power the assault cannon.\n");
  return;
 }
 self.current_weapon = 32768;
 W_SetCurrentAmmo();
};

void () TeamFortress_ExplodePerson =
{
 local entity te;

 self.owner.tfstate = self.owner.tfstate - (self.owner.tfstate & 1);
 KickPlayer(-2, self.owner);
 newmis = spawn();
 newmis.movetype = 10;
 newmis.solid = 2;
 newmis.classname = "grenade";
 newmis.team_no = self.owner.team_no;
 newmis.owner = self.owner;
 newmis.velocity = '0 0 0';
 newmis.angles = vectoangles(newmis.velocity);
 newmis.think = SUB_Null;
 newmis.nextthink = time + 0.1;
 if (self.weapon == 1) {
  newmis.touch = NormalGrenadeTouch;
  newmis.think = NormalGrenadeExplode;
  newmis.skin = 0;
  newmis.avelocity = '300 300 300';
  setmodel(newmis, "progs/hgren2.mdl");
 }
 else {
  if (self.weapon == 2) {
   newmis.touch = ConcussionGrenadeTouch;
   newmis.think = ConcussionGrenadeExplode;
   newmis.skin = 1;
   newmis.avelocity = '300 300 300';
   setmodel(newmis, "progs/hgren2.mdl");
  }
  else {
   if (self.weapon == 3) {
    newmis.touch = NailGrenadeTouch;
    newmis.think = NailGrenadeExplode;
    newmis.skin = 1;
    newmis.avelocity = '0 300 0';
    setmodel(newmis, "progs/biggren.mdl");
   }
   else {
    if (self.weapon == 4) {
     newmis.touch = MirvGrenadeTouch;
     newmis.think = MirvGrenadeExplode;
     newmis.skin = 0;
     newmis.avelocity = '0 300 0';
     setmodel(newmis, "progs/biggren.mdl");
    }
    else {
     if (self.weapon == 5) {
      newmis.touch = NapalmGrenadeTouch;
      newmis.think = NapalmGrenadeExplode;
      newmis.skin = 2;
      newmis.avelocity = '0 300 0';
      setmodel(newmis, "progs/biggren.mdl");
     }
     else {
      if (self.weapon == 6) {
       sprint(self.owner, 2, "Flare lit.\n");
       te = spawn();
       te.touch = SUB_Null;
       te.think = RemoveFlare;
       te.nextthink = time + 25;
       te.owner = self.owner;
       te.solid = 0;
       self.owner.effects = self.owner.effects | 4;
       dremove(self);
       dremove(newmis);
       return;
      }
      else {
       if (self.weapon == 7) {
        newmis.touch = GasGrenadeTouch;
        newmis.think = GasGrenadeExplode;
        newmis.skin = 2;
        newmis.avelocity = '300 300 300';
        setmodel(newmis, "progs/grenade2.mdl");
       }
       else {
        if (self.weapon == 8) {
         newmis.touch = EMPGrenadeTouch;
         newmis.think = EMPGrenadeExplode;
         newmis.skin = 4;
         newmis.avelocity = '300 300 300';
         setmodel(newmis, "progs/grenade2.mdl");
        }
        else {
         if (self.weapon == 10) {
          newmis.touch = CaltropTouch;
          newmis.think = ScatterCaltrops;
         }
         else {
          if (self.weapon == 9) {
           newmis.touch = FlashGrenadeTouch;
           newmis.think = FlashGrenadeExplode;
           newmis.skin = 1;
           newmis.avelocity = '300 300 300';
           setmodel(newmis, "progs/grenade2.mdl");
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
 setsize(newmis, '0 0 0', '0 0 0');
 setorigin(newmis, self.owner.origin);
 if (birthday == 1) 
  bprint3(1, self.owner.netname, " wouldn't let go of his gifts!\n");
 else {
  if (self.owner.playerclass == 1 && self.weapon != 10) 
   bprint3(1, "No ", self.owner.netname, ", swallowing the grenade isn't very effective!\n");
  else {
   if (self.owner.playerclass == 2) 
    bprint3(1, "Well ", self.owner.netname, ", don't quit your day job!\n");
   else {
    if (self.owner.playerclass == 3) 
     bprint3(1, "Ummm, ", self.owner.netname, ", you're supposed to THROW the grenade!\n");
    else {
     if (self.owner.playerclass == 4) 
      bprint3(1, "Ack! ", self.owner.netname, "! The grenade is your friend for another reason!\n");
     else {
      if (self.owner.playerclass == 5) 
       bprint3(1, "No ", self.owner.netname, "! Assist your own suicide some other time!\n");
      else {
       if (self.owner.playerclass == 6) 
        bprint3(1, "Hey ", self.owner.netname, ", you're not THAT heavy!\n");
       else {
        if (self.owner.playerclass == 7) 
         bprint3(1, "Yes ", self.owner.netname, ", the grenade does explode on '3'!\n");
        else {
         if (self.owner.playerclass == 8) 
          bprint3(1, "You do realize ", self.owner.netname, ", you can blow your cover in easier ways!\n");
         else {
          if (self.owner.playerclass == 9) 
           bprint3(1, "Hey ", self.owner.netname, ", study grenade dynamics on your own time!\n");
          else 
           bprint3(1, "No ", self.owner.netname, ", throw the grenade, not the pin!\n");
         }
        }
       }
      }
     }
    }
   }
  }
 }
 dremove(self);
};

void () NormalGrenadeTouch =
{
 if (other == self.owner) 
  return;
 sound(self, 1, "weapons/bounce.wav", 1, 1);
 if (self.velocity == '0 0 0') 
  self.avelocity = '0 0 0';
};

void () NormalGrenadeExplode =
{
 deathmsg = 8;
 T_RadiusDamage(self, self.owner, 180, world);
 WriteByte(4, 23);
 WriteByte(4, 3);
 WriteCoord(4, self.origin_x);
 WriteCoord(4, self.origin_y);
 WriteCoord(4, self.origin_z);
 multicast(self.origin, 1);
 dremove(self);
};

void () TeamFortress_DisplayDetectionItems =
{
 local entity Goal;
 local entity te;

 Goal = find(world, classname, "info_tfdetect");
 if (!Goal) 
  return;
 if (Goal.display_item_status1) {
  te = Finditem(Goal.display_item_status1);
  if (te) 
   DisplayItemStatus(Goal, self, te);
  else 
   sprint(self, 2, "Item is missing.\n");
 }
 else 
  return;
 if (Goal.display_item_status2) {
  te = Finditem(Goal.display_item_status2);
  if (te) 
   DisplayItemStatus(Goal, self, te);
  else 
   sprint(self, 2, "Item is missing.\n");
 }
 else 
  return;
 if (Goal.display_item_status3) {
  te = Finditem(Goal.display_item_status3);
  if (te) 
   DisplayItemStatus(Goal, self, te);
  else 
   sprint(self, 2, "Item is missing.\n");
 }
 else 
  return;
 if (Goal.display_item_status4) {
  te = Finditem(Goal.display_item_status4);
  if (te) 
   DisplayItemStatus(Goal, self, te);
  else 
   sprint(self, 2, "Item is missing.\n");
 }
};

void () BioInfection_Decay =
{
 local entity te;
 local entity Bio;

 if ((teamplay & 16) && self.owner.team_no == self.enemy.team_no && self.owner.team_no) {
  self.owner.tfstate = self.owner.tfstate - (self.owner.tfstate & 16);
  dremove(self);
  return;
 }
 else {
  if (self.invincible_finished > time) {
   self.owner.tfstate = self.owner.tfstate - (self.owner.tfstate & 16);
   dremove(self);
   return;
  }
 }
 if (!(self.owner.tfstate & 16) || self.owner.playerclass == 5) {
  dremove(self);
  return;
 }
 te = findradius(self.owner.origin, 80);
 while (te != world && te != self.owner) {
  if (te.classname == "player" && !te.deadflag && te.playerclass) {
   if (!(te.tfstate & 16)) {
    if (te.playerclass != 5) {
     if (!((teamplay & 16) && self.owner.team_no == self.enemy.team_no && self.owner.team_no)) {
      Bio = spawn();
      Bio.nextthink = 2;
      Bio.think = BioInfection_Decay;
      Bio.owner = te;
      Bio.classname = "timer";
      Bio.enemy = self.enemy;
      te.tfstate = te.tfstate | 16;
      te.infection_team_no = self.owner.infection_team_no;
      sprint(te, 1, "You have been infected by ");
      sprint(te, 1, self.owner.netname);
      sprint(te, 1, "!\n");
      sprint(self.owner, 1, "You have infected ");
      sprint(self.owner, 1, te.netname);
      sprint(self.owner, 1, "!\n");
     }
    }
   }
  }
  te = te.chain;
 }
 self.nextthink = time + 3;
 deathmsg = 13;
 TF_T_Damage(self.owner, self, self.enemy, 8, 1, 0);
 SpawnBlood(self.owner.origin, 30);
};

void () BioInfection_MonsterDecay =
{
 self.nextthink = time + 2;
 T_Damage(self.enemy, self, self.owner, 5);
 SpawnBlood(self.enemy.origin, 20);
 if (self.enemy.health < 1) 
  dremove(self);
};

void (string halias, float himpulse1, float himpulse2) TeamFortress_Alias =
{
 local string imp;

 stuffcmd(self, "alias ");
 stuffcmd(self, halias);
 stuffcmd(self, " \"impulse ");
 imp = ftos(himpulse1);
 stuffcmd(self, imp);
 if (himpulse2) {
  stuffcmd(self, ";wait; impulse ");
  imp = ftos(himpulse2);
  stuffcmd(self, imp);
 }
 stuffcmd(self, "\"\n");
};

void () TeamFortress_Regenerate =
{
 local entity oldself;
 if (self.owner.playerclass == 5) {
  self.nextthink = time + 3;
  if (self.owner.has_disconnected == 1) {
   dremove(self);
   return;
  }
  if (self.owner.health >= self.owner.max_health) 
   return;
  if (!self.owner.ammo_medikit) 
   return;
  if (self.owner.ammo_medikit < 2) {
   self.owner.health = self.owner.health + self.owner.ammo_medikit;
   self.owner.ammo_medikit = 0;
  }
  else {
   self.owner.health = self.owner.health + 2;
   self.owner.ammo_medikit = self.owner.ammo_medikit - 2;
  }
  if (self.owner.health > self.owner.max_health) 
   self.owner.health = self.owner.max_health;

/*   oldself=self;
   self=self.owner;
   W_SetCurrentAmmo();
   self=oldself;*/
   self.owner.currentammo = self.owner.ammo_medikit;
 }
};

void () TeamFortress_RegenerateCells =
{
 if (self.owner.playerclass == 8) {
  self.nextthink = time + 5;
  if (self.owner.is_undercover == 1) {
   if (!self.owner.ammo_cells) {
    self.owner.is_undercover = 0;
    self.owner.modelindex = modelindex_player;
    self.owner.items = self.owner.items - (self.owner.items & 524288);
   }
   else {
    self.owner.ammo_cells = self.owner.ammo_cells - 3;
    if (self.owner.ammo_cells < 0) 
     self.owner.ammo_cells = 0;
   }
  }
  else {
   if (self.owner.ammo_cells >= self.owner.maxammo_cells) 
    return;
   self.owner.ammo_cells = self.owner.ammo_cells + 1;
   if (self.owner.ammo_cells > self.owner.maxammo_cells) 
    self.owner.ammo_cells = self.owner.maxammo_cells;
  }
  return;
 }
};


void () TeamFortress_AutoID =
{
 local entity oldself;
 self.nextthink = time + #TF_AUTOIDTIME;
  oldself = self;
  self=self.owner;
  TeamFortress_ID();
  self = oldself;
};

void () TeamFortress_CheckforCheats =
{
 local float tf;
 local float pf;
 local string st;
 local vector vplf;
 local vector vf;

 self.nextthink = time + 2;
 if (self.owner.immune_to_check > time) 
  return;
 if (self.owner.deadflag) 
  return;
 if (!(self.owner.flags & 512) || self.velocity_z) 
  return;
 vplf = self.owner.velocity;
 makevectors(self.owner.angles);
 vf = v_forward;
 vf_z = 0;
 vf = normalize(vf);
 tf = vplf_x * vf_x + vplf_y * vf_y;
 pf = self.owner.maxfbspeed + 100;
 if ((self.owner.tfstate & 65536) && tf > 20) {
  self.nextthink = time + 0.5;
  self.owner.cheat_level = self.owner.cheat_level + 600;
 }
 if (tf > pf) {
  pf = pf + 100;
  if (tf > pf) {
   self.nextthink = time + 2;
   self.owner.cheat_level = self.owner.cheat_level + 300;
  }
  else {
   self.nextthink = time + 3;
   self.owner.cheat_level = self.owner.cheat_level + 150;
  }
  TeamFortress_SetSpeed(self.owner);
 }
 if (self.owner.cheat_level > 1200) {
  self.owner.cheat_level = 0;
  bprint2(1, self.owner.netname, " has been kicked for cheating.\n");
  sprint(self.owner, 2, "You have been kicked for cheating, because of your speed.\n");
  KickCheater(self.owner);
 }
};

void () PlayerObserverMode =
{
 self.current_menu = 1;
 self.impulse = 0;
 self.playerclass = 0;
 self.lives = 0;
 self.team_no = -1;
 self.flags = 8 | 128 | 512;
 self.waterlevel = 3;
 self.takedamage = 0;
 self.solid = 0;
 self.movetype = 8;
 sprint(self, 2, "Observer mode\n");
 CenterPrint(self, "\n");
 stuffcmd(self, "cl_rollangle 0\n");
};

float (vector veca, vector vecb) crossproduct =
{
 local float result;

 result = veca_x * vecb_y - vecb_x * veca_y;
 return result;
};

void (entity pl, float fr) TF_AddFrags =
{
 local entity e;

 if (intermission_running || intermission_exittime > time) 
  return;
 pl.real_frags = pl.real_frags + fr;
 if (!pl.team_no) 
  return;
 if (toggleflags & 2048) {
  if (pl.team_no == 1) 
   team1score = team1score + fr;
  else {
   if (pl.team_no == 2) 
    team2score = team2score + fr;
   else {
    if (pl.team_no == 3) 
     team3score = team3score + fr;
    else {
     if (pl.team_no == 4) 
      team4score = team4score + fr;
    }
   }
  }
 }
 if (pl.team_no == 1) 
  team1frags = team1frags + fr;
 else {
  if (pl.team_no == 2) 
   team2frags = team2frags + fr;
  else {
   if (pl.team_no == 3) 
    team3frags = team3frags + fr;
   else {
    if (pl.team_no == 4) 
     team4frags = team4frags + fr;
   }
  }
 }
 if (toggleflags & 2048) {
  e = find(world, classname, "player");
  while (e) {
   if (e.team_no == pl.team_no) 
    e.frags = TeamFortress_TeamGetScore(e.team_no);
   e = find(e, classname, "player");
  }
 }
 else {
  if (!(toggleflags & 128)) 
   pl.frags = pl.real_frags;
 }
};

void (entity p) TeamFortress_ExecClassScript =
{
 local string st;

 st = infokey(p, "ec");
 if (st == string_null) 
  st = infokey(p, "exec_class");
        if (st == string_null) 
        {
         st = infokey(p, "s");
         if (stof(st)& #TF_EXEC_CLASS_MASK ) 
         {
           st="on";
         }
        }
 if (st == "on") {
  if (p.playerclass == 1) 
   stuffcmd(p, "exec scout.cfg\n");
  else {
   if (p.playerclass == 2) 
    stuffcmd(p, "exec sniper.cfg\n");
   else {
    if (p.playerclass == 3) 
     stuffcmd(p, "exec soldier.cfg\n");
    else {
     if (p.playerclass == 4) 
      stuffcmd(p, "exec demoman.cfg\n");
     else {
      if (p.playerclass == 5) 
       stuffcmd(p, "exec medic.cfg\n");
      else {
       if (p.playerclass == 6) 
        stuffcmd(p, "exec hwguy.cfg\n");
       else {
        if (p.playerclass == 7) 
         stuffcmd(p, "exec pyro.cfg\n");
        else {
         if (p.playerclass == 8) 
          stuffcmd(p, "exec spy.cfg\n");
         else {
          if (p.playerclass == 9) 
           stuffcmd(p, "exec engineer.cfg\n");
         }
        }
       }
      }
     }
    }
   }
  }
 }
};

void (entity p) TeamFortress_ExecMapScript =
{
 local string st;

 st = infokey(p, "em");
 if (st == string_null) 
  st = infokey(p, "exec_map");
        if (st == string_null) 
        {
         st = infokey(p, "s");
         if (stof(st)& #TF_EXEC_MAP_MASK ) 
         {
           st="on";
         }
        }

 if (st == "on") {
  stuffcmd(p, "exec mapdefault.cfg\n");
  stuffcmd(p, "exec ");
  stuffcmd(p, mapname);
  stuffcmd(p, ".cfg\n");
 }
};

void (entity p) KickCheater =
{
 stuffcmd(p, "disconnect\n");
 msg_entity = p;
 WriteByte(1, 23);
 WriteByte(1, 5);
 WriteCoord(1, self.origin_x);
 p.has_disconnected = 1;
 p.touch = SUB_Null;
 p.health = 0;
 p.solid = 0;
 p.tfstate = p.tfstate | 65536;
 TeamFortress_SetSpeed(p);
 TeamFortress_RemoveTimers();
};

