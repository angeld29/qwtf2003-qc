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


void () button_return;

void () button_wait =
{
 self.state = 0;
 self.nextthink = self.ltime + self.wait;
 self.think = button_return;
 activator = self.enemy;
 SUB_UseTargets();
 self.frame = 1;
};

void () button_done =
{
 self.state = 1;
};

void () button_return =
{
 self.goal_state = 2;
 self.state = 3;
 SUB_CalcMove(self.pos1, self.speed, button_done);
 self.frame = 0;
 if (self.health) 
  self.takedamage = 1;
};

void () button_blocked =
{
};

void () button_fire =
{
 if (self.state == 2 || !self.state) 
  return;
 sound(self, 2, self.noise, 1, 1);
 self.state = 2;
 SUB_CalcMove(self.pos2, self.speed, button_wait);
};

void () button_use =
{
 self.enemy = activator;
 button_fire();
};

float () button_touch =
{
 local entity te;


 if (cb_prematch_time > time) 
  return;

 if (other.health <= 0) 
  return;

 if (other.classname != "player") 
  return;
 if (self.goal_activation & 8) 
  return;
 if (!other.playerclass) 
  return 0;
 if (!Activated(self, other)) {
  if (self.else_goal) {
   te = Findgoal(self.else_goal);
   if (te) 
    AttemptToActivate(te, other, self);
  }
  return;
 }
 self.enemy = other;
 button_fire();
};

void () button_killed =
{
 if (self.goal_activation & 8) 
  return;
 self.enemy = damage_attacker;
 self.health = self.max_health;
 self.takedamage = 0;
 button_fire();
};

void () func_button =
{
 local float gtemp;
 local float ftemp;

 if (!CheckExistence()) {
  dremove(self);
  return;
 }
 if (!self.sounds) {
  precache_sound("buttons/airbut1.wav");
  self.noise = "buttons/airbut1.wav";
 }
 if (self.sounds == 1) {
  precache_sound("buttons/switch21.wav");
  self.noise = "buttons/switch21.wav";
 }
 if (self.sounds == 2) {
  precache_sound("buttons/switch02.wav");
  self.noise = "buttons/switch02.wav";
 }
 if (self.sounds == 3) {
  precache_sound("buttons/switch04.wav");
  self.noise = "buttons/switch04.wav";
 }
 SetMovedir();
 self.movetype = 7;
 self.solid = 4;
 setmodel(self, self.model);
 self.blocked = button_blocked;
 self.use = button_use;
 if (self.health) {
  self.max_health = self.health;
  self.th_die = button_killed;
  self.takedamage = 1;
 }
 else 
  self.touch = button_touch;
 if (!self.speed) 
  self.speed = 40;
 if (!self.wait) 
  self.wait = 1;
 if (!self.lip) 
  self.lip = 4;
 self.state = 1;
 self.pos1 = self.origin;
 self.pos2 = self.pos1 + self.movedir * (fabs(self.movedir * self.size) - self.lip);
 if (self.spawnflags & 32) 
  button_fire();
};

