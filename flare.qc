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

void () FlareGrenadeTouch =
{
 sound(self, 1, "weapons/bounce.wav", 1, 1);
 if (pointcontents(self.origin) == -6) {
  dremove(self);
  return;
 }
 if (other == world) {
  self.movetype = 0;
  self.velocity = '0 0 0';
 }
 if (self.velocity == '0 0 0') {
  self.avelocity = '0 0 0';
  self.touch = SUB_Null;
 }
};

void () FlareGrenadeThink =
{
 local float rnum;
 local float time_left;

 time_left = self.health - time;
 if (time_left > 33) {
  rnum = random();
  if (rnum < 0.5) 
   self.effects = 8;
  else 
   self.effects = 0;
  self.nextthink = time + 0.05 + random() * 0.1;
 }
 else {
  if (time_left > 31) {
   rnum = random();
   if (rnum < 0.5) 
    self.effects = 4;
   else 
    self.effects = 8;
   self.nextthink = time + 0.05 + random() * 0.1;
  }
  else {
   if (time_left > 15) {
    self.effects = 4;
    self.nextthink = time + 10;
   }
   else {
    if (time_left < 1) 
     RemoveFlare();
    else {
     self.effects = 8;
     self.nextthink = time + time_left;
    }
   }
  }
 }
};

void () FlareGrenadeExplode =
{
 if (self.weapon) {
  increment_team_flares(self.weapon);
  if (num_team_flares(self.weapon) > 9 / number_of_teams) 
   RemoveOldFlare(self.weapon);
 }
 else {
  num_world_flares = num_world_flares + 1;
  if (num_world_flares > 9) 
   RemoveOldFlare(0);
 }
 self.skin = 1;
 self.health = time + 40;
 self.nextthink = time + 0.05 + random() * 0.1;
 self.think = FlareGrenadeThink;
};

void () RemoveFlare =
{
 self.effects = self.effects - (self.effects & 4);
 dremove(self);
 num_world_flares = num_world_flares - 1;
 decrement_team_flares(self.weapon);
};

