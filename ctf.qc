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

void () TeamFortress_CTF_FlagInfo =
{
 local entity te;

 te = Finditem(1);
 if (te.goal_state == 1) {
  if (self == te.owner) 
   sprint(self, 2, "You have the enemy flag. ");
  else {
   sprint(self, 2, te.owner.netname);
   sprint(self, 2, " has");
   if (self.team_no == 1) 
    sprint(self, 2, " your flag. ");
   else 
    sprint(self, 2, " the enemy flag. ");
  }
 }
 else {
  if (te.origin != te.oldorigin) {
   if (self.team_no == 1) 
    sprint(self, 2, "Your flag is lying about. ");
   else 
    sprint(self, 2, "The enemy flag is lying about. ");
  }
  else {
   if (self.team_no == 1) 
    sprint(self, 2, "Your flag is in your base. ");
   else 
    sprint(self, 2, "The enemy flag is in their base. ");
  }
 }
 te = Finditem(2);
 if (te.goal_state == 1) {
  if (self == te.owner) 
   sprint(self, 2, "You have the enemy flag.\n");
  else {
   sprint(self, 2, te.owner.netname);
   sprint(self, 2, " has");
   if (self.team_no == 2) 
    sprint(self, 2, " your flag.\n");
   else 
    sprint(self, 2, " the enemy flag.\n");
  }
 }
 else {
  if (te.origin != te.oldorigin) {
   if (self.team_no == 2) 
    sprint(self, 2, "Your flag is lying about.\n");
   else 
    sprint(self, 2, "The enemy flag is lying about.\n");
  }
  else {
   if (self.team_no == 2) 
    sprint(self, 2, "Your flag is in your base.\n");
   else 
    sprint(self, 2, "The enemy flag is in their base.\n");
  }
 }
};

