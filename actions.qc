void () TeamFortress_Discard =
{
	newmis = spawn();
	if (self.playerclass == 1) 
		newmis.ammo_rockets = self.ammo_rockets;
	else {
		if (self.playerclass == 2) {
			newmis.ammo_rockets = self.ammo_rockets;
			newmis.ammo_cells = self.ammo_cells;
		}
		else {
			if (self.playerclass == 3) {
				newmis.ammo_cells = self.ammo_cells;
				newmis.ammo_nails = self.ammo_nails;
			}
			else {
				if (self.playerclass == 4) {
					newmis.ammo_cells = self.ammo_cells;
					newmis.ammo_nails = self.ammo_nails;
				}
				else {
					if (self.playerclass == 5) {
						newmis.ammo_rockets = self.ammo_rockets;
						newmis.ammo_cells = self.ammo_cells;
					}
					else {
						if (self.playerclass == 6) {
							newmis.ammo_rockets = self.ammo_rockets;
							newmis.ammo_nails = self.ammo_nails;
						}
						else {
							if (self.playerclass == 7) 
								newmis.ammo_nails = self.ammo_nails;
							else {
								if (self.playerclass == 8) 
									newmis.ammo_rockets = self.ammo_rockets;
								else {
									if (self.playerclass == 9) 
										newmis.ammo_rockets = self.ammo_rockets;
								}
							}
						}
					}
				}
			}
		}
	}
	if (!(newmis.ammo_shells + newmis.ammo_nails + newmis.ammo_rockets + newmis.ammo_cells)) {
		dremove(newmis);
		return;
	}
	if (newmis.ammo_shells) 
		self.ammo_shells = 0;
	if (newmis.ammo_nails) 
		self.ammo_nails = 0;
	if (newmis.ammo_rockets) 
		self.ammo_rockets = 0;
	if (newmis.ammo_cells) 
		self.ammo_cells = 0;
	W_SetCurrentAmmo();
	sound(self, 3, "weapons/lock4.wav", 1, 1);
	if (self.team_no) {
		increment_team_ammoboxes(self.team_no);
		if (num_team_ammoboxes(self.team_no) > 20 / number_of_teams) 
			RemoveOldAmmobox(self.team_no);
	}
	else {
		num_world_ammoboxes = num_world_ammoboxes + 1;
		if (num_world_ammoboxes > 20) 
			RemoveOldAmmobox(0);
	}
	newmis.enemy = self;
	newmis.health = time;
	newmis.weapon = 0;
	newmis.movetype = 6;
	newmis.solid = 1;
	newmis.classname = "ammobox";
	newmis.team_no = self.team_no;
	makevectors(self.v_angle);
	if (self.v_angle_x) 
		newmis.velocity = v_forward * 400 + v_up * 200;
	else {
		newmis.velocity = aim(self, 10000);
		newmis.velocity = newmis.velocity * 400;
		newmis.velocity_z = 200;
	}
	newmis.avelocity = '0 300 0';
	setsize(newmis, '0 0 0', '0 0 0');
	setorigin(newmis, self.origin);
	newmis.nextthink = time + 30;
	newmis.think = SUB_Remove;
	newmis.touch = TeamFortress_AmmoboxTouch;
	setmodel(newmis, "progs/backpack.mdl");
};

void () TeamFortress_SaveMe =
{
	local entity te;
	local entity tl;

	if (self.last_saveme_sound < time) {
		if (random() < 0.8) 
			sound(self, 1, "speech/saveme1.wav", 1, 1);
		else 
			sound(self, 1, "speech/saveme2.wav", 1, 1);
		self.last_saveme_sound = time + 4;
	}
	te = find(world, classname, "player");
	while (te) {
		if (self == te || te.playerclass == 5 || te.playerclass == 9 || te.playerclass == 8) {
			if ((te.team_no == self.team_no && self.team_no) || te.playerclass == 8) {
				if (visible(te)) {
					msg_entity = te;
					tl = spawn();
					tl.origin = self.origin;
					tl.origin_z = tl.origin_z + 32;
					WriteByte(1, 23);
					WriteByte(1, 9);
					WriteEntity(1, tl);
					WriteCoord(1, tl.origin_x);
					WriteCoord(1, tl.origin_y);
					WriteCoord(1, tl.origin_z + 24);
					WriteCoord(1, self.origin_x);
					WriteCoord(1, self.origin_y);
					WriteCoord(1, self.origin_z);
					dremove(tl);
				}
			}
		}
		te = find(te, classname, "player");
	}
};

void () TeamFortress_ID =
{
	local vector src;
	local string st,st_s,st_r;
	local string cls;
	local entity te;

	src = self.origin + v_forward * 10;
	src_z = self.absmin_z + self.size_z * 0.7;
	traceline(src, src + v_forward * 2048, 0, self);
	if (trace_ent != world && trace_ent.origin != world.origin) {
		if (trace_ent.classname == "player" && trace_ent.health > 0) {
//angel fix
			if (trace_ent.is_feigning && self.team_no && self.team_no != trace_ent.team_no) 
				return;
//////////
			self.StatusRefreshTime = time + 1.5;
			if (self.team_no && self.team_no == trace_ent.team_no) {
				cls = TeamFortress_GetClassName(trace_ent.playerclass);
				if (self.playerclass == 5) {
					st = NumberToString1000(trace_ent.health);
					centerprint(self, "\n\n\n\n", trace_ent.netname, "\nFriendly ", cls, "\n", st, " health\n");
					return;
				}
				else {
					if (self.playerclass == 9) {
						st = NumberToString1000(trace_ent.armorvalue);
						centerprint(self, "\n\n\n\n", trace_ent.netname, "\nFriendly ", cls, "\n", st, " armor\n");
						return;
					}
				}
				centerprint(self, "\n\n\n\n", trace_ent.netname, "\nFriendly ", cls);
				return;
			}
			if (trace_ent.playerclass == 8) {
				cls = TeamFortress_GetClassName(trace_ent.undercover_skin);
				if (self.team_no && self.team_no == trace_ent.undercover_team) {
					if (self.playerclass == 5) {
						st = NumberToString1000(trace_ent.health);
						if (trace_ent.undercover_skin) 
							centerprint(self, "\n\n\n\n", trace_ent.undercover_name, "\nFriendly ", cls, "\n", st, " health\n");
						else 
							centerprint(self, "\n\n\n\n", trace_ent.undercover_name, "\nFriendly Spy\n", st, " health\n");
						return;
					}
					else {
						if (self.playerclass == 9) {
							st = NumberToString1000(trace_ent.armorvalue);
							if (trace_ent.undercover_skin) 
								centerprint(self, "\n\n\n\n", trace_ent.undercover_name, "\nFriendly ", cls, "\n", st, " armor\n");
							else 
								centerprint(self, "\n\n\n\n", trace_ent.undercover_name, "\nFriendly Spy\n", st, " armor\n");
							return;
						}
						else {
							st = NumberToString1000(trace_ent.armorvalue);
							if (trace_ent.undercover_skin) 
								centerprint(self, "\n\n\n\n", trace_ent.undercover_name, "\nFriendly ", cls);
							else 
								centerprint(self, "\n\n\n\n", trace_ent.undercover_name, "\nFriendly Spy\n");
							return;
						}
					}
				}
				if (trace_ent.undercover_name != string_null) {
					if (trace_ent.undercover_skin) 
						centerprint(self, "\n\n\n\n", trace_ent.undercover_name, "\nEnemy ", cls);
					else 
						centerprint(self, "\n\n\n\n", trace_ent.undercover_name, "\nEnemy Spy");
				}
				else {
					if (trace_ent.undercover_skin) 
						centerprint(self, "\n\n\n\n", trace_ent.netname, "\nEnemy ", cls);
					else 
						centerprint(self, "\n\n\n\n", trace_ent.netname, "\nEnemy Spy");
				}
			}
			else {
				cls = TeamFortress_GetClassName(trace_ent.playerclass);
				centerprint(self, "\n\n\n\n", trace_ent.netname, "\nEnemy ", cls);
			}
		}
		else {
			if (trace_ent.classname == "building_dispenser") {
				self.StatusRefreshTime = time + 1.5;
				if (self == trace_ent.real_owner) 
				{
                                        st = NumberToString1000(trace_ent.health);
					centerprint(self, "\n\n\n\nYour Dispenser\nHealth: ",st);
				}	
				else 
				{
                                  if (self.team_no && self.team_no == trace_ent.team_no)  {
                                        st = NumberToString1000(trace_ent.health);
					centerprint(self, "\n\n\n\nDispenser made by ", trace_ent.real_owner.netname,"\nHealth: ",st);                                  
				  }
                                  else
					centerprint(self, "\n\n\n\nDispenser made by ", trace_ent.real_owner.netname);
				}
			}
			else {
				if (trace_ent.classname == "building_sentrygun" || trace_ent.classname == "building_sentrygun_base") {
				        if(trace_ent.classname == "building_sentrygun_base")
				        {
				         te = find(world, classname, "building_sentrygun");
				         while(te.real_owner != trace_ent.real_owner)
 				          te = find(world, classname, "building_sentrygun");
 				          if(!te)te = trace_ent;
				        }else te = trace_ent;
					self.StatusRefreshTime = time + 1.5;
					if (self == trace_ent.real_owner) {
//angel fix					    
                                               if( self.playerclass == 9)
                                               {
                                                st = NumberToString1000(te.health);
                                                st_s = NumberToString1000(te.ammo_shells);
                                                if(te.weapon != 3)
                                                centerprint(self, "\n\n\nYour SentryGun\nHealth: ",st,"\nAmmo: ",st_s);
                                                else
                                                {
                                                 st_r = NumberToString1000(te.ammo_rockets);
                                                 centerprint(self, "\n\n\nYour SentryGun\nHealth: ",st,"\nAmmo: ",st_s,st_r);
                                                }
                                               }
                                               else 
                                                 centerprint(self, "\n\n\n\nYour SentryGun");
                                               
					     }	
					else {
						if (!teamplay) 
							centerprint(self, "\n\n\n\nSentrygun made by\n", trace_ent.real_owner.netname);
						else {
							if (self.team_no && self.team_no == trace_ent.team_no) 
							{
                                                         if( self.playerclass == 9) {
                                                          st = NumberToString1000(te.health);
                                                          st_s = NumberToString1000(te.ammo_shells);
                                                          if(te.weapon!=3)
                                                          centerprint(self, "\n\n\nFriendly Sentrygun made by\n", trace_ent.real_owner.netname,"\nHealth: ",st,"\nAmmo: ",st_s);
                                                          else {
                                                           st_r = NumberToString1000(te.ammo_rockets);
                                                           centerprint(self, "\n\n\nFriendly Sentrygun made by\n", trace_ent.real_owner.netname,"\nHealth: ",st,"\nAmmo: ",st_s,st_r);
                                                          }
                                                         }
                                                         else
								centerprint(self, "\n\n\n\nFriendly Sentrygun made by\n", trace_ent.real_owner.netname);
						        }
							else 
								centerprint(self, "\n\n\n\nEnemy Sentrygun made by\n", trace_ent.real_owner.netname);
						}
					}
				}
			}
		}
	}
};


void () TeamFortress_ReloadCurrentWeapon =
{
	local float rt;
	local entity tWeapon;

	if (self.tfstate & 2) 
		return;
	if (self.current_weapon == 128) {
		if (!self.ammo_shells) {
			sprint(self, 2, "out of shells.\n");
			return;
		}
		if (!self.reload_shotgun) {
			sprint(self, 2, "clip full.\n");
			return;
		}
		if (8 - self.reload_shotgun == self.ammo_shells) {
			sprint(self, 2, "all shells are in the clip.\n");
			return;
		}
		if (self.reload_shotgun < self.ammo_shells) {
			Attack_Finished(0.4);
			rt = (8 - self.reload_shotgun) / 8;
			rt = 2 - 2 * rt;
			self.reload_shotgun = 0;
			if (self.ammo_shells < 8) 
				self.reload_shotgun = 8 - self.ammo_shells;
			sprint(self, 2, "reloading...\n");
			self.tfstate = self.tfstate | 2;
			tWeapon = spawn();
			tWeapon.owner = self;
			tWeapon.classname = "timer";
			tWeapon.nextthink = time + rt;
			tWeapon.think = W_Reload_shotgun;
			self.weaponmodel = "";
			self.weaponframe = 0;
		}
		else 
			sprint(self, 2, "not enough ammo to reload\n");
	}
	else {
		if (self.current_weapon == 256) {
			if (!self.ammo_shells) {
				sprint(self, 2, "out of shells.\n");
				return;
			}
			if (!self.reload_super_shotgun) {
				sprint(self, 2, "clip full.\n");
				return;
			}
			if (16 - self.reload_super_shotgun == self.ammo_shells) {
				sprint(self, 2, "all shells are in the clip.\n");
				return;
			}
			if (self.reload_super_shotgun < self.ammo_shells) {
				Attack_Finished(0.7);
				rt = (16 - self.reload_super_shotgun) / 16;
				rt = 3 - 3 * rt;
				self.reload_super_shotgun = 0;
				if (self.ammo_shells < 16) 
					self.reload_super_shotgun = 16 - self.ammo_shells;
				sprint(self, 2, "reloading...\n");
				self.tfstate = self.tfstate | 2;
				tWeapon = spawn();
				tWeapon.owner = self;
				tWeapon.classname = "timer";
				tWeapon.nextthink = time + rt;
				tWeapon.think = W_Reload_super_shotgun;
				self.weaponmodel = "";
				self.weaponframe = 0;
			}
			else 
				sprint(self, 2, "not enough ammo to reload\n");
		}
		else {
			if (self.current_weapon == 2048) {
				if (!self.ammo_rockets) {
					sprint(self, 2, "out of grenades.\n");
					return;
				}
				if (!self.reload_grenade_launcher) {
					sprint(self, 2, "clip full.\n");
					return;
				}
				if (6 - self.reload_grenade_launcher == self.ammo_rockets) {
					sprint(self, 2, "all grenades are in the clip.\n");
					return;
				}
				if (self.reload_grenade_launcher < self.ammo_rockets) {
					Attack_Finished(0.6);
					rt = (6 - self.reload_grenade_launcher) / 6;
					rt = 4 - 4 * rt;
					self.reload_grenade_launcher = 0;
					if (self.ammo_rockets < 6) 
						self.reload_grenade_launcher = 6 - self.ammo_rockets;
					sprint(self, 2, "reloading...\n");
					self.tfstate = self.tfstate | 2;
					tWeapon = spawn();
					tWeapon.owner = self;
					tWeapon.classname = "timer";
					tWeapon.nextthink = time + rt;
					tWeapon.think = W_Reload_grenade_launcher;
					self.weaponmodel = "";
					self.weaponframe = 0;
				}
				else 
					sprint(self, 2, "not enough ammo to reload\n");
			}
			else {
				if (self.current_weapon == 8192) {
					if (!self.ammo_rockets) {
						sprint(self, 2, "out of rockets.\n");
						return;
					}
					if (!self.reload_rocket_launcher) {
						sprint(self, 2, "clip full.\n");
						return;
					}
					if (4 - self.reload_rocket_launcher == self.ammo_rockets) {
						sprint(self, 2, "all rockets are in the clip.\n");
						return;
					}
					if (self.reload_rocket_launcher < self.ammo_rockets) {
						Attack_Finished(0.8);
						rt = (4 - self.reload_rocket_launcher) / 4;
						rt = 5 - 5 * rt;
						self.reload_rocket_launcher = 0;
						if (self.ammo_rockets < 4) 
							self.reload_rocket_launcher = 4 - self.ammo_rockets;
						sprint(self, 2, "reloading...\n");
						self.tfstate = self.tfstate | 2;
						tWeapon = spawn();
						tWeapon.owner = self;
						tWeapon.classname = "timer";
						tWeapon.nextthink = time + rt;
						tWeapon.think = W_Reload_rocket_launcher;
						self.weaponmodel = "";
						self.weaponframe = 0;
					}
				}
			}
		}
	}
};

