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

float (entity targ) visible =
{
 local vector spot1;
 local vector spot2;
 local string st;

 spot1 = self.origin + self.view_ofs;
 spot2 = targ.origin + targ.view_ofs;
 traceline(spot1, spot2, 1, self);
 st = infokey(world,"watervis");
 if(stof(st) == 0)
 {
  if (trace_inopen && trace_inwater) 
   return 0;
 }
 if (trace_fraction == 1) 
  return 1;
 return 0;
};

void() monster_ogre = {remove(self);};
void() monster_demon1 = {remove(self);};
void() monster_shambler = {remove(self);};
void() monster_knight = {remove(self);};
void() monster_army = {remove(self);};
void() monster_wizard = {remove(self);};
void() monster_dog = {remove(self);};
void() monster_zombie = {remove(self);};
void() monster_boss = {remove(self);};
void() monster_tarbaby = {remove(self);};
void() monster_hell_knight = {remove(self);};
void() monster_fish = {remove(self);};
void() monster_shalrath = {remove(self);};
void() monster_enforcer = {remove(self);};
void() monster_oldone = {remove(self);};
void() monster_vomit = {remove(self);};
void() monster_dragon = {remove(self);};

void () t_movetarget;

void () movetarget_f =
{
 if (!self.targetname) 
  objerror("monster_movetarget: no targetname");
 self.solid = 1;
 self.touch = t_movetarget;
 setsize(self, '-8 -8 -8', '8 8 8');
};

void () path_corner =
{
 if (!CheckExistence()) {
  dremove(self);
  return;
 }
 movetarget_f();
};

void () t_movetarget =
{
 local entity temp;

 if (other.movetarget != self) 
  return;
 if (other.enemy) 
  return;
 temp = self;
 self = other;
 other = temp;
 self.movetarget = find(world, targetname, other.target);
 self.goalentity = find(world, targetname, other.target);
 self.ideal_yaw = vectoyaw(self.goalentity.origin - self.origin);
 if (!self.movetarget) {
  self.pausetime = time + 999999;
  self.th_stand();
  return;
 }
};

float (float v) anglemod =
{
 while (v >= 360) 
  v = v - 360;
 while (v < 0) 
  v = v + 360;
 return v;
};

float (entity targ) range =
{
 local vector spot1;
 local vector spot2;
 local float r;

 spot1 = self.origin + self.view_ofs;
 spot2 = targ.origin + targ.view_ofs;
 r = vlen(spot1 - spot2);
 if (r < 120) 
  return 0;
 if (r < 500) 
  return 1;
 if (r < 1000) 
  return 2;
 return 3;
};

float (entity targ) infront =
{
 local vector vec;
 local float dot;

 makevectors(self.angles);
 vec = normalize(targ.origin - self.origin);
 dot = vec * v_forward;
 if (dot > 0.3) 
  return 1;
 return 0;
};

void () HuntTarget =
{
 self.goalentity = self.enemy;
 self.think = self.th_run;
 self.ideal_yaw = vectoyaw(self.enemy.origin - self.origin);
 self.nextthink = time + 0.1;
 SUB_AttackFinished(1);
};

float () FindTarget =
{
 local entity client;

 client = checkclient();
 if (!client) 
  return 0;
 if (client.flags & 128) 
  return 0;
 if (client.items & 524288) 
  return 0;
 if (!visible(client)) 
  return 0;
 if (client.classname != "player") 
  return;
 self.enemy = client;
 HuntTarget();
 return 1;
};

