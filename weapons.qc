
void () player_run;
void () TeamFortress_DisplayDetectionItems;
float (vector veca, vector vecb) crossproduct;
void (vector org, float damage) SpawnBlood;
void (entity rhook) Reset_Grapple;
void () SuperDamageSound;
void () ConcussionGrenadeTimer;
void () OldConcussionGrenadeTimer;
void () W_PrintWeaponMessage;
float () button_touch;
void () button_fire;
void (entity pl, float fr) TF_AddFrags;
void () DropGoalItems;
void () TeamFortress_DisplayLegalClasses;
void () TeamFortress_Inventory;
void () TeamFortress_SaveMe;
void () TeamFortress_ID;
void () TeamFortress_ShowIDs;
void () TeamFortress_ShowTF;
void () TeamFortress_SniperWeapon;
void () TeamFortress_AssaultWeapon;
void () TeamFortress_IncendiaryCannon;
void () TeamFortress_FlameThrower;
void () TeamFortress_PrimeGrenade;
void () TeamFortress_ThrowGrenade;
void () TeamFortress_Discard;
void () TeamFortress_DetonatePipebombs;
void () PipebombTouch;
void () TeamFortress_DetpackStop;
void () SniperSight_Create;
void (float zoom_level) TF_zoom;
void () TeamFortress_ReloadCurrentWeapon;
void () TeamFortress_AutoZoomToggle;
void () TeamFortress_StatusQuery;
void () TeamFortress_SpyGoUndercover;
void () TeamFortress_EngineerBuild;
void () DropKey;
void () UseSpecialSkill;
void () RemoveFlare;
void (float scanrange) TeamFortress_Scan;
//void (float scanrange) TeamFortress_Scan_Angel;
void (float scanrange,float typescan) TeamFortress_Scan_Angel;
void (float timer) TeamFortress_SetDetpack;
void (float all) TeamFortress_TeamShowScores;
void (entity Player) TeamFortress_TeamShowMemberClasses;
void (entity Player) TeamFortress_TeamShowMemberClasses_New;
void () Admin_CountPlayers;
void () Admin_CycleKick;
void () Admin_DoKick;
void () Admin_CeaseFire;
void () CamLock;
void () CamDistLock;
void () CamVecLock;
void () CamAngleLock;
void () CamRevAngleLock;
void () CamProjectileLock;
void () CamProjectileZoom;
void () CamProjectileLockOn;
void () CamProjectileLockOff;
void () CamOffset;
void () CamDrop;
void () fadetoblack;
void () fadefromblack;
void () fadetowhite;
void () fadefromwhite;
void (entity disp) Engineer_UseDispenser;
void (entity gun) Engineer_UseSentryGun;
void (entity mortar) Engineer_UseMortar;
void () TeamFortress_MOTD;
void () TeamFortress_HelpMap;
void (float res) StatusRes;
void () BioInfection_Decay;
void () BioInfection_MonsterDecay;
void () W_FireFlame;
void () W_FireIncendiaryCannon;
void () W_FireTranq;
void () W_FireLaser;
void () HallucinationTimer;
void () TranquiliserTimer;
void () TeamFortress_CTF_FlagInfo;
void () TF_MovePlayer;
void () ScannerSwitch;

void () W_Precache =
{
 precache_sound("weapons/r_exp3.wav");
 precache_sound("weapons/rocket1i.wav");
 precache_sound("weapons/sgun1.wav");
 precache_sound("weapons/guncock.wav");
 precache_sound("weapons/ric1.wav");
 precache_sound("weapons/ric2.wav");
 precache_sound("weapons/ric3.wav");
 precache_sound("weapons/spike2.wav");
 precache_sound("weapons/tink1.wav");
 precache_sound("weapons/grenade.wav");
 precache_sound("weapons/bounce.wav");
 precache_sound("weapons/shotgn2.wav");
 precache_sound("wizard/wattack.wav");
 precache_sound("items/r_item1.wav");
 precache_sound("items/r_item2.wav");
 precache_model("progs/flame2.mdl");
 precache_sound("ambience/fire1.wav");
 precache_sound2("blob/land1.wav");
 precache_model2("progs/v_spike.mdl");
 precache_sound("hknight/hit.wav");
 precache_sound("weapons/detpack.wav");
 precache_sound("weapons/turrset.wav");
 precache_sound("weapons/turrspot.wav");
 precache_sound("weapons/turridle.wav");
 precache_sound("weapons/sniper.wav");
 precache_sound("weapons/flmfire2.wav");
 precache_sound("weapons/flmgrexp.wav");
 precache_sound("misc/vapeur2.wav");
 precache_sound("weapons/asscan1.wav");
 precache_sound("weapons/asscan2.wav");
 precache_sound("weapons/asscan3.wav");
 precache_sound("weapons/asscan4.wav");
 precache_sound("weapons/railgun.wav");
 precache_sound("weapons/dartgun.wav");
};

float () crandom =
{
 return 2 * (random() - 0.5);
};

void (float att_delay) Attack_Finished =
{
 if (self.tfstate & #TFSTATE_TRANQUILISED) 
  self.attack_finished = time + att_delay * 2;
 else 
  self.attack_finished = time + att_delay;
};

void () W_FireAxe =
{
 local vector source;
 local vector org;
 local vector def;

 makevectors(self.v_angle);
 source = self.origin + '0 0 16';
 traceline(source, source + v_forward * 64, 0, self);
 if (trace_fraction == 1) 
  return;
 org = trace_endpos - v_forward * 4;
 if (trace_ent.takedamage) {
  trace_ent.axhitme = 1;
  SpawnBlood(org, 20);
  if (self.playerclass != 8 || trace_ent.classname != "player") {
   deathmsg = 17;
   TF_T_Damage(trace_ent, self, self, 20, 2, 0);
  }
  else {
   self.weaponmode = 1;
   self.weaponmodel = "progs/v_knife2.mdl";
   makevectors(trace_ent.v_angle);
   def = v_right;
   makevectors(self.v_angle);
   if (crossproduct(def, v_forward) > 0) {
    deathmsg = 22;
    TF_T_Damage(trace_ent, self, self, 120, 2, 0);
   }
   else {
    deathmsg = 17;
    TF_T_Damage(trace_ent, self, self, 40, 2, 0);
   }
  }
 }
 else {
  sound(self, 1, "player/axhit2.wav", 1, 1);
  WriteByte(4, 23);
  WriteByte(4, 2);
  WriteByte(4, 3);
  WriteCoord(4, org_x);
  WriteCoord(4, org_y);
  WriteCoord(4, org_z);
  multicast(org, 2);
 }
};

void () W_FireSpanner =
{
 local vector source;
 local vector org;
 local vector def;
 local float healam;
 local entity te;

 makevectors(self.v_angle);
 source = self.origin + '0 0 16';
 traceline(source, source + v_forward * 64, 0, self);
 if (trace_fraction == 1) 
  return;
 org = trace_endpos - v_forward * 4;
 if (trace_ent.goal_activation & 8) {
  if (Activated(trace_ent, self)) {
   DoResults(trace_ent, self, 1);
   if (trace_ent.classname == "func_button") {
    trace_ent.enemy = self;
    other = self;
    self = trace_ent;
    self.dont_do_triggerwork = 1;
    button_fire();
    self = other;
   }
  }
  else {
   if (trace_ent.else_goal) {
    te = Findgoal(trace_ent.else_goal);
    if (te) 
     AttemptToActivate(te, self, trace_ent);
   }
   else {
    sound(self, 1, "player/axhit2.wav", 1, 1);
    WriteByte(4, 23);
    WriteByte(4, 2);
    WriteByte(4, 3);
    WriteCoord(4, org_x);
    WriteCoord(4, org_y);
    WriteCoord(4, org_z);
    multicast(org, 2);
   }
  }
  return;
 }
 if (trace_ent.takedamage) {
  if (trace_ent.classname == "building_dispenser") {
   Engineer_UseDispenser(trace_ent);
   return;
  }
  else {
   if (trace_ent.classname == "building_sentrygun") {
    Engineer_UseSentryGun(trace_ent);
    return;
   }
   else {
    if (trace_ent.classname == "building_sentrygun_base") {
     if (trace_ent.oldenemy) 
      Engineer_UseSentryGun(trace_ent.oldenemy);
     return;
    }
    else {
     if (trace_ent.classname == "player") {
      if ((trace_ent.team_no == self.team_no && self.team_no && teamplay) || coop) {
       healam = #WEAP_SPANNER_REPAIR;
       if (self.ammo_cells < healam) 
        healam = self.ammo_cells;
       if (!trace_ent.armortype) 
        return;
       if (trace_ent.maxarmor - trace_ent.armorvalue < healam * 4) 
        healam = ceil((trace_ent.maxarmor - trace_ent.armorvalue) / 4);
       if (healam > 0) {
        trace_ent.armorvalue = trace_ent.armorvalue + healam * 4;
        if (trace_ent.armorvalue > trace_ent.maxarmor) 
         trace_ent.armorvalue = trace_ent.maxarmor;
#ifdef TG
  if (!unlimit_ammo) 
#endif
        self.ammo_cells = self.ammo_cells - healam;
        sound(trace_ent, 1, "items/r_item1.wav", 1, 1);
        WriteByte(4, 23);
        WriteByte(4, 2);
        WriteByte(4, 3);
        WriteCoord(4, org_x);
        WriteCoord(4, org_y);
        WriteCoord(4, org_z);
        multicast(org, 2);
        W_SetCurrentAmmo();
       }
       return;
      }
     }
     trace_ent.axhitme = 1;
     SpawnBlood(org, 20);
     deathmsg = 32;
     TF_T_Damage(trace_ent, self, self, 20, 2, 0);
    }
   }
  }
 }
 else {
  sound(self, 1, "player/axhit2.wav", 1, 1);
  WriteByte(4, 23);
  WriteByte(4, 2);
  WriteByte(4, 3);
  WriteCoord(4, org_x);
  WriteCoord(4, org_y);
  WriteCoord(4, org_z);
  multicast(org, 2);
 }
};

void () W_FireMedikit =
{
 local vector source;
 local vector org;
 local float healam;
 local entity te;
 local entity BioInfection;

 source = self.origin + '0 0 16';
 traceline(source, source + v_forward * 64, 0, self);
 if (trace_fraction == 1) 
  return;
 org = trace_endpos - v_forward * 4;
 if (trace_ent.takedamage) {
  if (trace_ent.classname == "player") {
   if ((trace_ent.team_no == self.team_no && self.team_no) || coop) {
    healam = #WEAP_MEDIKIT_HEAL;
    te = find(world, classname, "timer");
    while ((te.owner != trace_ent || (te.think != ConcussionGrenadeTimer && te.think != OldConcussionGrenadeTimer)) && te != world) 
     te = find(te, classname, "timer");
    if (te != world) {
     if (old_grens == 1) 
      stuffcmd(trace_ent, "v_idlescale 0\nfov 90\n");
     SpawnBlood(org, 20);
     bprint(1, self.netname);
     bprint(1, " cured ");
     bprint(1, trace_ent.netname);
     bprint(1, "'s concussion\n");
     if (te.team_no != self.team_no) 
      TF_AddFrags(self, 1);
     dremove(te);
    }
    if (trace_ent.tfstate & 16384) {
     te = find(world, classname, "timer");
     while ((te.owner != trace_ent || te.think != HallucinationTimer) && te != world) 
      te = find(te, classname, "timer");
     if (te != world) {
      trace_ent.tfstate = trace_ent.tfstate - (trace_ent.tfstate & 16384);
      SpawnBlood(org, 20);
      bprint(1, self.netname);
      bprint(1, " healed ");
      bprint(1, trace_ent.netname);
      bprint(1, " of his hallucinations\n");
      if (old_grens == 1) 
       stuffcmd(trace_ent, "v_cshift; wait; bf\n");
      if (te.team_no != self.team_no) 
       TF_AddFrags(self, 1);
      dremove(te);
     }
     else 
      dprint("Warning: Error in Hallucination Timer logic.\n");
    }
    if (trace_ent.tfstate & 32768) {
     te = find(world, classname, "timer");
     while ((te.owner != trace_ent || te.think != TranquiliserTimer) && te != world) 
      te = find(te, classname, "timer");
     if (te != world) {
      trace_ent.tfstate = trace_ent.tfstate - (trace_ent.tfstate & 32768);
      TeamFortress_SetSpeed(trace_ent);
      SpawnBlood(org, 20);
      bprint(1, self.netname);
      bprint(1, " healed ");
      bprint(1, trace_ent.netname);
      bprint(1, "'s tranquilisation\n");
      if (te.team_no != self.team_no) 
       TF_AddFrags(self, 1);
      dremove(te);
     }
     else 
      dprint("Warning: Error in Tranquilisation Timer logic.\n");
    }
    if (trace_ent.FlashTime > 0) {
     te = find(world, netname, "flashtimer");
     while ((te.owner != trace_ent || te.classname != "timer") && te != world) 
      te = find(te, netname, "flashtimer");
     if (te != world) {
      trace_ent.FlashTime = 0;
      SpawnBlood(org, 20);
      bprint(1, self.netname);
      bprint(1, " cured ");
      bprint(1, trace_ent.netname);
      bprint(1, "'s blindness\n");
      if (te.team_no != self.team_no) 
       TF_AddFrags(self, 1);
#ifdef ANTIANTIFLASH
       if(new_flash) 
                disable_updates(trace_ent, -1); /* server-side flash */
#endif // antiantiflash
//      dremove(te);
     }
     else {
      dprint("Warning: Error in Flash Timer logic.\n");
      trace_ent.FlashTime = 0;
     }
    }
    if (trace_ent.tfstate & 16) {
     healam = rint(trace_ent.health / 2);
     trace_ent.tfstate = trace_ent.tfstate - (trace_ent.tfstate & 16);
     deathmsg = 23;
     T_Damage(trace_ent, self, self, healam);
     SpawnBlood(org, 30);
     if (self.classname == "player") {
      bprint(1, self.netname);
      bprint(1, " cured ");
      bprint(1, trace_ent.netname);
      bprint(1, "'s infection\n");
      if (trace_ent.infection_team_no != self.team_no) 
       TF_AddFrags(self, 1);
     }
     return;
    }
    if (trace_ent.numflames > 0) {
     sound(trace_ent, 1, "items/r_item1.wav", 1, 1);
     trace_ent.numflames = 0;
     if (self.classname == "player") {
      bprint(1, self.netname);
      bprint(1, " put out ");
      bprint(1, trace_ent.netname);
      bprint(1, "'s fire.\n");
     }
     return;
    }
    if (healam > 0 && trace_ent.health < trace_ent.max_health) {
     sound(trace_ent, 1, "items/r_item1.wav", 1, 1);
     trace_ent.axhitme = 1;
     SpawnBlood(org, 20);
     T_Heal(trace_ent, healam, 0);
    }
    else {
     if (trace_ent.health >= trace_ent.max_health && trace_ent.health < trace_ent.max_health + #WEAP_MEDIKIT_OVERHEAL) {
      healam = 5;
      if (healam > self.ammo_medikit * 5) 
       healam = self.ammo_medikit * 5;
      if (healam > 0) {
       sound(trace_ent, 3, "items/r_item2.wav", 1, 1);
       T_Heal(trace_ent, healam, 1);
       self.ammo_medikit = self.ammo_medikit - rint(healam / 5);
       if (!(trace_ent.items & 65536)) {
        trace_ent.items = trace_ent.items | 65536;
        newmis = spawn();
        newmis.nextthink = time + 5;
        newmis.think = item_megahealth_rot;
        newmis.owner = trace_ent;
       }
       self.currentammo = self.ammo_medikit;
//       W_SetCurrentAmmo();
      }
     }
    }
   }
   else {
    trace_ent.axhitme = 1;
    SpawnBlood(org, 20);
    deathmsg = 14;
    T_Damage(trace_ent, self, self, 10);
    if (trace_ent.playerclass == 5) 
     return;
    if (cb_prematch_time > time) 
     return;
    if (trace_ent.tfstate & 16) 
     return;
    trace_ent.tfstate = trace_ent.tfstate | 16;
    BioInfection = spawn();
    BioInfection.classname = "timer";
    BioInfection.owner = trace_ent;
    BioInfection.nextthink = time + 2;
    BioInfection.think = BioInfection_Decay;
    BioInfection.enemy = self;
    trace_ent.infection_team_no = self.team_no;
   }
  }
 }
 else {
  sound(self, 1, "player/axhit2.wav", 1, 1);
  WriteByte(4, 23);
  WriteByte(4, 2);
  WriteByte(4, 3);
  WriteCoord(4, org_x);
  WriteCoord(4, org_y);
  WriteCoord(4, org_z);
  multicast(org, 2);
 }
};

void () W_FireBioweapon =
{
 local vector source;
 local vector org;
 local float healam;
 local entity BioInfection;

 source = self.origin + '0 0 16';
 traceline(source, source + v_forward * 64, 0, self);
 if (trace_fraction == 1) 
  return;
 org = trace_endpos - v_forward * 4;
 if (trace_ent.takedamage) {
  if (trace_ent.classname == "player") {
   if ((trace_ent.team_no != self.team_no && self.team_no && teamplay) || !teamplay) {
    trace_ent.axhitme = 1;
    SpawnBlood(org, 20);
    deathmsg = 14;
    T_Damage(trace_ent, self, self, 10);
    if (trace_ent.playerclass == 5) 
     return;
    if (cb_prematch_time > time) 
     return;
    trace_ent.tfstate = trace_ent.tfstate | 16;
    BioInfection = spawn();
    BioInfection.classname = "timer";
    BioInfection.owner = trace_ent;
    BioInfection.nextthink = time + 2;
    BioInfection.think = BioInfection_Decay;
    BioInfection.enemy = self;
    trace_ent.infection_team_no = self.team_no;
   }
  }
  else {
   if (trace_ent.flags & 32) {
    if (trace_ent.classname == "monster_zombie") 
     T_Damage(trace_ent, self, self, 200);
    trace_ent.axhitme = 1;
    SpawnBlood(org, 20);
    T_Damage(trace_ent, self, self, 10);
    BioInfection = spawn();
    BioInfection.classname = "timer";
    BioInfection.nextthink = time + 2;
    BioInfection.think = BioInfection_MonsterDecay;
    BioInfection.owner = self;
    BioInfection.enemy = trace_ent;
   }
   else {
    trace_ent.axhitme = 1;
    SpawnBlood(org, 30);
    T_Damage(trace_ent, self, self, 40);
   }
  }
 }
 else {
  sound(self, 1, "player/axhit2.wav", 1, 1);
  WriteByte(4, 23);
  WriteByte(4, 2);
  WriteByte(4, 3);
  WriteCoord(4, org_x);
  WriteCoord(4, org_y);
  WriteCoord(4, org_z);
  multicast(org, 2);
 }
};

vector () wall_velocity =
{
 local vector vel;

 vel = normalize(self.velocity);
 vel = normalize(vel + v_up * (random() - 0.5) + v_right * (random() - 0.5));
 vel = vel + 2 * trace_plane_normal;
 vel = vel * 200;
 return vel;
};

void (vector org, vector vel) SpawnMeatSpray =
{
 local entity missile;

 missile = spawn();
 missile.owner = self;
 missile.movetype = 10;
 missile.solid = 0;
 makevectors(self.angles);
 missile.velocity = vel;
 missile.velocity_z = missile.velocity_z + 250 + 50 * random();
 missile.avelocity = '3000 1000 2000';
 missile.nextthink = time + 1;
 missile.think = SUB_Remove;
 setmodel(missile, "progs/zom_gib.mdl");
 setsize(missile, '0 0 0', '0 0 0');
 setorigin(missile, org);
};

void (vector org, float damage) SpawnBlood =
{
 WriteByte(4, 23);
 WriteByte(4, 12);
 WriteByte(4, 1);
 WriteCoord(4, org_x);
 WriteCoord(4, org_y);
 WriteCoord(4, org_z);
 multicast(org, 2);
};

void (float damage) spawn_touchblood =
{
 local vector vel;

 vel = wall_velocity() * 0.2;
 SpawnBlood(self.origin + vel * 0.01, damage);
};

void (vector org, vector vel) SpawnChunk =
{
 particle(org, vel * 0.02, 0, 10);
};

entity multi_ent;
float multi_damage;
vector blood_org;
float blood_count;
vector puff_org;
float puff_count;

void () ClearMultiDamage =
{
 multi_ent = world;
 multi_damage = 0;
 blood_count = 0;
 puff_count = 0;
};

void () ApplyMultiDamage =
{
 if (!multi_ent) 
  return;
 TF_T_Damage(multi_ent, self, self, multi_damage, 2, 1);
};

void (entity hit, float damage) AddMultiDamage =
{
 if (!hit) 
  return;
 if (hit != multi_ent) {
  ApplyMultiDamage();
  multi_damage = damage;
  multi_ent = hit;
 }
 else 
  multi_damage = multi_damage + damage;
};

void () Multi_Finish =
{
 if (puff_count) {
  WriteByte(4, 23);
  WriteByte(4, 2);
  WriteByte(4, puff_count);
  WriteCoord(4, puff_org_x);
  WriteCoord(4, puff_org_y);
  WriteCoord(4, puff_org_z);
  multicast(puff_org, 2);
 }
 if (blood_count) {
  WriteByte(4, 23);
  WriteByte(4, 12);
  WriteByte(4, blood_count);
  WriteCoord(4, blood_org_x);
  WriteCoord(4, blood_org_y);
  WriteCoord(4, blood_org_z);
  multicast(puff_org, 2);
 }
};

void (float damage, vector dir) TraceAttack =
{
 local vector vel;
 local vector org;

 vel = normalize(dir + v_up * crandom() + v_right * crandom());
 vel = vel + 2 * trace_plane_normal;
 vel = vel * 200;
 org = trace_endpos - dir * 4;
 if (trace_ent.takedamage) {
  blood_count = blood_count + 1;
  blood_org = org;
  AddMultiDamage(trace_ent, damage);
 }
 else 
 {
//  puff_org = org;
  puff_count = puff_count + 1;
 }
};

void (float shotcount, vector dir, vector spread) FireBullets =
{
 local vector direction;
 local vector src;

 makevectors(self.v_angle);
 src = self.origin + v_forward * 10;
 src_z = self.absmin_z + self.size_z * 0.7;
 ClearMultiDamage();
#ifndef NEWHWGUY
 traceline(src, src + dir * 2048, 0, self);
 puff_org = trace_endpos - dir * 4;
#else 
 direction = dir + (crandom() * spread_x) * v_right + (crandom() * spread_y) * v_up;
 traceline(src, src + direction * 2048, 0, self);
 puff_org = trace_endpos - normalize(dir) * 4;
#endif

 while (shotcount > 0) {
  direction = dir + (crandom() * spread_x) * v_right + (crandom() * spread_y) * v_up;
  traceline(src, src + direction * 2048, 0, self);
  if (trace_fraction != 1) {
#ifndef NEWHWGUY
   if (self.weapon != #WEAP_ASSAULT_CANNON ) 
#else
   if (self.current_weapon != #WEAP_ASSAULT_CANNON ) 
#endif 
    TraceAttack(4, direction);
   else 
    TraceAttack(12, direction);
  }
  shotcount = shotcount - 1;
 }

 ApplyMultiDamage();
 Multi_Finish();
};


void () W_FireShotgun =
{
 local vector dir;

 sound(self, 1, "weapons/guncock.wav", 1, 1);
 KickPlayer(-2, self);
#ifdef TG
  if (!unlimit_ammo) 
#endif
 self.ammo_shells = self.ammo_shells - 1;
#ifdef TG
  if (!unlimit_ammo) 
#endif
 self.currentammo = self.ammo_shells - 1;
 dir = aim(self, 100000);
 deathmsg = 1;
 FireBullets(6, dir, '0.04 0.04 0');
};

void () W_FireSuperShotgun =
{
 local vector dir;

 if (self.currentammo == 1) {
  W_FireShotgun();
  return;
 }
 sound(self, 1, "weapons/shotgn2.wav", 1, 1);
 KickPlayer(-4, self);
#ifdef TG
  if (!unlimit_ammo) 
#endif
 self.ammo_shells = self.ammo_shells - 2;
#ifdef TG
  if (!unlimit_ammo) 
#endif
 self.currentammo = self.ammo_shells - 2;
 dir = aim(self, 100000);
 deathmsg = 2;
 FireBullets(14, dir, '0.14 0.08 0');
};

void (vector direction, float damage) FireSniperBullet =
{
 local vector src;

 makevectors(self.v_angle);
 src = self.origin + v_forward * 10;
 src_z = self.absmin_z + self.size_z * 0.7;
 ClearMultiDamage();
 traceline(src, src + direction * 4096, 0, self);
 if (trace_fraction != 1) 
  TraceAttack(damage, direction);
 if (!trace_ent)
 {
        WriteByte (#MSG_BROADCAST, #SVC_TEMPENTITY);
        WriteByte (#MSG_BROADCAST, #TE_SPIKE);
        WriteCoord (#MSG_BROADCAST, trace_endpos_x);
        WriteCoord (#MSG_BROADCAST, trace_endpos_y);
        WriteCoord (#MSG_BROADCAST, trace_endpos_z);
        multicast (trace_endpos, #MULTICAST_PHS);
 }

 ApplyMultiDamage();
};

void () W_FireSniperRifle =
{
 local vector dir;
 local vector src;
 local float dam_mult;
 local float zdif;
 local float use_this;
 // local 8092
 // local 10000
 // local 3072
 local float x;
 local vector f;
 local vector g;
 local vector h;

 if(snip_fps)
 {
   self.heat = (time - self.heat) * snip_fps * 3 + #SR_INITDAMAGE;

  if (self.heat > #SR_MAXDAMAGE)
   self.heat = #SR_MAXDAMAGE;
 }

 sound(self, 1, "weapons/sniper.wav", 1, 1);
 KickPlayer(-2, self);
#ifdef TG
  if (!unlimit_ammo) 
#endif
 self.ammo_shells = self.ammo_shells - 1;
#ifdef TG
  if (!unlimit_ammo) 
#endif
 self.currentammo = self.ammo_shells - 1;
 makevectors(self.v_angle);
 if(snip_range_fix)
  dir = v_forward;
 src = self.origin + v_forward * 10;
 src_z = self.absmin_z + self.size_z * 0.7;
 use_this = 0;
 traceline(src, src + dir * 8092, 0, self);
 if (trace_fraction != 1) {
  if (trace_ent != world) {
   if (trace_ent.classname == "player") 
    use_this = 1;
  }
 }
 KickPlayer(-4, self);
 if (!use_this) {
  dir = aim(self, 10000);
  traceline(src, src + dir * 3072, 0, self);
 }
 deathmsg = 18;
 dam_mult = 1;
 if (trace_ent) {
  if (trace_ent.classname == "player") {
   f = trace_endpos - src;
   g_x = trace_endpos_x;
   g_y = trace_endpos_y;
   g_z = 0;
   h_x = trace_ent.origin_x;
   h_y = trace_ent.origin_y;
   h_z = 0;
   x = vlen(g - h);
   f = normalize(f) * x + trace_endpos;
   zdif = f_z - trace_ent.origin_z;
   deathmsg = 18;
   trace_ent.head_shot_vector = '0 0 0';
   if (zdif < 0) {
    dam_mult = 0.5;
    trace_ent.leg_damage = trace_ent.leg_damage + 1;
    TeamFortress_SetSpeed(trace_ent);
    deathmsg = 28;
    TF_T_Damage(trace_ent, self, self, self.heat * dam_mult, 2, 1);
    if (trace_ent.health > 0) {
     sprint(trace_ent, 0, "Leg injury!\n");
     sprint(self, 1, "Leg shot - that'll slow him down!\n");
    }
    return;
   }
   else {
    if (zdif > 20) {
     dam_mult = 2;
     stuffcmd(trace_ent, "bf\n");
     trace_ent.head_shot_vector = trace_ent.origin - self.origin;
     deathmsg = 29;
     TF_T_Damage(trace_ent, self, self, self.heat * dam_mult, 2, 1);
     if (trace_ent.health > 0) {
      sprint(trace_ent, 0, "Head injury!\n");
      sprint(self, 1, "Head shot - that's gotta hurt!\n");
     }
     return;
    }
    else 
     deathmsg = 18;
   }
  }
 }
 ClearMultiDamage();
 if (trace_fraction != 1) {
    TraceAttack(self.heat * dam_mult, dir);
    WriteByte (#MSG_BROADCAST, #SVC_TEMPENTITY);
    WriteByte (#MSG_BROADCAST, #TE_SPIKE);
    WriteCoord (#MSG_BROADCAST, trace_endpos_x);
    WriteCoord (#MSG_BROADCAST, trace_endpos_y);
    WriteCoord (#MSG_BROADCAST, trace_endpos_z);
    multicast (trace_endpos, #MULTICAST_PHS);
  }
 ApplyMultiDamage();
};

void () W_FireAutoRifle =
{
 local vector dir;

 sound(self, 1, "weapons/sniper.wav", 1, 1);
 KickPlayer(-1, self);
#ifdef TG
  if (!unlimit_ammo) 
#endif
 self.ammo_shells = self.ammo_shells - 1;
#ifdef TG
  if (!unlimit_ammo) 
#endif
 self.currentammo = self.ammo_shells - 1;
 makevectors(self.v_angle);
 dir = v_forward;
 deathmsg = 19;
 FireSniperBullet(dir, 8);
};

void () W_FireAssaultCannon =
{
 local vector dir;
#ifdef 	NEWHWGUY
 local vector spread;
 spread='0.04 0.04 0';
 if(self.heat<( (#ASSAULT_SPREAD_TIME / 0.2) *0.1))
 {
  spread=spread*(1+(self.heat/((#ASSAULT_SPREAD_TIME/0.2)*0.1))*( #ASSAULT_SPREAD_MULTIPLY - 1));
 }else  
 spread = spread * #ASSAULT_SPREAD_MULTIPLY;
#endif  
 KickPlayer(-4, self);

 if(self.ScanRange <10)
 {
#ifdef TG
  if (!unlimit_ammo) 
#endif
   self.ammo_shells = self.ammo_shells - 1;
#ifdef TG
  if (!unlimit_ammo) 
#endif
   self.currentammo = self.ammo_shells - 1;
   self.ScanRange= self.ScanRange + 1;
 }else
 {
  self.ScanRange=0;
 }

 dir = aim(self, 100000);
 deathmsg = 20;
#ifndef NEWHWGUY
 FireBullets(5, dir, '0.04 0.04 0');
#else
 FireBullets(5, dir, spread);
#endif 
};

void () s_explode1 = [0, s_explode2]
{
};

void () s_explode2 = [1, s_explode3]
{
};

void () s_explode3 = [2, s_explode4]
{
};

void () s_explode4 = [3, s_explode5]
{
};

void () s_explode5 = [4, s_explode6]
{
};

void () s_explode6 = [5, SUB_Remove]
{
};

void () BecomeExplosion =
{
 dremove(self);
};

void () T_MissileTouch =
{
 local float damg;

 if (self.voided) 
  return;
 self.voided = 1;
 if (pointcontents(self.origin) == -6) {
  dremove(self);
  return;
 }
 damg = 92 + random() * 20;
 deathmsg = self.weapon;
 if (other.health) 
  TF_T_Damage(other, self, self.owner, damg, 2, 0);
 if (self.owner.classname == "building_sentrygun") 
  T_RadiusDamage(self, self.owner, 150, other);
 else 
  T_RadiusDamage(self, self.owner, 92, other);
 self.origin = self.origin - 8 * normalize(self.velocity);
 WriteByte(4, 23);
 WriteByte(4, 3);
 WriteCoord(4, self.origin_x);
 WriteCoord(4, self.origin_y);
 WriteCoord(4, self.origin_z);
 multicast(self.origin, 1);
 dremove(self);
};

void () W_FireRocket =
{
#ifdef TG
  if (!unlimit_ammo) 
#endif
 self.ammo_rockets = self.ammo_rockets - 1;
#ifdef TG
  if (!unlimit_ammo) 
#endif
 self.currentammo = self.ammo_rockets - 1;
 sound(self, 1, "weapons/sgun1.wav", 1, 1);
 KickPlayer(-2, self);
 newmis = spawn();
 newmis.owner = self;
 newmis.movetype = 9;
 newmis.solid = 2;
 makevectors(self.v_angle);
 newmis.velocity = v_forward;
 newmis.velocity = newmis.velocity * 900;
 newmis.angles = vectoangles(newmis.velocity);
 newmis.touch = T_MissileTouch;
 newmis.voided = 0;
 newmis.nextthink = time + 5;
 newmis.think = SUB_Remove;
 newmis.weapon = 6;
 setmodel(newmis, "progs/missile.mdl");
 setsize(newmis, '0 0 0', '0 0 0');
 setorigin(newmis, self.origin + v_forward * 8 + '0 0 16');
};

void (entity from, float damage) LightningHit =
{
 WriteByte(4, 23);
 WriteByte(4, 13);
 WriteCoord(4, trace_endpos_x);
 WriteCoord(4, trace_endpos_y);
 WriteCoord(4, trace_endpos_z);
 multicast(trace_endpos, 2);
 TF_T_Damage(trace_ent, from, from, damage, 2, 8);
};

void (vector p1, vector p2, entity from, float damage) LightningDamage =
{
 local entity e1;
 local entity e2;
 local vector f;

 f = p2 - p1;
 normalize(f);
 f_x = 0 - f_y;
 f_y = f_x;
 f_z = 0;
 f = f * 16;
 e2 = world;
 e1 = world;
 traceline(p1, p2, 0, self);
 if (trace_ent.takedamage) {
  LightningHit(from, damage);
  if (self.classname == "player") {
   if (other.classname == "player") 
    trace_ent.velocity_z = trace_ent.velocity_z + 400;
  }
 }
 e1 = trace_ent;
 traceline(p1 + f, p2 + f, 0, self);
 if (trace_ent != e1 && trace_ent.takedamage) 
  LightningHit(from, damage);
 e2 = trace_ent;
 traceline(p1 - f, p2 - f, 0, self);
 if (trace_ent != e1 && trace_ent != e2 && trace_ent.takedamage) 
  LightningHit(from, damage);
};

void () W_FireLightning =
{
 local vector org;
 local float cells;

 if (self.ammo_cells < 1) {
  self.last_weapon = self.current_weapon;
  self.last_weaponmode = self.weaponmode;
  self.current_weapon = W_BestWeapon();
  W_SetCurrentAmmo();
  W_PrintWeaponMessage();
  return;
 }
 if (self.waterlevel > 1) {
  cells = self.ammo_cells;
  self.ammo_cells = 0;
  W_SetCurrentAmmo();
  deathmsg = 7;
  T_RadiusDamage(self, self, 35 * cells, world);
  return;
 }
 if (self.t_width < time) {
  sound(self, 1, "weapons/lhit.wav", 1, 1);
  self.t_width = time + 0.6;
 }
 KickPlayer(-2, self);
#ifdef TG
  if (!unlimit_ammo) 
#endif
 self.ammo_cells = self.ammo_cells - 1;
#ifdef TG
  if (!unlimit_ammo) 
#endif
 self.currentammo = self.ammo_cells - 1;
 org = self.origin + '0 0 16';
 traceline(org, org + v_forward * 600, 1, self);
 WriteByte(4, 23);
 WriteByte(4, 6);
 WriteEntity(4, self);
 WriteCoord(4, org_x);
 WriteCoord(4, org_y);
 WriteCoord(4, org_z);
 WriteCoord(4, trace_endpos_x);
 WriteCoord(4, trace_endpos_y);
 WriteCoord(4, trace_endpos_z);
 multicast(org, 1);
 LightningDamage(self.origin, trace_endpos + v_forward * 4, self, 30);
};

float (float tno) num_team_pipebombs =
{
 if (tno == 1) 
  return num_team_pipebombs_1;
 else {
  if (tno == 2) 
   return num_team_pipebombs_2;
  else {
   if (tno == 3) 
    return num_team_pipebombs_3;
   else {
    if (tno == 4) 
     return num_team_pipebombs_4;
   }
  }
 }
 return 0;
};

float (float tno) num_team_flares =
{
 if (tno == 1) 
  return num_team_flares_1;
 else {
  if (tno == 2) 
   return num_team_flares_2;
  else {
   if (tno == 3) 
    return num_team_flares_3;
   else {
    if (tno == 4) 
     return num_team_flares_4;
   }
  }
 }
 return 0;
};

void (float tno) RemoveOldFlare =
{
 local entity old;
 local float index;

 index = num_team_flares(tno);
 index = index - 9 / number_of_teams;
 old = find(world, mdl, "flare");
 while (index > 0) {
  if (old == world) {
   num_world_flares = 0;
   num_team_flares_1 = 0;
   num_team_flares_2 = 0;
   num_team_flares_3 = 0;
   num_team_flares_4 = 0;
   return;
  }
  if (old.weapon == tno || !tno) {
   old.think = RemoveFlare;
   old.nextthink = time + 0.1;
   index = index - 1;
  }
  old = find(old, mdl, "flare");
 }
};

void (float tno) ExplodeOldPipebomb =
{
 local entity old;
 local float index;

 if (tno) {
  index = num_team_pipebombs(tno);
  index = index - 15 / number_of_teams;
 }
 else 
  index = num_world_pipebombs - 15;
 old = find(world, classname, "pipebomb");
 while (index > 0) {
  if (old == world) {
   num_world_pipebombs = 0;
   num_team_pipebombs_1 = 0;
   num_team_pipebombs_2 = 0;
   num_team_pipebombs_3 = 0;
   num_team_pipebombs_4 = 0;
   return;
  }
  if (old.owner.team_no == tno || !tno) {
   old.nextthink = time + 0.5;
   index = index - 1;
  }
  old = find(old, classname, "pipebomb");
 }
};

void (float tno) increment_team_pipebombs =
{
 if (tno == 1) 
  num_team_pipebombs_1 = num_team_pipebombs_1 + 1;
 else {
  if (tno == 2) 
   num_team_pipebombs_2 = num_team_pipebombs_2 + 1;
  else {
   if (tno == 3) 
    num_team_pipebombs_3 = num_team_pipebombs_3 + 1;
   else {
    if (tno == 4) 
     num_team_pipebombs_4 = num_team_pipebombs_4 + 1;
   }
  }
 }
};

void (float tno) increment_team_flares =
{
 if (tno == 1) 
  num_team_flares_1 = num_team_flares_1 + 1;
 else {
  if (tno == 2) 
   num_team_flares_2 = num_team_flares_2 + 1;
  else {
   if (tno == 3) 
    num_team_flares_3 = num_team_flares_3 + 1;
   else {
    if (tno == 4) 
     num_team_flares_4 = num_team_flares_4 + 1;
   }
  }
 }
};

void (float tno) decrement_team_pipebombs =
{
 if (tno == 1) 
  num_team_pipebombs_1 = num_team_pipebombs_1 - 1;
 else {
  if (tno == 2) 
   num_team_pipebombs_2 = num_team_pipebombs_2 - 1;
  else {
   if (tno == 3) 
    num_team_pipebombs_3 = num_team_pipebombs_3 - 1;
   else {
    if (tno == 4) 
     num_team_pipebombs_4 = num_team_pipebombs_4 - 1;
   }
  }
 }
};

void (float tno) decrement_team_flares =
{
 if (tno == 1) 
  num_team_flares_1 = num_team_flares_1 - 1;
 else {
  if (tno == 2) 
   num_team_flares_2 = num_team_flares_2 - 1;
  else {
   if (tno == 3) 
    num_team_flares_3 = num_team_flares_3 - 1;
   else {
    if (tno == 4) 
     num_team_flares_4 = num_team_flares_4 - 1;
   }
  }
 }
};

void () GrenadeExplode =
{
 local entity te;

 if (self.voided) 
  return;
 self.voided = 1;
 if (self.classname == "pipebomb") {
  num_world_pipebombs = num_world_pipebombs - 1;
  decrement_team_pipebombs(self.team_no);
  if (!(self.flags & 512)) 
   self.weapon = 40;
 }
 if (self.owner.has_disconnected != 1) {
  deathmsg = self.weapon;
  T_RadiusDamage(self, self.owner, 120, world);
 }
 if (self.no_active_nail_grens) {
  self.no_active_nail_grens = 0;
  self.owner.no_active_nail_grens = self.owner.no_active_nail_grens - 1;
  te = find(world, classname, "grenade");
  while (te) {
   if (te.owner == self.owner && te.no_active_nail_grens) 
    te.no_active_nail_grens = te.no_active_nail_grens - 1;
   te = find(te, classname, "grenade");
  }
 }
 WriteByte(4, 23);
 WriteByte(4, 3);
 WriteCoord(4, self.origin_x);
 WriteCoord(4, self.origin_y);
 WriteCoord(4, self.origin_z);
 multicast(self.origin, 1);
 BecomeExplosion();
};

void () GrenadeTouch =
{
 if (other == self.owner) 
  return;
 if (other.takedamage == 2) {
  GrenadeExplode();
  return;
 }
 sound(self, 1, "weapons/bounce.wav", 1, 1);
 if (self.velocity == '0 0 0') 
  self.avelocity = '0 0 0';
};

void () W_FireGrenade =
{
 self.ammo_rockets = self.ammo_rockets - 1;
 self.currentammo = self.ammo_rockets - 1;
 sound(self, 1, "weapons/grenade.wav", 1, 1);
 KickPlayer(-2, self);
 newmis = spawn();
 newmis.voided = 0;
 newmis.owner = self;
 newmis.movetype = 10;
 newmis.solid = 2;
 if (!self.weaponmode || cb_prematch_time > time) {
  newmis.weapon = 5;
  newmis.classname = "grenade";
  newmis.skin = 1;
  newmis.touch = GrenadeTouch;
  newmis.nextthink = time + 2.5;
 }
 else {
  if (self.team_no) {
   increment_team_pipebombs(self.team_no);
   if (num_team_pipebombs(self.team_no) > 15 / number_of_teams) 
    ExplodeOldPipebomb(self.team_no);
  }
  else {
   num_world_pipebombs = num_world_pipebombs + 1;
   if (num_world_pipebombs > 15) 
    ExplodeOldPipebomb(0);
  }
  newmis.classname = "pipebomb";
  newmis.skin = 2;
  newmis.touch = PipebombTouch;
  newmis.nextthink = time + 120;
  newmis.weapon = 11;
  newmis.team_no = self.team_no;
 }
 makevectors(self.v_angle);
 if (self.v_angle_x) 
  newmis.velocity = v_forward * 600 + v_up * 200 + crandom() * v_right * 10 + crandom() * v_up * 10;
 else {
  newmis.velocity = aim(self, 10000);
  newmis.velocity = newmis.velocity * 600;
  newmis.velocity_z = 200;
 }
 newmis.avelocity = '300 300 300';
 newmis.angles = vectoangles(newmis.velocity);
 newmis.think = GrenadeExplode;
 if (birthday == 1 && random() < 0.2) 
  setmodel(newmis, "progs/grenade3.mdl");
 else 
  setmodel(newmis, "progs/grenade2.mdl");
 setsize(newmis, '0 0 0', '0 0 0');
 setorigin(newmis, self.origin);
};


void () spike_touch;
void () superspike_touch;

void (vector org, vector dir) launch_spike =
{
 newmis = spawn();
 newmis.voided = 0;
 newmis.owner = self;
 newmis.movetype = 9;
 newmis.solid = 2;
 newmis.angles = vectoangles(dir);
 newmis.touch = spike_touch;
 newmis.weapon = 3;
 newmis.classname = "spike";
 newmis.think = SUB_Remove;
 newmis.nextthink = time + 6;
 setmodel(newmis, "progs/spike.mdl");
 setsize(newmis, '0 0 0', '0 0 0');
 setorigin(newmis, org);
 newmis.velocity = dir * 1000;
};

void () W_FireSuperSpikes =
{
 local vector dir;
 local entity old;

 sound(self, 1, "weapons/spike2.wav", 1, 1);
#ifdef TG
  if (!unlimit_ammo) 
#endif
 self.ammo_nails = self.ammo_nails - 4;
#ifdef TG
  if (!unlimit_ammo) 
#endif
 self.currentammo = self.ammo_nails - 4;
 dir = aim(self, 1000);
 launch_spike(self.origin + '0 0 16', dir);
 newmis.touch = superspike_touch;
 newmis.weapon = 4;
 setmodel(newmis, "progs/s_spike.mdl");
 setsize(newmis, '0 0 0', '0 0 0');
 KickPlayer(-2, self);
};

void (float ox) W_FireSpikes =
{
 local vector dir;
 local entity old;

 makevectors(self.v_angle);
 if (self.ammo_nails >= 4 && self.current_weapon == 1024) {
  W_FireSuperSpikes();
  return;
 }
 if (self.ammo_nails < 1) {
  self.last_weapon = self.current_weapon;
  self.last_weaponmode = self.weaponmode;
  self.current_weapon = W_BestWeapon();
  W_SetCurrentAmmo();
  W_PrintWeaponMessage();
  return;
 }
 sound(self, 1, "weapons/rocket1i.wav", 1, 1);
 if (self.ammo_nails == 1) {
#ifdef TG
  if (!unlimit_ammo) 
#endif
  self.ammo_nails = self.ammo_nails - 1;
#ifdef TG
  if (!unlimit_ammo) 
#endif
  self.currentammo = self.ammo_nails - 1;
 }
 else {
#ifdef TG
  if (!unlimit_ammo) 
#endif
  self.ammo_nails = self.ammo_nails - 2;
#ifdef TG
  if (!unlimit_ammo) 
#endif
  self.currentammo = self.ammo_nails - 2;
 }
 dir = aim(self, 1000);
 launch_spike(self.origin + '0 0 16' + v_right * ox, dir);
 KickPlayer(-2, self);
};


.float hit_z;

void () spike_touch =
{
 if (self.voided) 
  return;
 self.voided = 1;
 if (other.solid == 1) 
  return;
 if (pointcontents(self.origin) == -6) {
  dremove(self);
  return;
 }
 if (other.takedamage) {
  spawn_touchblood(9);
  deathmsg = self.weapon;
  if (self.owner.classname == "grenade") 
   TF_T_Damage(other, self, self.owner.owner, 9, 2, 2);
  else 
   TF_T_Damage(other, self, self.owner, 18, 2, 2);
 }
 else {
  WriteByte(4, 23);
  if (self.classname == "wizspike") 
   WriteByte(4, 7);
  else {
   if (self.classname == "knightspike") 
    WriteByte(4, 8);
   else 
    WriteByte(4, 0);
  }
  WriteCoord(4, self.origin_x);
  WriteCoord(4, self.origin_y);
  WriteCoord(4, self.origin_z);
  multicast(self.origin, 1);
 }
 dremove(self);
};

void () superspike_touch =
{
 local float ndmg;

 if (self.voided) 
  return;
 self.voided = 1;
 if (other == self.owner) 
  return;
 if (other.solid == 1) 
  return;
 if (pointcontents(self.origin) == -6) {
  dremove(self);
  return;
 }
 if (other.takedamage) {
  spawn_touchblood(18);
  deathmsg = self.weapon;
  if (deathmsg == 9) 
   ndmg = 40;
  else 
   ndmg = 26;
  if (self.owner.classname == "grenade") 
   TF_T_Damage(other, self, self.owner.owner, ndmg, 2, 2);
  else 
   TF_T_Damage(other, self, self.owner, ndmg, 2, 2);
 }
 else {
  WriteByte(4, 23);
  WriteByte(4, 1);
  WriteCoord(4, self.origin_x);
  WriteCoord(4, self.origin_y);
  WriteCoord(4, self.origin_z);
  multicast(self.origin, 1);
 }
 dremove(self);
};

void () W_SetCurrentAmmo =
{
 local string st;

 if (self.health <= 0 || !self.current_weapon) 
  return;
 if (self.current_weapon == 32768 && (self.tfstate & 2048)) 
  return;
 player_run();
 self.items = self.items - (self.items & (256 | 512 | 1024 | 2048));
 self.weapon = 0;
 if (self.current_weapon == 16) {
  self.currentammo = 0;
  if (self.playerclass == 8) {
   if (!self.weaponmode) 
    self.weaponmodel = "progs/v_knife.mdl";
   else 
    self.weaponmodel = "progs/v_knife2.mdl";
  }
  else 
   self.weaponmodel = "progs/v_axe.mdl";
  self.weaponframe = 0;
 }
 else {
  if (self.current_weapon == 1) {
   self.currentammo = 0;
   self.weaponmodel = "progs/v_grap.mdl";
   self.weaponframe = 0;
  }
  else {
   if (self.current_weapon == 8) {
    self.currentammo = self.ammo_cells;
    self.weaponmodel = "progs/v_span.mdl";
    self.weaponframe = 0;
   }
   else {
    if (self.current_weapon == 128) {
     self.currentammo = self.ammo_shells;
     self.items = self.items | 2048;
     if (!(self.tfstate & 2)) {
      self.weaponmodel = "progs/v_shot.mdl";
      self.weaponframe = 0;
     }
     self.items = self.items | 256;
     self.weapon = 1;
    }
    else {
     if (self.current_weapon == 256) {
      self.currentammo = self.ammo_shells;
      if (!(self.tfstate & 2)) {
       self.weaponmodel = "progs/v_shot2.mdl";
       self.weaponframe = 0;
      }
      self.items = self.items | 256;
      self.weapon = 2;
     }
     else {
      if (self.current_weapon == 512) {
       self.currentammo = self.ammo_nails;
       if (!(self.tfstate & 2)) {
        self.weaponmodel = "progs/v_nail.mdl";
        self.weaponframe = 0;
       }
       self.items = self.items | 512;
       self.weapon = 4;
      }
      else {
       if (self.current_weapon == 1024) {
        self.currentammo = self.ammo_nails;
        if (!(self.tfstate & 2)) {
         self.weaponmodel = "progs/v_nail2.mdl";
         self.weaponframe = 0;
        }
        self.items = self.items | 512;
        self.weapon = 8;
       }
       else {
        if (self.current_weapon == 2048) {
         self.currentammo = self.ammo_rockets;
         if (!(self.tfstate & 2)) {
          if (self.weaponmode == #GL_NORMAL) 
                    self.weaponmodel = "progs/v_rock.mdl";
          else 
           self.weaponmodel = "progs/v_pipe.mdl";
          self.weaponframe = 0;
         }
         self.weapon = 16;
         self.items = self.items | 1024;
        }
        else {
         if (self.current_weapon == 8192) {
          self.currentammo = self.ammo_rockets;
          if (!(self.tfstate & 2)) {
           self.weaponmodel = "progs/v_rock2.mdl";
           self.weaponframe = 0;
          }
          self.items = self.items | 1024;
          self.weapon = 32;
         }
         else {
          if (self.current_weapon == 65536) {
           self.currentammo = self.ammo_cells;
           if (!(self.tfstate & 2)) {
            self.weaponmodel = "progs/v_light.mdl";
            self.weaponframe = 0;
           }
           self.items = self.items | 2048;
           self.weapon = 64;
          }
          else {
           if (self.current_weapon == 32) {
            self.currentammo = self.ammo_shells;
            if (!(self.tfstate & 2)) {
             self.weaponmodel = "progs/v_srifle.mdl";
             self.weaponframe = 0;
            }
            self.items = self.items | 256;
            self.weapon = 1;
           }
           else {
            if (self.current_weapon == 64) {
             self.currentammo = self.ammo_shells;
             if (!(self.tfstate & 2)) {
              self.weaponmodel = "progs/v_srifle.mdl";
              self.weaponframe = 0;
             }
             self.items = self.items | 256;
             self.weapon = 2;
            }
            else {
             if (self.current_weapon == 32768) {
              self.currentammo = self.ammo_shells;
              if (!(self.tfstate & 2)) {
               self.weaponmodel = "progs/v_asscan.mdl";
               self.weaponframe = 0;
              }
              self.items = self.items | 256;
              self.weapon = 32;
             }
             else {
              if (self.current_weapon == 4096) {
               self.currentammo = self.ammo_cells;
               if (!(self.tfstate & 2)) {
                self.weaponmodel = "progs/v_flame.mdl";
                self.weaponframe = 0;
               }
               self.items = self.items | 2048;
               self.weapon = 16;
              }
              else {
               if (self.current_weapon == 16384) {
                self.currentammo = self.ammo_rockets;
                if (!(self.tfstate & 2)) {
                 self.weaponmodel = "progs/v_rock2.mdl";
                 self.weaponframe = 0;
                }
                self.items = self.items | 1024;
                self.weapon = 32;
               }
               else {
                if (self.current_weapon == 4) {
//                 self.currentammo = 0;
                 self.currentammo = self.ammo_medikit;
                 self.weaponmodel = "progs/v_medi.mdl";
                 self.weaponframe = 0;
                }
                else {
                 if (self.current_weapon == 2) {
                  self.currentammo = 0;
                  self.weaponmodel = "progs/v_bio.mdl";
                  self.weaponframe = 0;
                 }
                 else {
                  if (self.current_weapon == 262144) {
                   self.currentammo = self.ammo_shells;
                   if (!(self.tfstate & 2)) {
                    self.weaponmodel = "progs/v_tgun.mdl";
                    self.weaponframe = 0;
                   }
                   self.items = self.items | 256;
                   self.weapon = 1;
                  }
                  else {
                   if (self.current_weapon == 524288) {
                    self.currentammo = self.ammo_nails;
                    if (!(self.tfstate & 2)) {
                     self.weaponmodel = "progs/v_rail.mdl";
                     self.weaponframe = 0;
                    }
                    self.items = self.items | 512;
                    self.weapon = 1;
                   }
                   else {
                    self.currentammo = 0;
                    self.weaponmodel = "";
                    self.weaponframe = 0;
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
};

float () W_BestWeapon =
{
 local float it;

 it = self.weapons_carried;
 if (self.ammo_cells >= 1 && (it & 65536) && self.waterlevel <= 1) 
  return 65536;
 else {
  if (self.ammo_cells >= 6 && self.ammo_shells > #ASSAULT_MIN_SHELLS && (it & 32768)) 
   return 32768;
  else {
   if (self.ammo_cells >= 1 && (it & 4096)) 
    return 4096;
   else {
    if (self.ammo_nails >= 2 && (it & 1024)) 
     return 1024;
    else {
     if (self.ammo_shells >= 2 && (it & 256)) 
      return 256;
     else {
      if (self.ammo_nails >= 1 && (it & 524288)) 
       return 524288;
      else {
       if (self.ammo_nails >= 1 && (it & 512)) 
        return 512;
       else {
        if (self.ammo_shells >= 1 && (it & 128)) 
         return 128;
        else {
         if (self.ammo_shells >= 1 && (it & 262144)) 
          return 262144;
         else {
          if (it & 4) 
           return 4;
          else {
           if (it & 8) 
            return 8;
           else {
            if (it & 16) 
             return 16;
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
 return 0;
};

float () W_CheckNoAmmo =
{
 if (self.current_weapon == 4) 
  return 1;
 else {
  if (self.current_weapon == 2) 
   return 1;
  else {
   if (self.current_weapon == 16 || self.current_weapon == 1 || self.current_weapon == 8) 
    return 1;
   else {
    if (self.current_weapon == 16384) {
     if (self.currentammo >= 3) 
      return 1;
    }
    else {
     if (self.currentammo > 0) 
      return 1;
    }
   }
  }
 }
 self.current_weapon = W_BestWeapon();
 W_SetCurrentAmmo();
 W_PrintWeaponMessage();
 return 0;
};

void () W_Reload_shotgun =
{
 self.owner.tfstate = self.owner.tfstate - (self.owner.tfstate & 2);
 self.owner.weaponmodel = "progs/v_shot.mdl";
 sprint(self.owner, 0, "finished reloading\n");
 dremove(self);
 self.owner.StatusRefreshTime = time + 0.1;
};

void () W_Reload_super_shotgun =
{
 self.owner.tfstate = self.owner.tfstate - (self.owner.tfstate & 2);
 self.owner.weaponmodel = "progs/v_shot2.mdl";
 sprint(self.owner, 0, "finished reloading\n");
 dremove(self);
 self.owner.StatusRefreshTime = time + 0.1;
};

void () W_Reload_grenade_launcher =
{
 self.owner.tfstate = self.owner.tfstate - (self.owner.tfstate & 2);
// self.owner.weaponmodel = "progs/v_rock.mdl";
 if (self.owner.weaponmode == #GL_NORMAL) 
         self.owner.weaponmodel = "progs/v_rock.mdl";
 else 
  self.owner.weaponmodel = "progs/v_pipe.mdl";
 sprint(self.owner, 0, "finished reloading\n");
 dremove(self);
 self.owner.StatusRefreshTime = time + 0.1;
};

void () W_Reload_rocket_launcher =
{
 self.owner.tfstate = self.owner.tfstate - (self.owner.tfstate & 2);
 self.owner.weaponmodel = "progs/v_rock2.mdl";
 sprint(self.owner, 0, "finished reloading\n");
 dremove(self);
 self.owner.StatusRefreshTime = time + 0.1;
};

float () CheckForReload =
{
 local entity tWeapon;

 if (self.current_weapon == 128) {
  if (self.reload_shotgun >= 8 && self.ammo_shells > 0) {
   self.reload_shotgun = 0;
   if (self.ammo_shells < 8) 
    self.reload_shotgun = 8 - self.ammo_shells;
   sprint(self, 2, "reloading...\n");
   self.tfstate = self.tfstate | 2;
   tWeapon = spawn();
   tWeapon.owner = self;
   tWeapon.classname = "timer";
   tWeapon.nextthink = time + 2;
   tWeapon.think = W_Reload_shotgun;
   self.weaponmodel = "";
   self.weaponframe = 0;
   return 1;
  }
 }
 else {
  if (self.current_weapon == 256) {
   if (self.reload_super_shotgun > 16) 
    self.reload_super_shotgun = 16;
   if (self.reload_super_shotgun >= 16 && self.ammo_shells > 0) {
    self.reload_super_shotgun = 0;
    if (self.ammo_shells < 16) 
     self.reload_super_shotgun = 16 - self.ammo_shells;
    sprint(self, 2, "reloading...\n");
    self.tfstate = self.tfstate | 2;
    tWeapon = spawn();
    tWeapon.owner = self;
    tWeapon.classname = "timer";
    tWeapon.nextthink = time + 3;
    tWeapon.think = W_Reload_super_shotgun;
    self.weaponmodel = "";
    self.weaponframe = 0;
    return 1;
   }
  }
  else {
   if (self.current_weapon == 2048) {
    if (self.reload_grenade_launcher >= 6 && self.ammo_rockets > 0) {
     self.reload_grenade_launcher = 0;
     if (self.ammo_rockets < 6) 
      self.reload_grenade_launcher = 6 - self.ammo_rockets;
     sprint(self, 2, "reloading...\n");
     self.tfstate = self.tfstate | 2;
     tWeapon = spawn();
     tWeapon.owner = self;
     tWeapon.classname = "timer";
     tWeapon.nextthink = time + 4;
     tWeapon.think = W_Reload_grenade_launcher;
     self.weaponmodel = "";
     self.weaponframe = 0;
     return 1;
    }
   }
   else {
    if (self.current_weapon == 8192) {
     if (self.reload_rocket_launcher >= 4 && self.ammo_rockets > 0) {
      self.reload_rocket_launcher = 0;
      if (self.ammo_rockets < 4) 
       self.reload_rocket_launcher = 4 - self.ammo_rockets;
      sprint(self, 2, "reloading...\n");
      self.tfstate = self.tfstate | 2;
      tWeapon = spawn();
      tWeapon.owner = self;
      tWeapon.classname = "timer";
      tWeapon.nextthink = time + 5;
      tWeapon.think = W_Reload_rocket_launcher;
      self.weaponmodel = "";
      self.weaponframe = 0;
      return 1;
     }
    }
   }
  }
 }
 return 0;
};


void () player_axe1;
void () player_axeb1;
void () player_axec1;
void () player_axed1;
void () player_shot1;
void () player_nail1;
void () player_light1;
void () player_rocket1;
void () player_autorifle1;
void () player_assaultcannon1;
void () player_assaultcannonup1;
void () player_assaultcannondown1;
void () player_medikit1;
void () player_medikitb1;
void () player_medikitc1;
void () player_medikitd1;
void () player_bioweapon1;
void () player_bioweaponb1;
void () player_bioweaponc1;
void () player_bioweapond1;
void () player_chain1;
void () player_chain2;
void () player_chain3;
void () player_chain4;
void () player_chain5;

void () W_Attack =
{
 local float r;
 local float tc;
 local entity tcool;
 local string st;

 if (!W_CheckNoAmmo()) 
  return;
 if (self.has_disconnected == 1) 
  return;
 if (self.tfstate & 2) 
  return;
 if (self.is_undercover || self.undercover_team || self.undercover_skin) 
  Spy_RemoveDisguise(self);
 makevectors(self.v_angle);
 self.show_hostile = time + 1;
 if (self.current_weapon == 16) {
  Attack_Finished(0.5);
  sound(self, 1, "weapons/ax1.wav", 1, 1);
  r = random();
  if (r < 0.25) 
   player_axe1();
  else {
   if (r < 0.5) 
    player_axeb1();
   else {
    if (r < 0.75) 
     player_axec1();
    else 
     player_axed1();
   }
  }
 }
 else {
  if (self.current_weapon == 8) {
   Attack_Finished(0.5);
   sound(self, 1, "weapons/ax1.wav", 1, 1);
   player_axe1();
  }
  else {
   if (self.current_weapon == 1) {
    if (!self.hook_out) 
     player_chain1();
    Attack_Finished(0.1);
   }
   else {
    if (self.current_weapon == #WEAP_SHOTGUN) {
     if (CheckForReload() == 1) 
      return;
     player_shot1();
     W_FireShotgun();
     self.reload_shotgun = self.reload_shotgun + 1;
     self.StatusRefreshTime = time + 0.1;
     CheckForReload();
     Attack_Finished(0.5);
    }
    else {
     if (self.current_weapon == #WEAP_SUPER_SHOTGUN) {
      if (CheckForReload() == 1) 
       return;
      player_shot1();
      W_FireSuperShotgun();
      self.reload_super_shotgun = self.reload_super_shotgun + 2;
      self.StatusRefreshTime = time + 0.1;
      CheckForReload();
      Attack_Finished(0.7);
     }
     else {
      if (self.current_weapon == #WEAP_NAILGUN) 
       player_nail1();
      else {
       if (self.current_weapon == #WEAP_SUPER_NAILGUN) 
        player_nail1();
       else {
        if (self.current_weapon == #WEAP_GRENADE_LAUNCHER) {
         if (CheckForReload() == 1) 
          return;
         player_rocket1();
         W_FireGrenade();
         self.reload_grenade_launcher = self.reload_grenade_launcher + 1;
         self.StatusRefreshTime = time + 0.1;
         CheckForReload();
         Attack_Finished(0.6);
        }
        else {
         if (self.current_weapon == #WEAP_ROCKET_LAUNCHER) {
          if (CheckForReload() == 1) 
           return;
          player_rocket1();
          W_FireRocket();
          self.reload_rocket_launcher = self.reload_rocket_launcher + 1;
          self.StatusRefreshTime = time + 0.1;
          CheckForReload();
          Attack_Finished(0.8);
         }
         else {
          if (self.current_weapon == #WEAP_LIGHTNING) {
           player_light1();
           Attack_Finished(0.1);
           sound(self, 0, "weapons/lstart.wav", 1, 1);
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
 if (self.current_weapon == #WEAP_SNIPER_RIFLE) {
  if ((self.flags & #FL_ONGROUND) || self.hook_out) {
   player_shot1();
   W_FireSniperRifle();
   Attack_Finished(1.5);
  }
 }
 else {
  if (self.current_weapon == #WEAP_AUTO_RIFLE) {
   player_autorifle1();
   W_FireAutoRifle();
   Attack_Finished(0.1);
  }
  else {
   if (self.current_weapon == #WEAP_ASSAULT_CANNON) {
    if (self.ammo_cells < 4) 
     sprint(self, 1, "Insufficient cells to power up the Assault Cannon.\n");
    else {
     self.ammo_cells = self.ammo_cells - 4;
     self.heat = 1;
//     self.immune_to_check = time + 5;
     self.tfstate = self.tfstate | 2048;
     TeamFortress_SetSpeed(self);
     player_assaultcannonup1();
    }
   }
   else {
    if (self.current_weapon == #WEAP_FLAMETHROWER) {
     player_shot1();
     W_FireFlame();
     if (self.waterlevel > 2) 
      Attack_Finished(1);
     else {
      Attack_Finished(0.15);
     }
    }
    else {
     if (self.current_weapon == #WEAP_INCENDIARY) {
      player_rocket1();
      W_FireIncendiaryCannon();
      Attack_Finished(1.2);
     }
     else {
      if (self.current_weapon == 4) {
       sound(self, 1, "weapons/ax1.wav", 1, 1);
       r = random();
       if (r < 0.25) 
        player_medikit1();
       else {
        if (r < 0.5) 
         player_medikitb1();
        else {
         if (r < 0.75) 
          player_medikitc1();
         else 
          player_medikitd1();
        }
       }
       Attack_Finished(0.5);
      }
      else {
       if (self.current_weapon == 2) {
        sound(self, 1, "weapons/ax1.wav", 1, 1);
        r = random();
        if (r < 0.25) 
         player_bioweapon1();
        else {
         if (r < 0.5) 
          player_bioweaponb1();
         else {
          if (r < 0.75) 
           player_bioweaponc1();
          else 
           player_bioweapond1();
         }
        }
        Attack_Finished(0.5);
       }
       else {
        if (self.current_weapon == #WEAP_TRANQ) {
         sound(self, 1, "weapons/dartgun.wav", 1, 1);
         player_shot1();
         W_FireTranq();
         Attack_Finished(1.5);
        }
        else {
         if (self.current_weapon == #WEAP_LASER) {
          sound(self, 1, "weapons/railgun.wav", 1, 1);
          player_shot1();
          W_FireLaser();
          Attack_Finished(0.4);
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

void () W_PrintWeaponMessage =
{
 if (self.current_weapon == 16 && allow_hook) {
  if (self.playerclass != 8) 
   sprint(self, 1, "Axe selected\n");
 }
 else {
  if (self.current_weapon == 1) 
   sprint(self, 1, "grappling hook selected\n");
  else {
   if (self.current_weapon == 2048) {
    if (!self.weaponmode) 
     sprint(self, 1, "Normal grenade mode\n");
    else {
     if (cb_prematch_time > time) 
      sprint(self, 1, "Pipebomb mode not available in PreMatch\n");
     else {
      if (self.weaponmode == 1) 
       sprint(self, 1, "Pipebomb mode\n");
     }
    }
   }
   else {
    if (self.current_weapon == 32) 
     sprint(self, 1, "Sniper rifle ready\n");
    else {
     if (self.current_weapon == 64) 
      sprint(self, 1, "rifle on fully auto\n");
     else {
      if (self.current_weapon == 262144) 
       sprint(self, 1, "Tranquiliser gun selected\n");
      else {
       if (self.current_weapon == 2) 
        sprint(self, 1, "BioWeapon readied\n");
       else {
        if (self.current_weapon == 4) 
         sprint(self, 1, "Medikit/Bioweapon readied\n");
       }
      }
     }
    }
   }
  }
 }
};

void () W_ChangeWeapon =
{
 local float it;
 local float am;
 local float fl;
 local float wm;
 local float have_weapon;
 local float usable;

 if (self.tfstate & 2) 
  return;
 it = self.weapons_carried;
 fl = self.current_weapon;
 am = 0;
 usable = 0;
 have_weapon = 1;
 if (self.impulse == 1) {
  if (!(it & (1 | 2 | 4 | 16 | 8))) 
   have_weapon = 0;
  while (!usable && have_weapon) {
   if (fl == 8) {
    fl = 2;
    if (it & 2) 
     usable = 1;
    usable = 0;
   }
   else {
    if (fl == 2) {
     fl = 4;
     if (it & 4) 
      usable = 1;
    }
    else {
     if (fl == 4) {
      fl = 1;
      if (allow_hook && (fl & 1)) 
       usable = 1;
      if (self.hook_out) 
       Reset_Grapple(self.hook);
     }
     else {
      if (fl == 1) {
       fl = 16;
       if (it & 16) 
        usable = 1;
      }
      else {
       fl = 8;
       if (it & 8) 
        usable = 1;
      }
     }
    }
   }
  }
 }
 else {
  if (allow_hook && (self.impulse == 22 || self.impulse == 39)) 
   fl = 1;
  else {
   if (self.impulse == 40) {
    if (!(it & (2 | 4 | 16 | 8))) 
     have_weapon = 0;
    while (!usable && have_weapon) {
     if (fl == 8) {
      fl = 2;
      if (it & 2) 
       usable = 1;
      usable = 0;
     }
     else {
      if (fl == 2) {
       fl = 4;
       if (it & 4) 
        usable = 1;
      }
      else {
       if (fl == 4) {
        fl = 16;
        if (it & 16) 
         usable = 1;
       }
       else {
        fl = 8;
        if (it & 8) 
         usable = 1;
       }
      }
     }
    }
   }
   else {
    if (self.impulse == 2) {
     if (it & 32) {
      fl = 32;
      if (self.ammo_shells < 1) 
       am = 1;
     }
     else {
      if (it & 128) {
       fl = 128;
       if (self.ammo_shells < 1) 
        am = 1;
      }
      else {
       if (it & 262144) {
        fl = 262144;
        if (self.ammo_shells < 1) 
         am = 1;
       }
       else {
        if (it & 524288) {
         fl = 524288;
         if (self.ammo_nails < 1) 
          am = 1;
        }
        else 
         have_weapon = 0;
       }
      }
     }
    }
    else {
     if (self.impulse == 3) {
      if (it & 64) {
       fl = 64;
       if (self.ammo_shells < 1) 
        am = 1;
      }
      else {
       fl = 256;
       if (self.ammo_shells < 2) 
        am = 1;
      }
     }
     else {
      if (self.impulse == 4) {
       fl = 512;
       if (self.ammo_nails < 1) 
        am = 1;
      }
      else {
       if (self.impulse == 5) {
        fl = 1024;
        if (self.ammo_nails < 2) 
         am = 1;
       }
       else {
        if (self.impulse == 6) {
         if (it & 4096) {
          fl = 4096;
          if (self.ammo_cells < 1) 
           am = 1;
         }
         else {
          if (it & 2048) {
           fl = 2048;
           if (self.ammo_rockets < 1) 
            am = 1;
           wm = 0;
          }
          else 
           have_weapon = 0;
         }
        }
        else {
         if (self.impulse == 7) {
          if (it & 16384) {
           fl = 16384;
           if (self.ammo_rockets < 3) 
            am = 1;
          }
          else {
           if (it & 8192) {
            fl = 8192;
            if (self.ammo_rockets < 1) 
             am = 1;
           }
           else {
            if (it & 32768) {
             fl = 32768;
             if (self.ammo_shells <= #ASSAULT_MIN_SHELLS) 
              am = 1;
             else {
              if (self.ammo_cells < 4) 
               am = 2;
             }
            }
            else {
             if (it & 2048) {
              fl = 2048;
              wm = 1;
              if (self.ammo_rockets < 1) 
               am = 1;
             }
             else 
              have_weapon = 0;
            }
           }
          }
         }
         else {
          if (self.impulse == 8) {
           fl = 65536;
           if (self.ammo_cells < 1) 
            am = 1;
          }
          else {
           if (self.impulse == 176) {
            fl = 4;
            if (it & 4) 
             usable = 1;
           }
           else {
            if (self.impulse == 69) {
             fl = self.last_weapon;
                                                                                                        if((fl & #WEAP_ASSAULT_CANNON) && self.ammo_shells <= #ASSAULT_MIN_SHELLS)
                                                                                                         am = 1;
             
             if (it & self.last_weapon) 
              usable = 1;
             if (fl & (32 | 64 | 128 | 256 | 32768 | 262144) && self.ammo_shells < 1) {
              am = 1;
             }
             else {
              if (fl & (512 | 1024 | 524288) && self.ammo_nails < 1) 
               am = 1;
              else {
               if (fl & (2048 | 8192) && self.ammo_rockets < 1) 
                am = 1;
               else {
                if (fl & (4096 | 65536) && self.ammo_cells < 1) 
                 am = 1;
                else {
                 if (fl == 16384 && self.ammo_rockets < 3) 
                  am = 1;
                 else {
                  if (fl == #WEAP_ASSAULT_CANNON && self.ammo_cells < 4) 
                   am = 2;
                 }
                }
               }
              }
             }
             if (!am) 
              wm = self.last_weaponmode;
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
 self.impulse = 0;
 if (!have_weapon || !(it & fl)) {
  sprint(self, 2, "no weapon.\n");
  return;
 }
 if (am == 1) {
  sprint(self, 2, "not enough ammo.\n");
  return;
 }
 if (am == 2) {
  sprint(self, 2, "not enough cells to power assault cannon.\n");
  return;
 }
 self.last_weaponmode = self.weaponmode;
 self.last_weapon = self.current_weapon;
 self.current_weapon = fl;
 self.weaponmode = wm;
 W_SetCurrentAmmo();
 W_PrintWeaponMessage();
 self.StatusRefreshTime = time + 0.1;
};

void () CycleWeaponCommand =
{
 local float it;
 local float am;
 local float cont;
 local float loopcount;
 local float lw;

 if (self.weaponmodel == string_null || !self.current_weapon) 
  return;
 if (self.tfstate & 2) 
  return;
 it = self.weapons_carried;
 self.impulse = 0;
 loopcount = 0;
 lw = self.current_weapon;
 while (1) {
  am = 0;
  cont = 0;
  if (self.current_weapon == 16) 
   self.current_weapon = 8;
  else {
   if (self.current_weapon == 8) {
    self.current_weapon = 128;
    if (self.ammo_shells < 1) 
     am = 1;
   }
   else {
    if (self.current_weapon == 128) {
     self.current_weapon = 524288;
     if (self.ammo_nails < 1) 
      am = 1;
    }
    else {
     if (self.current_weapon == 524288) {
      self.current_weapon = 262144;
      if (self.ammo_shells < 1) 
       am = 1;
     }
     else {
      if (self.current_weapon == 262144) {
       self.current_weapon = 32;
       if (self.ammo_shells < 1) 
        am = 1;
      }
      else {
       if (self.current_weapon == 32) {
        self.current_weapon = 64;
        if (self.ammo_shells < 1) 
         am = 1;
       }
       else {
        if (self.current_weapon == 64) {
         self.current_weapon = 256;
         if (self.ammo_shells < 2) 
          am = 1;
        }
        else {
         if (self.current_weapon == 256) {
          self.current_weapon = 512;
          if (self.ammo_nails < 1) 
           am = 1;
         }
         else {
          if (self.current_weapon == 512) {
           self.current_weapon = 1024;
           if (self.ammo_nails < 2) 
            am = 1;
          }
          else {
           if (self.current_weapon == 1024) {
            self.current_weapon = 2048;
            self.weaponmode = 0;
            if (self.ammo_rockets < 1) 
             am = 1;
           }
           else {
            if (self.current_weapon == 2048 && !self.weaponmode) {
             self.current_weapon = 2048;
             self.weaponmode = 1;
             if (self.ammo_rockets < 1) 
              am = 1;
            }
            else {
             if (self.current_weapon == 2048 && self.weaponmode == 1) {
              self.current_weapon = 8192;
              if (self.ammo_rockets < 1) 
               am = 1;
             }
             else {
              if (self.current_weapon == 8192) {
               self.current_weapon = 65536;
               if (self.ammo_cells < 1) 
                am = 1;
              }
              else {
               if (self.current_weapon == 65536) {
                self.current_weapon = 4096;
                if (self.ammo_cells < 1) 
                 am = 1;
               }
               else {
                if (self.current_weapon == 4096) {
                 self.current_weapon = 16384;
                 if (self.ammo_rockets < 3) 
                  am = 1;
                }
                else {
                 if (self.current_weapon == 16384) {
                  self.current_weapon = 32768;
                  if (self.ammo_cells < 4) 
                   am = 1;
                  if (self.ammo_shells <= #ASSAULT_MIN_SHELLS) 
                   am = 1;
                 }
                 else {
                  if (self.current_weapon == 32768) {
                   self.current_weapon = 1;
                   if (!allow_hook) 
                    am = 1;
                  }
                  else {
                   if (self.current_weapon == 1) 
                    self.current_weapon = 4;
                   else {
                    if (self.current_weapon == 2) 
                     self.current_weapon = 4;
                    else {
                     if (self.current_weapon == 4) 
                      self.current_weapon = 16;
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
  if (loopcount > 30) 
   return;
  loopcount = loopcount + 1;
  if ((self.weapons_carried & self.current_weapon) && !am) {
   if (self.current_weapon != 2048) 
    self.weaponmode = 0;
   self.last_weapon = lw;
   W_SetCurrentAmmo();
   W_PrintWeaponMessage();
   self.StatusRefreshTime = time + 0.1;
   return;
  }
 }
};


void () PreMatchImpulses;
void () DeadImpulses;

void () ImpulseCommands =
{
 local entity te;
 // local 168
 // local 159
 // local 242
 local string st;

 if (self.last_impulse == 168 && self.impulse) 
  TeamFortress_SetDetpack(self.impulse);
 else {
  if (self.last_impulse == 159 && self.impulse) 
   TeamFortress_Scan_Angel(self.impulse,0);
  if(self.impulse == 160 || self.impulse == 161 )
   TeamFortress_Scan_Angel(self.impulse,0);
 }
 if (self.impulse == 8 && self.current_menu != 6) {
  self.current_menu = 6;
  self.menu_count = 25;
  self.menu_displaytime = 0;
 }
 if (self.impulse == 242 && !birthday) {
  st = infokey(world, "birthday");
  if (st != "off") {
   self.current_menu = 23;
   self.menu_count = 25;
   self.menu_displaytime = 0;
   self.impulse = 0;
   return;
  }
 }
 if (cb_prematch_time > time || cease_fire) {
  PreMatchImpulses();
  DeadImpulses();
  self.impulse = 0;
  return;
 }
 if (self.impulse == 171) 
  UseSpecialSkill();
#ifdef TG
 if(self.impulse == #TG_MAINMENU_IMPULSE)
 {
   self.current_menu = #TG_MENU_MAIN;
   self.impulse = 0;
 }
#endif
 if (!self.is_building && !self.is_detpacking && !self.is_feigning) {
  if ((self.impulse >= 1 && self.impulse < 8) || self.impulse == 176) 
   W_ChangeWeapon();
  else {
         if (allow_hook && (self.impulse == 22 || self.impulse == 39)) 
          W_ChangeWeapon();
      else {
        if (self.impulse == 40) 
         W_ChangeWeapon();
        else {
        if (self.impulse == 10 || self.impulse == 12) 
         CycleWeaponCommand();
        else {
        if (self.impulse == 69 && self.last_weapon) 
         W_ChangeWeapon();
        else {
         if (self.impulse == 150) 
          TeamFortress_PrimeGrenade();
         else {
         if (self.impulse == 151) 
          TeamFortress_PrimeGrenade();
         else {
        if (self.impulse == 173) 
         TeamFortress_ReloadCurrentWeapon();
         else {
        if (self.impulse == 162) 
         TeamFortress_Scan_Angel(10,0);
         else {
         if (self.impulse == 163) 
          TeamFortress_Scan_Angel(30,0);
         else {
        if (self.impulse == 164) 
         TeamFortress_Scan_Angel(100,0);
         else {
         if (self.impulse == 165) 
          TeamFortress_SetDetpack(5);
         else {
        if (self.impulse == 166) 
         TeamFortress_SetDetpack(20);
         else {
         if (self.impulse == 167) 
          TeamFortress_SetDetpack(50);
         else {
         if (self.impulse == 172) {
          self.current_menu = 4;
          self.menu_count = 25 - 5;
         }
         else {
          if (self.impulse == 184) 
           TeamFortress_Discard();
         }}}}}}}}}}}}}}}
     }
     if (self.impulse == 135) 
        TeamFortress_Inventory();
       else {
        if (self.playerclass && self.impulse == 181) 
         TeamFortress_SaveMe();
       else {
        if (self.impulse == 152) 
         TeamFortress_ThrowGrenade();
       else {
        if (self.impulse == 185) 
         TeamFortress_ID();
       else {
        if (self.impulse == 186) 
         TeamFortress_ShowIDs();
       else {
        if (self.playerclass && self.impulse == 194) 
         DropGoalItems();
       else {
        if (self.impulse == 170) 
         TeamFortress_DetonatePipebombs();
       else {
        if (self.impulse == 169) 
         TeamFortress_DetpackStop();
       else {
#ifndef TG
       if (self.impulse == 188 && self.playerclass == 9) 
        DestroyBuilding(self, "building_sentrygun");
       else {
        if (self.impulse == 187 && self.playerclass == 9) 
         DestroyBuilding(self, "building_dispenser");
       else {
        if (self.impulse == 196 && self.playerclass == 9) 
         DestroyBuilding(self, "building_teleporter_exit");
       else {
       if (self.impulse == 197 && self.playerclass == 9) 
        DestroyBuilding(self, "building_teleporter_entrance");
#else
       if (self.impulse == 188 ) 
        DestroyBuilding(self, "building_sentrygun");
       else {
        if (self.impulse == 187 ) 
         DestroyBuilding(self, "building_dispenser");
       else {
        if (self.impulse == 196 ) 
         DestroyBuilding(self, "building_teleporter_exit");
       else {
       if (self.impulse == 197 ) 
        DestroyBuilding(self, "building_teleporter_entrance");
#endif
       else {
        if (self.impulse == 177 && self.playerclass == 8) 
         TeamFortress_SpyGoUndercover();
       else {
     if (self.impulse == 178 && self.playerclass == 8) 
      TeamFortress_SpyFeignDeath(0);
       else {
       if (self.impulse == #TF_SPY_SFEIGN_IMPULSE  && self.playerclass == 8) 
        TeamFortress_SpyFeignDeath(1);
       else {

#ifndef TG
       if (self.impulse == 179        && self.playerclass == 9)
#else
       if (self.impulse == 179       )
#endif
        TeamFortress_EngineerBuild();
       else {
       if (self.impulse == #AUTOSCAN_IMPULSE && self.playerclass == #PC_SCOUT) 
       {
        ScannerSwitch();
       }else
       {
       if (self.impulse == 23) {
         if (CTF_Map == 1) 
          TeamFortress_CTF_FlagInfo();
         else 
          TeamFortress_DisplayDetectionItems();
       }
       else {
         if (self.impulse == 118) 
          display_location();
         else 
          DeadImpulses();
        }}}}}}}}}}}}}}}}}}

 if (self.impulse == 168) {
  self.last_impulse = self.impulse;
 }
 if (self.impulse == 159) 
  self.last_impulse = self.impulse;
 self.impulse = 0;
};

void () PreMatchImpulses =
{
 if ((self.impulse >= 1 && self.impulse < 8) || self.impulse == 176) 
  W_ChangeWeapon();
 else {
  if (allow_hook && (self.impulse == 22 || self.impulse == 39)) 
   W_ChangeWeapon();
  else {
   if (self.impulse == 40) 
    W_ChangeWeapon();
   else {
    if (self.impulse == 10 || self.impulse == 12) 
     CycleWeaponCommand();
   }
  }
 }
 if (self.impulse == 135) 
  TeamFortress_Inventory();
 else {
  if (self.impulse == 185) 
   TeamFortress_ID();
  else {
   if (self.impulse == 23) {
    if (CTF_Map == 1) 
     TeamFortress_CTF_FlagInfo();
    else 
     TeamFortress_DisplayDetectionItems();
   }
   else {
    if (self.impulse == 118) 
     display_location();
   }
  }
 }
};

void () DeadImpulses =
{
 if (self.impulse == 136) 
  TeamFortress_ShowTF();
 else {
  if (self.impulse == 174) 
   TeamFortress_AutoZoomToggle();
  else {
   if (self.impulse == 137) 
    TeamFortress_DisplayLegalClasses();
   else {
    if (self.impulse > 100 && self.impulse <= 100 + 10) 
     TeamFortress_ChangeClass();
    else {
     if (self.playerclass && self.impulse == 99 && deathmatch == 3 && cb_prematch_time < time) {
      self.current_menu = 20;
      self.menu_count = 25;
     }
     else {
      if (self.is_admin == 1) {
       if (self.impulse == 193) 
        Admin_CeaseFire();
       else {
        if (self.impulse == 192) 
         Admin_CountPlayers();
        else {
         if (self.impulse == 190) 
          Admin_CycleKick();
         else {
          if (self.impulse == 191 && self.admin_mode == 1) 
           Admin_DoKick();
          else {
           if (self.impulse == 195 && self.admin_mode == 1) 
            Admin_CycleKick();
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
 if (self.impulse == 131) 
  TeamFortress_HelpMap();
 else {
  if (self.impulse == 119) 
   TeamFortress_StatusQuery();
  else {
   if (self.impulse == 140) 
    TeamFortress_TeamSet(1);
   else {
    if (self.impulse == 141) 
     TeamFortress_TeamSet(2);
    else {
     if (self.impulse == 142) 
      TeamFortress_TeamSet(3);
     else {
      if (self.impulse == 143) 
       TeamFortress_TeamSet(4);
      else {
       if (self.impulse == 145) 
        TeamFortress_TeamShowScores(0);
       else {
        if (self.impulse == 144) 
         TeamFortress_TeamShowMemberClasses_New(self);
        else {
         if (self.impulse == 182) {
          self.StatusRefreshTime = time + 0.2;
          self.StatusBarSize = self.StatusBarSize + 1;
          if (self.StatusBarSize > 2) 
           self.StatusBarSize = 1;
         }
         else {
          if (self.impulse == 183) {
           self.StatusRefreshTime = time + 60;
           self.StatusBarSize = 0;
          }
          else {
           if (self.impulse >= 71 && self.impulse <= 81) 
            StatusRes(self.impulse - 71);
           else {
            if (self.impulse == 13) {
             sprint(self, 2, "Aliases checked.\n");
             self.got_aliases = 1;
             self.impulse = 0;
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

void () W_WeaponFrame =
{
 local vector tv;

 if (!(self.tfstate & #TFSTATE_AIMING)) {
  if (self.height > 29 && self.height < 90) {
   self.height = self.height + 8;
   if (self.height > 90) 
    self.height = 90;
   TF_zoom(self.height);
  }
 }
 if (self.current_menu > 0) {
  Player_Menu();
  if (self.impulse > 0 && (self.current_menu == 23 || self.current_menu == 24 || self.current_menu == 25)) 
   Menu_Input(self.impulse);
  else {
   if (self.impulse > 0 && self.impulse < 11) {
    Menu_Input(self.impulse);
    if (self.impulse) {
     if (!self.team_no && teamplay && self.lives) 
      Menu_Team_Input(self.impulse);
     else {
      if (!self.playerclass && self.lives) 
       Menu_Class_Input(self.impulse);
     }
    }
   }
  }
 }
 if (time < self.attack_finished) 
 {
  if (self.impulse) 
   Angel_SaveImpulse();
  return;
 } 
 if (self.impulse && !self.has_disconnected)
  ImpulseCommands();
 self.impulse=0;

 while( (self.impulse = Angel_GetSavedImpulse()) && !self.has_disconnected)
  ImpulseCommands();
/* if (!self.impulse ) // fixme: save this impulse?
  self.impulse = Angel_GetSavedImpulse();*/

 if (self.impulse && !self.has_disconnected) 
  ImpulseCommands();
 if (cease_fire) 
  return;
 if (self.is_building || self.is_detpacking || self.is_feigning) 
  return;
 if (!self.button0 && self.fire_held_down && self.current_weapon == #WEAP_ASSAULT_CANNON) {
  self.fire_held_down = 0;
  self.tfstate = self.tfstate - (self.tfstate & #TFSTATE_AIMING);
  TeamFortress_SetSpeed(self);
  player_run();
 }
 if (self.button0 && !self.fire_held_down) {
  if (self.current_menu == 6 || self.current_menu == 7) {
   self.current_menu = 8;
   self.menu_count = 25;
   Attack_Finished(0.2);
  }
  else {
   if (self.current_weapon == #WEAP_SNIPER_RIFLE) {
    if (self.tfstate & #TFSTATE_AIMING) {
     if (!snip_fps && self.heat < 400) 
      self.heat = self.heat + 3;
     if (self.height > 30) {
      self.height = self.height - 5;
      TF_zoom(self.height);
     }
    }
    else {
     tv = self.velocity;
     tv_z = 0;
     if (vlen(tv) <= #WEAP_SNIPER_RIFLE_MAX_MOVE) {
      SniperSight_Create();
      if(snip_fps)
       self.heat = time;
      else
       self.heat = 50;

      self.height = 90;
      self.tfstate = self.tfstate | #TFSTATE_AIMING;
      TeamFortress_SetSpeed(self);
     }
    }
   }
   else {
    if (self.current_weapon == #WEAP_ASSAULT_CANNON) {
     if (self.flags & #FL_ONGROUND) {
      SuperDamageSound();
      W_Attack();
     }
     else 
      sprint(self, 1, "You cannot fire the assault cannon without\nyour feet on the ground...\n");
    }
    else {
     SuperDamageSound();
     W_Attack();
    }
   }
  }
 }
 else {
  if (!self.playerclass) 
   self.weaponmode = 0;
  else {
   if (self.tfstate & 2048) {
    W_Attack();
    self.tfstate = self.tfstate - 2048;
    TeamFortress_SetSpeed(self);
    self.heat = 0;
   }
  }
 }
};

void () SuperDamageSound =
{
 if (self.super_damage_finished > time) {
  if (self.super_sound < time) {
   self.super_sound = time + 1;
   sound(self, 4, "items/damage3.wav", 1, 1);
  }
 }
 return;
};

