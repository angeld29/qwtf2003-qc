
void (float tno) TeamFortress_TeamSetColor;
void (float tno, float scoretoadd) TeamFortress_TeamIncreaseScore;
float (float tno) TeamFortress_TeamGetLives;
float (float tno) TeamFortress_TeamGetMaxPlayers;
string (float tno) TeamFortress_TeamGetColorString;
float (float tno) TeamFortress_TeamGetIllegalClasses;
string (entity p) TeamFortress_GetSkin;

float () TeamFortress_TeamPutPlayerInTeam =
{
 local float i;
 local float j;
 local float lowest;
 local float likely_team;
 local string st;

 i = 1;
 likely_team = random() * number_of_teams;
 likely_team = ceil(likely_team);
 if (!likely_team) 
  likely_team = number_of_teams;
 lowest = 33;
 while (i < number_of_teams + 1) {
  j = TeamFortress_TeamGetNoPlayers(i);
  if (j < lowest) {
   if (TeamFortress_TeamGetMaxPlayers(i) > j) {
    lowest = j;
    likely_team = i;
   }
  }
  i = i + 1;
 }
 return TeamFortress_TeamSet(likely_team);
};

float (float tno) TeamFortress_TeamGetColor =
{
 if (tno == 1) 
  return 14;
 if (tno == 2) 
  return 5;
 if (tno == 3) 
  return 13;
 if (tno == 4) 
  return 12;
 return 0;
};

float (float tno) TeamFortress_TeamGetTopColor =
{
 if (tno == 1) 
  return tc1;
 if (tno == 2) 
  return tc2;
 if (tno == 3) 
  return tc3;
 if (tno == 4) 
  return tc4;
 return 0;
};

void (float tno) TeamFortress_TeamSetColor =
{
 if (tno == 1) {
  team1col = 14;
  return;
 }
 if (tno == 2) {
  team2col = 5;
  return;
 }
 if (tno == 3) {
  team3col = 13;
  return;
 }
 if (tno == 4) {
  team4col = 12;
  return;
 }
};

string (float tno) GetTeamName =
{
 local string st;

 if (tno == 1) {
  st = infokey(world, "team1");
  if (st == string_null) 
   st = infokey(world, "t1");
  if (st == string_null || st == "") 
   return "blue";
 }
 else {
  if (tno == 2) {
   st = infokey(world, "team2");
   if (st == string_null) 
    st = infokey(world, "t2");
   if (st == string_null || st == "") 
    return "red";
  }
  else {
   if (tno == 3) {
    st = infokey(world, "team3");
    if (st == string_null) 
     st = infokey(world, "t3");
    if (st == string_null || st == "") 
     return "yell";
   }
   else {
    if (tno == 4) {
     st = infokey(world, "team4");
     if (st == string_null) 
      st = infokey(world, "t4");
     if (st == string_null || st == "") 
      return "gren";
    }
    else 
     st = "\"\"";
   }
  }
 }
 return st;
};

void (entity p) SetTeamName =
{
 local string st;

 stuffcmd(p, "team ");
 st = GetTeamName(p.team_no);
 stuffcmd(p, st);
 stuffcmd(p, "\n");
};

float (float tno) TeamFortress_TeamSet =
{
 local string st;
 local float tc;

 if (teamplay < 1) {
  sprint(self, 2, "Teamplay is not On, so FortressTeams are inactive.\n");
  return 0;
 }
 if (tno > number_of_teams && number_of_teams) {
  sprint(self, 2, "There can be only ");
  st = ftos(number_of_teams);
  sprint(self, 2, st);
  sprint(self, 2, " teams on this map.\nTry again\n");
  return 0;
 }
 if (self.team_no > 0) {
  sprint(self, 2, "You're already in Team No ");
  st = ftos(self.team_no);
  sprint(self, 2, st);
  sprint(self, 2, ".\n");
  return 0;
 }
 tc = TeamFortress_TeamGetNoPlayers(tno);
 if (tc >= TeamFortress_TeamGetMaxPlayers(tno)) {
  sprint(self, 2, "That team is full. Pick another.\n");
  return 0;
 }
 if (!TeamFortress_TeamGetColor(tno)) {
  TeamFortress_TeamSetColor(tno);
  if (!TeamFortress_TeamGetColor(tno)) {
   sprint(self, 2, "You can't start a new team with your color, since another ");
   sprint(self, 2, "already using that color. Change your pants color, then try again.\n");
   return 0;
  }
  bprint(2, self.netname);
  bprint(2, " has started Team No ");
  st = ftos(tno);
  bprint(2, st);
  bprint(2, ".\n");
  self.immune_to_check = time + 10;
  if ((toggleflags & 128) || (toggleflags & 2048)) 
   self.frags = TeamFortress_TeamGetScore(tno);
  stuffcmd(self, "color ");

  tc = TeamFortress_TeamGetTopColor(tno);
  st = ftos(tc);
  stuffcmd(self, st);
  stuffcmd(self, " ");

  tc = TeamFortress_TeamGetColor(tno) - 1;
  st = ftos(tc);
  stuffcmd(self, st);

  stuffcmd(self, "\n");
  self.team_no = tno;
  self.lives = TeamFortress_TeamGetLives(tno);
  SetTeamName(self);
  if (!self.playerclass) {
   if (TeamFortress_TeamIsCivilian(self.team_no)) {
    self.impulse = 1;
    TeamFortress_ChangeClass();
   }
  }
  return 1;
 }
 bprint(2, self.netname);
 bprint(2, " has joined Team No ");
 st = ftos(tno);
 bprint(2, st);
 bprint(2, ".\n");
 stuffcmd(self, "color ");

 tc = TeamFortress_TeamGetTopColor(tno);
 st = ftos(tc);
 stuffcmd(self, st);
 stuffcmd(self, " ");

 tc = TeamFortress_TeamGetColor(tno) - 1;
 st = ftos(tc);
 stuffcmd(self, st);

 stuffcmd(self, "\n");
 self.team_no = tno;
 self.immune_to_check = time + 10;
 self.lives = TeamFortress_TeamGetLives(tno);
 if ((toggleflags & 128) || (toggleflags & 2048)) 
  self.frags = TeamFortress_TeamGetScore(tno);
 TeamFortress_TeamShowMemberClasses(self);
 SetTeamName(self);
 if (!self.playerclass) {
  if (TeamFortress_TeamIsCivilian(self.team_no)) {
   self.impulse = 1;
   TeamFortress_ChangeClass();
  }
 }
 return 1;
};

void () TeamFortress_CheckTeamCheats =
{
 local string st;
 local string sk;
 local float tc;

 if (self.immune_to_check > time) 
  return;
 if (self.deadflag) 
  return;
 if (self.netname == string_null) 
  KickCheater(self);
 else {
  if (self.playerclass && !self.team_no && teamplay > 0) 
   KickCheater(self);
 }
 if (self.team_no > 0 && teamplay > 0) {
  st = infokey(self, "bottomcolor");
  tc = stof(st);
  if (self.playerclass == 8 && self.undercover_team) {
   if (TeamFortress_TeamGetColor(self.undercover_team) - 1 != tc) {
    stuffcmd(self, "color ");
    tc = TeamFortress_TeamGetTopColor(self.undercover_team) ;
    st = ftos(tc);
    stuffcmd(self, st);
    stuffcmd(self, " ");

    tc = TeamFortress_TeamGetColor(self.undercover_team) - 1;
    st = ftos(tc);
    stuffcmd(self, st);

    stuffcmd(self, "\n");
    bprint2(1, self.netname, " has been kicked for changing color.\n");
    sprint(self, 2, "You have been kicked for changing your pants color. Don't do it.\n");
    KickCheater(self);
    return;
   }
  }
  else {
   if (tc != TeamFortress_TeamGetColor(self.team_no) - 1) {
    stuffcmd(self, "color ");
    tc = TeamFortress_TeamGetTopColor(self.team_no);
    st = ftos(tc);
    stuffcmd(self, st);
    stuffcmd(self, " ");

    tc = TeamFortress_TeamGetColor(self.team_no) - 1;
    st = ftos(tc);
    stuffcmd(self, st);

    stuffcmd(self, "\n");
    bprint2(1, self.netname, " has been kicked for changing color.\n");
    sprint(self, 2, "You have been kicked for changing your pants color. Don't do it.\n");
    KickCheater(self);
    return;
   }
  }
                if(topcolor_check){
  st = infokey(self, "topcolor");
  tc = stof(st);
  if (self.playerclass == 8 && self.undercover_team) {
   if (TeamFortress_TeamGetTopColor(self.undercover_team) != tc) {
    stuffcmd(self, "color ");

    tc = TeamFortress_TeamGetTopColor(self.undercover_team) ;
    st = ftos(tc);
    stuffcmd(self, st);
    stuffcmd(self, " ");

    tc = TeamFortress_TeamGetColor(self.undercover_team) - 1;
    st = ftos(tc);
    stuffcmd(self, st);

    stuffcmd(self, "\n");
    bprint2(1, self.netname, " has been kicked for changing color.\n");
    sprint(self, 2, "You have been kicked for changing your top color. Don't do it.\n");
    KickCheater(self);
    return;
   }
  }
  else {
   if (tc != TeamFortress_TeamGetTopColor(self.team_no)) {
    stuffcmd(self, "color ");


    tc = TeamFortress_TeamGetTopColor(self.team_no);
    st = ftos(tc);
    stuffcmd(self, st);
    stuffcmd(self, " ");

    tc = TeamFortress_TeamGetColor(self.team_no) - 1;
    st = ftos(tc);
    stuffcmd(self, st);

    stuffcmd(self, "\n");
    bprint2(1, self.netname, " has been kicked for changing color.\n");
    sprint(self, 2, "You have been kicked for changing your top color. Don't do it.\n");
    KickCheater(self);
    return;
   }
   }
  }
  if (self.playerclass) {
   st = infokey(self, "skin");
   tc = 0;
   sk = TeamFortress_GetSkin(self);
   if (st != sk) {
    TeamFortress_SetSkin(self);
    bprint2(1, self.netname, " has been kicked for changing skin.\n");
    sprint(self, 2, "You have been kicked for changing your skin. Don't do it.\n");
    KickCheater(self);
   }
   if (tc == 8) 
    self.playerclass = 8;
  }
  st = GetTeamName(self.team_no);
  if (st != infokey(self, "team")) {
   SetTeamName(self);
   bprint2(1, self.netname, " has been kicked for changing team.\n");
   sprint(self, 2, "You have been kicked for changing your team. Don't do it.\n");
   KickCheater(self);
   return;
  }
 }
};

void (float tno, float scoretoadd) TeamFortress_TeamIncreaseScore =
{
 local entity e;

 if (!tno || !scoretoadd) 
  return;
 if (tno == 1) 
  team1score = team1score + scoretoadd;
 if (tno == 2) 
  team2score = team2score + scoretoadd;
 if (tno == 3) 
  team3score = team3score + scoretoadd;
 if (tno == 4) 
  team4score = team4score + scoretoadd;
 if ((toggleflags & 128) || (toggleflags & 2048)) {
  e = find(world, classname, "player");
  while (e) {
   if (e.team_no == tno) 
    e.frags = TeamFortress_TeamGetScore(tno);
   e = find(e, classname, "player");
  }
 }
};

float (float tno) TeamFortress_TeamGetScore =
{
 if (tno == 1) 
  return team1score;
 if (tno == 2) 
  return team2score;
 if (tno == 3) 
  return team3score;
 if (tno == 4) 
  return team4score;
 return 0;
};

float (float tno) TeamFortress_TeamGetScoreFrags =
{
 if ((toggleflags & 128) || (toggleflags & 2048)) {
  if (tno == 1) 
   return team1score;
  if (tno == 2) 
   return team2score;
  if (tno == 3) 
   return team3score;
  if (tno == 4) 
   return team4score;
 }
 else {
  if (tno == 1) 
   return team1frags;
  if (tno == 2) 
   return team2frags;
  if (tno == 3) 
   return team3frags;
  if (tno == 4) 
   return team4frags;
 }
 return 0;
};

float (float tno) TeamFortress_TeamGetLives =
{
 if (tno == 1) 
  return team1lives;
 if (tno == 2) 
  return team2lives;
 if (tno == 3) 
  return team3lives;
 if (tno == 4) 
  return team4lives;
 return 0;
};

float (float tno) TeamFortress_TeamGetNoPlayers =
{
 local float size_team;
 local entity search;

 search = find(world, classname, "player");
 while (search != world) {
  if (search.team_no == tno) 
   size_team = size_team + 1;
  search = find(search, classname, "player");
 }
 return size_team;
};

float () TeamFortress_GetNoPlayers =
{
 local float nump;
 local entity search;

 search = find(world, classname, "player");
 while (search != world) {
  if (search.netname != string_null) 
   nump = nump + 1;
  search = find(search, classname, "player");
 }
 return nump;
};

float (float tno) TeamFortress_TeamGetMaxPlayers =
{
 if (tno == 1) 
  return team1maxplayers;
 if (tno == 2) 
  return team2maxplayers;
 if (tno == 3) 
  return team3maxplayers;
 if (tno == 4) 
  return team4maxplayers;
 return 0;
};

float () TeamFortress_TeamGetWinner =
{
 local float i;
 local float j;
 local float highest;
 local float highestteam;

 i = 1;
 highest = 0;
 highestteam = 0;
 while (i < number_of_teams + 1) {
  j = TeamFortress_TeamGetScoreFrags(i);
  if (j > highest) {
   highest = j;
   highestteam = i;
  }
  i = i + 1;
 }
 return highestteam;
};

float () TeamFortress_TeamGetSecond =
{
 local float i;
 local float j;
 local float highest;
 local float highestteam;
 local float secondteam;
 local float second;

 i = 1;
 highestteam = TeamFortress_TeamGetWinner();
 highest = TeamFortress_TeamGetScoreFrags(highestteam);
 secondteam = 0;
 second = 0;
 while (i < number_of_teams + 1) {
  j = TeamFortress_TeamGetScoreFrags(i);
  if (j < highest && j > second) {
   second = j;
   secondteam = i;
  }
  i = i + 1;
 }
 return secondteam;
};

void (float all) TeamFortress_TeamShowScores =
{
 local string st;
 local float i;
 local float j;

 i = 1;
 if (all == 2) {
  while (i <= number_of_teams) {
   if (TeamFortress_TeamGetColor(i) > 0) {
    j = TeamFortress_TeamGetScore(i);
    st = TeamFortress_TeamGetColorString(i);
    bprint(2, st);
    bprint(2, ": ");
    st = ftos(j);
    bprint(2, st);
    bprint(2, " ");
   }
   i = i + 1;
  }
  bprint(2, "\n");
  return;
 }
 while (i <= number_of_teams) {
  if (TeamFortress_TeamGetColor(i) > 0) {
   if (all) 
    bprint(2, "Team ");
   else 
    sprint(self, 2, "Team ");
   st = ftos(i);
   if (all) 
    bprint(2, st);
   else 
    sprint(self, 2, st);
   if (all) 
    bprint(2, " (");
   else 
    sprint(self, 2, " (");
   st = TeamFortress_TeamGetColorString(i);
   if (all) 
    bprint(2, st);
   else 
    sprint(self, 2, st);
   if (all) 
    bprint(2, ") : ");
   else 
    sprint(self, 2, ") : ");
   j = TeamFortress_TeamGetScore(i);
   st = ftos(j);
   if (all) 
    bprint(2, st);
   else 
    sprint(self, 2, st);
   if (all) 
    bprint(2, "\n");
   else 
    sprint(self, 2, "\n");
  }
  i = i + 1;
 }
};

string (float tno) TeamFortress_TeamGetColorString =
{
 local float col;

 col = TeamFortress_TeamGetColor(tno);
 if (col == 1) 
  return "White";
 if (col == 2) 
  return "Brown";
 if (col == 3) 
  return "Blue";
 if (col == 4) 
  return "Green";
 if (col == 5) 
  return "Red";
 if (col == 6) 
  return "Tan";
 if (col == 7) 
  return "Pink";
 if (col == 8) 
  return "Orange";
 if (col == 9) 
  return "Purple";
 if (col == 10) 
  return "DarkPurple";
 if (col == 11) 
  return "Grey";
 if (col == 12) 
  return "DarkGreen";
 if (col == 13) 
  return "Yellow";
 return "DarkBlue";
};

void (entity Player) TeamFortress_TeamShowMemberClasses =
{
 local entity e;
 local float found;

 found = 0;
 e = find(world, classname, "player");
 while (e) {
  if ((e.team_no == Player.team_no || !e.team_no) && e != Player) {
   if (e.model != string_null) {
    if (!found) {
     found = 1;
     sprint(self, 2, "The other members of your team are:\n");
    }
    sprint(Player, 2, e.netname);
    sprint(Player, 2, " : ");
    TeamFortress_PrintClassName(Player, e.playerclass, e.tfstate & 8);
   }
  }
  e = find(e, classname, "player");
 }
 if (!found) 
  sprint(Player, 2, "There are no other players on your team.\n");
};

void () CalculateTeamEqualiser =
{
 local float t1;
 local float t2;
 local float t3;
 local float t4;
 local float t_ave;
 local float calc;

 team1advantage = 1;
 team2advantage = 1;
 team3advantage = 1;
 team4advantage = 1;
 if (number_of_teams < 2) {
  self.nextthink = time + 60;
  return;
 }
 if (teamplay & 32) {
  t1 = TeamFortress_TeamGetNoPlayers(1);
  t2 = TeamFortress_TeamGetNoPlayers(2);
  t3 = TeamFortress_TeamGetNoPlayers(3);
  t4 = TeamFortress_TeamGetNoPlayers(4);
  if (t1 + t2 + t3 + t4 < 1) {
   self.nextthink = time + 30;
   return;
  }
  t_ave = (t1 + t2 + t3 + t4) / number_of_teams;
  if (t1 > 0) {
   calc = t_ave / t1 - 1;
   if (calc) 
    calc = calc / 3 + 1;
   else 
    calc = calc + 1;
   team1advantage = calc;
  }
  if (t2 > 0 && number_of_teams >= 2) {
   calc = t_ave / t2 - 1;
   if (calc) 
    calc = calc / 3 + 1;
   else 
    calc = calc + 1;
   team2advantage = calc;
  }
  if (t3 > 0 && number_of_teams >= 3) {
   calc = t_ave / t3 - 1;
   if (calc) 
    calc = calc / 3 + 1;
   else 
    calc = calc + 1;
   team3advantage = calc;
  }
  if (t4 > 0 && number_of_teams >= 4) {
   calc = t_ave / t4 - 1;
   if (calc) 
    calc = calc / 3 + 1;
   else 
    calc = calc + 1;
   team4advantage = calc;
  }
 }
 if (teamplay & 64) {
  t1 = team1score + 60;
  if (number_of_teams >= 2) 
   t2 = team2score + 60;
  else 
   t2 = 0;
  if (number_of_teams >= 3) 
   t3 = team3score + 60;
  else 
   t3 = 0;
  if (number_of_teams >= 4) 
   t4 = team4score + 60;
  else 
   t4 = 0;
  t_ave = (t2 + t3 + t4) / (number_of_teams - 1);
  calc = t_ave / t1 - 1;
  if (calc) 
   calc = calc / 3 + 1;
  else 
   calc = calc + 1;
  team1advantage = calc * team1advantage;
  if (number_of_teams >= 2) {
   t_ave = (t1 + t3 + t4) / (number_of_teams - 1);
   calc = t_ave / t2 - 1;
   if (calc) 
    calc = calc / 3 + 1;
   else 
    calc = calc + 1;
   team2advantage = calc * team2advantage;
  }
  if (number_of_teams >= 3) {
   t_ave = (t2 + t1 + t4) / (number_of_teams - 1);
   calc = t_ave / t3 - 1;
   if (calc) 
    calc = calc / 3 + 1;
   else 
    calc = calc + 1;
   team3advantage = calc * team3advantage;
  }
  if (number_of_teams >= 4) {
   t_ave = (t2 + t3 + t1) / (number_of_teams - 1);
   calc = t_ave / t4 - 1;
   if (calc) 
    calc = calc / 3 + 1;
   else 
    calc = calc + 1;
   team4advantage = calc * team4advantage;
  }
 }
 self.nextthink = time + 10;
};

void () SetupTeamEqualiser =
{
 local entity TE;

 team1advantage = 1;
 team2advantage = 1;
 team3advantage = 1;
 team4advantage = 1;
 if (!(teamplay & (32 | 64))) 
  return;
 TE = spawn();
 TE.classname = "Team Equaliser";
 TE.think = CalculateTeamEqualiser;
 TE.nextthink = time + 30;
};

float (entity targ, entity attacker, float damage) TeamEqualiseDamage =
{
 local float adv;
 local float newdam;

 if (targ.classname != "player" || attacker.classname != "player") 
  return damage;
 if (!targ.team_no || !attacker.team_no || attacker.team_no == targ.team_no) 
  return damage;
 if (attacker.team_no == 1) 
  adv = team1advantage;
 else {
  if (attacker.team_no == 2) 
   adv = team2advantage;
  else {
   if (attacker.team_no == 3) 
    adv = team3advantage;
   else {
    if (attacker.team_no == 4) 
     adv = team4advantage;
   }
  }
 }
 if (!adv) {
  dprint("There is a team with an advantage of 0\n");
  adv = 0.1;
 }
 newdam = damage * adv;
 if (targ.team_no == 1) 
  adv = team1advantage;
 else {
  if (targ.team_no == 2) 
   adv = team2advantage;
  else {
   if (targ.team_no == 3) 
    adv = team3advantage;
   else {
    if (targ.team_no == 4) 
     adv = team4advantage;
   }
  }
 }
 if (!adv) {
  dprint("There is a team with an advantage of 0\n");
  adv = 0.1;
 }
 newdam = newdam * 1 / adv;
 return newdam;
};

void () TeamFortress_StatusQuery =
{
 local float ft;
 local string st;

 sprint(self, 2, "players per team: ");
 ft = TeamFortress_TeamGetNoPlayers(1);
 st = ftos(ft);
 sprint(self, 2, st);
 sprint(self, 2, "  ");
 ft = TeamFortress_TeamGetNoPlayers(2);
 st = ftos(ft);
 sprint(self, 2, st);
 sprint(self, 2, "  ");
 ft = TeamFortress_TeamGetNoPlayers(3);
 st = ftos(ft);
 sprint(self, 2, st);
 sprint(self, 2, "  ");
 ft = TeamFortress_TeamGetNoPlayers(4);
 st = ftos(ft);
 sprint(self, 2, st);
 sprint(self, 2, "\n");
 sprint(self, 2, "    equalisation: ");
 st = ftos(team1advantage);
 sprint(self, 2, st);
 sprint(self, 2, "  ");
 st = ftos(team2advantage);
 sprint(self, 2, st);
 sprint(self, 2, "  ");
 st = ftos(team3advantage);
 sprint(self, 2, st);
 sprint(self, 2, "  ");
 st = ftos(team4advantage);
 sprint(self, 2, st);
 sprint(self, 2, "\n");
 st = ftos(teamplay);
 sprint(self, 2, "Teamplay is ");
 sprint(self, 2, st);
 sprint(self, 2, "\n");
};

float (float tno) TeamFortress_TeamGetIllegalClasses =
{
 if (tno == 1) 
  return illegalclasses1;
 if (tno == 2) 
  return illegalclasses2;
 if (tno == 3) 
  return illegalclasses3;
 if (tno == 4) 
  return illegalclasses4;
 return 0;
};

float (float tno) TeamFortress_TeamIsCivilian =
{
 local entity te;

 if (tno == 1) {
  if (civilianteams & 1) 
   return 1;
 }
 else {
  if (tno == 2) {
   if (civilianteams & 2) 
    return 1;
  }
  else {
   if (tno == 3) {
    if (civilianteams & 4) 
     return 1;
   }
   else {
    if (civilianteams & 8) 
     return 1;
   }
  }
 }
 return 0;
};

float (float tno, float pc) ClassIsRestricted =
{
 local float num;
 local float max;
 local entity te;
 local string st;

 if (!tno) 
  return 0;
 if (pc == 1) {
  st = infokey(world, "cr_sc");
  if (st == string_null) 
   st = infokey(world, "cr_scout");
  max = stof(st);
 }
 else {
  if (pc == 2) {
   st = infokey(world, "cr_sn");
   if (st == string_null) 
    st = infokey(world, "cr_sniper");
   max = stof(st);
  }
  else {
   if (pc == 3) {
    st = infokey(world, "cr_so");
    if (st == string_null) 
     st = infokey(world, "cr_soldier");
    max = stof(st);
   }
   else {
    if (pc == 4) {
     st = infokey(world, "cr_de");
     if (st == string_null) 
      st = infokey(world, "cr_demoman");
     max = stof(st);
    }
    else {
     if (pc == 5) {
      st = infokey(world, "cr_me");
      if (st == string_null) 
       st = infokey(world, "cr_medic");
      max = stof(st);
     }
     else {
      if (pc == 6) {
       st = infokey(world, "cr_hw");
       if (st == string_null) 
        st = infokey(world, "cr_hwguy");
       max = stof(st);
      }
      else {
       if (pc == 7) {
        st = infokey(world, "cr_py");
        if (st == string_null) 
         st = infokey(world, "cr_pyro");
        max = stof(st);
       }
       else {
        if (pc == 8) {
         st = infokey(world, "cr_sp");
         if (st == string_null) 
          st = infokey(world, "cr_spy");
         max = stof(st);
        }
        else {
         if (pc == 9) {
          st = infokey(world, "cr_en");
          if (st == string_null) 
           st = infokey(world, "cr_engineer");
          max = stof(st);
         }
         else {
          if (pc == 10) {
           st = infokey(world, "cr_ra");
           if (st == string_null) 
            st = infokey(world, "cr_random");
           max = stof(st);
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
 if (max > 0) {
  num = 0;
  te = find(world, classname, "player");
  while (te) {
   if (te.team_no == tno) {
    if (pc == 10) {
     if (te.tfstate & 8) 
      num = num + 1;
    }
    else {
     if (te.playerclass == pc || te.nextpc == pc) {
      if (!(te.tfstate & 8)) 
       num = num + 1;
     }
    }
   }
   te = find(te, classname, "player");
  }
  if (num >= max) 
   return 1;
 }
 if (max == -1) 
  return 1;
 return 0;
};

void (float tno, entity ignore, string st) teamsprint =
{
 local entity te;

 if (!tno) 
  return;
 te = find(world, classname, "player");
 while (te) {
  if (te.team_no == tno && te != ignore) 
   sprint(te, 2, st);
  te = find(te, classname, "player");
 }
};

