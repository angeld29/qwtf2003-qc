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


void () LaserBolt_Touch;
void () EMPExplode;
void () EMPGrenadeTouch;
void () EMPGrenadeExplode;
void () TeamFortress_FinishedBuilding;
void () T_Mortar;
void () Dispenser_Die;
void () CheckDistance;
float (entity obj, entity builder) CheckArea;

void () LaserBolt_Think =
{
 self.solid = 1;
 self.movetype = 9;
 self.velocity = self.oldorigin;
 self.touch = LaserBolt_Touch;
 setmodel(self, "progs/e_spike2.mdl");
 self.nextthink = time + 1;
 self.think = SUB_Remove;
};

void () LaserBolt_Touch =
{
 local vector org;

 if (other == self.owner) 
  return;
 if (other == self.enemy && self.enemy != world) 
  return;
 if (pointcontents(self.origin) == -6) {
  dremove(self);
  return;
 }
 org = self.origin - 8 * normalize(self.velocity);
 if (other.health) {
  SpawnBlood(org, 15);
  deathmsg = 26;
  TF_T_Damage(other, self, self.enemy, 25, 2, 8);
  self.velocity = self.oldorigin;
  self.owner = other;
  setmodel(self, string_null);
  self.touch = SUB_Null;
  self.nextthink = time + 0.1;
  self.think = LaserBolt_Think;
  return;
 }
 else {
  WriteByte(4, 23);
  WriteByte(4, 0);
  WriteCoord(4, self.origin_x);
  WriteCoord(4, self.origin_y);
  WriteCoord(4, self.origin_z);
  multicast(self.origin, 1);
 }
 dremove(self);
};

void () W_FireLaser =
{
 local vector vec;
 local vector org;

 self.ammo_nails = self.ammo_nails - 1;
 self.currentammo = self.ammo_nails ;
 makevectors(self.v_angle);
 org = self.origin + v_forward * 8;
 vec = aim(self, 10000);
 vec = normalize(vec);
 newmis = spawn();
 newmis.owner = self;
 newmis.enemy = self;
 newmis.movetype = 9;
 newmis.solid = 1;
 setmodel(newmis, "progs/e_spike1.mdl");
 setsize(newmis, '0 0 0', '0 0 0');
 setorigin(newmis, org + '0 0 16');
 newmis.velocity = vec * 1500;
 newmis.angles = vectoangles(newmis.velocity);
 newmis.oldorigin = newmis.velocity;
 newmis.nextthink = time + 5;
 newmis.think = SUB_Remove;
 newmis.touch = LaserBolt_Touch;
};

void () EMPExplode =
{
 local float expsize;

 expsize = 10;
 if (self.touch == weapon_touch) 
  expsize = 60;
 else {
  if (self.classname == "item_shells") 
   expsize = 50 + self.aflag;
  else {
   if (self.classname == "item_spikes") 
    expsize = 40;
   else {
    if (self.classname == "item_rockets") 
     expsize = 100 + self.aflag * 4;
    else {
     if (self.classname == "item_cells") 
      expsize = 100 + self.aflag * 3;
     else {
      if (self.classname == "item_weapon") 
       expsize = 60;
      else {
       dprint("EMPExplode: Attempting to explode a ");
       dprint(self.classname);
       dprint("\n");
       return;
      }
     }
    }
   }
  }
 }
 deathmsg = 31;
 T_RadiusDamage(self, self.enemy, expsize, world);
 WriteByte(4, 23);
 WriteByte(4, 3);
 WriteCoord(4, self.origin_x);
 WriteCoord(4, self.origin_y);
 WriteCoord(4, self.origin_z);
 multicast(self.origin, 1);
 Respawn_Item(self, self.enemy);
};

void () EMPGrenadeTouch =
{
 sound(self, 1, "weapons/bounce.wav", 1, 1);
 if (self.velocity == '0 0 0') 
  self.avelocity = '0 0 0';
};

void () EMPGrenadeExplode =
{
 local float expsize;
 local entity te;
 local entity oldself;

 WriteByte(4, 23);
 WriteByte(4, 4);
 WriteCoord(4, self.origin_x);
 WriteCoord(4, self.origin_y);
 WriteCoord(4, self.origin_z);
 multicast(self.origin, 1);
 te = findradius(self.origin, 240);
 while (te) {
  if (te.touch == ammo_touch || te.touch == weapon_touch) {
   if (te.classname != "item_spikes") {
    te.solid = 0;
    te.enemy = self.owner;
    te.nextthink = time + 1 + random() * 2;
    te.think = EMPExplode;
   }
  }
  else {
   if (te.think == TeamFortress_DetpackExplode) {
    te.solid = 0;
    te.nextthink = time + 1 + random() * 2;
    dremove(te.oldenemy);
   }
   else {
    if (te.classname == "pipebomb") 
     te.nextthink = time + 0.1;
    else {
     if (te.classname == "building_dispenser" || te.classname == "building_sentrygun"){
              if (!((teamplay & #TEAMPLAY_NOEXPLOSIVE) && te.team_no > 0 && te.team_no == self.owner.team_no))       
      TF_T_Damage(te, self, self.owner, 200, 0, 4);
     } 
     else {
      if (te.classname == "ammobox") {
       expsize = 0;
       expsize = expsize + te.ammo_shells * 0.75;
       expsize = expsize + te.ammo_rockets * 0.75 * 2;
       expsize = expsize + te.ammo_cells * 0.75 * 2;
       if (expsize > 0) {
        te.solid = 0;
        deathmsg = 30;
        T_RadiusDamage(te, self.owner, expsize, te);
        te.think = SUB_Remove;
        te.nextthink = time + 0.1;
        WriteByte(4, 23);
        WriteByte(4, 3);
        WriteCoord(4, te.origin_x);
        WriteCoord(4, te.origin_y);
        WriteCoord(4, te.origin_z);
        multicast(te.origin, 1);
       }
      }
      else {
       if (te.classname == "player" || te.touch == BackpackTouch) {
        if (!((teamplay & 16) && te.team_no > 0 && te.team_no == self.owner.team_no)) {
         expsize = 0;
         expsize = expsize + te.ammo_shells * 0.75;
         expsize = expsize + te.ammo_rockets * 0.75 * 2;
         if (te.playerclass != 9) 
          expsize = expsize + te.ammo_cells * 0.75;
         if (expsize > 0) {
          deathmsg = 30;
          T_RadiusDamage(te, self.owner, expsize, te);
          if (te.touch != BackpackTouch) {
           TF_T_Damage(te, self, self.owner, expsize, 2, 4);
           te.ammo_shells = ceil(te.ammo_shells * 0.25);
           te.ammo_rockets = ceil(te.ammo_rockets * 0.25);
           if (te.playerclass != 9) 
            te.ammo_cells = ceil(te.ammo_cells * 0.25);
           oldself = self;
           self = te;
           W_SetCurrentAmmo();
           self = oldself;
          }
          else {
           te.think = SUB_Remove;
           te.nextthink = time + 0.1;
          }
          WriteByte(4, 23);
          WriteByte(4, 3);
          WriteCoord(4, te.origin_x);
          WriteCoord(4, te.origin_y);
          WriteCoord(4, te.origin_z);
          multicast(te.origin, 1);
         }
        }
       }
      }
     }
    }
   }
  }
  te = te.chain;
 }
 dremove(self);
};

void () TeamFortress_EngineerBuild =
{
 local entity te;

 if (!(self.flags & 512)) {
  CenterPrint(self, "You can't build in the air!\n\n");
  return;
 }
 if (!self.is_building) {
#ifndef TG
  if (self.ammo_cells < 100 && !self.has_dispenser && !self.has_sentry) {
   CenterPrint(self, "You don't have enough metal to \nbuild anything.\n\n");
   return;
  }
#endif
  self.current_menu = 15;
  self.menu_count = 25;
 }
 else {
  if (self.is_building == 1) {
   sprint(self, 2, "You stop building.\n");
   self.tfstate = self.tfstate - (self.tfstate & 65536);
   TeamFortress_SetSpeed(self);
   te = find(world, netname, "build_timer");
   while (te) {
    if (te.owner == self) {
     dremove(te);
     te = world;
    }
    else 
     te = find(te, netname, "build_timer");
   }
   self.is_building = 0;
   self.current_weapon = self.weapon;
   W_SetCurrentAmmo();
  }
 }
};


float (entity obj, entity builder) CheckAreaNew = 
{
 local entity te;
 local string st;

 tracecapsule(obj.origin, obj.origin , 0, obj , #VEC_CB_MIN , #VEC_CB_MAX );
 if(trace_startsolid == 1)
 {
  tracecapsule(obj.origin, obj.origin - '0 0 48', 0, obj, '-16 -16 0','16 16 4' );
  tracecapsule(trace_endpos + '0 0 1', trace_endpos + '0 0 1', 0, obj  , #VEC_CB_MIN , #VEC_CB_MAX);
  if(trace_startsolid == 1)
  {
   return 0;
  }
 }

 te = findradius(obj.origin, 64);
 if (te != world) 
  return 0;

 return 1;
}
float (entity obj, entity builder) CheckArea =
{
 local vector src;
 local vector end;
 local float pos;
 local entity te;
 local string st;

  if(new_build_check)
  {
   pos = CheckAreaNew(obj,builder);
   if(pos == 0) 
     return pos;
  }
//  st = ftos(pos);
//  sprint(builder,2,"new check=",st,"\n");
/*  traceline(builder.origin, obj.origin, 1, builder, '-16 -16 0','16 16 48');

  if (trace_fraction != 1) 
   return 0;*/

 pos = pointcontents(obj.origin);
 if (pos == -2 || pos == -6) 
  return 0;
 src_x = obj.origin_x + obj.maxs_x + 24;
 src_y = obj.origin_y + obj.maxs_y + 24;
 src_z = obj.origin_z + obj.maxs_z + 16;
 pos = pointcontents(src);
 if (pos == -2 || pos == -6) 
  return 0;
 end_x = obj.origin_x + obj.mins_x - 16;
 end_y = obj.origin_y + obj.mins_y - 16;
 end_z = obj.origin_z + obj.mins_z - 16;
 traceline(src, end, 1, obj);
 if (trace_fraction != 1) 
  return 0;
 pos = pointcontents(end);
 if (pos == -2 || pos == -6) 
  return 0;
 src_x = obj.origin_x + obj.mins_x - 16;
 src_y = obj.origin_y + obj.maxs_y + 16;
 src_z = obj.origin_z + obj.maxs_z + 16;
 pos = pointcontents(src);
 if (pos == -2 || pos == -6) 
  return 0;
 end_x = obj.origin_x + obj.maxs_x + 16;
 end_y = obj.origin_y + obj.mins_y - 16;
 end_z = obj.origin_z + obj.mins_z - 16;
 traceline(src, end, 1, obj);

 if (trace_fraction != 1) 
  return 0;
 pos = pointcontents(end);
 if (pos == -2 || pos == -6) 
  return 0;
 traceline(builder.origin, obj.origin, 1, builder);
 if (trace_fraction != 1) 
  return 0;
 te = findradius(obj.origin, 64);
 if (te != world) 
  return 0;
 st = ftos(pos);

 return 1;
};



void (float objtobuild) TeamFortress_Build =
{
 local float btime;
 local entity te;
#ifdef TG
 local entity saveself;
#endif
 local vector tmp1;
 local vector tmp2;

 newmis = spawn();
 makevectors(self.v_angle);
 v_forward_z = 0;
 v_forward = normalize(v_forward) * 64;
 newmis.origin = self.origin + v_forward;
 if (objtobuild == #BUILD_DISPENSER) {
#ifndef TG
  if (self.has_dispenser) {
   sprint(self, 2, "You can only have one dispenser.\nTry dismantling your old one.\n");
   return;
  }
#endif
  tmp1 = '-16 -16 0';
  tmp2 = '16 16 48';
  newmis.mdl = "progs/disp.mdl";
  newmis.netname = "dispenser";
#ifdef TG
  btime = time +0.1;
#else
  btime = time + #BUILD_TIME_DISPENSER;
#endif
 }
 else {
  if (objtobuild == #BUILD_SENTRYGUN) {
#ifndef TG
   if (self.has_sentry) {
    sprint(self, 2, "You can only have one sentry gun.\nTry dismantling your old one.\n");
    return;
   }
#endif
   tmp1 = '-16 -16 0';
   tmp2 = '16 16 48';
   newmis.mdl = "progs/turrbase.mdl";
   newmis.netname = "sentrygun";
#ifdef TG
  btime = time +0.1;
//  btime = time +1;
#else
   btime = time + #BUILD_TIME_SENTRYGUN;
#endif
  }
 }

 if (!CheckArea(newmis, self)) {
  sprint(self, 2, "Not enough room to build here\n");
  dremove(newmis);
  return;
 }
 if (!(self.flags & 512)) {
  CenterPrint(self, "You can't build in the air!\n\n");
  return;
 }
 self.is_building = 1;
// self.immune_to_check = time + 5;
 self.tfstate = self.tfstate | 65536;
 self.weapon = self.current_weapon;
 self.current_weapon = 0;
 self.weaponmodel = "";
 self.weaponframe = 0;
 TeamFortress_SetSpeed(self);
 newmis.owner = self;
 newmis.classname = "timer";
 newmis.netname = "build_timer";
 newmis.nextthink = btime;
 newmis.think = TeamFortress_FinishedBuilding;
 newmis.colormap = self.colormap;
 newmis.weapon = objtobuild;
 newmis.angles_y = anglemod(self.angles_y + 180);
 newmis.velocity = '0 0 8';
 newmis.movetype = 6;
 newmis.solid = 2;
 setmodel(newmis, newmis.mdl);
 setsize(newmis, tmp1, tmp2);
 setorigin(newmis, newmis.origin);


#ifdef TG
/* if (objtobuild == #BUILD_SENTRYGUN)
 {
  saveself=self;
  self=newmis;
  droptofloor();
  self=saveself;
 }*/
#endif
 newmis.flags = newmis.flags - (newmis.flags & 512);
};

void (entity bld) CheckBelowBuilding =
{
 local vector below;

 below = bld.origin;
 if (bld.classname == "detpack")
  below_z = below_z - 8;
 else 
  below_z = below_z - 24;
 traceline(bld.origin , below, 1, bld);
 if (trace_fraction == 1) {
  bld.movetype = 6;
  bld.flags = bld.flags - (bld.flags & 512);
 }
 /*else{
  bld.flags = (bld.flags | 512);
 }*/

};

void () DispenserThink =
{
 CheckBelowBuilding(self);
 if (self.hook_out > 3) {
  self.ammo_shells = self.ammo_shells + rint(400 / 20);
  self.ammo_cells = self.ammo_cells + rint(400 / 20);
  self.ammo_nails = self.ammo_nails + rint(600 / 20);
  self.ammo_rockets = self.ammo_rockets + rint(300 / 20);
  self.armorvalue = self.armorvalue + rint(500 / 20);
  if (self.ammo_shells > #BUILD_DISPENSER_MAX_SHELLS) 
   self.ammo_shells = #BUILD_DISPENSER_MAX_SHELLS;
  if (self.ammo_nails > #BUILD_DISPENSER_MAX_NAILS) 
   self.ammo_nails = #BUILD_DISPENSER_MAX_NAILS;
  if (self.ammo_rockets > #BUILD_DISPENSER_MAX_ROCKETS) 
   self.ammo_rockets = #BUILD_DISPENSER_MAX_ROCKETS;
  if (self.ammo_cells > #BUILD_DISPENSER_MAX_CELLS) 
   self.ammo_cells = #BUILD_DISPENSER_MAX_CELLS;
  if (self.armorvalue > #BUILD_DISPENSER_MAX_ARMOR) 
   self.armorvalue = #BUILD_DISPENSER_MAX_ARMOR;
  self.hook_out = 0;
 }
 self.hook_out = self.hook_out + 1;
 self.nextthink = time + 3;
};

void () TeamFortress_FinishedBuilding =
{
 local entity oldself,saveself;
 local entity te;
 local float current_yaw;
 local vector source;

 if (self.owner.is_building != 1) 
  return;
#ifdef TG
  if (self.weapon == #BUILD_SENTRYGUN) {
   droptofloor();
  }
#endif
 oldself = self;
 self = self.owner;
 oldself.owner = world;
 oldself.real_owner = self;
 self.is_building = 0;
 self.tfstate = self.tfstate - (self.tfstate & 65536);
 self.current_weapon = self.weapon;
 self.StatusRefreshTime = time + 0.1;
 TeamFortress_SetSpeed(self);
 if (oldself.weapon == #BUILD_DISPENSER) {
#ifndef TG
  self.has_dispenser = 1;
#else
  self.has_dispenser = self.has_dispenser + 1;
#endif
  sprint(self, 2, "You finish building the dispenser.\n");
  teamsprint(self.team_no, self, self.netname);
  teamsprint(self.team_no, self, " has built a Dispenser.\n");
#ifndef TG
  self.ammo_cells = self.ammo_cells - 100;
#endif
  oldself.classname = "building_dispenser";
  oldself.netname = "dispenser";
  oldself.blocked = T_Dispenser;
  oldself.touch = T_Dispenser;
  oldself.max_health = #BUILD_HEALTH_DISPENSER;
  oldself.health = #BUILD_HEALTH_DISPENSER;
  oldself.hook_out = 1;
  oldself.think = DispenserThink;
  oldself.nextthink = time + 3;
  oldself.th_die = Dispenser_Die;
  oldself.mdl = "progs/disp.mdl";
  oldself.team_no = self.team_no;
  oldself.real_owner = self;
  oldself.colormap = self.colormap;
  oldself.takedamage = 2;
  oldself.owner = world;
  oldself.movetype = 6;
  oldself.velocity = '0 0 8';
  oldself.flags = oldself.flags - (oldself.flags & 512);
  oldself.ammo_shells = ceil(self.ammo_shells * 0.25);
  oldself.ammo_nails = ceil(self.ammo_nails * 0.25);
  oldself.ammo_rockets = ceil(self.ammo_rockets * 0.25);
  oldself.ammo_cells = ceil(self.ammo_cells * 0.25);
  oldself.armorvalue = ceil(self.armorvalue * 0.25);
  self.ammo_shells = ceil(self.ammo_shells * 0.75);
  self.ammo_nails = ceil(self.ammo_nails * 0.75);
  self.ammo_rockets = ceil(self.ammo_rockets * 0.75);
  self.ammo_cells = ceil(self.ammo_cells * 0.75);
  self.armorvalue = ceil(self.armorvalue * 0.75);
  oldself.solid = 2;
  setmodel(oldself, oldself.mdl);
  setsize(oldself, '-8 -8 0', '8 8 24');
  setorigin(oldself, oldself.origin + '0 0 8');
 }
 else {
  if (oldself.weapon == #BUILD_SENTRYGUN) {
#ifndef TG
   self.has_sentry = 1;
#else
   self.has_sentry =  self.has_sentry + 1;
#endif
#ifdef TG
  saveself=self;
  self=oldself;
  droptofloor();
  self=saveself;
#endif

   sprint(self, 2, "You finish building the sentry gun.\n");
   teamsprint(self.team_no, self, self.netname);
   teamsprint(self.team_no, self, " has built a Sentry Gun.\n");
   oldself.classname = "building_sentrygun_base";
   oldself.netname = "sentry gun";
   oldself.takedamage = 0;
   oldself.th_die = Sentry_Die;
   oldself.team_no = self.team_no;
#ifndef TG
   self.ammo_cells = self.ammo_cells - 130;
#endif
   setsize(oldself, '-16 -16 0', '16 16 4');
   newmis = spawn();
   newmis.classname = "building_sentrygun";
   newmis.health = #BUILD_HEALTH_SENTRYGUN;
   newmis.max_health = newmis.health;
   newmis.weapon = 1;
   newmis.th_die = Sentry_Die;
   newmis.th_pain = Sentry_Pain;
   newmis.mdl = "progs/turrgun.mdl";
   sound(oldself, 3, "weapons/turrset.wav", 1, 1);
   newmis.solid = 2;
   setmodel(newmis, newmis.mdl);
   setsize(newmis, '-16 -16 0', '16 16 48');
   setorigin(newmis, oldself.origin + '0 0 8');
   newmis.view_ofs = '0 0 22';
   newmis.real_owner = oldself.real_owner;
   newmis.trigger_field = oldself;
   oldself.oldenemy = newmis;
   newmis.movetype = 4;
   oldself.colormap = self.colormap;
   newmis.colormap = self.colormap;
   newmis.takedamage = 2;
   newmis.velocity = '0 0 -8';
   newmis.flags = newmis.flags - (newmis.flags & 512);
   oldself.flags = oldself.flags - (oldself.flags & 512);
   newmis.team_no = self.team_no;
   newmis.think = lvl1_sentry_stand;
   newmis.nextthink = time + 0.5;
   newmis.yaw_speed = 10;
   newmis.heat = 0;
   newmis.angles_x = 0;
   newmis.angles_y = rint(oldself.angles_y);
   newmis.angles_z = 0;
   newmis.waitmin = rint(newmis.angles_y - 50);
   newmis.waitmin = anglemod(newmis.waitmin);
   newmis.waitmax = rint(newmis.angles_y + 50);
   newmis.waitmax = anglemod(newmis.waitmax);
   if (newmis.waitmin > newmis.waitmax) {
    newmis.waitmin = newmis.waitmax;
    newmis.waitmax = anglemod(newmis.angles_y - 50);
   }
   newmis.ammo_shells = 25;
   newmis.maxammo_shells = 100;
   newmis.maxammo_rockets = 20;
  }
 }
 W_SetCurrentAmmo();
 self = oldself;
};

void () T_Mortar =
{
 self.touch = T_Mortar;
};

void () T_Dispenser =
{
 local entity dist_checker;

 if (other.classname != "player") 
  return;
 if (other.team_no && other.team_no != self.team_no) 
  centerprint(self.real_owner, "Enemies are using your dispenser!\n");
 if (other.building == world && other.building_wait < time) {
  other.current_menu = 19;
  other.menu_count = 25;
  other.building = self;
  dist_checker = spawn();
  dist_checker.classname = "timer";
  dist_checker.owner = other;
  dist_checker.enemy = self;
  dist_checker.think = CheckDistance;
  dist_checker.nextthink = time + 0.3;
 }
};

void () Dispenser_Explode =
{
 local float sdmg;

 if (self.real_owner.has_disconnected != 1) {
  deathmsg = 39;
  sdmg = 25 + self.ammo_rockets * 1.5 + self.ammo_cells;
  if (sdmg > 250) 
   sdmg = 250;
  T_RadiusDamage(self, self.real_owner, sdmg, self);
 }
 ThrowGib("progs/dgib1.mdl", -30);
 ThrowGib("progs/dgib2.mdl", -50);
 ThrowGib("progs/dgib3.mdl", -50);
 WriteByte(4, 23);
 WriteByte(4, 3);
 WriteCoord(4, self.origin_x);
 WriteCoord(4, self.origin_y);
 WriteCoord(4, self.origin_z);
 multicast(self.origin, 1);
 BecomeExplosion();
};

void () Dispenser_Die =
{
        sprint(self.real_owner, 2, "Your dispenser was destroyed.\n");
#ifndef TG
 self.real_owner.has_dispenser = 0;
#else
 self.real_owner.has_dispenser =  self.real_owner.has_dispenser - 1;
#endif
 self.think = Dispenser_Explode;
 self.nextthink = time + 0.1;
};

void (entity disp) Engineer_UseDispenser =
{
 local entity dist_checker;
 local string st;

 sprint(self, 2, "Dispenser has ");
 st = ftos(disp.health);
 sprint(self, 2, st);
 sprint(self, 2, " health\n");
 st = ftos(disp.ammo_shells);
 sprint(self, 2, st);
 sprint(self, 2, " shells, ");
 st = ftos(disp.ammo_nails);
 sprint(self, 2, st);
 sprint(self, 2, " nails,");
 st = ftos(disp.ammo_rockets);
 sprint(self, 2, st);
 sprint(self, 2, " rockets\n");
 st = ftos(disp.ammo_cells);
 sprint(self, 2, st);
 sprint(self, 2, " cells, and ");
 st = ftos(disp.armorvalue);
 sprint(self, 2, st);
 sprint(self, 2, " armor\n");
 self.current_menu = 16;
 self.menu_count = 25;
 self.building = disp;
 dist_checker = spawn();
 dist_checker.classname = "timer";
 dist_checker.owner = self;
 dist_checker.enemy = disp;
 dist_checker.think = CheckDistance;
 dist_checker.nextthink = time + 0.3;
};

void (entity gun) Engineer_UseSentryGun =
{
 local entity dist_checker;
 local string st;

 sprint(self, 2, "Level ");
 st = ftos(gun.weapon);
 sprint(self, 2, st);
 sprint(self, 2, " Sentry Gun has ");
 st = ftos(gun.health);
 sprint(self, 2, st);
 sprint(self, 2, " health, ");
 st = ftos(gun.ammo_shells);
 sprint(self, 2, st);
 sprint(self, 2, " shells");
 if (gun.weapon == 3) {
  st = ftos(gun.ammo_rockets);
  sprint(self, 2, ", ");
  sprint(self, 2, st);
  sprint(self, 2, " rockets");
 }
#ifdef TG
 if (gun.has_sentry) 
  sprint(self, 2, ", static");
#endif
 sprint(self, 2, "\n");
 self.current_menu = 17;
 self.menu_count = 25;
 self.building = gun;
 dist_checker = spawn();
 dist_checker.classname = "timer";
 dist_checker.owner = self;
 dist_checker.enemy = gun;
 dist_checker.think = CheckDistance;
 dist_checker.nextthink = time + 0.3;
};

void (entity mortar) Engineer_UseMortar =
{
};

void (entity gunhead) CheckSentry =
{
 local vector dist;
 local entity gunbase;

 gunbase = gunhead.trigger_field;
 dist = gunbase.origin - gunhead.origin;
 if (vlen(dist) > 15) {
  bprint(1, self.real_owner.netname);
  bprint(1, "'s sentry gun malfunctioned\n");
  Sentry_Die();
 }
};

void () CheckDistance =
{
 local vector dist;

 if (self.owner.building != self.enemy) {
  dremove(self);
  return;
 }
 dist = self.enemy.origin - self.owner.origin;
 if (vlen(dist) > 64) {
  CenterPrint(self.owner, "\n");
  self.owner.menu_count = 25;
  self.owner.current_menu = 1;
  self.owner.building = world;
  dremove(self);
  return;
 }
 self.nextthink = time + 0.3;
};

void (entity eng, string bld) DestroyBuilding =
{
 local entity te;
 local entity oldself;
 local float pos;

 te = find(world, classname, bld);
 while (te) {
  if (te.real_owner == eng) {
   pos = pointcontents(te.origin);
   if (pos == -2 || pos == -6) {
    oldself = self;
    self = eng;
    self.ammo_cells = self.ammo_cells + 100;
    bound_other_ammo(self);
    W_SetCurrentAmmo();
    self = oldself;
   }
   if (te.real_owner.building == te) {
    if (!te.real_owner.StatusBarSize) 
     CenterPrint(te.real_owner, "\n");
    else 
     te.real_owner.StatusRefreshTime = time + 0.1;
    te.real_owner.menu_count = 25;
    te.real_owner.current_menu = 1;
    te.real_owner.building = world;
   }
#ifdef TG
   te.has_sentry=0;
#endif
   TF_T_Damage(te, world, world, 500, 0, 0);
  }
  te = find(te, classname, bld);
 }
};

void (entity eng) Engineer_RemoveBuildings =
{
 DestroyBuilding(eng, "building_dispenser");
 DestroyBuilding(eng, "building_sentrygun");
};


#ifdef TG
void () Eng_SGUp =
{
 local entity sg;

 sg = find(world, classname, "building_sentrygun");
 while (sg.weapon == 3 && sg.ammo_shells == 144 && sg.ammo_rockets == 20 && sg.health == sg.max_health) {
  if (sg == world) {
   sprint(self, 2, "no sg to upgrade\n");
   return;
  }
  sg = find(sg, classname, "building_sentrygun");
 }
 if (sg == world) {
  sprint(self, 2, "no sg to upgrade\n");
  return;
 }
 sg.weapon = 3;
 sg.max_health = 216;
 sg.maxammo_shells = 144;
 sg.health = sg.max_health;
 sound(sg, 3, "weapons/turrset.wav", 1, 1);
 sg.think = lvl3_sentry_stand;
 sg.skin = 2;
 sprint(self, 2, "You have upgraded/fixed/reloaded sentrygun\n");
 sg.ammo_shells = 144;
 sg.ammo_rockets = 20;
};

void () Eng_DispLoad =
{
 local entity disp;
 local string st;
 local float power;

 disp = find(world, classname, "building_dispenser");
 if (disp == world) {
  sprint(self, 2, "no disp\n");
  return;
 }
 disp.ammo_cells = disp.ammo_cells + 20;
 disp.ammo_rockets = disp.ammo_rockets + 15;
 if (disp.ammo_rockets > 300) 
  disp.ammo_rockets = 300;
 if (disp.ammo_cells > 400) 
  disp.ammo_cells = 400;
 self.hook_out = 0;
 power = rint(25 + disp.ammo_rockets * 1.5 + disp.ammo_cells);
 if (power > 250) 
  power = 250;
 st = ftos(power);
 bprint(2, "maximum detdispenser damage - ");
 bprint(2, st);
 bprint(2, "\n");
};

void () Eng_DispUnload =
{
 local entity disp;
 local string st;
 local float power;

 disp = find(world, classname, "building_dispenser");
 if (disp == world) {
  sprint(self, 2, "no disp\n");
  return;
 }
 disp.ammo_cells = disp.ammo_cells - 20;
 disp.ammo_rockets = disp.ammo_rockets - 15;
 if (disp.ammo_rockets > 300) 
  disp.ammo_rockets = 300;
 if (disp.ammo_cells > 400) 
  disp.ammo_cells = 400;
 self.hook_out = 0;
 power = rint(25 + disp.ammo_rockets * 1.5 + disp.ammo_cells);
 if (power > 250) 
  power = 250;
 st = ftos(power);
 bprint(2, "maximum detdispenser damage - ");
 bprint(2, st);
 bprint(2, "\n");
};

void () Eng_SGReload =
{
 local entity sg;

 sg = find(world, classname, "building_sentrygun");
 while (sg.ammo_shells == sg.maxammo_shells && sg.ammo_rockets == sg.maxammo_rockets && sg.health == sg.max_health) {
  if (sg == world) {
   sprint(self, 2, "no sg to reload\n");
   return;
  }
  sg = find(sg, classname, "building_sentrygun");
 }
 if (sg == world) {
  sprint(self, 2, "no sg to reload\n");
  return;
 }
 sg.health = sg.max_health;
 sg.ammo_shells = sg.maxammo_shells;
 sg.ammo_rockets = sg.maxammo_rockets;
 sound(sg, 3, "weapons/turrset.wav", 1, 1);
 sprint(self, 2, "You have fixed/reloaded ONE sentrygun\n");
};


#endif