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


void () bubble_bob;
void () Throw_Grapple;
void () T_Dispenser;
void () Headless_Think;

void () player_touch =
{
 local entity Bio;
 local entity te;
 local float v1;
 local float v2;
 local float found;

 if (!invis_only && (self.playerclass == 8 || other.playerclass == 8)) {
  if (other.classname == "player") {
   if (self.undercover_team || self.undercover_skin) {
    if ((other.playerclass == 8 || other.playerclass == 1) && other.team_no != self.team_no) {
     TF_AddFrags(other, 1);
     bprint(1, other.netname);
     bprint(1, " uncovered an enemy spy!\n");
     Spy_RemoveDisguise(self);
    }
   }
   if (other.undercover_team || other.undercover_skin) {
    if ((self.playerclass == 8 || self.playerclass == 1) && self.team_no != other.team_no) {
     TF_AddFrags(self, 1);
     bprint(1, self.netname);
     bprint(1, " uncovered an enemy spy!\n");
     Spy_RemoveDisguise(other);
    }
   }
  }
 }
 if ((self.tfstate & 16) && cb_prematch_time < time) {
  if (other.classname == "player" && te.playerclass) {
   if (!(other.tfstate & 16)) {
    if (other.playerclass != 5) {
     if (!((teamplay & 16) && self.owner.team_no == self.enemy.team_no && self.owner.team_no)) {
      found = 0;
      te = find(world, classname, "timer");
      while (te != world && !found) {
       if (te.owner == self && te.think == BioInfection_Decay) 
        found = 1;
       else 
        te = find(te, classname, "timer");
      }
      Bio = spawn();
      Bio.nextthink = 2;
      Bio.think = BioInfection_Decay;
      Bio.owner = other;
      Bio.classname = "timer";
      Bio.enemy = te.enemy;
      other.tfstate = other.tfstate | 16;
      other.infection_team_no = self.infection_team_no;
      sprint(other, 1, "You have been infected by ");
      sprint(other, 1, self.netname);
      sprint(other, 1, "!\n");
      sprint(self, 1, "You have infected ");
      sprint(self, 1, other.netname);
      sprint(self, 1, "!\n");
     }
    }
   }
  }
 }
};

void () player_stand1 = [17, player_stand1]
{
 self.weaponframe = 0;
 if (self.velocity_x || self.velocity_y) {
  self.walkframe = 0;
  player_run();
  return;
 }
 if (self.current_weapon <= 16) {
  if (self.walkframe >= 12) 
   self.walkframe = 0;
  self.frame = 17 + self.walkframe;
 }
 else {
  if (self.walkframe >= 5) 
   self.walkframe = 0;
  self.frame = 12 + self.walkframe;
 }
 self.walkframe = self.walkframe + 1;
};

void () player_run = [6, player_run]
{
 self.weaponframe = 0;
 if (!self.velocity_x && !self.velocity_y) {
  self.walkframe = 0;
  player_stand1();
  return;
 }
 if (self.current_weapon <= 16) {
  if (self.walkframe >= 6) 
   self.walkframe = 0;
  self.frame = 0 + self.walkframe;
 }
 else {
  if (self.walkframe >= 6) 
   self.walkframe = 0;
  self.frame = self.frame + self.walkframe;
 }
 self.walkframe = self.walkframe + 1;
};

void () player_shot1 = [113, player_shot2]
{
 self.weaponframe = 1;
 muzzleflash();
};

void () player_shot2 = [114, player_shot3]
{
 self.weaponframe = 2;
};

void () player_shot3 = [115, player_shot4]
{
 self.weaponframe = 3;
};

void () player_shot4 = [116, player_shot5]
{
 self.weaponframe = 4;
};

void () player_shot5 = [117, player_shot6]
{
 self.weaponframe = 5;
};

void () player_shot6 = [118, player_run]
{
 self.weaponframe = 6;
};

void () player_autorifle1 = [113, player_autorifle2]
{
 self.weaponframe = 1;
 muzzleflash();
};

void () player_autorifle2 = [114, player_autorifle3]
{
 self.weaponframe = 2;
};

void () player_autorifle3 = [118, player_run]
{
 self.weaponframe = 6;
};

void () player_axe1 = [119, player_axe2]
{
 self.weaponframe = 1;
};

void () player_axe2 = [120, player_axe3]
{
 self.weaponframe = 2;
};

void () player_axe3 = [121, player_axe4]
{
 self.weaponframe = 3;
 if (self.current_weapon == 16) 
  W_FireAxe();
 else 
  W_FireSpanner();
};

void () player_axe4 = [122, player_run]
{
 self.weaponframe = 4;
};

void () player_axeb1 = [125, player_axeb2]
{
 self.weaponframe = 5;
};

void () player_axeb2 = [126, player_axeb3]
{
 self.weaponframe = 6;
};

void () player_axeb3 = [127, player_axeb4]
{
 self.weaponframe = 7;
 if (self.current_weapon == 16) 
  W_FireAxe();
 else 
  W_FireSpanner();
};

void () player_axeb4 = [128, player_run]
{
 self.weaponframe = 8;
};

void () player_axec1 = [131, player_axec2]
{
 self.weaponframe = 1;
};

void () player_axec2 = [132, player_axec3]
{
 self.weaponframe = 2;
};

void () player_axec3 = [133, player_axec4]
{
 self.weaponframe = 3;
 if (self.current_weapon == 16) 
  W_FireAxe();
 else 
  W_FireSpanner();
};

void () player_axec4 = [134, player_run]
{
 self.weaponframe = 4;
};

void () player_axed1 = [137, player_axed2]
{
 self.weaponframe = 5;
};

void () player_axed2 = [138, player_axed3]
{
 self.weaponframe = 6;
};

void () player_axed3 = [139, player_axed4]
{
 self.weaponframe = 7;
 if (self.current_weapon == 16) 
  W_FireAxe();
 else 
  W_FireSpanner();
};

void () player_axed4 = [140, player_run]
{
 self.weaponframe = 8;
};

void () player_chain1 = [137, player_chain1a]
{
 self.weaponframe = 1;
 Throw_Grapple();
};

void () player_chain1a = [137, player_chain2]
{
 self.weaponframe = 2;
};

void () player_chain2 = [138, player_chain2a]
{
 self.weaponframe = 3;
};

void () player_chain2a = [138, player_chain3]
{
 self.weaponframe = 4;
};

void () player_chain3 = [139, player_chain3]
{
 self.weaponframe = 6;
 if (!self.hook_out) {
  player_chain5();
  return;
 }
 if (vlen(self.velocity) >= 750) {
  player_chain4();
  return;
 }
};

void () player_chain4 = [73, player_chain4]
{
 self.weaponframe = 6;
 if (!self.hook_out) {
  player_chain5();
  return;
 }
 if (vlen(self.velocity) < 750) {
  player_chain3();
  return;
 }
};

void () player_chain5 = [140, player_run]
{
 self.weaponframe = 0;
};

void () player_medikit1 = [119, player_medikit2]
{
 self.weaponframe = 1;
};

void () player_medikit2 = [120, player_medikit3]
{
 self.weaponframe = 2;
};

void () player_medikit3 = [121, player_medikit4]
{
 self.weaponframe = 3;
 W_FireMedikit();
};

void () player_medikit4 = [122, player_run]
{
 self.weaponframe = 4;
};

void () player_medikitb1 = [125, player_medikitb2]
{
 self.weaponframe = 5;
};

void () player_medikitb2 = [126, player_medikitb3]
{
 self.weaponframe = 6;
};

void () player_medikitb3 = [127, player_medikitb4]
{
 self.weaponframe = 7;
 W_FireMedikit();
};

void () player_medikitb4 = [128, player_run]
{
 self.weaponframe = 8;
};

void () player_medikitc1 = [131, player_medikitc2]
{
 self.weaponframe = 1;
};

void () player_medikitc2 = [132, player_medikitc3]
{
 self.weaponframe = 2;
};

void () player_medikitc3 = [133, player_medikitc4]
{
 self.weaponframe = 3;
 W_FireMedikit();
};

void () player_medikitc4 = [134, player_run]
{
 self.weaponframe = 4;
};

void () player_medikitd1 = [137, player_medikitd2]
{
 self.weaponframe = 5;
};

void () player_medikitd2 = [138, player_medikitd3]
{
 self.weaponframe = 6;
};

void () player_medikitd3 = [139, player_medikitd4]
{
 self.weaponframe = 7;
 W_FireMedikit();
};

void () player_medikitd4 = [140, player_run]
{
 self.weaponframe = 8;
};

void () player_bioweapon1 = [119, player_bioweapon2]
{
 self.weaponframe = 1;
};

void () player_bioweapon2 = [120, player_bioweapon3]
{
 self.weaponframe = 2;
};

void () player_bioweapon3 = [121, player_bioweapon4]
{
 self.weaponframe = 3;
 W_FireBioweapon();
};

void () player_bioweapon4 = [122, player_run]
{
 self.weaponframe = 4;
};

void () player_bioweaponb1 = [125, player_bioweaponb2]
{
 self.weaponframe = 5;
};

void () player_bioweaponb2 = [126, player_bioweaponb3]
{
 self.weaponframe = 6;
};

void () player_bioweaponb3 = [127, player_bioweaponb4]
{
 self.weaponframe = 7;
 W_FireBioweapon();
};

void () player_bioweaponb4 = [128, player_run]
{
 self.weaponframe = 8;
};

void () player_bioweaponc1 = [131, player_bioweaponc2]
{
 self.weaponframe = 1;
};

void () player_bioweaponc2 = [132, player_bioweaponc3]
{
 self.weaponframe = 2;
};

void () player_bioweaponc3 = [133, player_bioweaponc4]
{
 self.weaponframe = 3;
 W_FireBioweapon();
};

void () player_bioweaponc4 = [134, player_run]
{
 self.weaponframe = 4;
};

void () player_bioweapond1 = [137, player_bioweapond2]
{
 self.weaponframe = 5;
};

void () player_bioweapond2 = [138, player_bioweapond3]
{
 self.weaponframe = 6;
};

void () player_bioweapond3 = [139, player_bioweapond4]
{
 self.weaponframe = 7;
 W_FireBioweapon();
};

void () player_bioweapond4 = [140, player_run]
{
 self.weaponframe = 8;
};

void () player_nail1 = [103, player_nail2]
{
 muzzleflash();
 if (!self.button0 || intermission_running) {
  player_run();
  return;
 }
 self.weaponframe = self.weaponframe + 1;
 if (self.weaponframe == 9) 
  self.weaponframe = 1;
 SuperDamageSound();
 if (!self.nailpos) {
  W_FireSpikes(4);
  self.nailpos = 1;
 }
 else {
  W_FireSpikes(-4);
  self.nailpos = 0;
 }
 Attack_Finished(0.2);
};

void () player_nail2 = [104, player_nail1]
{
 if (!self.button0 || intermission_running) {
  player_run();
  return;
 }
 self.weaponframe = self.weaponframe + 1;
 if (self.weaponframe == 9) 
  self.weaponframe = 1;
 Attack_Finished(0.2);
};

void () player_assaultcannonup1 = [103, player_assaultcannonup2]
{

 if (!self.button0 || self.ammo_shells <= self.assault_min_shells || intermission_running) {
  self.tfstate = self.tfstate - (self.tfstate & 2048);
  TeamFortress_SetSpeed(self);
  self.count = 1;
  self.heat = 0;
  player_assaultcannondown1();
  return;
 }
 self.fire_held_down = 1;
 if (self.heat == 1) 
  sound(self, 1, "weapons/asscan1.wav", 1, 1);
 SuperDamageSound();
 Attack_Finished(0.1);
 if (self.heat != 2 && self.heat != 4) {
  if (self.weaponframe >= 3) 
   self.weaponframe = 0;
  else 
   self.weaponframe = self.weaponframe + 1;
 }
 self.heat = self.heat + 1;
 if (self.heat >= 7) {
  self.heat = 0;
  self.ScanRange=0;
  player_assaultcannon1();
 }
};

void () player_assaultcannonup2 = [103, player_assaultcannonup1]
{
 if (!self.button0 || self.ammo_shells <= self.assault_min_shells || intermission_running) {
  self.tfstate = self.tfstate - (self.tfstate & 2048);
  TeamFortress_SetSpeed(self);
  self.count = 1;
  self.heat = 0;
  player_assaultcannondown1();
  return;
 }
 SuperDamageSound();
 Attack_Finished(0.1);
 if (self.heat != 2 && self.heat != 4 && self.heat != 7) {
  if (self.weaponframe == 2 && self.heat >= 9) 
   self.weaponframe = 0;
  else {
   if (self.weaponframe >= 3) 
    self.weaponframe = 0;
   else 
    self.weaponframe = self.weaponframe + 1;
  }
 }
 self.heat = self.heat + 1;
 if (self.heat >= 13) {
  self.heat = 0;
  self.ScanRange=0;
  player_assaultcannon1();
 }
};

void () player_assaultcannon1 = [103, player_assaultcannon2]
{
 /* ERROR: Fields and functions must be global: player_assaultcannon2 */
 local string st;
 local vector v;
 v=self.velocity;
 v_z=0;
// if (vlen(self.velocity) < 50 && (self.flags & #FL_ONGROUND)) {
 if (vlen(v) < 20 && (self.flags & #FL_ONGROUND)) {
  muzzleflash();
  sound(self, 1, "weapons/asscan2.wav", 1, 1);
  if (self.weaponframe == 2) 
   self.weaponframe = 4;
  else 
   self.weaponframe = 2;
  SuperDamageSound();
  W_FireAssaultCannon();
#ifndef NEWHWGUY
  stuffcmd(self, "v_idlescale ");
  if (self.heat < 5) 
   st = ftos(self.heat * 4);
  else 
   st = "20";
  stuffcmd(self, st);
  stuffcmd(self, "\n");
#else 
//  stuffcmd(self, "v_idlescale 0\n");
#endif
 }
 else {
  sound(self, 1, "weapons/asscan4.wav", 1, 1);
  if (self.weaponframe == 2) 
   self.weaponframe = 0;
  else 
   self.weaponframe = 2;
#ifndef NEWHWGUY
  stuffcmd(self, "v_idlescale 5\n");
#else 
//  stuffcmd(self, "v_idlescale 0\n");
#endif
 }
 if (!self.button0 || self.ammo_shells <= self.assault_min_shells || intermission_running) {
#ifndef  NEWHWGUY
  stuffcmd(self, "v_idlescale 0\n");
#else 
//  stuffcmd(self, "v_idlescale 0\n");
#endif
  self.tfstate = self.tfstate - (self.tfstate & 2048);
  TeamFortress_SetSpeed(self);
  self.weaponframe = 0;
  self.count = 1;
  player_assaultcannondown1();
  return;
 }
 Attack_Finished(0.1);
};

void () player_assaultcannon2 = [104, player_assaultcannon1]
{
 local string st;
 local vector v;
 v=self.velocity;
 v_z=0;
#ifndef NEWHWGUY
 stuffcmd(self, "v_idlescale 0\n");
#else 
//  stuffcmd(self, "v_idlescale 0\n");
#endif
// if (vlen(self.velocity) < 50 && (self.flags & #FL_ONGROUND)) {
 if (vlen(v) < 20 && (self.flags & #FL_ONGROUND)) {
  if (self.weaponframe == 2) 
   self.weaponframe = 4;
  else 
   self.weaponframe = 2;
  SuperDamageSound();
  W_FireAssaultCannon();
  self.heat = self.heat + 0.1;
  stuffcmd(self, "bf\n");
 }
 else {
  if (self.weaponframe == 2) 
   self.weaponframe = 0;
  else 
   self.weaponframe = 2;
 }
 if (!self.button0 || self.ammo_shells <= self.assault_min_shells || intermission_running) {
#ifndef NEWHWGUY
  stuffcmd(self, "v_idlescale 0\n");
#endif
  self.tfstate = self.tfstate - (self.tfstate & 2048);
  TeamFortress_SetSpeed(self);
  self.weaponframe = 0;
  self.count = 1;
  player_assaultcannondown1();
  return;
 }
 Attack_Finished(0.1);
};

void () player_assaultcannondown1 = [103, player_assaultcannondown1]
{
 local entity tcool;

 if (self.count == 1) 
  sound(self, 1, "weapons/asscan3.wav", 1, 1);
 if (self.count >= 15) {
  self.heat = 0;
  self.fire_held_down = 0;
  self.tfstate = self.tfstate - (self.tfstate & 2048);
  TeamFortress_SetSpeed(self);
  if (self.ammo_shells <= self.assault_min_shells || self.ammo_cells < 4) {
   self.last_weapon = self.current_weapon;
   self.last_weaponmode = self.weaponmode;
   self.current_weapon = W_BestWeapon();
   W_SetCurrentAmmo();
   W_PrintWeaponMessage();
   return;
  }
  player_run();
  return;
 }
 if (self.count != 8 && self.count != 10 && self.count != 12 && self.count != 14) {
  if (self.weaponframe == 3) 
   self.weaponframe = 0;
  else 
   self.weaponframe = self.weaponframe + 1;
 }
 self.count = self.count + 1;
 Attack_Finished(0.1);
};

void () player_light1 = [105, player_light2]
{
 muzzleflash();
 if (!self.button0 || intermission_running) {
  player_run();
  return;
 }
 self.weaponframe = self.weaponframe + 1;
 if (self.weaponframe == 5) 
  self.weaponframe = 1;
 SuperDamageSound();
 W_FireLightning();
 Attack_Finished(0.2);
};

void () player_light2 = [106, player_light1]
{
 if (!self.button0 || intermission_running) {
  player_run();
  return;
 }
 self.weaponframe = self.weaponframe + 1;
 if (self.weaponframe == 5) 
  self.weaponframe = 1;
 SuperDamageSound();
 W_FireLightning();
 Attack_Finished(0.2);
};

void () player_rocket1 = [107, player_rocket2]
{
 self.weaponframe = 1;
 muzzleflash();
};

void () player_rocket2 = [108, player_rocket3]
{
 self.weaponframe = 2;
};

void () player_rocket3 = [109, player_rocket4]
{
 self.weaponframe = 3;
};

void () player_rocket4 = [110, player_rocket5]
{
 self.weaponframe = 4;
};

void () player_rocket5 = [111, player_rocket6]
{
 self.weaponframe = 5;
};

void () player_rocket6 = [112, player_run]
{
 self.weaponframe = 6;
};


void (float num_bubbles) DeathBubbles;

void () PainSound =
{
 local float rs;

 if (self.health < 0) 
  return;
 if (damage_attacker.classname == "teledeath") {
  sound(self, 2, "player/teledth1.wav", 1, 0);
  return;
 }
 if (self.watertype == -3 && self.waterlevel == 3) {
  DeathBubbles(1);
  if (random() > 0.5) 
   sound(self, 2, "player/drown1.wav", 1, 1);
  else 
   sound(self, 2, "player/drown2.wav", 1, 1);
  return;
 }
 if (self.watertype == -4) {
  if (random() > 0.5) 
   sound(self, 2, "player/lburn1.wav", 1, 1);
  else 
   sound(self, 2, "player/lburn2.wav", 1, 1);
  return;
 }
 if (self.watertype == -5) {
  if (random() > 0.5) 
   sound(self, 2, "player/lburn1.wav", 1, 1);
  else 
   sound(self, 2, "player/lburn2.wav", 1, 1);
  return;
 }
 if (self.pain_finished > time) {
  self.axhitme = 0;
  return;
 }
 self.pain_finished = time + 0.5;
 if (self.axhitme == 1) {
  self.axhitme = 0;
  sound(self, 2, "player/axhit1.wav", 1, 1);
  return;
 }
 rs = rint(random() * 5 + 1);
 self.noise = "";
 if (rs == 1) 
  self.noise = "player/pain1.wav";
 else {
  if (rs == 2) 
   self.noise = "player/pain2.wav";
  else {
   if (rs == 3) 
    self.noise = "player/pain3.wav";
   else {
    if (rs == 4) 
     self.noise = "player/pain4.wav";
    else {
     if (rs == 5) 
      self.noise = "player/pain5.wav";
     else 
      self.noise = "player/pain6.wav";
    }
   }
  }
 }
 sound(self, 2, self.noise, 1, 1);
 return;
};

void () player_pain1 = [35, player_pain2]
{
 PainSound();
 self.weaponframe = 0;
};

void () player_pain2 = [36, player_pain3]
{
};

void () player_pain3 = [37, player_pain4]
{
};

void () player_pain4 = [38, player_pain5]
{
};

void () player_pain5 = [39, player_pain6]
{
};

void () player_pain6 = [40, player_run]
{
};

void () player_axpain1 = [29, player_axpain2]
{
 PainSound();
 self.weaponframe = 0;
};

void () player_axpain2 = [30, player_axpain3]
{
};

void () player_axpain3 = [31, player_axpain4]
{
};

void () player_axpain4 = [32, player_axpain5]
{
};

void () player_axpain5 = [33, player_axpain6]
{
};

void () player_axpain6 = [34, player_run]
{
};

void () player_pain =
{
 if (self.weaponframe) {
  if (deathmsg == 37) 
   PainSound();
  return;
 }
 if (self.invisible_finished > time) 
  return;
 if (self.is_feigning) {
  PainSound();
  return;
 }
 if (self.button0 && self.current_weapon == 32768) 
  return;
 if (self.current_weapon <= 16) 
  player_axpain1();
 else 
  player_pain1();
};


void () player_diea1;
void () player_dieb1;
void () player_diec1;
void () player_died1;
void () player_diee1;
void () player_die_ax1;

void () DeathBubblesSpawn =
{
 if (self.owner.waterlevel != 3) 
  return;
 newmis = spawn();
 setmodel(newmis, "progs/s_bubble.spr");
 setorigin(newmis, self.owner.origin + '0 0 24');
 newmis.movetype = 8;
 newmis.solid = 0;
 newmis.velocity = '0 0 15';
 newmis.nextthink = time + 0.5;
 newmis.think = bubble_bob;
 newmis.classname = "bubble";
 newmis.frame = 0;
 newmis.cnt = 0;
 setsize(newmis, '-8 -8 -8', '8 8 8');
 self.nextthink = time + 0.1;
 self.think = DeathBubblesSpawn;
 self.air_finished = self.air_finished + 1;
 if (self.air_finished >= self.bubble_count) 
  dremove(self);
};

void (float num_bubbles) DeathBubbles =
{
 local entity bubble_spawner;

 bubble_spawner = spawn();
 setorigin(bubble_spawner, self.origin);
 bubble_spawner.movetype = 0;
 bubble_spawner.solid = 0;
 bubble_spawner.nextthink = time + 0.1;
 bubble_spawner.think = DeathBubblesSpawn;
 bubble_spawner.air_finished = 0;
 bubble_spawner.owner = self;
 bubble_spawner.bubble_count = num_bubbles;
 return;
};

void () DeathSound =
{
 local float rs;

 if (self.waterlevel == 3) {
  if (self.is_feigning) 
   DeathBubbles(2);
  else 
   DeathBubbles(10);
  sound(self, 2, "player/h2odeath.wav", 1, 0);
  return;
 }
 rs = rint(random() * 4 + 1);
 if (rs == 1) 
  self.noise = "player/death1.wav";
 if (rs == 2) 
  self.noise = "player/death2.wav";
 if (rs == 3) 
  self.noise = "player/death3.wav";
 if (rs == 4) 
  self.noise = "player/death4.wav";
 if (rs == 5) 
  self.noise = "player/death5.wav";
 sound(self, 2, self.noise, 1, 0);
 return;
};

void () PlayerDead =
{
 self.nextthink = -1;
 self.deadflag = 2;
};

vector (float dm) VelocityForDamage =
{
 local vector v;

 v_x = 100 * crandom();
 v_y = 100 * crandom();
 v_z = 200 + 100 * random();
 if (dm > -50) 
  v = v * 0.7;
 else {
  if (dm > -200) 
   v = v * 2;
  else 
   v = v * 10;
 }
 return v;
};

void (string gibname, float dm) ThrowGib =
{
 newmis = spawn();
 newmis.origin = self.origin;
 if (birthday == 1 && random() < 0.3) {
  setmodel(newmis, "progs/grenade3.mdl");
  newmis.skin = random() * 4;
  newmis.skin = floor(newmis.skin);
 }
 else 
  setmodel(newmis, gibname);
 setsize(newmis, '0 0 0', '0 0 0');
 newmis.velocity = VelocityForDamage(dm);
 newmis.movetype = 10;
 newmis.solid = 0;
 newmis.avelocity_x = random() * 600;
 newmis.avelocity_y = random() * 600;
 newmis.avelocity_z = random() * 600;
 newmis.think = SUB_Remove;
 newmis.ltime = time;
 newmis.nextthink = time + 10 + random() * 10;
 newmis.frame = 0;
 newmis.flags = 0;
};

void (string gibname, float dm) ThrowHead =
{
 setmodel(self, gibname);
 self.skin = 0;
 self.frame = 0;
 self.nextthink = -1;
 self.movetype = 10;
 self.takedamage = 0;
 self.solid = 0;
 self.view_ofs = '0 0 8';
 setsize(self, '-16 -16 0', '16 16 56');
 self.velocity = VelocityForDamage(dm);
 self.origin_z = self.origin_z - 24;
 self.flags = self.flags - (self.flags & 512);
 self.avelocity = crandom() * '0 600 0';
};

void (string gibname) HeadShotThrowHead =
{
 setmodel(self, gibname);
 self.frame = 0;
 self.nextthink = -1;
 self.movetype = 10;
 self.takedamage = 0;
 self.solid = 0;
 self.view_ofs = '0 0 8';
 setsize(self, '-16 -16 0', '16 16 56');
 self.velocity = normalize(self.head_shot_vector) * 600;
 self.origin_z = self.origin_z + 24;
 self.flags = self.flags - (self.flags & 512);
 self.avelocity = '0 0 0';
};

void () KillPlayer =
{
 self.owner.deadflag = 2;
 dremove(self);
};

void () GibPlayer =
{
 ThrowHead("progs/h_player.mdl", self.health);
 ThrowGib("progs/gib1.mdl", self.health);
 ThrowGib("progs/gib2.mdl", self.health);
 ThrowGib("progs/gib3.mdl", self.health);
 if (deathmsg == 36) {
  newmis = spawn();
  newmis.owner = self;
  newmis.think = KillPlayer;
  newmis.nextthink = time + 1;
 }
 else 
  self.deadflag = 2;
 TeamFortress_SetupRespawn(0);
 if (damage_attacker.classname == "teledeath") {
  sound(self, 2, "player/teledth1.wav", 1, 0);
  self.respawn_time = self.respawn_time + 2 + random() * 2;
  return;
 }
 if (damage_attacker.classname == "teledeath2") {
  sound(self, 2, "player/teledth1.wav", 1, 0);
  self.respawn_time = self.respawn_time + 2 + random() * 2;
  return;
 }
 if (random() < 0.5) 
  sound(self, 2, "player/gib.wav", 1, 0);
 else 
  sound(self, 2, "player/udeath.wav", 1, 0);
};

void () PlayerDie =
{
 local float i;
 local entity te;
 local string s;
 local entity saveself;

 if (self.hook_out) {
  Reset_Grapple(self.hook);
  Attack_Finished(0.75);
  self.hook_out = 1;
 }
 self.tf_impulse = 0;
 self.imp1 = 0;
 self.imp2 = 0;
 self.imp3 = 0;
 self.imp4 = 0;

 te = find(world, classname, "primer");
 while (te != world && te.owner != self) 
  te = find(te, classname, "primer");
 if (te != world) 
//  te.nextthink = time;
 {
   self.deadflag = 1;
   saveself=self;
   self=te;
   te.think();
   self=saveself;
   self.deadflag = 0;
 }
 self.items = self.items - (self.items & 524288);
 self.invisible_finished = 0;
 self.invincible_finished = 0;
 self.super_damage_finished = 0;
 self.radsuit_finished = 0;
 self.modelindex = modelindex_player;
 if ((self.tfstate & 16) && self == self.enemy) {
  te = find(world, classname, "timer");
  while (te) {
   if (te.owner == self && te.think == BioInfection_Decay) {
    logfrag(te.enemy, self);
    TF_AddFrags(te.enemy, 1);
   }
   te = find(te, classname, "timer");
  }
 }
 TeamFortress_RemoveTimers();
 if (deathmatch || coop) 
  DropBackpack();
 self.weaponmodel = "";
 self.view_ofs = '0 0 -8';
 self.deadflag = 1;
 self.solid = 0;
 self.flags = self.flags - (self.flags & 512);
 self.movetype = 6;
 if (self.velocity_z < 10) 
  self.velocity_z = self.velocity_z + random() * 300;
 if (self.health < -40) {
  GibPlayer();
  return;
 }
 DeathSound();
 self.angles_x = 0;
 self.angles_z = 0;
 if (self.current_weapon <= 16) {
  player_die_ax1();
  TeamFortress_SetupRespawn(0);
  return;
 }
 i = 1 + floor(random() * 6);
 if (i == 1) 
  player_diea1();
 else {
  if (i == 2) 
   player_dieb1();
  else {
   if (i == 3) 
    player_diec1();
   else {
    if (i == 4) 
     player_died1();
    else 
     player_diee1();
   }
  }
 }
 TeamFortress_SetupRespawn(0);
};

void () set_suicide_frame =
{
 if (self.model != "progs/player.mdl") 
  return;
 setmodel(self, string_null);
 setsize(self, '-16 -16 -24', '16 16 32');
};

void () player_diea1 = [50, player_diea2]
{
};

void () player_diea2 = [51, player_diea3]
{
};

void () player_diea3 = [52, player_diea4]
{
};

void () player_diea4 = [53, player_diea5]
{
};

void () player_diea5 = [54, player_diea6]
{
};

void () player_diea6 = [55, player_diea7]
{
};

void () player_diea7 = [56, player_diea8]
{
};

void () player_diea8 = [57, player_diea9]
{
};

void () player_diea9 = [58, player_diea10]
{
};

void () player_diea10 = [59, player_diea11]
{
};

void () player_diea11 = [60, player_diea11]
{
 PlayerDead();
};

void () player_dieb1 = [61, player_dieb2]
{
};

void () player_dieb2 = [62, player_dieb3]
{
};

void () player_dieb3 = [63, player_dieb4]
{
};

void () player_dieb4 = [64, player_dieb5]
{
};

void () player_dieb5 = [65, player_dieb6]
{
};

void () player_dieb6 = [66, player_dieb7]
{
};

void () player_dieb7 = [67, player_dieb8]
{
};

void () player_dieb8 = [68, player_dieb9]
{
};

void () player_dieb9 = [69, player_dieb9]
{
 PlayerDead();
};

void () player_diec1 = [70, player_diec2]
{
};

void () player_diec2 = [71, player_diec3]
{
};

void () player_diec3 = [72, player_diec4]
{
};

void () player_diec4 = [73, player_diec5]
{
};

void () player_diec5 = [74, player_diec6]
{
};

void () player_diec6 = [75, player_diec7]
{
};

void () player_diec7 = [76, player_diec8]
{
};

void () player_diec8 = [77, player_diec9]
{
};

void () player_diec9 = [78, player_diec10]
{
};

void () player_diec10 = [79, player_diec11]
{
};

void () player_diec11 = [80, player_diec12]
{
};

void () player_diec12 = [81, player_diec13]
{
};

void () player_diec13 = [82, player_diec14]
{
};

void () player_diec14 = [83, player_diec15]
{
};

void () player_diec15 = [84, player_diec15]
{
 PlayerDead();
};

void () player_died1 = [85, player_died2]
{
};

void () player_died2 = [86, player_died3]
{
};

void () player_died3 = [87, player_died4]
{
};

void () player_died4 = [88, player_died5]
{
};

void () player_died5 = [89, player_died6]
{
};

void () player_died6 = [90, player_died7]
{
};

void () player_died7 = [91, player_died8]
{
};

void () player_died8 = [92, player_died9]
{
};

void () player_died9 = [93, player_died9]
{
 PlayerDead();
};

void () player_diee1 = [94, player_diee2]
{
};

void () player_diee2 = [95, player_diee3]
{
};

void () player_diee3 = [96, player_diee4]
{
};

void () player_diee4 = [97, player_diee5]
{
};

void () player_diee5 = [98, player_diee6]
{
};

void () player_diee6 = [99, player_diee7]
{
};

void () player_diee7 = [100, player_diee8]
{
};

void () player_diee8 = [101, player_diee9]
{
};

void () player_diee9 = [102, player_diee9]
{
 PlayerDead();
};

void () player_die_ax1 = [41, player_die_ax2]
{
};

void () player_die_ax2 = [42, player_die_ax3]
{
};

void () player_die_ax3 = [43, player_die_ax4]
{
};

void () player_die_ax4 = [44, player_die_ax5]
{
};

void () player_die_ax5 = [45, player_die_ax6]
{
};

void () player_die_ax6 = [46, player_die_ax7]
{
};

void () player_die_ax7 = [47, player_die_ax8]
{
};

void () player_die_ax8 = [48, player_die_ax9]
{
};

void () player_die_ax9 = [49, player_die_ax9]
{
 PlayerDead();
};

void () Headless_Think =
{
 self.frame = self.frame + 1;
 if (self.frame == 7 || self.frame == 18) {
  self.nextthink = time + 10 + random() * 10;
  self.think = SUB_Remove;
  return;
 }
 self.nextthink = time + 0.1;
};

