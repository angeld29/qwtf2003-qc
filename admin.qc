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

void () Admin_CountPlayers =
{
 local string st;
 local float nump;

 nump = TeamFortress_GetNoPlayers();
 st = ftos(nump);
 sprint3(self, 2, "Players In Game : ", st, "\n");
 if (number_of_teams > 0) {
  nump = TeamFortress_TeamGetNoPlayers(1);
  st = ftos(nump);
  sprint3(self, 2, "Players In Team1: ", st, "\n");
 }
 if (number_of_teams > 1) {
  nump = TeamFortress_TeamGetNoPlayers(2);
  st = ftos(nump);
  sprint3(self, 2, "Players In Team2: ", st, "\n");
 }
 if (number_of_teams > 2) {
  nump = TeamFortress_TeamGetNoPlayers(3);
  st = ftos(nump);
  sprint3(self, 2, "Players In Team3: ", st, "\n");
 }
 if (number_of_teams > 3) {
  nump = TeamFortress_TeamGetNoPlayers(4);
  st = ftos(nump);
  sprint3(self, 2, "Players In Team4: ", st, "\n");
 }
};

void () Admin_CycleKick =
{
 if (TeamFortress_GetNoPlayers() <= 1) {
  sprint(self, 2, "No other players in the game.\n");
  self.admin_use = world;
  self.admin_mode = 0;
  return;
 }
 self.admin_use = find(self.admin_use, classname, "player");
 while (self.admin_use != world && (self.admin_use.netname == string_null || self.admin_use == self)) 
  self.admin_use = find(self.admin_use, classname, "player");
 if (self.admin_use) {
  self.admin_mode = 1;
  sprint3(self, 2, "Kick ", self.admin_use.netname, "?\n");
 }
 else {
  self.admin_mode = 0;
  sprint(self, 2, "End of player list\n");
 }
};

void () Admin_DoKick =
{
 bprint4(2, self.admin_use.netname, " was kicked by ", self.netname, "\n");
 KickCheater(self.admin_use);
 self.admin_mode = 0;
 self.admin_use = world;
};

void () CeaseFire_think =
{
 local entity te;

 if (time > cb_ceasefire_time && self.weapon == 1 && cease_fire == 1) {
  cease_fire = 0;
  bprint(2, "RESUME FIRE\n");
  te = find(world, classname, "player");
  while (te) {
   centerprint(te, "RESUME FIRE\n");
//   te.immune_to_check = time + 10;
   te.tfstate = te.tfstate - (te.tfstate & 65536);
   TeamFortress_SetSpeed(te);
   te = find(te, classname, "player");
  }
  dremove(self);
  return;
 }
 if (!cease_fire) {
  dremove(self);
  return;
 }
 te = find(world, classname, "player");
 while (te) {
  centerprint(te, "CEASE FIRE\n");
  te = find(te, classname, "player");
 }
 self.nextthink = time + 5;
};

void () Admin_CeaseFire =
{
 local entity te;

 if (!cease_fire) {
  cease_fire = 1;
  bprint(2, "CEASE FIRE\n");
  te = find(world, classname, "player");
  while (te) {
   centerprint(te, "CEASE FIRE\n");
//   te.immune_to_check = time + 10;
   te.tfstate = te.tfstate | 65536;
   TeamFortress_SetSpeed(te);
   te = find(te, classname, "player");
  }
  te = spawn();
  te.classname = "ceasefire";
  te.think = CeaseFire_think;
  te.nextthink = time + 5;
 }
 else {
  te = find(world, classname, "ceasefire");
  if (te) 
   dremove(te);
  cease_fire = 0;
  bprint(2, "RESUME FIRE\n");
  te = find(world, classname, "player");
  while (te) {
   centerprint(te, "RESUME FIRE\n");
//   te.immune_to_check = time + 10;
   te.tfstate = te.tfstate - (te.tfstate & 65536);
   TeamFortress_SetSpeed(te);
   te = find(te, classname, "player");
  }
 }
};

void (entity p) CheckAutoKick =
{
 local float rnum;
 local entity te;

 if (p.teamkills >= autokick_kills && autokick_kills) {
  bprint2(2, p.netname, " was kicked for killing teammates.\n");
  sprint(p, 2, "You were kicked for killing teammates.\n");
  KickCheater(p);
 }
 else {
  if (autokick_kills) {
   if (p.teamkills == autokick_kills - 1) 
    sprint(p, 2, "Kill one more teammate, and you're outta here.\n");
   rnum = 0;
   te = find(world, classname, "ak_timer");
   while (te) {
    if (te.owner == p) {
     rnum = 1;
     te = world;
    }
    else 
     te = find(te, classname, "ak_timer");
   }
   if (!rnum) {
    te = spawn();
    te.classname = "ak_timer";
    te.owner = p;
    te.think = autokick_think;
    te.nextthink = time + autokick_time;
   }
  }
 }
};

