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

void () ResetMenu;
void () Detpack_SetClip;
string (float num) NumberToString100;
void ()TG_LoadSettings;

void ()Menu_TG_Main=
{
// centerprint(self, "Options:\n1) SG options                 \n2) Detpack option             \n3) Cheats                     \n4) Misc MOD options           \n5) Load defaults              \n7) Nothing                    ");
 centerprint(self, "Options:\n1) SG options                 \n2) Detpack option             \n3) Cheats                     \n4) Load defaults              \n5) Saved position             \n7) Nothing                    ");
 self.StatusRefreshTime = time + 1.5;
};

void (float inp)Menu_TG_Main_Input=
{
 if(inp == 1)
  self.current_menu=#TG_MENU_SG;
 else{
  if(inp ==2 )
   self.current_menu=#TG_MENU_DETPACK;
   else{
    if(inp == 3)
     self.current_menu=#TG_MENU_CHEATS;
    else{
      if(inp == 4)
       TG_LoadSettings();
       else{ if(inp == 5)
        self.current_menu=#TG_MENU_POSITION;
      else{
       if(inp == 7)
        ResetMenu();
  }}}}}
 if (inp > 0 && inp <= 7) {
  self.impulse = 0;
  self.menu_count = 23;
 }
};

void ()Menu_TG_SGOptions=
{
 local string _sgtype;
 local string _sgppl;
 local string _sgfire;
 local string _sgfind;
 local string _sgftype;
// local string _sgchtype;
 local string _sg_sbar;
 _sgppl="";
 if (sentry_type == #SENTRY_MTFL){
    _sgtype="Sentry Gun Options:\nSentry: 2.8.1 fixed(mtfl)";
   }
 if (sentry_type == #SENTRY_OLD) {
    _sgtype="Sentry Gun Options:\nSentry: 2.8.1";
  }
 if (sentry_type == #SENTRY_FIX) {
    _sgtype="Sentry Gun Options:\nSentry: 2.8.1 fixed new";
  }
 if (sentry_type == #SENTRY_NEW) 
   {
    _sgppl=NumberToString100(sgppl);
    _sgtype="Sentry Gun Options:\nSentry: NEW,SGPPL =";
   }
 if (sentry_type == #SENTRY_MTFL_NEWFIND) 
   {
    _sgppl=NumberToString100(sgppl);
    _sgtype="Sentry Gun Options:\nSentry: MTFL new find,SGPPL =";
   }
 if (sentry_type == #SENTRY_OLD_NEWFIND) 
   {
    _sgppl=NumberToString100(sgppl);
    _sgtype="Sentry Gun Options:\nSentry: 2.8.1 new find,SGPPL =";
   }

 if (sg_allow_fire) 
 {
 if((sentry_type == #SENTRY_NEW || sentry_type == #SENTRY_MTFL_NEWFIND || sentry_type == #SENTRY_OLD_NEWFIND))
 _sgfire="\n1) Change SG type             \n2) Increase SGPPL             \n3) Decrease SGPPL             \n4)‰fire ON                    \n";
 else
 _sgfire="\n1) Change SG type             \n                              \n                              \n4)‰fire ON                    \n";
//  _sgfire = "4)‰fire ON                    \n";
 }else {
 if((sentry_type == #SENTRY_NEW || sentry_type == #SENTRY_MTFL_NEWFIND || sentry_type == #SENTRY_OLD_NEWFIND))
 _sgfire="\n1) Change SG type             \n2) Increase SGPPL             \n3) Decrease SGPPL             \n4)‡fire OFF                   \n";
 else
 _sgfire="\n1) Change SG type             \n                              \n                              \n4)‡fire OFF                   \n";
//  _sgfire = "4)‡fire OFF                   \n";
 }

 if (sg_allow_find == #TG_SG_FIND_IGNORE_OFF) 
  _sgfind = "5)‰ignore OFF                 \n";
 else {
  if (sg_allow_find == #TG_SG_FIND_IGNORE_TEAM) 
   _sgfind = "5)†ignore teammates           \n";
  else {
   if (sg_allow_find == #TG_SG_FIND_IGNORE_OWNER) 
    _sgfind = "5)ˆignore owner               \n";
   else {
    if (sg_allow_find == #TG_SG_FIND_IGNORE_ALL) 
     _sgfind = "5)‡ignore all targets         \n";
   }
  }
 }
 
 if (sg_fire_type == #TG_SG_FIRE_NORMAL) 
  _sgftype = "6) Fire bullets & rockets     \n";
 else {
  if (sg_fire_type == #TG_SG_FIRE_BULLETS) 
   _sgftype = "6) Fire bullets               \n";
  else if(sg_fire_type == #TG_SG_FIRE_LIGHTING)
   _sgftype = "6) Fire lightning (no damage) \n";
 }

/* if((sentry_type == #SENTRY_NEW || sentry_type == #SENTRY_MTFL_NEWFIND || sentry_type == #SENTRY_OLD_NEWFIND))
 _sgchtype="\n1) Change SG type             \n2) Increase SGPPL             \n3) Decrease SGPPL             \n";
 else
 _sgchtype="\n1) Change SG type             \n                              \n                              \n";
*/
// centerprint(self, _sgtype, _sgppl,_sgchtype,_sgfire,_sgfind,_sgftype );
 if(tg_sbar)
 _sg_sbar="7)‰Eng Sbar for All           \n8) Nothing                    \n";
 else
 _sg_sbar="7)‡Limited Eng Sbar           \n8) Nothing                    \n";
 centerprint(self, _sgtype, _sgppl,_sgfire,_sgfind,_sgftype,_sg_sbar );
 self.StatusRefreshTime = time + 1.5;
};
void (float inp)Menu_TG_SGOptions_Input=
{
 if(inp == 1)
 {
  sentry_type=sentry_type+1;
  if(sentry_type>#MAX_SENTRY_TYPES )sentry_type=0;
 }
 if((inp == 2) && (sentry_type == #SENTRY_NEW || sentry_type == #SENTRY_MTFL_NEWFIND || sentry_type == #SENTRY_OLD_NEWFIND))
 {
  sgppl=sgppl+1;
 }
 if((inp == 3) && (sentry_type == #SENTRY_NEW || sentry_type == #SENTRY_MTFL_NEWFIND || sentry_type == #SENTRY_OLD_NEWFIND))
 {
  if(sgppl>0){
   sgppl = sgppl - 1;
  }
 }
 if(inp == 4)
 {
  if(sg_allow_fire) sg_allow_fire = 0;
  else  sg_allow_fire=1;
 }
 if(inp == 5)
 {
  sg_allow_find=sg_allow_find+1;
  if(sg_allow_find>3)sg_allow_find = 0;
 }
 if(inp == 6)
 {
  sg_fire_type=sg_fire_type+1;
  if(sg_fire_type>2)sg_fire_type = 0;
 }
 if(inp == 7)
 {
  if(tg_sbar) tg_sbar = 0;
  else  tg_sbar=1;
 }

 if(inp == 8)
 {
  ResetMenu();
 }
 if (inp > 0 && inp <= 8) {
  self.impulse = 0;
  self.menu_count = 23;
 }

};

void () Menu_TG_Cheats =
{
 local string s1;
 local string s2;
 local string s3;
 local string s4;
 local string s5;
 local string s6;

 if (unlimit_ammo) 
  s1 = "1)‰Unlimited ammo ON          \n";
 else 
  s1 = "1)‡Unlimited ammo OFF         \n";
 if (unlimit_grens) 
  s2 = "2)‰Unlimited grenades ON      \n";
 else 
  s2 = "2)‡Unlimited grenades OFF     \n";
 if (gren_effect == 0) 
  s3 = "3)‡Grenade effect OFF         \n";
 else {
  if (gren_effect == 2) 
   s3 = "3)ˆGrenade effect OFF for self\n";
  else {
   if (gren_effect == 1) 
    s3 = "3)‰Grenade effect ON          \n";
  }
 }
 if (gren_time == 0) 
  s4 = "4)‰Grenade effect time: full  \n";
 else {
  if (gren_time == 10) 
   s4 = "4)ˆGrenade effect time: 10 sec\n";
  else 
   s4 = "4)‡Grenade effect time: 5 sec \n";
 }
 if (godmode) 
  s5 = "5)‰God Mode ON                \n";
 else 
  s5 = "5)‡God Mode OFF               \n";

/* if (fullflash_for_self) 
  s6 = "6)‰Flash for self: FULL       \n7) Nothing                    \n";
 else 
  s6 = "6)‡Flash for self: STD        \n7) Nothing                    \n";*/

 if (disable_reload) 
  s6 = "6)‡Reload Disabled            \n7) Nothing                    \n";
 else 
  s6 = "6)‰Reload Enabled             \n7) Nothing                    \n";

 centerprint(self, "Cheats menu:\n", s1, s2, s3, s4, s5,s6 );
 self.StatusRefreshTime = time + 1.5;
};

void (float inp) Menu_TG_Cheats_Input =
{
 if (inp == 1) {
  if (unlimit_ammo) 
   unlimit_ammo = 0;
  else 
   unlimit_ammo = 1;
 }
 else {
  if (inp == 2) {
   if (unlimit_grens) 
    unlimit_grens = 0;
   else 
    unlimit_grens = 1;
  }
  else {
   if (inp == 3) {
    gren_effect = gren_effect + 1;
    if (gren_effect > 2) 
     gren_effect = 0;
   }
   else {
    if (inp == 4) {
     gren_time = gren_time + 5;
     if (gren_time > 10) 
      gren_time = 0;
    }
    else {
     if (inp == 5) {
      if (godmode) 
       godmode = 0;
      else 
       godmode = 1;
     }else {
      if (inp == 6) {
/*       if (fullflash_for_self) 
        fullflash_for_self = 0;
       else 
        fullflash_for_self = 1;*/
       if (disable_reload) 
        disable_reload = 0;
       else 
        disable_reload = 1;
      }
      else {
      if (inp == 7) 
       ResetMenu();
       }
     }
    }
   }
  }
 }
 if (inp > 0 && inp <= 7) {
  self.impulse = 0;
  self.menu_count = 21;
 }
};

void ()Menu_TG_Detpack=
{
 local string st1;
 local string st2;
 local string st3;
 local string st4;

 if (detpack_clip == 0) 
  st1 = "1)‡detpack clip is OFF        \n";
 else {
  if (detpack_clip == 1) 
   st1 = "1)ˆdetpack clip is ON         \n";
  else {
   if (detpack_clip == 2) 
    st1 = "1)‰detpack clip is ALL        \n";
  }
 }
 if (!detpack_disarm) 
  st2 = "2)‡don't disarm detpacks      \n";
 else 
  st2 = "2)‰disarm detpacks            \n";

 if (!detpack_drop) 
  st3 = "3)‡don't drop detpacks        \n";
 else 
  st3 = "3)‰drop detpacks              \n";

 if (detpack_block) 
  st4 = "4)‡Stack detpacks: TF2003     \n";
 else 
  st4 = "4)‰Stack detpacks: TF 2.8.1   \n";

 centerprint(self, "Detpack options:\n", st1, st2, st3, st4, "5) Nothing                    ");
 self.StatusRefreshTime = time + 1.5;
};
void (float inp)Menu_TG_Detpack_Input
{
 if (inp == 1) {
   detpack_clip = detpack_clip + 1;
   if (detpack_clip > 2) 
    detpack_clip = 0;
   Detpack_SetClip();
  }
 else {
  if (inp == 2) {
   if (detpack_disarm) 
    detpack_disarm = 0;
   else 
    detpack_disarm = 1;
  }else {
   if(inp ==  3){
   if (detpack_drop) 
    detpack_drop = 0;
   else 
    detpack_drop = 1;
   }else{
      if(inp ==  4){
      if (detpack_block) 
       detpack_block = 0;
      else 
       detpack_block = 1;
      }else{
     if (inp == 5) 
      ResetMenu();
      }
    }
  }
 }
 if (inp > 0 && inp <= 5) {
  self.impulse = 0;
  self.menu_count = 23;
 }

};

void () Menu_TG_SavePosition =
{
 if (saved_position == '0 0 0'){
  centerprint(self,"\n1) Save Position              \n                              \n                              \n                              \n5) Nothing                    ");
 }else
 {
  centerprint(self,"\n1) Save Position              \n2) Show Position              \n3) Restore Position           \n4) Delete saved position      \n5) Nothing                    ");
 }
 self.StatusRefreshTime = time + 1.5;
};

void (float inp) Menu_TG_SavePosition_Input =
{
 local string s1;

   if (inp == 1) {
    saved_position = self.origin;
    saved_angle = self.angles;
    saved_velocity = self.velocity;
    WriteByte(4, 23);
    WriteByte(4, 4);
    WriteCoord(4, saved_position_x);
    WriteCoord(4, saved_position_y);
    WriteCoord(4, saved_position_z);
    multicast(saved_position, 1);
      ResetMenu();
      }else{ if(inp == 2 && saved_position != '0 0 0'){
      WriteByte(4, 23);
      WriteByte(4, 4);
      WriteCoord(4, saved_position_x);
      WriteCoord(4, saved_position_y);
      WriteCoord(4, saved_position_z);
      multicast(saved_position, 1);
      s1 = vtos(saved_position);
      sprint(self, 2, "Saved position:", s1);
      s1 = vtos(saved_angle);
      sprint(self, 2, "\nangle:", s1);
      s1 = vtos(saved_velocity);
      sprint(self, 2, "\nspeed:", s1, "\n");

   } else { if (inp == 3 && saved_position != '0 0 0') {
      self.origin=saved_position;
      setorigin(self, saved_position);
      self.angles = saved_angle;
      self.fixangle=1;
      self.velocity = saved_velocity;
      ResetMenu();
    }else{    if (inp == 4 && saved_position != '0 0 0') {
      saved_position = '0 0 0';
      ResetMenu();
     }
     if (inp == 5) 
      ResetMenu();
  }}}
 if (inp > 0 && inp < 6) 
 {
  self.impulse = 0;
  self.menu_count = 25;

 }
}