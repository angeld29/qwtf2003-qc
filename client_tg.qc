void () Detpack_SetClip;

void TG_LoadSettings()=
{
  local string st;

  st = infokey(world, "sg_fire");
  if (st == "off") 
    sg_allow_fire=0;
   else  sg_allow_fire=1;

  st = infokey(world, "sg_find");
  if (st == "all") sg_allow_find = #TG_SG_FIND_IGNORE_OFF;
   else  if( st == "self") sg_allow_find = #TG_SG_FIND_IGNORE_OWNER;
   else if( st == "no") sg_allow_find = #TG_SG_FIND_IGNORE_ALL;
   else sg_allow_find=#TG_SG_FIND_IGNORE_TEAM;

  st = infokey(world, "sg_fire_type");
  if (st == "nodmg")  sg_fire_type = #TG_SG_FIRE_LIGHTING;
  else if (st == "bullets")  sg_fire_type = #TG_SG_FIRE_BULLETS;
  else sg_fire_type=#TG_SG_FIRE_NORMAL;

  st = infokey(world, "gren_eff");
  if (st == "off") gren_effect = 0;
   else if (st == "self") gren_effect = 2;
    else gren_effect = 1;

  st = infokey(world, "gren_time");
  if (st == "10" ) gren_time = 10;
   else if (st == "5") gren_time = 5;
     else gren_time = 0;

  st = infokey(world, "god");
  if (st == "on") godmode=1;
   else  godmode=0;

  st = infokey(world, "unl_ammo");
  if (st == "on") unlimit_ammo=1;
   else  unlimit_ammo=0;

  st = infokey(world, "unl_grens");
  if (st == "on") unlimit_grens=1;
   else  unlimit_grens=0;

  st = infokey(world, "dp_da");
  if (st == "off") detpack_disarm=0;
   else  detpack_disarm=1;

  st = infokey(world, "dp_drop");
  if (st == "on") detpack_drop=1;
   else  detpack_drop=0;

  st = infokey(world, "full_flash");
  if (st == "on") fullflash_for_self=1;
   else  fullflash_for_self=0;

  st = infokey(world, "dp_clip");
  if (st == "off") detpack_clip = 0;
   else if (st == "all") detpack_clip = 2;
    else detpack_clip = 1;
  Detpack_SetClip();

  st = infokey(world, "sg");
  if (st == "old") {sentry_type = #SENTRY_OLD; }
  else {if (st == "fix")  sentry_type = #SENTRY_FIX;
    else { if (st == "new")  sentry_type = #SENTRY_NEW;
     else { if (st == "mtflf") sentry_type = #SENTRY_MTFL_NEWFIND;
      else { if (st == "oldf")  sentry_type = #SENTRY_OLD_NEWFIND;
       else { sentry_type = #SENTRY_MTFL; }}}}}

  st = infokey(world, "sgppl");
  if(st == string_null)  sgppl=12;
  else{
   sgppl=rint(stof(st));
   if(sgppl<0)sgppl=0;
  }
  st = infokey(world, "dtpb");
  if(st == "off")
   detpack_block=0;
   else detpack_block=1;

  st = infokey(world, "tg_sbar");
  if(st == "on")
   tg_sbar=1;
   else tg_sbar=0;

 //defaults_loaded=1;
}