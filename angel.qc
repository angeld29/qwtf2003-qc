float (entity Goal, entity AP) Activated;

float (entity spot)CheckTelefragSpot=
{
  local entity at_spot;
  at_spot = findradius(spot.origin, 40);
  while (at_spot != world) {
  	if (at_spot.classname == "player" && !at_spot.deadflag) 
  		return 0;
  	at_spot = at_spot.chain;
  }
 return 1;
};

entity (float team_num) FindRandomTeamSpawnPoint =
{
	local entity spot;
	local entity at_spot;
	local float numspots;
	local string teststr;

	if (team_num == 1)
	 teststr="ts1";
	 else if (team_num == 2) 
	        teststr="ts2";
	 else if (team_num == 3) 
	        teststr="ts3";
	 else if (team_num == 4) 
	        teststr="ts4";
	        else  return world;

		spot = find(world, team_str_home, teststr);
       		if (spot == world) 
       			return world;
       		numspots=0;
       		while(spot != world)
       		{
       	 	 if( CheckTelefragSpot(spot) && Activated(spot, self))
       	 	   numspots=numspots+1;
       	 	 spot = find(spot, team_str_home, teststr);
       		}
       		if(numspots == 0) return world;
       		numspots = rint((random() * numspots));

       		spot = find(world, team_str_home, teststr);
		while(numspots > 0)
		{
                 if( CheckTelefragSpot(spot) && Activated(spot, self))
		  numspots = numspots - 1;
		 spot = find(spot, team_str_home, teststr);
		}
		return spot;
	
};



void (entity pl) Angel_PrintRules =
{
	local string st;
	local float fl;

	if (clanbattle == 1) {
		st = infokey(world, "pm");
		if (!st) 
			st = infokey(world, "prematch");
		fl = stof(st) * 60;
		st = ftos(fl);
		sprint(pl, 2, "Clan battle: ÏÎ\nPrematch: ", st, " seconds\n");
		st = infokey(world, "cft");
		if (!st) 
		  st = infokey(world, "ceasefire_time");
		fl = stof(st) * 60;
		st = ftos(fl);
		sprint(pl, 2, "Cease fire: ", st, " seconds\n");
	}
	else 
		sprint(pl, 2, "Clan battle: ÏÆÆ\n");
	if (old_grens) 
		sprint(pl, 2, "ÏÌÄ grenades\n");
	else 
		sprint(pl, 2, "ÎÅ× grenades\n");

	if (sentry_type == 1) 
		sprint(pl, 2, "Sentry: 2.8.1 fixed\n");
	else {
	 if (!sentry_type) 
		sprint(pl, 2, "Sentry: 2.8.1\n");
	  else 
	        sprint(pl, 2, "Sentry: NEW\n");
	}

	if(new_flash)
       		sprint(pl, 2, "New Flash: ÏÎ\n");
       	else 
       		sprint(pl, 2, "New Flash: ÏÆÆ\n");

	if(disable_powerups)
       		sprint(pl, 2, "Powerups: ÏÎ\n");
       	else 
       		sprint(pl, 2, "Powerups: ÏÆÆ\n");

	if(flag_timer)
       		sprint(pl, 2, "Flag Timer: ÏÎ\n");
       	else 
       		sprint(pl, 2, "Flag Timer: ÏÆÆ\n");

	if(snip_fps)
	{
              sprint(pl, 2, "Sniper FPS: ");
              st=ftos(snip_fps);
              sprint(pl, 2, st);
       	      sprint(pl, 2, "\n");

        } else 
       		sprint(pl, 2, "Sniper FPS: ÏÆÆ\n");

	if(snip_range_fix)
       		sprint(pl, 2, "Sniper Range Fix: ÏÎ\n");
       	else 
       		sprint(pl, 2, "Sniper Range Fix: ÏÆÆ\n");

	if(random_tf_spawn)
       		sprint(pl, 2, "Random Team Spawn: ÏÎ\n");
       	else 
       		sprint(pl, 2, "Random Team Spawn: ÏÆÆ\n");


	if (gren2box) 
	{
	  sprint(pl, 2, "Extended Backpack:\n");
	  if(gren2box & #BP_TYPE_HEALTH)
	          sprint(pl, 2, " Drop Health   : ÏÎ\n");
	    else  sprint(pl, 2, " Drop Health   : ÏÆÆ\n");

	  if(gren2box & #BP_TYPE_ARMOR)
	          sprint(pl, 2, " Drop Armor    : ÏÎ\n");
	    else  sprint(pl, 2, " Drop Armor    : ÏÆÆ\n");

	  if(gren2box & #BP_GREN_BYTYPE)
	          sprint(pl, 2, " Drop Grenades : Type-depend\n");
	    else  {
	     if(gren2box & #BP_GREN_BYTYPE)
	          sprint(pl, 2, " Drop Grenades : ÏÎ\n");
	    
	          sprint(pl, 2, " Drop Grenades : ÏÆÆ\n");
	    }
	  if(gren2box & #BP_TYPE_DETPACK)
	          sprint(pl, 2, " Drop Detpack  : ÏÎ\n");
	    else  sprint(pl, 2, " Drop Detpack  : ÏÆÆ\n");
	}else {	    
	sprint(pl, 2, "Extended Backpack: ÏÆÆ\n"); 
	}
	if(disable_grens)	
	{
	 sprint(pl, 2, "Disabled Grenade Types:\n"); 
	 if(disable_grens & #DG_TYPE_NORMAL)
	  sprint(pl, 2, " Normal\n"); 
	 if(disable_grens & #DG_TYPE_CONCUSSION)
	  sprint(pl, 2, " Concussion\n"); 
	 if(disable_grens & #DG_TYPE_NAIL)
	  sprint(pl, 2, " Nail\n"); 
	 if(disable_grens & #DG_TYPE_MIRV)
	  sprint(pl, 2, " Mirv\n"); 
	 if(disable_grens & #DG_TYPE_NAPALM)
	  sprint(pl, 2, " Napalm\n"); 
	 if(disable_grens & #DG_TYPE_FLARE)
	  sprint(pl, 2, " Flare\n"); 
	 if(disable_grens & #DG_TYPE_GAS)
	  sprint(pl, 2, " Gas\n"); 
	 if(disable_grens & #DG_TYPE_EMP)
	  sprint(pl, 2, " Emp\n"); 
	 if(disable_grens & #DG_TYPE_FLASH)
	  sprint(pl, 2, " Flash\n"); 
	 if(disable_grens & #DG_TYPE_CALTROPS)
	  sprint(pl, 2, " Caltrops\n"); 
	 if(disable_grens & #DG_TYPE_DETPACK)
	  sprint(pl, 2, " Detpack\n"); 

//	  sprint(pl, 2, "\n"); 
	}else
	 sprint(pl, 2, "All Grenades Enabled\n"); 

};

