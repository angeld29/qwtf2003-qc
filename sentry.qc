
void (entity bld) CheckBelowBuilding;
void (entity gunhead) CheckSentry;
void () Sentry_Rotate;
float () Sentry_FindTarget;
float () Sentry_FindTarget_Angel;
void () Sentry_FoundTarget;
void () Sentry_HuntTarget;
void () Sentry_Pain;
void () Sentry_Die;
float () Sentry_Fire;
void () Sentry_MuzzleFlash;

void () ai_face =
{
 self.ideal_yaw = vectoyaw(self.enemy.origin - self.origin);
 self.ideal_yaw = anglemod(self.ideal_yaw);
 ChangeYaw();
};


void () lvl1_sentry_atk3;

void () lvl1_sentry_stand = [0, lvl1_sentry_stand]
{
 Sentry_Rotate();
};

void () lvl1_sentry_atk1 = [1, lvl1_sentry_atk3]
{
 ai_face();
 if (self.enemy == world || self.enemy.is_feigning || self.enemy.health <= 0 || !visible(self.enemy) || self.enemy.has_disconnected == 1) 
  lvl1_sentry_stand();
 else {
  if (self.ammo_shells <= 0) 
   lvl1_sentry_stand();
  else {
   if (!Sentry_Fire()) 
    lvl1_sentry_atk3();
  }
 }
};

void () lvl1_sentry_atk2 = [2, lvl1_sentry_atk3]
{
 ai_face();
 Sentry_Fire();
};

void () lvl1_sentry_atk3 = [0, lvl1_sentry_atk1]
{
 ai_face();
};


void () lvl2_sentry_atk3;

void () lvl2_sentry_stand = [3, lvl2_sentry_stand]
{
 Sentry_Rotate();
};

void () lvl2_sentry_atk1 = [4, lvl2_sentry_atk2]
{
 ai_face();
 if (self.enemy == world || self.enemy.is_feigning || self.enemy.health <= 0 || !visible(self.enemy) || self.enemy.has_disconnected == 1) 
  lvl2_sentry_stand();
 else {
  if (self.ammo_shells <= 0) 
   lvl2_sentry_stand();
  else {
   if (!Sentry_Fire()) 
    lvl2_sentry_atk3();
  }
 }
};

void () lvl2_sentry_atk2 = [5, lvl2_sentry_atk3]
{
 ai_face();
 Sentry_Fire();
};

void () lvl2_sentry_atk3 = [3, lvl2_sentry_atk1]
{
 ai_face();
 Sentry_Fire();
};


void () lvl3_sentry_atk3;

void () lvl3_sentry_stand = [6, lvl3_sentry_stand]
{
 Sentry_Rotate();
};

void () lvl3_sentry_atk1 = [7, lvl3_sentry_atk2]
{
 ai_face();
 if (self.enemy == world || self.enemy.is_feigning || self.enemy.health <= 0 || !visible(self.enemy) || self.enemy.has_disconnected == 1) 
  lvl3_sentry_stand();
 else {
  if (self.ammo_shells <= 0 && self.ammo_rockets <= 0) 
   lvl3_sentry_stand();
  else {
   if (!Sentry_Fire()) 
    lvl3_sentry_atk3();
  }
 }
};

void () lvl3_sentry_atk2 = [8, lvl3_sentry_atk3]
{
 ai_face();
 Sentry_Fire();
};

void () lvl3_sentry_atk3 = [6, lvl3_sentry_atk1]
{
 ai_face();
 Sentry_Fire();
};

void () Sentry_Rotate =
{
 local float ay;
 local entity gunhead;

 self.effects = self.effects - (self.effects & 8);
 CheckSentry(self);
 if(sentry_type == 2)
 {
 if (Sentry_FindTarget_Angel()) 
  return;
 }else
 {
  if (Sentry_FindTarget()) 
  return;
 }
 if (!self.heat) {
  self.ideal_yaw = self.waitmin;
  ChangeYaw();
  ay = anglemod(self.angles_y);
  ay = rint(ay);
  if (ay == rint(self.waitmin)) {
   CheckBelowBuilding(self.trigger_field);
   self.heat = 1;
   if (random() < 0.1) 
    sound(self, 3, "weapons/turridle.wav", 1, 1);
  }
 }
 else {
  self.ideal_yaw = self.waitmax;
  ChangeYaw();
  ay = anglemod(self.angles_y);
  ay = rint(ay);
  if (ay == rint(self.waitmax)) {
   CheckBelowBuilding(self.trigger_field);
   self.heat = 0;
  }
 }
};
//////////////////////////////////////////////////////////////////////
float (entity Target) CheckTarget=
{
    local float r;
    if (!Target) 
     return 0;
    if (Target == self) 
     return 0;
    if (Target.has_disconnected == 1) 
     return 0;
    if (!Target.takedamage) 
     return 0;
    if (teamplay) {
     if (Target.team_no == self.team_no && self.team_no) 
      return 0;
     if (Target.undercover_team == self.team_no && self.team_no) 
            return 0;
    }
    if (Target == self.real_owner) 
     return 0;
    if (Target.is_feigning) 
     return 0;
    if (Target.flags & #FL_NOTARGET) 
     return 0;
    if (Target.items & #IT_INVISIBILITY) 
     return 0;
    if (!visible(Target)) 
     return 0;
    r = range(Target);
    if (r == 3) 
     return 0;
    else {
     if (r == 2 && !infront(Target)) 
      return 0;
    }

 return 1;
};
//////////////////////////////////////////////////////////////////////
float () Sentry_FindTarget_Angel =
{
 local entity client;

 if(self.enemy != world)
 {
  if(CheckTarget(self.enemy))
  {
   if( time > self.height )
   {
     Sentry_FoundTarget();
     return 1;
   }else
    return 0;
  }
 }
 client=find(world,classname,"player");
 while(client!=world)
 {
  if(CheckTarget(client))
  {
     self.enemy = client;
     self.height = time + 0.1 * rint(random() * sgppl);
//     self.height = time + 0.1 * rint(sgppl);
     if(self.height == time)
     {
      Sentry_FoundTarget();
      return 1;
     }
     return 0;
  }
  client=find(client,classname,"player");
 }
 self.enemy = world;
 return 0;
};
//////////////////////////////////////////////////////////////////////
float () Sentry_FindTarget =
{
 local entity client;
 local float r;
 local float gotone;
 local float loopc;

 r = 0;
 loopc = 0;
 gotone = 0;
 while (loopc < 6 && !gotone) {
  client = checkclient();
  gotone = 1;
  if (!client) 
   gotone = 0;
  if (client == self) 
   gotone = 0;
  if (client.has_disconnected == 1) 
   gotone = 0;
  if (!client.takedamage) 
   gotone = 0;
  if (teamplay) {
   if (client.team_no == self.team_no && self.team_no) 
    gotone = 0;
   if (client.undercover_team == self.team_no && self.team_no) 
    gotone = 0;
  }
  if (client == self.real_owner) 
   gotone = 0;
  if (client.is_feigning) 
   gotone = 0;
  if (client.flags & #FL_NOTARGET) 
   gotone = 0;
  if (client.items & #IT_INVISIBILITY) 
   gotone = 0;
  if (!visible(client)) 
   gotone = 0;
  r = range(client);
  if (r == 3) 
   gotone = 0;
  else {
   if (r == 2 && !infront(client)) 
    gotone = 0;
  }
  loopc = loopc + 1;
 }
 if (!gotone) 
  return 0;
 self.enemy = client;
 if (self.enemy.classname != "player") {
  self.enemy = self.enemy.enemy;
  if (self.enemy.classname != "player") {
   self.enemy = world;
   return 0;
  }
 }
 Sentry_FoundTarget();
 return 1;
};

void () Sentry_FoundTarget =
{
 if (self.ammo_shells > 0 || (self.ammo_rockets > 0 && self.weapon == 3)) 
  sound(self, 2, "weapons/turrspot.wav", 1, 1);
 Sentry_HuntTarget();
 if (self.super_damage_finished < time) 
  self.super_damage_finished = time + 0.5;
};

void () Sentry_HuntTarget =
{
 self.goalentity = self.enemy;
 if (self.weapon == 1) 
  self.think = lvl1_sentry_atk1;
 else {
  if (self.weapon == 2) 
   self.think = lvl2_sentry_atk1;
  else 
   self.think = lvl3_sentry_atk1;
 }
 self.ideal_yaw = vectoyaw(self.enemy.origin - self.origin);
 self.nextthink = time + 0.1;
 SUB_AttackFinished(1);
};

void () Sentry_Pain =
{
 self.real_owner.StatusRefreshTime = time + 0.2;
};

void () Sentry_Explode =
{
 ThrowGib("progs/tgib1.mdl", -70);
 ThrowGib("progs/tgib2.mdl", -70);
 ThrowGib("progs/tgib3.mdl", -70);
 if (self.real_owner.has_disconnected != 1) {
  deathmsg = 38;
  T_RadiusDamage(self, self.real_owner, 75 + self.ammo_rockets * 8, self);
 }
 if (self.classname == "building_sentrygun_base") {
  if (self.oldenemy) 
   dremove(self.oldenemy);
 }
 else 
  dremove(self.trigger_field);
 WriteByte(4, 23);
 WriteByte(4, 3);
 WriteCoord(4, self.origin_x);
 WriteCoord(4, self.origin_y);
 WriteCoord(4, self.origin_z);
 multicast(self.origin, 1);
 BecomeExplosion();
};

void () Sentry_Die =
{
 sprint(self.real_owner, 2, "Your sentry gun was destroyed.\n");
 self.real_owner.has_sentry = 0;
 self.think = Sentry_Explode;
 self.nextthink = time + 0.1;
};

float () Sentry_Fire =
{
 local vector dir;

 self.effects = self.effects - (self.effects & 8);
 dir = self.enemy.origin - self.origin;
 if (self.ideal_yaw - anglemod(self.angles_y) < -10 || self.ideal_yaw - anglemod(self.angles_y) > 10) 
  return 0;
 if (self.enemy.is_feigning == 1) 
  return 0;
 if (self.weapon == 3 && self.ammo_rockets > 0 && self.super_damage_finished < time) {
  Sentry_MuzzleFlash();
  sound(self, 1, "weapons/rocket1i.wav", 1, 1);
  newmis = spawn();
  newmis.owner = self;
  newmis.movetype = 9;
  newmis.solid = 2;
  newmis.velocity = normalize(self.enemy.origin - self.origin) * 800;
  newmis.angles = vectoangles(newmis.velocity);
  newmis.weapon = 34;
  newmis.touch = T_MissileTouch;
  newmis.nextthink = time + 5;
  newmis.think = SUB_Remove;
  setmodel(newmis, "progs/missile.mdl");
  setsize(newmis, '0 0 0', '0 0 0');
  setorigin(newmis, self.origin + v_forward * 8 + '0 0 16');
  self.super_damage_finished = time + 3;
  self.ammo_rockets = self.ammo_rockets - 1;
  if (self.ammo_rockets == 10) 
   sprint(self.real_owner, 2, "Sentry Gun is low on rockets.\n");
 }
 self.ammo_shells = self.ammo_shells - 1;
 if (self.ammo_shells < 0) {
  self.ammo_shells = 0;
  return 0;
 }
 Sentry_MuzzleFlash();
 sound(self, 1, "weapons/sniper.wav", 1, 1);
 deathmsg = 27;
// FireBullets(4, dir, '0.1 0.1 0');
        if (sentry_type == 1 || sentry_type == 2) {
                self.v_angle = self.angles;
                FireBullets(4, dir, '0.1 0.1 0');
        }
        else {
/*                if (sentry_type == 2) {
                        self.v_angle = self.angles;
                        dir = normalize(dir);
                        FireBullets(5, dir, '0.08 0.08 0');
                }
                else */
                        FireBullets(4, dir, '0.1 0.1 0');
        }
//////
 if (!self.ammo_shells && random() < 0.1) 
  sprint(self.real_owner, 2, "Sentry Gun is out of shells.\n");
 else {
  if (self.ammo_shells == 20) 
   sprint(self.real_owner, 2, "Sentry Gun is low on shells.\n");
 }
 if (!self.ammo_rockets && self.weapon == 3 && random() < 0.1) 
  sprint(self.real_owner, 2, "Sentry Gun is out of rockets.\n");
 return 1;
};

void () Sentry_MuzzleFlash =
{
 self.effects = self.effects | 8;
};

