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


void () SniperSight_Update;

void () TeamFortress_SniperWeapon =
{
 local float it;

 self.impulse = 0;
 if (self.tfstate & 2) 
  return;
 if (!((self.weapons_carried & 32) && (self.weapons_carried & 64))) 
  return;
 if (self.ammo_shells < 1) {
  sprint(self, 2, "not enough ammo.\n");
  return;
 }
 if (self.current_weapon == 32) 
  self.current_weapon = 64;
 else 
  self.current_weapon = 32;
 W_SetCurrentAmmo();
};

void (float zoom_level) TF_zoom =
{
 local string zl;

 if (self.tfstate & 4096) 
  return;
 zl = ftos(zoom_level);
 stuffcmd(self, "fov ");
 stuffcmd(self, zl);
 stuffcmd(self, "\n");
};

void () SniperSight_Update =
{
 local vector org;

 if (!(self.owner.tfstate & 2048) || self.owner.current_weapon != 32) {
  self.owner.tfstate = self.owner.tfstate - (self.owner.tfstate & 2048);
  TeamFortress_SetSpeed(self.owner);
  self.owner.heat = 0;
  dremove(self);
  return;
 }
 makevectors(self.owner.v_angle);
 org = self.owner.origin + v_forward * 10;
 org_z = self.owner.absmin_z + self.owner.size_z * 0.7;
 traceline(org, org + v_forward * 9192, 0, self);
 if (trace_fraction == 1) {
  setorigin(self, self.owner.origin);
  return;
 }
 self.angles = vectoangles(v_forward);
 setorigin(self, trace_endpos);
 self.nextthink = time + 0.1;
};

void () SniperSight_Create =
{
 local entity sight;

 if (self.has_disconnected == 1) 
  return;
 self.tfstate = self.tfstate | 2048;
 sight = spawn();
 sight.owner = self;
 sight.movetype = 8;
 sight.solid = 0;
 setmodel(sight, "progs/sight.spr");
 sight.classname = "timer";
 setorigin(sight, self.origin);
 sight.think = SniperSight_Update;
 sight.nextthink = time + 0.05;
};

void () TeamFortress_AutoZoomToggle =
{
 if (self.tfstate & 4096) {
  self.tfstate = self.tfstate - 4096;
  sprint(self, 2, "autozoom ON\n");
 }
 else {
  self.tfstate = self.tfstate | 4096;
  sprint(self, 2, "autozoom OFF\n");
 }
};

