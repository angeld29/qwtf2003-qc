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

#define SI_DETPIPE 1
#define SI_THROWGREN 2
#define SI_PRIMEONE 4
#define SI_PRIMETWO 8
#define SI_DISCARD 16  // fixme: do not save discard?
#define SI_INV 32
#define SI_ID 64
#define SI_SPECIAL 128
#define SI_RELOAD 256

void () Angel_SaveImpulse = {
 if (self.impulse <= 9)
 {
   if (self.current_weapon == 8)
    return;
  self.imp1=self.impulse;
  self.impulse = 0;
  return;
 }
 if (self.impulse == 152 && (self.tfstate & #TFSTATE_GRENPRIMED))
  self.tf_impulse = self.tf_impulse | #SI_THROWGREN;
 else if (self.impulse == 170)
  self.tf_impulse = self.tf_impulse | #SI_DETPIPE;
 else if (self.impulse == 171)
  self.tf_impulse = self.tf_impulse | #SI_SPECIAL;
 else if (self.impulse == 173)
  self.tf_impulse = self.tf_impulse | #SI_RELOAD;
 else if (self.impulse == 184)
  self.tf_impulse = self.tf_impulse | #SI_DISCARD;
 else if (self.impulse == 150 && !(self.tfstate & #TFSTATE_GRENPRIMED))
 {
  self.tf_impulse = self.tf_impulse - (self.tf_impulse & #SI_PRIMETWO);
  self.tf_impulse = self.tf_impulse | #SI_PRIMEONE;
 }else 
 if (self.impulse == 151 && !(self.tfstate & #TFSTATE_GRENPRIMED)) {
  self.tf_impulse = self.tf_impulse - (self.tf_impulse & #SI_PRIMEONE);
  self.tf_impulse = self.tf_impulse | #SI_PRIMETWO;
 }
 else
    return;    // do not save impulse
 self.impulse = 0;  // reset impulse, chto by ne bylo gemora

}
float () Angel_GetSavedImpulse ={
 local float saved;

// if (saved)
//  return saved;
 
 // throwgren MUST be after priming;
 // special and reload MUST BE LAST!!!
 if (self.tf_impulse & #SI_PRIMEONE)
 {
   self.tf_impulse = self.tf_impulse - (self.tf_impulse & #SI_PRIMEONE);
  return 150;
 }
 else if (self.tf_impulse & #SI_PRIMETWO)
 {
   self.tf_impulse = self.tf_impulse - (self.tf_impulse & #SI_PRIMETWO);
  return 151;
 }
 else if (self.tf_impulse & #SI_THROWGREN)
 {
   self.tf_impulse = self.tf_impulse - (self.tf_impulse & #SI_THROWGREN);
  return 152;
 }
 else if (self.tf_impulse & #SI_DETPIPE)
 {
   self.tf_impulse = self.tf_impulse - (self.tf_impulse & #SI_DETPIPE);
  return 170;
 }
 else if (self.imp1){
   saved = self.imp1;
   self.imp1 = 0;
   return saved;
  }else 
 if (self.tf_impulse & #SI_DISCARD)
 {
   self.tf_impulse = self.tf_impulse - (self.tf_impulse & #SI_DISCARD);
  return 184;
 }
 else if (self.tf_impulse & #SI_SPECIAL)
 {
   self.tf_impulse = self.tf_impulse - (self.tf_impulse & #SI_SPECIAL);
  return 171;
 }
 else if (self.tf_impulse & #SI_RELOAD)
 {
   self.tf_impulse = self.tf_impulse - (self.tf_impulse & #SI_RELOAD);
  return 173;
 }
/* if (self.imp1){
   saved = self.imp1;
   self.imp1 = 0;
   return saved;
  }*/

 return 0;
}
void () Omi_SaveImpulse = {

 // save weapon impulse
 if (self.impulse <= 9)
 {
   if (self.current_weapon == 8)
   return;
   if (!self.imp1)
  {
    self.imp1 = self.impulse;
   self.impulse = 0;
  }
  else if (!self.imp2)
  {
    self.imp2 = self.imp1;
   self.imp1 = self.impulse;
   self.impulse = 0;
  }
  else if (!self.imp3)
  {
   if ((self.impulse != self.imp1) && (self.impulse != self.imp2))
   {
     self.imp3 = self.imp2;
     self.imp2 = self.imp1;
    self.imp1 = self.impulse;
    self.impulse = 0;
   }
  }
  else if (!self.imp4)
  {
   if ((self.impulse != self.imp2) && (self.impulse != self.imp3))
   {
     self.imp4 = self.imp3;
     self.imp3 = self.imp2;
     self.imp2 = self.imp1;
    self.imp1 = self.impulse;
    self.impulse = 0;
   }
  }
   self.impulse = 0;
//  if (self.current_weapon != 8)
//   Omi_PreChangeWeapon(self.weapon_impulse);
  return;
 }
 // save tf impulse
 if (self.impulse == 152)
  self.tf_impulse = self.tf_impulse | #SI_THROWGREN;
 else if (self.impulse == 170)
  self.tf_impulse = self.tf_impulse | #SI_DETPIPE;
 else if (self.impulse == 171)
  self.tf_impulse = self.tf_impulse | #SI_SPECIAL;
 else if (self.impulse == 173)
  self.tf_impulse = self.tf_impulse | #SI_RELOAD;
 else if (self.impulse == 184)
  self.tf_impulse = self.tf_impulse | #SI_DISCARD;
 else if (self.impulse == 150)
 {
  self.tf_impulse = self.tf_impulse - (self.tf_impulse & #SI_PRIMETWO);
  self.tf_impulse = self.tf_impulse | #SI_PRIMEONE;
 }
 else if (self.impulse == 151) {
  self.tf_impulse = self.tf_impulse - (self.tf_impulse & #SI_PRIMEONE);
  self.tf_impulse = self.tf_impulse | #SI_PRIMETWO;
 }
 else
    return;    // do not save impulse
 self.impulse = 0;  // reset impulse, chto by ne bylo gemora
};

float () Omi_GetSavedImpulse =
{
 local float saved;

 if (self.imp4)
  saved = self.imp4;
  self.imp4 = 0;
 if (self.imp3)
  saved = self.imp3;
  self.imp3 = 0;
 if (self.imp2)
  saved = self.imp2;
  self.imp2 = 0;
 if (self.imp1)
  saved = self.imp1;
  self.imp1 = 0;
 if (saved)
  return saved;
 
 // throwgren MUST be after priming;
 // special and reload MUST BE LAST!!!
 if (self.tf_impulse & #SI_PRIMEONE)
 {
   self.tf_impulse = self.tf_impulse - (self.tf_impulse & #SI_PRIMEONE);
  return 150;
 }
 else if (self.tf_impulse & #SI_PRIMETWO)
 {
   self.tf_impulse = self.tf_impulse - (self.tf_impulse & #SI_PRIMETWO);
  return 151;
 }
 else if (self.tf_impulse & #SI_THROWGREN)
 {
   self.tf_impulse = self.tf_impulse - (self.tf_impulse & #SI_THROWGREN);
  return 152;
 }
 else if (self.tf_impulse & #SI_DETPIPE)
 {
   self.tf_impulse = self.tf_impulse - (self.tf_impulse & #SI_DETPIPE);
  return 170;
 }
 else if (self.tf_impulse & #SI_DISCARD)
 {
   self.tf_impulse = self.tf_impulse - (self.tf_impulse & #SI_DISCARD);
  return 184;
 }
 else if (self.tf_impulse & #SI_SPECIAL)
 {
   self.tf_impulse = self.tf_impulse - (self.tf_impulse & #SI_SPECIAL);
  return 171;
 }
 else if (self.tf_impulse & #SI_RELOAD)
 {
   self.tf_impulse = self.tf_impulse - (self.tf_impulse & #SI_RELOAD);
  return 173;
 }

 return 0;
};