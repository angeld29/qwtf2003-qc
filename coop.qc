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

void () DroppedKeyThink =
{
 self.think = SUB_Null;
 self.touch = key_touch;
 self.owner = world;
};

void () DropKey =
{
 if ((self.items & 131072) || (self.items & 262144)) {
  newmis = spawn();
  if (self.items & 131072) {
   self.items = self.items - (self.items & 131072);
   newmis.items = 131072;
   if (!world.worldtype) {
    setmodel(newmis, "progs/w_s_key.mdl");
    newmis.netname = "silver key";
    newmis.noise = "misc/medkey.wav";
   }
   else {
    if (world.worldtype == 1) {
     setmodel(newmis, "progs/m_s_key.mdl");
     newmis.netname = "silver runekey";
     newmis.noise = "misc/runekey.wav";
    }
    else {
     if (world.worldtype == 2) {
      setmodel(newmis, "progs/b_s_key.mdl");
      newmis.netname = "silver keycard";
      newmis.noise = "misc/basekey.wav";
     }
    }
   }
  }
  else {
   if (self.items & 262144) {
    self.items = self.items - (self.items & 262144);
    newmis.items = 262144;
    if (!world.worldtype) {
     setmodel(newmis, "progs/w_g_key.mdl");
     newmis.netname = "gold key";
     newmis.noise = "misc/medkey.wav";
    }
    else {
     if (world.worldtype == 1) {
      setmodel(newmis, "progs/m_g_key.mdl");
      newmis.netname = "gold runekey";
      newmis.noise = "misc/runekey.wav";
     }
     else {
      if (world.worldtype == 2) {
       setmodel(newmis, "progs/b_g_key.mdl");
       newmis.netname = "gold keycard";
       newmis.noise = "misc/basekey.wav";
      }
     }
    }
   }
  }
  newmis.owner = self;
  newmis.touch = SUB_Null;
  setorigin(newmis, self.origin + '0 0 16');
  makevectors(self.v_angle);
  newmis.velocity = normalize(v_forward) * 300 + '0 0 200';
  newmis.movetype = 6;
  newmis.solid = 1;
  newmis.deadflag = 1;
  setsize(newmis, '-16 -16 -24', '16 16 32');
  newmis.think = DroppedKeyThink;
  newmis.nextthink = time + 1.5;
 }
 else 
  sprint(self, 2, "You don't have a key\n");
};

float () DoorShouldOpen =
{
 local entity ptr;
 local float plyrcount;
 local entity plyr1;
 local entity plyr2;

 if (coop != 2) 
  return 1;
 plyrcount = 0;
 ptr = find(world, classname, "player");
 while (ptr != world) {
  if (!(ptr.tf_items & self.items) && ptr.playerclass && ptr.solid && ptr.model != string_null) {
   plyrcount = plyrcount + 1;
   if (plyrcount == 1) 
    plyr1 = ptr;
   else {
    if (plyrcount == 2) 
     plyr2 = ptr;
   }
  }
  ptr = find(ptr, classname, "player");
 }
 if (plyrcount) {
  if (plyrcount == 1) {
   bprint(2, plyr1.netname);
   bprint(2, " needs");
  }
  else {
   if (plyrcount == 2) {
    bprint(2, plyr1.netname);
    bprint(2, " and ");
    bprint(2, plyr2.netname);
    bprint(2, " need");
   }
   else 
    bprint(2, "More players need");
  }
  bprint(2, " to unlock the ");
  if (self.items & 131072) 
   bprint(2, "silver");
  else 
   bprint(2, "gold");
  bprint(2, " door\n");
  return 0;
 }
 bprint(2, "The ");
 if (self.items & 131072) 
  bprint(2, "silver");
 else 
  bprint(2, "gold");
 bprint(2, " door has been unlocked\n");
 return 1;
};

