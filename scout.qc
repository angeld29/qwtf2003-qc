
void () CaltropTouch;
void () CaltropScatterThink;
void () ScatterCaltrops;
void () FlashGrenadeTouch;
void () FlashTimer;
void () FlashGrenadeExplode;
void () ConcussionGrenadeTouch;
void () ConcussionGrenadeExplode;
void (entity inflictor, entity attacker, float bounce, entity ignore) T_RadiusBounce;
entity (entity scanner, float scanrange, float enemies, float friends) T_RadiusScan;

void () CanisterTouch =
{
 sound(self, 1, "weapons/tink1.wav", 1, 1);
 if (self.velocity == '0 0 0') 
  self.avelocity = '0 0 0';
};

void () CaltropTouch =
{
 if (other.classname != "player" || !(other.flags & 512) || other.deadflag) 
  return;
 if ((teamplay & 16) && other != self.owner && other.team_no == self.owner.team_no && self.owner.team_no) 
  return;
 sprint(other, 2, "Ow, Ow, Ow! Caltrops!\n");
 other.leg_damage = other.leg_damage + 2;
 TeamFortress_SetSpeed(other);
 deathmsg = 41;
 T_Damage(other, self, self.owner, 10);
 dremove(self);
};

void () CaltropScatterThink =
{
 self.nextthink = time + 0.2;
 if (self.velocity == '0 0 0') {
  if (self.flags & 512) {
   self.nextthink = time + 10 + random() * 5;
   self.think = SUB_Remove;
   self.solid = 1;
   self.movetype = 6;
   self.touch = CaltropTouch;
   self.angles = '90 90 90';
   sound(self, 0, "weapons/tink1.wav", 1, 1);
   setorigin(self, self.origin);
   return;
  }
  else {
   self.nextthink = time + 10 + random() * 5;
   self.think = SUB_Remove;
   self.solid = 1;
   self.movetype = 6;
   self.touch = CanisterTouch;
   setorigin(self, self.origin);
   return;
  }
 }
 traceline(self.movedir, self.origin, 1, self);
 if (trace_fraction == 1) {
  self.movedir = self.origin;
  return;
 }
 self.velocity = self.velocity * -1;
 self.heat = self.heat + 1;
 if (self.heat > 10) {
  remove(self);
  return;
 }
};

void () ScatterCaltrops =
{
 local float num;
 local entity e;

 num = 6;
 while (num > 0) {
  e = spawn();
  e.classname = "grenade";
  e.weapon = 10;
  e.owner = self.owner;
  e.team_no = self.owner.team_no;
  setmodel(e, "progs/caltrop.mdl");
  e.mins = '-4 -4 -8';
  e.maxs = '4 4 4';
  e.angles = '0 0 0';
  e.angles_x = random() * 360;
  e.velocity_x = crandom() * 100;
  e.velocity_y = crandom() * 100;
  e.velocity_z = 200 + random() * 100;
  e.avelocity_x = crandom() * 400;
  e.avelocity_y = crandom() * 400;
  e.avelocity_z = crandom() * 400;
  setorigin(e, self.owner.origin);
  e.movedir = e.origin;
  e.heat = 0;
  e.movetype = 10;
  e.solid = 0;
  e.nextthink = time + 0.2;
  e.think = CaltropScatterThink;
  num = num - 1;
 }
 dremove(self);
};

void () FlashGrenadeTouch =
{
 sound(self, 1, "weapons/bounce.wav", 1, 1);
 if (self.velocity == '0 0 0') 
  self.avelocity = '0 0 0';
};

void () FlashTimer =
{
 local entity te;
 local string st;

 te = self.owner;
 te.FlashTime = te.FlashTime - 0.6;
 if (te.FlashTime < 5) {
  te.FlashTime = 0;
  stuffcmd(te, "v_cshift; wait; bf\n");
  remove(self);
  return;
 }
 st = ftos(te.FlashTime * 10);
 stuffcmd(te, "v_cshift ");
 stuffcmd(te, st);
 stuffcmd(te, " ");
 stuffcmd(te, st);
 stuffcmd(te, " ");
 stuffcmd(te, st);
 stuffcmd(te, " ");
 stuffcmd(te, st);
 stuffcmd(te, "\n");
 self.nextthink = time + 0.6;
};

void () FlashTimerNew =
{
 local entity te;
 local string st;

 te = self.owner;
 te.FlashTime = te.FlashTime - 0.6;
 if (te.FlashTime < 5) {
  te.FlashTime = 0;
  stuffcmd(te, "v_cshift; wait; bf\n");
  remove(self);
  return;
 }
 st = ftos(te.FlashTime * 10);
 if(te.FlashTime < (24 - #NEW_FLASH_START_TIME))
 {
/*
//     stuffcmd(te, "v_cshift 255 255 255 255\n");
 }else
 {*/
  stuffcmd(te, "v_cshift ");
  stuffcmd(te, st);
  stuffcmd(te, " ");
  stuffcmd(te, st);
  stuffcmd(te, " ");
  stuffcmd(te, st);
  stuffcmd(te, " ");
  stuffcmd(te, st);
  stuffcmd(te, "\n");
 }
 self.nextthink = time + 0.6;
};

void () FlashGrenadeExplode =
{
 local float expsize;
 local entity te;
 local entity oldself;
 local string st;

 self.effects = self.effects | 4;
 WriteByte(4, 23);
 WriteByte(4, 4);
 WriteCoord(4, self.origin_x);
 WriteCoord(4, self.origin_y);
 WriteCoord(4, self.origin_z);
 multicast(self.origin, 1);
 te = findradius(self.origin, 300);
 while (te) {
  if (te.classname == "player") {
   traceline(self.origin, te.origin, 1, self);
   if (trace_fraction == 1) {
    if (vlen(self.origin - te.origin) <= 200) {
     deathmsg = 35;
     TF_T_Damage(te, self, self.owner, 60, 2, 16 | 4);
    }
    if (te.health > 0) {
            if(new_flash)
            {
      if (!te.FlashTime) {
      newmis = spawn();
      newmis.classname = "timer";
      newmis.netname = "flashtimer";
      newmis.team_no = self.owner.team_no;
      newmis.owner = te;
      newmis.think = FlashTimerNew;
      newmis.nextthink = time + 1;
     }
     if (te == self.owner){
      te.FlashTime = 16;
             stuffcmd(te, "v_cshift 160 160 160 160\n");
#ifdef ANTIANTIFLASH
                                            disable_updates(te, -1); /* server-side flash */
#endif // antiantiflash
     }else {
      te.FlashTime = 24;
             stuffcmd(te, "v_cshift 255 255 255 255\n");
#ifdef ANTIANTIFLASH
                                              disable_updates(te, #NEW_FLASH_START_TIME); /* server-side flash */
#endif // antiantiflash                 
     }
            
            }else
            {
     if (!te.FlashTime) {
      newmis = spawn();
      newmis.classname = "timer";
      newmis.netname = "flashtimer";
      newmis.team_no = self.owner.team_no;
      newmis.owner = te;
      newmis.think = FlashTimer;
      newmis.nextthink = time + 1;
     }
     if (te == self.owner){
      te.FlashTime = 16;
     }else {
      te.FlashTime = 24;
     }
     st = ftos(te.FlashTime * 10);
     stuffcmd(te, "v_cshift ");
     stuffcmd(te, st);
     stuffcmd(te, " ");
     stuffcmd(te, st);
     stuffcmd(te, " ");
     stuffcmd(te, st);
     stuffcmd(te, " ");
     stuffcmd(te, st);
     stuffcmd(te, "\n");
     }
    }
   }
  }
  te = te.chain;
 }
 dremove(self);
};

void () ConcussionGrenadeTouch =
{
 sound(self, 1, "weapons/bounce.wav", 1, 1);
 if (self.velocity == '0 0 0') 
  self.avelocity = '0 0 0';
};

void () ConcussionGrenadeExplode =
{
 T_RadiusBounce(self, self.owner, 240, world);
 WriteByte(4, 23);
 WriteByte(4, 3);
 WriteCoord(4, self.origin_x);
 WriteCoord(4, self.origin_y);
 WriteCoord(4, self.origin_z);
 multicast(self.origin, 1);
 dremove(self);
};

void () OldConcussionGrenadeTimer =
{
 local string st;

 if (self.owner.invincible_finished > time) {
  stuffcmd(self.owner, "v_idlescale 0; wait; fov 90\n");
  dremove(self);
  return;
 }
 newmis = spawn();
 setmodel(newmis, "progs/s_bubble.spr");
 setorigin(newmis, self.owner.origin);
 newmis.movetype = 8;
 newmis.solid = 0;
 newmis.velocity = '0 0 15';
 newmis.nextthink = time + 0.5;
 newmis.think = bubble_bob;
 newmis.touch = bubble_remove;
 newmis.classname = "bubble";
 newmis.frame = 0;
 newmis.cnt = 0;
 setsize(newmis, '-8 -8 -8', '8 8 8');
 self.health = self.health - 20;
 if (self.owner.playerclass == 5) 
  self.health = self.health - 20;
 if (self.health < 0) 
  self.health = 0;
 self.nextthink = time + 5;
 stuffcmd(self.owner, "v_iroll_cycle 0.5\n");
 stuffcmd(self.owner, "v_ipitch_cycle 1\n");
 stuffcmd(self.owner, "v_iyaw_cycle 2\n");
 st = ftos(self.health);
 stuffcmd(self.owner, "v_idlescale ");
 stuffcmd(self.owner, st);
 stuffcmd(self.owner, "\n");
 st = ftos(90 + self.health / 2);
 stuffcmd(self.owner, "fov ");
 stuffcmd(self.owner, st);
 stuffcmd(self.owner, "\n");
 if (!self.health) 
  dremove(self);
};

void () ConcussionGrenadeTimer =
{
 local string st;
 local vector stumble;
 local vector src;
 local float pos;

 if (self.owner.invincible_finished > time) {
  sprint(self.owner, 2, "Your head feels better now.\n");
  self.owner.fixangle = 0;
  dremove(self);
  return;
 }
 if (self.health == 200 || self.health == 400 || self.health == 600 || self.health == 800 || self.health == 1000) {
  newmis = spawn();
  setmodel(newmis, "progs/s_bubble.spr");
  setorigin(newmis, self.owner.origin);
  newmis.movetype = 8;
  newmis.solid = 0;
  newmis.velocity = '0 0 15';
  newmis.nextthink = time + 0.5;
  newmis.think = bubble_bob;
  newmis.touch = bubble_remove;
  newmis.classname = "bubble";
  newmis.frame = 0;
  newmis.cnt = 0;
  setsize(newmis, '-8 -8 -8', '8 8 8');
 }
 self.health = self.health - 10;
 if (self.owner.playerclass == 5) 
  self.health = self.health - 10;
 if (self.health < 0) 
  self.health = 0;
 self.nextthink = time + 0.25;
 pos = pointcontents(self.owner.origin);
 src_x = self.owner.origin_x + self.owner.maxs_x + 2;
 src_y = self.owner.origin_y + self.owner.maxs_y + 2;
 pos = pointcontents(src);
 if ((self.owner.flags & 512) || (self.owner.flags & 16)) {
  if (!self.owner.is_feigning) {
   makevectors(self.owner.v_angle);
   stumble = crandom() * v_forward * self.health + crandom() * v_right * self.health;
   if (!(pos == -2 && self.owner.velocity == '0 0 0')) {
    self.owner.velocity = self.owner.velocity + stumble;
    self.owner.fixangle = 1;
   }
  }
 }
 if (!self.health) {
  sprint(self.owner, 2, "Your head feels better now.\n");
  dremove(self);
 }
};

void () TeamFortress_AutoScan =
{
 local entity oldself;
 oldself=self;
 self=oldself.owner;
 TeamFortress_Scan_Angel(self.ScanRange,1);
 self=oldself;
 self.nextthink = time + #TF_AUTOSCAN_TIME;
};

void () ScannerSwitch =
{
 local entity te;

 if (self.ScannerOn != 1) {
  te = spawn();
  te.nextthink = time + #TF_AUTOSCAN_TIME;
  te.think = TeamFortress_AutoScan;
  te.owner = self;
  te.classname = "timer";
  te.netname = "scanner";
  sprint(self, #PRINT_HIGH, "Scanner On.\n");
  self.ScannerOn = 1;
 }
 else {
  te = find(world, netname, "scanner");
  while (te) {
   if (te.owner == self) 
    dremove(te);
   te = find(te, netname, "scanner");
  }
  sprint(self, #PRINT_HIGH, "Scanner Off.\n");
  self.ScannerOn = 0;
 }
       self.StatusRefreshTime = time + 0.1;
};


void (float scanrange) TeamFortress_Scan =
{
 local string power;
 local entity list;
 local float scancost;
 local float scen;
 local float scfr;
 local vector lightningvec;
 local float enemy_detected;
 local float any_detected;
 local vector vf;
 local vector vr;
 local vector e;
 local float res1;
 local float res2;
 local float res3;
 local float vf_e_angle;
 local float vr_e_angle;

 self.impulse = 0;
 self.last_impulse = 0;
 if (self.classname == "player") {
  if (!(self.tf_items & #NIT_SCANNER)) 
   return;
  if (scanrange == 160) {
   if (self.tf_items_flags & 1) {
    sprint(self, 2, "Enemy Scanning disabled.\n");
    self.tf_items_flags = self.tf_items_flags - 1;
    return;
   }
   sprint(self, #PRINT_HIGH, "Enemy Scanning enabled.\n");
   self.tf_items_flags = self.tf_items_flags | 1;
   return;
  }
  if (scanrange == 161) {
   if (self.tf_items_flags & 2) {
    sprint(self, #PRINT_HIGH, "Friendly Scanning disabled.\n");
    self.tf_items_flags = self.tf_items_flags - 2;
    return;
   }
   sprint(self, #PRINT_HIGH, "Friendly Scanning enabled.\n");
   self.tf_items_flags = self.tf_items_flags | 2;
   return;
  }
  if (scanrange > 50) 
   scanrange = 50;
  self.ScanRange=scanrange;
  scen = 0;
  scfr = 0;
  if (self.tf_items_flags & 1) 
   scen = 1;
  if (self.tf_items_flags & 2) 
   scfr = 1;
  if (!scen && !scfr) {
   sprint(self, #PRINT_HIGH, "All scanner functions are disabled.\n");
   return;
  }
  if(self.ScannerOn == 0)
   sprint(self, #PRINT_HIGH, "Scanning...\n");
  scanrange = scanrange * 25;
  list = T_RadiusScan(self, scanrange, scen, scfr);
 }
 scen = 0;
 scfr = 0;
 makevectors(self.v_angle);
 while (list) {
  any_detected = 1;
  if (self.tf_items_flags & 4) {
   if (vlen(list.velocity) > 50) {
    if (list.team_no > 0 && list.team_no == self.team_no) {
     scfr = scfr + 1;
     enemy_detected = 0;
    }
    else {
     scen = scen + 1;
     enemy_detected = 1;
    }
   }
   else 
    any_detected = 0;
  }
  else {
   if (list.team_no > 0 && self.team_no > 0 && list.team_no == self.team_no) {
    scfr = scfr + 1;
    enemy_detected = 0;
   }
   else {
    scen = scen + 1;
    enemy_detected = 1;
   }
  }
  if (any_detected) {
          sprint(self,#PRINT_HIGH,"Scanned ",list.netname,"\n");
   lightningvec = normalize(list.origin - self.origin);
   lightningvec = lightningvec * (vlen(list.origin - self.origin) / 5);
   lightningvec = lightningvec + self.origin;
   msg_entity = self;
   WriteByte(#MSG_ONE, #SVC_TEMPENTITY);
   WriteByte(#MSG_ONE, #TE_LIGHTNING1);
   WriteEntity(#MSG_ONE, self);
   WriteCoord(#MSG_ONE, self.origin_x);
   WriteCoord(#MSG_ONE, self.origin_y);
   WriteCoord(#MSG_ONE, self.origin_z + 8);
   WriteCoord(#MSG_ONE, lightningvec_x);
   WriteCoord(#MSG_ONE, lightningvec_y);
   WriteCoord(#MSG_ONE, lightningvec_z + 8);
  }
  list = list.linked_list;
 }
 if (!scen && !scfr) {
  if(self.ScannerOn == 0)
   sprint(self, #PRINT_HIGH, "No blips.\n");
  return;
 }
 W_SetCurrentAmmo();
 return;
};

void (entity inflictor, entity attacker, float bounce, entity ignore) T_RadiusBounce =
{
 local float points;
 local entity head;
 local entity te;
 local vector org;
 local string st;

 head = findradius(inflictor.origin, bounce + 40);
 while (head) {
  if (head != ignore) {
   if (head.takedamage) {
    org = head.origin + (head.mins + head.maxs) * 0.5;
    points = 0.5 * vlen(org - inflictor.origin);
    if (points < 0) 
     points = 0;
    points = bounce - points;
    if (head.classname != "building_dispenser" && head.classname != "building_sentrygun" && head.classname != "building_sentrygun_base" && points > 0) {
     head.velocity = org - inflictor.origin;
     head.velocity = head.velocity * (points / 20);
     if (head.classname != "player") {
      if (head.flags & 512) 
       head.flags = head.flags - 512;
     }
     else {
      te = find(world, classname, "timer");
      while ((te.owner != head || te.think != ConcussionGrenadeTimer || te.think != OldConcussionGrenadeTimer) && te != world) 
       te = find(te, classname, "timer");
      if (te != world) {
       if (old_grens == 1) {
        stuffcmd(head, "v_idlescale 100\n");
        stuffcmd(head, "fov 130\n");
        te.health = 100;
        te.nextthink = time + 5;
       }
       else {
        te.health = 800;
        te.nextthink = time + 0.25;
       }
      }
      else {
       if (old_grens == 1) {
        stuffcmd(head, "v_idlescale 100\n");
        stuffcmd(head, "fov 130\n");
        stuffcmd(head, "bf\n");
        te = spawn();
        te.nextthink = time + 5;
        te.think = OldConcussionGrenadeTimer;
        te.team_no = attacker.team_no;
        te.classname = "timer";
        te.owner = head;
        te.health = 100;
       }
       else {
        te = spawn();
        te.nextthink = time + 0.25;
        te.think = ConcussionGrenadeTimer;
        te.team_no = attacker.team_no;
        te.classname = "timer";
        te.owner = head;
        te.health = 800;
       }
      }
     }
    }
   }
  }
  head = head.chain;
 }
};

entity (entity scanner, float scanrange, float enemies, float friends) T_RadiusScan =
{
 local entity head;
 local entity list_head;
 local entity list;
 local float gotatarget;

 head = findradius(scanner.origin, scanrange + 40);
 while (head) {
  gotatarget = 0;
  if (head != scanner) {
   if (head.takedamage && head.health > 0) {
    if (head.classname == "player" && (friends || enemies)) {
     if (teamplay) {
      if (friends && head.team_no > 0 && head.team_no == scanner.team_no) 
       gotatarget = 1;
      if (enemies && head.team_no > 0 && scanner.team_no > 0 && head.team_no != scanner.team_no) 
       gotatarget = 1;
     }
     else 
      gotatarget = 1;
    }
   }
  }
  if (gotatarget) {
   if (list) {
    list.linked_list = head;
           list = list.linked_list;
   }
   else {
    list_head = head;
    list = head;
   }
  }
  head = head.chain;
 }
 return list_head;
};

//////////////////////////////////////////

void (float scanrange,float typescan) TeamFortress_Scan_Angel =
{
 local string power;
 local entity list;
 local entity saveent;
 local float minlen;
 local float len;
 local float scancost;
 local float scen;
 local float scfr;
 local vector lightningvec;
 local float enemy_detected;
 local float friend_detected;
 local float any_detected;
 local float any_detected2;
 local vector vf;
 local vector vr;
 local vector e;
 local float res1;
 local float res2;
 local float res3;
 local float vf_e_angle;
 local float vr_e_angle;

 self.impulse = 0;
 self.last_impulse = 0;
 if (self.classname != "player") 
     return;
        if (!(self.tf_items & #NIT_SCANNER)) 
         return;
        if (scanrange == 160) {
         if (self.tf_items_flags & 1) {
          sprint(self, 2, "Enemy Scanning disabled.\n");
          self.tf_items_flags = self.tf_items_flags - 1;
          self.StatusRefreshTime = time + 0.1;
          return;
         }
         sprint(self, #PRINT_HIGH, "Enemy Scanning enabled.\n");
         self.tf_items_flags = self.tf_items_flags | 1;
         self.StatusRefreshTime = time + 0.1;
         return;
        }
        if (scanrange == 161) {
         if (self.tf_items_flags & 2) {
          sprint(self, #PRINT_HIGH, "Friendly Scanning disabled.\n");
          self.tf_items_flags = self.tf_items_flags - 2;
          self.StatusRefreshTime = time + 0.1;
          return;
         }
         sprint(self, #PRINT_HIGH, "Friendly Scanning enabled.\n");
         self.tf_items_flags = self.tf_items_flags | 2;
         self.StatusRefreshTime = time + 0.1;
         return;
        }
        if (scanrange > 50) 
         scanrange = 50;

        if(self.ScanRange != scanrange)
        {
         self.ScanRange=scanrange;
         self.StatusRefreshTime = time + 0.1;
        }
        scen = 0;
        scfr = 0;
        if (self.tf_items_flags & 1) 
         scen = 1;
        if (self.tf_items_flags & 2) 
         scfr = 1;
        if (!scen && !scfr) {
         sprint(self, #PRINT_HIGH, "All scanner functions are disabled.\n");
         return;
        }
    if(typescan == 0)
       sprint(self, #PRINT_HIGH, "Scanning...\n");
       any_detected2=0;
        scanrange = scanrange * 25;
        minlen=scanrange+100;
        list = findradius(self.origin, scanrange + 40);
        while(list)
        {
         enemy_detected=0;
         friend_detected=0;
         any_detected=0;
         if(list != self)
         {
          if(list.takedamage && list.health>0 && list.classname=="player")
          {
           if(teamplay)
           {
            if(scfr && list.team_no > 0 && list.team_no == self.team_no)
            {
              friend_detected=1;
              any_detected=1;
            }
            if(scen && (self.team_no > 0) && (list.team_no > 0) && (list.team_no != self.team_no))
            {
              enemy_detected=1;
              any_detected=1;
            }
            }else
            any_detected=1;
            if((self.tf_items_flags & 4)&&(vlen(list.velocity) <= 50))
             any_detected=0;
           }
          }
         if(any_detected)
         {
           any_detected2=1;
           /*len=vlen(list.origin - self.origin);
           if(!saveent || (len < minlen))
           {
            saveent=list;
            minlen=len;
           }*/
           lightningvec = normalize(list.origin - self.origin);
           lightningvec = lightningvec * (vlen(list.origin - self.origin) / 5);
           lightningvec = lightningvec + self.origin;
           msg_entity = self;
           WriteByte(#MSG_ONE, #SVC_TEMPENTITY);
           WriteByte(#MSG_ONE, #TE_LIGHTNING1);
           WriteEntity(#MSG_ONE, list);
           WriteCoord(#MSG_ONE, self.origin_x);
           WriteCoord(#MSG_ONE, self.origin_y);
           WriteCoord(#MSG_ONE, self.origin_z + 8);
           WriteCoord(#MSG_ONE, lightningvec_x);
           WriteCoord(#MSG_ONE, lightningvec_y);
           WriteCoord(#MSG_ONE, lightningvec_z + 8);
         }
         list=list.chain;
        }
/*        if(saveent)
        {
         lightningvec = normalize(saveent.origin - self.origin);
         lightningvec = lightningvec * (vlen(saveent.origin - self.origin) / 5);
         lightningvec = lightningvec + self.origin;
         msg_entity = self;
         WriteByte(#MSG_ONE, #SVC_TEMPENTITY);
         WriteByte(#MSG_ONE, #TE_LIGHTNING1);
         WriteEntity(#MSG_ONE, self);
         WriteCoord(#MSG_ONE, self.origin_x);
         WriteCoord(#MSG_ONE, self.origin_y);
         WriteCoord(#MSG_ONE, self.origin_z + 8);
         WriteCoord(#MSG_ONE, lightningvec_x);
         WriteCoord(#MSG_ONE, lightningvec_y);
         WriteCoord(#MSG_ONE, lightningvec_z + 8);
        }*/
   if(typescan == 0 && any_detected2==0)
    sprint(self, #PRINT_HIGH, "No blips.\n");

 W_SetCurrentAmmo();
 return;
};
