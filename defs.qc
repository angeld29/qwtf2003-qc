//
// constants
//
// edict.flags
#define FL_FLY 1 
#define FL_SWIM 2 
#define FL_CLIENT 8  // set for all client edicts
#define FL_INWATER 16  // for enter / leave water splash
#define FL_MONSTER 32 
#define FL_GODMODE 64  // player cheat
#define FL_NOTARGET 128  // player cheat
#define FL_ITEM 256  // extra wide size for bonus items
#define FL_ONGROUND 512  // standing on something
#define FL_PARTIALGROUND 1024  // not all corners are valid
#define FL_WATERJUMP 2048  // player jumping out of water
#define FL_JUMPRELEASED 4096  // for jump debouncing

// edict.movetype values
#define MOVETYPE_NONE   0  // never moves
//#define MOVETYPE_ANGLENOCLIP 1 
//#define MOVETYPE_ANGLECLIP 2 
#define MOVETYPE_WALK   3  // players only
#define MOVETYPE_STEP   4  // discrete, not real time unless fall
#define MOVETYPE_FLY   5 
#define MOVETYPE_TOSS   6  // gravity
#define MOVETYPE_PUSH   7  // no clip to world, push and crush
#define MOVETYPE_NOCLIP   8 
#define MOVETYPE_FLYMISSILE  9  // fly with extra size against monsters
#define MOVETYPE_BOUNCE   10 
#define MOVETYPE_BOUNCEMISSILE 11  // bounce with extra size

// edict.solid values
#define SOLID_NOT  0  // no interaction with other objects
#define SOLID_TRIGGER 1  // touch on edge, but not blocking
#define SOLID_BBOX  2  // touch on edge, block
#define SOLID_SLIDEBOX 3  // touch on edge, but not an onground
#define SOLID_BSP  4  // bsp clip, touch on edge, block

// range values
#define RANGE_MELEE 0 
#define RANGE_NEAR 1 
#define RANGE_MID 2 
#define RANGE_FAR 3 

// deadflag values

#define DEAD_NO    0 
#define DEAD_DYING   1 
#define DEAD_DEAD   2 
#define DEAD_RESPAWNABLE 3 

// takedamage values

#define DAMAGE_NO 0 
#define DAMAGE_YES 1 
#define DAMAGE_AIM 2 

// items
#define IT_AXE 4096 
#define IT_SHOTGUN 1 
#define IT_SUPER_SHOTGUN 2 
#define IT_NAILGUN 4 
#define IT_SUPER_NAILGUN 8 
#define IT_GRENADE_LAUNCHER 16 
#define IT_ROCKET_LAUNCHER 32 
#define IT_LIGHTNING 64 
#define IT_EXTRA_WEAPON 128 

#define IT_SHELLS 256 
#define IT_NAILS 512 
#define IT_ROCKETS 1024 
#define IT_CELLS 2048 

#define IT_ARMOR1 8192 
#define IT_ARMOR2 16384 
#define IT_ARMOR3 32768 
#define IT_SUPERHEALTH 65536 

#define IT_KEY1 131072 
#define IT_KEY2 262144 

#define IT_INVISIBILITY 524288 
#define IT_INVULNERABILITY 1048576 
#define IT_SUIT 2097152
#define IT_QUAD 4194304 
#define IT_HOOK 8388608

// point content values

#define CONTENT_EMPTY -1 
#define CONTENT_SOLID -2 
#define CONTENT_WATER -3 
#define CONTENT_SLIME -4 
#define CONTENT_LAVA -5 
#define CONTENT_SKY  -6 

#define STATE_TOP 0 
#define STATE_BOTTOM 1 
#define STATE_UP 2 
#define STATE_DOWN 3 

#define VEC_ORIGIN  '0 0 0' 
#define VEC_HULL_MIN '-16 -16 -24' 
#define VEC_HULL_MAX '16 16 32' 

#define VEC_HULL2_MIN '-32 -32 -24' 
#define VEC_HULL2_MAX '32 32 64' 

// protocol bytes
#define SVC_TEMPENTITY 23 
#define SVC_KILLEDMONSTER 27 
#define SVC_FOUNDSECRET 28 
#define SVC_INTERMISSION 30 
#define SVC_FINALE 31 
#define SVC_CDTRACK 32 
#define SVC_SELLSCREEN 33 

#ifdef QUAKE_WORLD

 #define SVC_SMALLKICK  34
 #define SVC_BIGKICK   35
 #define SVC_MUZZLEFLASH  39

#endif


#define TE_SPIKE   0 
#define TE_SUPERSPIKE  1 
#define TE_GUNSHOT   2 
#define TE_EXPLOSION  3 
#define TE_TAREXPLOSION  4 
#define TE_LIGHTNING1  5 
#define TE_LIGHTNING2  6 
#define TE_WIZSPIKE   7 
#define TE_KNIGHTSPIKE  8 
#define TE_LIGHTNING3  9 
#define TE_LAVASPLASH  10 
#define TE_TELEPORT   11 
#define TE_BLOOD         12
#define TE_LIGHTNINGBLOOD 13

// sound channels
// channel 0 never willingly overrides
// other channels (1-7) allways override a playing sound on that channel
#define CHAN_AUTO 0 
#define CHAN_WEAPON 1 
#define CHAN_VOICE 2 
#define CHAN_ITEM 3 
#define CHAN_BODY 4 

#define ATTN_NONE 0 
#define ATTN_NORM 1 
#define ATTN_IDLE 2 
#define ATTN_STATIC 3 

// update types

#define UPDATE_GENERAL 0 
#define UPDATE_STATIC 1 
#define UPDATE_BINARY 2 
#define UPDATE_TEMP 3 

// entity effects

#define EF_BRIGHTFIELD 1 
#define EF_MUZZLEFLASH 2 
#define EF_BRIGHTLIGHT 4 
#define EF_DIMLIGHT 8 


// messages
// Since BROADCAST is never used in QW 1.5, and MULTICAST is used instead,
// just define BROADCAST as MULTICAST for QW 1.5
#define MSG_MULTICAST   4       
#define MSG_BROADCAST  #MSG_MULTICAST
#define MSG_ONE   1   // reliable to one (msg_entity)
#define MSG_ALL   2   // reliable to all
#define MSG_INIT  3   // write to the init string


// message levels
#define PRINT_LOW   0  // pickup messages
#define PRINT_MEDIUM  1  // death messages
#define PRINT_HIGH   2  // critical messages
#define PRINT_CHAT   3  // also goes to chat console

// multicast sets
#define MULTICAST_ALL    0     // every client
#define MULTICAST_PHS    1     // within hearing
#define MULTICAST_PVS    2     // within sight
#define MULTICAST_ALL_R  3     // every client, reliable
#define MULTICAST_PHS_R  4     // within hearing, reliable
#define MULTICAST_PVS_R  5   // within sight, reliable



#define AS_STRAIGHT 1 
#define AS_SLIDING 2 
#define AS_MELEE 3 
#define AS_MISSILE 4 


// TeamFortress State Flags
#define TFSTATE_GRENPRIMED  1  // Whether the player has a primed grenade
#define TFSTATE_RELOADING  2  // Whether the player is reloading
#define TFSTATE_ALTKILL   4   // #TRUE if killed with a weapon not in self.weapon: NOT USED ANYMORE
#define TFSTATE_RANDOMPC  8   // Whether Playerclass is random, new one each respawn
#define TFSTATE_INFECTED  16  // set when player is infected by the bioweapon
#define TFSTATE_INVINCIBLE  32  // Player has permanent Invincibility (Usually by GoalItem)
#define TFSTATE_INVISIBLE  64  // Player has permanent Invisibility (Usually by GoalItem)
#define TFSTATE_QUAD   128 // Player has permanent Quad Damage (Usually by GoalItem)
#define TFSTATE_RADSUIT   256 // Player has permanent Radsuit (Usually by GoalItem)
#define TFSTATE_BURNING   512 // Is on fire
#define TFSTATE_GRENTHROWING 1024  // is throwing a grenade
#define TFSTATE_AIMING   2048  // is using the laser sight
#define TFSTATE_ZOOMOFF   4096  // doesn't want the FOV changed when zooming
#define TFSTATE_RESPAWN_READY 8192  // is waiting for respawn, and has pressed fire
#define TFSTATE_HALLUCINATING  16384  // set when player is hallucinating
#define TFSTATE_TRANQUILISED   32768  // set when player is tranquilised
#define TFSTATE_CANT_MOVE    65536  // set when player is setting a detpack

// Defines used by TF_T_Damage (see combat.qc)
#define TF_TD_IGNOREARMOUR 1  // Bypasses the armour of the target
#define TF_TD_NOTTEAM  2  // Doesn't damage a team member (indicates direct fire weapon)
#define TF_TD_NOTSELF  4  // Doesn't damage self

#define TF_TD_OTHER   0  // Ignore armorclass
#define TF_TD_SHOT   1  // Bullet damage
#define TF_TD_NAIL   2  // Nail damage
#define TF_TD_EXPLOSION  4  // Explosion damage
#define TF_TD_ELECTRICITY 8  // Electric damage
#define TF_TD_FIRE   16  // Fire damage
#define TF_TD_NOSOUND  256 // Special damage. Makes no sound/painframe, etc


/*==================================================*/
/* Toggleable Game Settings       */
/*==================================================*/

#define TF_RESPAWNDELAY1 5  // seconds of waiting before player can respawn
#define TF_RESPAWNDELAY2 10  // seconds of waiting before player can respawn
#define TF_RESPAWNDELAY3 20  // seconds of waiting before player can respawn

#define TEAMPLAY_NORMAL    1   
#define TEAMPLAY_HALFDIRECT   2
#define TEAMPLAY_NODIRECT   4
#define TEAMPLAY_HALFEXPLOSIVE  8
#define TEAMPLAY_NOEXPLOSIVE  16
#define TEAMPLAY_LESSPLAYERSHELP 32
#define TEAMPLAY_LESSSCOREHELP  64

// FortressMap stuff
#define TEAM1_CIVILIANS 1 
#define TEAM2_CIVILIANS 2
#define TEAM3_CIVILIANS 4 
#define TEAM4_CIVILIANS 8 

// Defines for the playerclass
#define PC_UNDEFINED 0 

#define PC_SCOUT  1 
#define PC_SNIPER  2 
#define PC_SOLDIER  3 
#define PC_DEMOMAN  4 
#define PC_MEDIC  5 
#define PC_HVYWEAP  6 
#define PC_PYRO   7
#define PC_SPY   8
#define PC_ENGINEER  9

// Insert new class definitions here

// PC_RANDOM _MUST_ be the third last class
#define PC_RANDOM  10   // Random playerclass
#define PC_CIVILIAN  11  // Civilians are a special class. They cannot
        // be chosen by players, only enforced by maps
#define PC_LASTCLASS 12   // Use this as the high-boundary for any loops
        // through the playerclass.
// Flare skin numbers
//float TF_FLARE_LIT  = 0;
//float TF_FLARE_OFF  = 1;

/*==================================================*/
/* Impulse Defines                           */
/*==================================================*/
// Alias check to see whether they already have the aliases
#define TF_ALIAS_CHECK  13 

// CTF Support Impulses
#define HOOK_IMP1  22
#define FLAG_INFO  23
#define HOOK_IMP2  39

// Axe
#define AXE_IMP   40

// Camera Impulse
#define TF_CAM_TARGET   50
#define TF_CAM_ZOOM    51
#define TF_CAM_ANGLE   52
#define TF_CAM_VEC    53
#define TF_CAM_PROJECTILE  54
#define TF_CAM_PROJECTILE_Z  55
#define TF_CAM_REVANGLE   56
#define TF_CAM_OFFSET   57
#define TF_CAM_DROP    58 
#define TF_CAM_FADETOBLACK  59
#define TF_CAM_FADEFROMBLACK 60
#define TF_CAM_FADETOWHITE  61
#define TF_CAM_FADEFROMWHITE 62

// Status Bar Resolution Settings.  Same as CTF to maintain ease of use.
#define TF_STATUSBAR_RES_START 71
#define TF_STATUSBAR_RES_END 81

// Added to PC_??? to get impulse to use if this clashes with your 
// own impulses, just change this value, not the PC_??
#define TF_CHANGEPC   100 
// The next few impulses are all the class selections
//PC_SCOUT  101 
//PC_SNIPER  102 
//PC_SOLDIER 103 
//PC_DEMOMAN 104 
//PC_MEDIC  105 
//PC_HVYWEAP 106 
//PC_PYRO  107 
//PC_RANDOM  108
//PC_CIVILIAN 109  // Cannot be used
//PC_SPY  110
//PC_ENGINEER 111

// Help impulses
#define TF_DISPLAYLOCATION  118
#define TF_STATUS_QUERY  119

#define TF_HELP_MAP   131

// Information impulses
#define TF_INVENTORY  135
#define TF_SHOWTF   136 
#define TF_SHOWLEGALCLASSES 137

// Team Impulses
#define TF_TEAM_1   140   // Join Team 1
#define TF_TEAM_2   141   // Join Team 2
#define TF_TEAM_3   142   // Join Team 3
#define TF_TEAM_4   143   // Join Team 4
#define TF_TEAM_CLASSES  144   // Impulse to display team classes
#define TF_TEAM_SCORES  145   // Impulse to display team scores
#define TF_TEAM_LIST  146   // Impulse to display the players in each team.

// Grenade Impulses
#define TF_GRENADE_1  150   // Prime grenade type 1
#define TF_GRENADE_2  151   // Prime grenade type 2
#define TF_GRENADE_T  152   // Throw primed grenade

// Impulses for new items
#define TF_SCAN    159  // Scanner Pre-Impulse
#define TF_SCAN_ENEMY  160  // Impulses to toggle scanning of enemies
#define TF_SCAN_FRIENDLY 161  // Impulses to toggle scanning of friendlies 
#define TF_SCAN_10   162  // Scan using 10 enery (1 cell)
#define TF_SCAN_30   163  // Scan using 30 energy (2 cells)
#define TF_SCAN_100   164  // Scan using 100 energy (5 cells)
#define TF_DETPACK_5  165  // Detpack set to 5 seconds
#define TF_DETPACK_20  166  // Detpack set to 20 seconds
#define TF_DETPACK_50  167  // Detpack set to 50 seconds
#define TF_DETPACK   168  // Detpack Pre-Impulse
#define TF_DETPACK_STOP  169  // Impulse to stop setting detpack
#define TF_PB_DETONATE  170  // Detonate Pipebombs

// Special skill
#define TF_SPECIAL_SKILL 171

// Ammo Drop impulse
#define TF_DROP_AMMO        172

// Reload impulse
#define TF_RELOAD   173

// auto-zoom toggle
#define TF_AUTOZOOM   174

// drop/pass commands
#define TF_DROPKEY   175

// Select Medikit  
#define TF_MEDIKIT   176

// Spy Impulses
#define TF_SPY_SPY   177  // On net, go invisible, on LAN, change skin/color
#define TF_SPY_DIE   178  // Feign Death

// Engineer Impulses
#define TF_ENGINEER_BUILD 179
#define TF_ENGINEER_SANDBAG 180

// Medic!! 
#define TF_MEDIC_HELPME  181

// Status bar
#define TF_STATUSBAR_ON  182
#define TF_STATUSBAR_OFF 183

// Discard impulse
#define TF_DISCARD      184

// ID Player impulse
#define TF_ID       185

/*==================================================*/
/* Colors           */
/*==================================================*/
#define WHITE   1
#define BROWN   2
#define BLUE   3
#define GREEN    4
#define RED   5
#define TAN      6
#define PINK     7
#define ORANGE   8
#define PURPLE   9
#define DARKPURPLE  10
#define GREY     11
#define DARKGREEN   12
#define YELLOW   13
#define DARKBLUE    14

/*==================================================*/
/* Defines for the ENGINEER's Building ability  */
/*==================================================*/
// Ammo costs
#define AMMO_COST_SHELLS  3  // Metal needed to make 1 shell
#define AMMO_COST_NAILS   2
#define AMMO_COST_ROCKETS  5
#define AMMO_COST_CELLS   5

// Building types
#define BUILD_DISPENSER   1
#define BUILD_SENTRYGUN   2
//#define BUILD_MORTAR   3

// Building metal costs
#define BUILD_COST_DISPENSER 100  // Built thru the menu
#define BUILD_COST_SENTRYGUN 130  // Built thru the menu
//#define BUILD_COST_MORTAR  150  // Built thru the menu

//#define BUILD_COST_SANDBAG  20  // Built with a separate alias

// Building times
#define BUILD_TIME_DISPENSER 2  // 2 seconds to build
#define BUILD_TIME_SENTRYGUN 5  // 5 seconds to build
//#define BUILD_TIME_MORTAR  5  // 5 seconds to build

// Building health levels
#define BUILD_HEALTH_DISPENSER 150  // Built thru the menu
#define BUILD_HEALTH_SENTRYGUN 150  // Built thru the menu
#define BUILD_HEALTH_MORTAR  200  // Built thru the menu

// Dispenser's maximum carrying capability
#define BUILD_DISPENSER_MAX_SHELLS  400
#define BUILD_DISPENSER_MAX_NAILS   600
#define BUILD_DISPENSER_MAX_ROCKETS 300
#define BUILD_DISPENSER_MAX_CELLS   400
#define BUILD_DISPENSER_MAX_ARMOR   500

/*==================================================*/
/* Ammo quantities for dropping               */
/*==================================================*/
#define DROP_SHELLS   20
#define DROP_NAILS    20
#define DROP_ROCKETS  10
#define DROP_CELLS    10
#define DROP_ARMOR   40

/*==================================================*/
/* Team Defines                   */
/*==================================================*/
#define TM_MAX_NO 4    // Max number of teams. Simply changing this value isn't enough.
        // A new global to hold new team colors is needed, and more flags
        // in the spawnpoint spawnflags may need to be used.
        // Basically, don't change this unless you know what you're doing :)

/*==================================================*/
/* New Weapon Defines                          */
/*==================================================*/

#define WEAP_HOOK    1
#define WEAP_BIOWEAPON   2
#define WEAP_MEDIKIT   4
#define WEAP_SPANNER   8
#define WEAP_AXE    16
#define WEAP_SNIPER_RIFLE  32
#define WEAP_AUTO_RIFLE   64
#define WEAP_SHOTGUN   128
#define WEAP_SUPER_SHOTGUN  256
#define WEAP_NAILGUN   512
#define WEAP_SUPER_NAILGUN  1024
#define WEAP_GRENADE_LAUNCHER 2048
#define WEAP_FLAMETHROWER  4096
#define WEAP_ROCKET_LAUNCHER 8192
#define WEAP_INCENDIARY   16384
#define WEAP_ASSAULT_CANNON  32768
#define WEAP_LIGHTNING   65536
#define WEAP_DETPACK   131072
#define WEAP_TRANQ    262144
#define WEAP_LASER    524288
// still room for 12 more weapons
// but we can remove some by giving the weapons
// a weapon mode (like the rifle)

/*==================================================*/
/* New Weapon Related Defines                  */
/*==================================================*/
// shots per reload 
#define RE_SHOTGUN   8 
#define RE_SUPER_SHOTGUN 16 // 8 shots
#define RE_GRENADE_LAUNCHER 6 
#define RE_ROCKET_LAUNCHER 4 

// reload times
#define RE_SHOTGUN_TIME    2 
#define RE_SUPER_SHOTGUN_TIME  3 
#define RE_GRENADE_LAUNCHER_TIME 4 
#define RE_ROCKET_LAUNCHER_TIME  5 

// Maximum velocity you can move and fire the Sniper Rifle
#define WEAP_SNIPER_RIFLE_MAX_MOVE 50 

// Medikit
#define WEAP_MEDIKIT_HEAL 200  // Amount medikit heals per hit
#define WEAP_MEDIKIT_OVERHEAL 50 // Amount of superhealth over max_health the medikit will dispense

// Spanner
#define WEAP_SPANNER_REPAIR 10

// Detpack
#define WEAP_DETPACK_DISARMTIME 3    //Time it takes to disarm a Detpack
#define WEAP_DETPACK_SETTIME  3    // Time it takes to set a Detpack
#define WEAP_DETPACK_SIZE  1500 
#define WEAP_DETPACK_BITS_NO  12   // Bits that detpack explodes into

// Tranquiliser Gun
#define TRANQ_TIME   15

// Grenades
#define GR_PRIMETIME  3 
#define GR_TYPE_NONE  0 
#define GR_TYPE_NORMAL  1 
#define GR_TYPE_CONCUSSION 2 
#define GR_TYPE_NAIL  3 
#define GR_TYPE_MIRV  4 
#define GR_TYPE_NAPALM  5 
#define GR_TYPE_FLARE  6 
#define GR_TYPE_GAS   7
#define GR_TYPE_EMP   8
#define GR_TYPE_FLASH  9
#define GR_TYPE_CALTROPS  10

// Defines for WeaponMode
#define GL_NORMAL 0 
#define GL_PIPEBOMB 1 

// Defines for Concussion Grenade
//#define GR_CONCUSS_TIME 5 
//#define GR_CONCUSS_DEC 20 

// Defines for the Gas Grenade
//#define GR_HALLU_TIME 0.5
//#define GR_HALLU_DEC 2.5

/*==================================================*/
/* New Items                            */
/*==================================================*/
#define NIT_SCANNER    1 

#define NIT_SILVER_DOOR_OPENED  #IT_KEY1 // 131072 
#define NIT_GOLD_DOOR_OPENED  #IT_KEY2 // 262144

/*==================================================*/
/* New Item Flags                           */
/*==================================================*/
#define NIT_SCANNER_ENEMY  1  // Detect enemies
#define NIT_SCANNER_FRIENDLY 2  // Detect friendlies (team members)
#define NIT_SCANNER_MOVEMENT 4  // Motion detection. Only report moving entities.

/*==================================================*/
/* New Item Related Defines                      */
/*==================================================*/
#define NIT_SCANNER_POWER   100 // The amount of power spent on a scan with the scanner
          // is multiplied by this to get the scanrange.
#define NIT_SCANNER_MAXCELL   50  // The maximum number of cells than can be used in one scan
#define NIT_SCANNER_MIN_MOVEMENT 50  // The minimum velocity an entity must have to be detected
          // by scanners that only detect movement

/*==================================================*/
/* Variables used for New Weapons and Reloading     */
/*==================================================*/
// Armor Classes : Bitfields. Use the "armorclass" of armor for the Armor Type.
#define AT_SAVESHOT   1   // Kevlar    : Reduces bullet damage by 15%
#define AT_SAVENAIL   2   // Wood :)   : Reduces nail damage by 15%
#define AT_SAVEEXPLOSION 4   // Blast     : Reduces explosion damage by 15%
#define AT_SAVEELECTRICITY 8  // Shock  : Reduces electricity damage by 15%
#define AT_SAVEFIRE   16  // Asbestos  : Reduces fire damage by 15%

/*==========================================================================*/
/* TEAMFORTRESS CLASS DETAILS            */
/*==========================================================================*/
//++ Class Details for SCOUT
#define PC_SCOUT_SKIN    4   // Skin for this class when Classkin is on.
#define PC_SCOUT_MAXHEALTH   75  // Maximum Health Level
#define PC_SCOUT_MAXSPEED   450  // Maximum movement speed
#define PC_SCOUT_MAXSTRAFESPEED  450  // Maximum strafing movement speed
#define PC_SCOUT_MAXARMOR   50   // Maximum Armor Level, of any armor class
#define PC_SCOUT_INITARMOR   25   // Armor level when respawned
#define PC_SCOUT_MAXARMORTYPE  0.3  // Maximum level of Armor absorption
#define PC_SCOUT_INITARMORTYPE  0.3  // Absorption Level of armor when respawned
#define PC_SCOUT_ARMORCLASSES  3   // #AT_SAVESHOT | #AT_SAVENAIL     <-Armor Classes allowed for this class
#define PC_SCOUT_INITARMORCLASS  0   // Armorclass worn when respawned
#ifdef TG
#define PC_SCOUT_WEAPONS   #WEAP_SPANNER | #WEAP_SHOTGUN | #WEAP_NAILGUN
#else
#define PC_SCOUT_WEAPONS   #WEAP_AXE | #WEAP_SHOTGUN | #WEAP_NAILGUN
#endif
#define PC_SCOUT_MAXAMMO_SHOT  50   // Maximum amount of shot ammo this class can carry
#define PC_SCOUT_MAXAMMO_NAIL  200  // Maximum amount of nail ammo this class can carry
#define PC_SCOUT_MAXAMMO_CELL  100  // Maximum amount of cell ammo this class can carry
#define PC_SCOUT_MAXAMMO_ROCKET  25   // Maximum amount of rocket ammo this class can carry
#define PC_SCOUT_INITAMMO_SHOT  25   // Amount of shot ammo this class has when respawned
#define PC_SCOUT_INITAMMO_NAIL  100  // Amount of nail ammo this class has when respawned
#define PC_SCOUT_INITAMMO_CELL  50   // Amount of cell ammo this class has when respawned
#define PC_SCOUT_INITAMMO_ROCKET 0   // Amount of rocket ammo this class has when respawned
//#define PC_SCOUT_GRENADE_TYPE_1  #GR_TYPE_NORMAL    //    <- 1st Type of Grenade this class has
#define PC_SCOUT_GRENADE_TYPE_1  #GR_TYPE_FLASH    //    <- 1st Type of Grenade this class has
#define PC_SCOUT_GRENADE_TYPE_2  #GR_TYPE_CONCUSSION      //    <- 2nd Type of Grenade this class has
#define PC_SCOUT_GRENADE_INIT_1  2   // Number of grenades of Type 1 this class has when respawned
#define PC_SCOUT_GRENADE_INIT_2  3   // Number of grenades of Type 2 this class has when respawned
#define PC_SCOUT_TF_ITEMS   #NIT_SCANNER  // <- TeamFortress Items this class has

#define PC_SCOUT_MOTION_MIN_I  0.5  // < Short range
#define PC_SCOUT_MOTION_MIN_MOVE 50   // Minimum vlen of player velocity to be picked up by motion detector

// Class Details for SNIPER
#define PC_SNIPER_SKIN    5 
#define PC_SNIPER_MAXHEALTH   90 
#define PC_SNIPER_MAXSPEED   300   
#define PC_SNIPER_MAXSTRAFESPEED 300 
#define PC_SNIPER_MAXARMOR   50 
#define PC_SNIPER_INITARMOR   0 
#define PC_SNIPER_MAXARMORTYPE  0.3 
#define PC_SNIPER_INITARMORTYPE  0.3 
#define PC_SNIPER_ARMORCLASSES  3   // #AT_SAVESHOT | #AT_SAVENAIL
#define PC_SNIPER_INITARMORCLASS 0 
#ifdef TG
#define PC_SNIPER_WEAPONS   #WEAP_SNIPER_RIFLE | #WEAP_AUTO_RIFLE | #WEAP_SPANNER | #WEAP_NAILGUN
#else
#define PC_SNIPER_WEAPONS   #WEAP_SNIPER_RIFLE | #WEAP_AUTO_RIFLE | #WEAP_AXE | #WEAP_NAILGUN
#endif
#define PC_SNIPER_MAXAMMO_SHOT  75 
#define PC_SNIPER_MAXAMMO_NAIL  100 
#define PC_SNIPER_MAXAMMO_CELL  50 
#define PC_SNIPER_MAXAMMO_ROCKET 25 
#define PC_SNIPER_INITAMMO_SHOT  60 
#define PC_SNIPER_INITAMMO_NAIL  50 
#define PC_SNIPER_INITAMMO_CELL  0 
#define PC_SNIPER_INITAMMO_ROCKET 0 
#define PC_SNIPER_GRENADE_TYPE_1 #GR_TYPE_NORMAL
#define PC_SNIPER_GRENADE_TYPE_2 #GR_TYPE_FLARE
#define PC_SNIPER_GRENADE_INIT_1 2   
#define PC_SNIPER_GRENADE_INIT_2 3
#define PC_SNIPER_TF_ITEMS   0 

// Class Details for SOLDIER
#define PC_SOLDIER_SKIN    6    
#define PC_SOLDIER_MAXHEALTH  100  
#define PC_SOLDIER_MAXSPEED   240   
#define PC_SOLDIER_MAXSTRAFESPEED 240 
#define PC_SOLDIER_MAXARMOR   200 
#define PC_SOLDIER_INITARMOR  100 
#define PC_SOLDIER_MAXARMORTYPE  0.8 
#define PC_SOLDIER_INITARMORTYPE 0.8 
#define PC_SOLDIER_ARMORCLASSES  31   // ALL
#define PC_SOLDIER_INITARMORCLASS 0 
#ifdef TG
#define PC_SOLDIER_WEAPONS    #WEAP_SPANNER | #WEAP_SHOTGUN | #WEAP_SUPER_SHOTGUN | #WEAP_ROCKET_LAUNCHER
#else
#define PC_SOLDIER_WEAPONS    #WEAP_AXE | #WEAP_SHOTGUN | #WEAP_SUPER_SHOTGUN | #WEAP_ROCKET_LAUNCHER
#endif
#define PC_SOLDIER_MAXAMMO_SHOT  100 
#define PC_SOLDIER_MAXAMMO_NAIL  100 
#define PC_SOLDIER_MAXAMMO_CELL  50 
#define PC_SOLDIER_MAXAMMO_ROCKET 50 
#define PC_SOLDIER_INITAMMO_SHOT 50 
#define PC_SOLDIER_INITAMMO_NAIL 0 
#define PC_SOLDIER_INITAMMO_CELL 0 
#define PC_SOLDIER_INITAMMO_ROCKET 10 
#define PC_SOLDIER_GRENADE_TYPE_1 #GR_TYPE_NORMAL
#define PC_SOLDIER_GRENADE_TYPE_2 #GR_TYPE_NAIL
#define PC_SOLDIER_GRENADE_INIT_1 4   
#define PC_SOLDIER_GRENADE_INIT_2 1   
#define PC_SOLDIER_TF_ITEMS   0 

// Class Details for DEMOLITION MAN
#define PC_DEMOMAN_SKIN    1 
#define PC_DEMOMAN_MAXHEALTH  90 
#define PC_DEMOMAN_MAXSPEED   280   
#define PC_DEMOMAN_MAXSTRAFESPEED 280 
#define PC_DEMOMAN_MAXARMOR   120 
#define PC_DEMOMAN_INITARMOR  50 
#define PC_DEMOMAN_MAXARMORTYPE  0.6 
#define PC_DEMOMAN_INITARMORTYPE 0.6 
#define PC_DEMOMAN_ARMORCLASSES  31   // ALL
#define PC_DEMOMAN_INITARMORCLASS 0   // AT_SAVEEXPLOSION 
#ifdef TG
#define PC_DEMOMAN_WEAPONS   #WEAP_SPANNER | #WEAP_SHOTGUN | #WEAP_GRENADE_LAUNCHER | #WEAP_DETPACK
#else
#define PC_DEMOMAN_WEAPONS   #WEAP_AXE | #WEAP_SHOTGUN | #WEAP_GRENADE_LAUNCHER | #WEAP_DETPACK
#endif
#define PC_DEMOMAN_MAXAMMO_SHOT  75 
#define PC_DEMOMAN_MAXAMMO_NAIL  50 
#define PC_DEMOMAN_MAXAMMO_CELL  50 
#define PC_DEMOMAN_MAXAMMO_ROCKET 50 
#define PC_DEMOMAN_MAXAMMO_DETPACK 1 
#define PC_DEMOMAN_INITAMMO_SHOT 30 
#define PC_DEMOMAN_INITAMMO_NAIL 0 
#define PC_DEMOMAN_INITAMMO_CELL 0 
#define PC_DEMOMAN_INITAMMO_ROCKET 20 
#define PC_DEMOMAN_INITAMMO_DETPACK 1 
#define PC_DEMOMAN_GRENADE_TYPE_1 #GR_TYPE_NORMAL
#define PC_DEMOMAN_GRENADE_TYPE_2 #GR_TYPE_MIRV
#define PC_DEMOMAN_GRENADE_INIT_1 4   
#define PC_DEMOMAN_GRENADE_INIT_2 4   
#define PC_DEMOMAN_TF_ITEMS   0 

// Class Details for COMBAT MEDIC
#define PC_MEDIC_SKIN    3 
#define PC_MEDIC_MAXHEALTH   90 
#define PC_MEDIC_MAXSPEED   320 
#define PC_MEDIC_MAXSTRAFESPEED  320 
#define PC_MEDIC_MAXARMOR   100
#define PC_MEDIC_INITARMOR   50 
#define PC_MEDIC_MAXARMORTYPE  0.6 
#define PC_MEDIC_INITARMORTYPE  0.3 
#define PC_MEDIC_ARMORCLASSES  11   // ALL except EXPLOSION
#define PC_MEDIC_INITARMORCLASS  0 
#ifdef TG
#define PC_MEDIC_WEAPONS   #WEAP_SPANNER | #WEAP_BIOWEAPON | #WEAP_MEDIKIT | #WEAP_SHOTGUN | #WEAP_SUPER_SHOTGUN | #WEAP_SUPER_NAILGUN
#else
#define PC_MEDIC_WEAPONS   #WEAP_BIOWEAPON | #WEAP_MEDIKIT | #WEAP_SHOTGUN | #WEAP_SUPER_SHOTGUN | #WEAP_SUPER_NAILGUN
#endif
#define PC_MEDIC_MAXAMMO_SHOT  75 
#define PC_MEDIC_MAXAMMO_NAIL  150 
#define PC_MEDIC_MAXAMMO_CELL  50 
#define PC_MEDIC_MAXAMMO_ROCKET  25 
#define PC_MEDIC_MAXAMMO_MEDIKIT 100 
#define PC_MEDIC_INITAMMO_SHOT  50 
#define PC_MEDIC_INITAMMO_NAIL  50 
#define PC_MEDIC_INITAMMO_CELL  0 
#define PC_MEDIC_INITAMMO_ROCKET 0 
#define PC_MEDIC_INITAMMO_MEDIKIT 50 
#define PC_MEDIC_GRENADE_TYPE_1  #GR_TYPE_NORMAL
#define PC_MEDIC_GRENADE_TYPE_2  #GR_TYPE_CONCUSSION
#define PC_MEDIC_GRENADE_INIT_1  3   
#define PC_MEDIC_GRENADE_INIT_2  2   
#define PC_MEDIC_TF_ITEMS   0 
#define PC_MEDIC_REGEN_TIME   3   // Number of seconds between each regen.
#define PC_MEDIC_REGEN_AMOUNT  2  // Amount of health regenerated each regen.

// Class Details for HVYWEAP
#define PC_HVYWEAP_SKIN    2 
#define PC_HVYWEAP_MAXHEALTH  100 
#define PC_HVYWEAP_MAXSPEED   230   
#define PC_HVYWEAP_MAXSTRAFESPEED 230 
#define PC_HVYWEAP_MAXARMOR   300 
#define PC_HVYWEAP_INITARMOR  150 
#define PC_HVYWEAP_MAXARMORTYPE  0.8 
#define PC_HVYWEAP_INITARMORTYPE 0.8 
#define PC_HVYWEAP_ARMORCLASSES  31    // ALL
#define PC_HVYWEAP_INITARMORCLASS 0   
#ifdef TG
#define PC_HVYWEAP_WEAPONS   #WEAP_ASSAULT_CANNON | #WEAP_SPANNER | #WEAP_SHOTGUN | #WEAP_SUPER_SHOTGUN
#else
#define PC_HVYWEAP_WEAPONS   #WEAP_ASSAULT_CANNON | #WEAP_AXE | #WEAP_SHOTGUN | #WEAP_SUPER_SHOTGUN
#endif
#define PC_HVYWEAP_MAXAMMO_SHOT  200 
#define PC_HVYWEAP_MAXAMMO_NAIL  200 
#define PC_HVYWEAP_MAXAMMO_CELL  50 
#define PC_HVYWEAP_MAXAMMO_ROCKET 25 
#define PC_HVYWEAP_INITAMMO_SHOT 200 
#define PC_HVYWEAP_INITAMMO_NAIL 0 
#define PC_HVYWEAP_INITAMMO_CELL 24 
#define PC_HVYWEAP_INITAMMO_ROCKET 0 
#define PC_HVYWEAP_GRENADE_TYPE_1 #GR_TYPE_NORMAL
#define PC_HVYWEAP_GRENADE_TYPE_2 #GR_TYPE_MIRV
#define PC_HVYWEAP_GRENADE_INIT_1 4   
#define PC_HVYWEAP_GRENADE_INIT_2 1   
#define PC_HVYWEAP_TF_ITEMS   0 


// Class Details for PYRO
#define PC_PYRO_SKIN   21 
#define PC_PYRO_MAXHEALTH  100 
#define PC_PYRO_MAXSPEED  300 
#define PC_PYRO_MAXSTRAFESPEED 300 
#define PC_PYRO_MAXARMOR  150 
#define PC_PYRO_INITARMOR  50 
#define PC_PYRO_MAXARMORTYPE 0.6 
#define PC_PYRO_INITARMORTYPE 0.6 
#define PC_PYRO_ARMORCLASSES 27   // ALL except EXPLOSION
#define PC_PYRO_INITARMORCLASS 16   // #AT_SAVEFIRE
#ifdef TG
#define PC_PYRO_WEAPONS   #WEAP_INCENDIARY | #WEAP_FLAMETHROWER | #WEAP_SPANNER | #WEAP_SHOTGUN
#else
#define PC_PYRO_WEAPONS   #WEAP_INCENDIARY | #WEAP_FLAMETHROWER | #WEAP_AXE | #WEAP_SHOTGUN
#endif
#define PC_PYRO_MAXAMMO_SHOT 40 
#define PC_PYRO_MAXAMMO_NAIL 50 
#define PC_PYRO_MAXAMMO_CELL 200 
#define PC_PYRO_MAXAMMO_ROCKET 60 
#define PC_PYRO_INITAMMO_SHOT 20 
#define PC_PYRO_INITAMMO_NAIL 0 
#define PC_PYRO_INITAMMO_CELL 120 
#define PC_PYRO_INITAMMO_ROCKET 15 
#define PC_PYRO_GRENADE_TYPE_1 #GR_TYPE_NORMAL
#define PC_PYRO_GRENADE_TYPE_2 #GR_TYPE_NAPALM
#define PC_PYRO_GRENADE_INIT_1 1   
#define PC_PYRO_GRENADE_INIT_2 4   
#define PC_PYRO_TF_ITEMS  0 

// Class Details for SPY
#define PC_SPY_SKIN    22 
#define PC_SPY_MAXHEALTH  90 
#define PC_SPY_MAXSPEED   300 
#define PC_SPY_MAXSTRAFESPEED 300 
#define PC_SPY_MAXARMOR   70 // 75 //100 
#define PC_SPY_INITARMOR  25 
#define PC_SPY_MAXARMORTYPE  0.6 //0.3 
#define PC_SPY_INITARMORTYPE 0.3 
#define PC_SPY_ARMORCLASSES  27   // ALL except EXPLOSION
#define PC_SPY_INITARMORCLASS 0  
#ifdef TG
#define PC_SPY_WEAPONS   #WEAP_SPANNER | #WEAP_AXE | #WEAP_TRANQ | #WEAP_SUPER_SHOTGUN | #WEAP_NAILGUN
#else
#define PC_SPY_WEAPONS   #WEAP_AXE | #WEAP_TRANQ | #WEAP_SUPER_SHOTGUN | #WEAP_NAILGUN
#endif
#define PC_SPY_MAXAMMO_SHOT  40 
#define PC_SPY_MAXAMMO_NAIL  100 
#define PC_SPY_MAXAMMO_CELL  30 
#define PC_SPY_MAXAMMO_ROCKET 15 
#define PC_SPY_INITAMMO_SHOT 40 
#define PC_SPY_INITAMMO_NAIL 50 
#define PC_SPY_INITAMMO_CELL 10 
#define PC_SPY_INITAMMO_ROCKET 0 
#define PC_SPY_GRENADE_TYPE_1 #GR_TYPE_NORMAL
#define PC_SPY_GRENADE_TYPE_2 #GR_TYPE_GAS
#define PC_SPY_GRENADE_INIT_1 2   
#define PC_SPY_GRENADE_INIT_2 2   
#define PC_SPY_TF_ITEMS   0 
#define PC_SPY_CELL_REGEN_TIME  5 
#define PC_SPY_CELL_REGEN_AMOUNT 1
#define PC_SPY_CELL_USAGE   3 // Amount of cells spent while invisible
#define PC_SPY_GO_UNDERCOVER_TIME 4 // Time it takes to go undercover

// Class Details for ENGINEER
#define PC_ENGINEER_SKIN   22   // Not used anymore
#define PC_ENGINEER_MAXHEALTH  80 
#define PC_ENGINEER_MAXSPEED  300 
#define PC_ENGINEER_MAXSTRAFESPEED 300 
#define PC_ENGINEER_MAXARMOR  50
#define PC_ENGINEER_INITARMOR  25 
#define PC_ENGINEER_MAXARMORTYPE 0.6 
#define PC_ENGINEER_INITARMORTYPE 0.3 
#define PC_ENGINEER_ARMORCLASSES 31   // ALL
#define PC_ENGINEER_INITARMORCLASS 0  
#define PC_ENGINEER_WEAPONS   #WEAP_SPANNER | #WEAP_LASER | #WEAP_SUPER_SHOTGUN
#define PC_ENGINEER_MAXAMMO_SHOT 50
#define PC_ENGINEER_MAXAMMO_NAIL 50 
#define PC_ENGINEER_MAXAMMO_CELL 200  // synonymous with metal 
#define PC_ENGINEER_MAXAMMO_ROCKET 30 
#define PC_ENGINEER_INITAMMO_SHOT 20 
#define PC_ENGINEER_INITAMMO_NAIL 25 
#define PC_ENGINEER_INITAMMO_CELL 100  // synonymous with metal 
#define PC_ENGINEER_INITAMMO_ROCKET 0 
#define PC_ENGINEER_GRENADE_TYPE_1 #GR_TYPE_NORMAL
#define PC_ENGINEER_GRENADE_TYPE_2 #GR_TYPE_EMP
#define PC_ENGINEER_GRENADE_INIT_1 2   
#define PC_ENGINEER_GRENADE_INIT_2 2   
#define PC_ENGINEER_TF_ITEMS  0 

// Class Details for CIVILIAN
#define PC_CIVILIAN_SKIN   22 
#define PC_CIVILIAN_MAXHEALTH  50
#define PC_CIVILIAN_MAXSPEED  240
#define PC_CIVILIAN_MAXSTRAFESPEED 240
#define PC_CIVILIAN_MAXARMOR  0
#define PC_CIVILIAN_INITARMOR  0 
#define PC_CIVILIAN_MAXARMORTYPE 0
#define PC_CIVILIAN_INITARMORTYPE 0 
#define PC_CIVILIAN_ARMORCLASSES 0   
#define PC_CIVILIAN_INITARMORCLASS 0
#ifdef TG
#define PC_CIVILIAN_WEAPONS   #WEAP_SPANNER
#else
#define PC_CIVILIAN_WEAPONS   #WEAP_AXE
#endif
#define PC_CIVILIAN_MAXAMMO_SHOT 0
#define PC_CIVILIAN_MAXAMMO_NAIL 0 
#define PC_CIVILIAN_MAXAMMO_CELL 0 
#define PC_CIVILIAN_MAXAMMO_ROCKET 0 
#define PC_CIVILIAN_INITAMMO_SHOT 0 
#define PC_CIVILIAN_INITAMMO_NAIL 0 
#define PC_CIVILIAN_INITAMMO_CELL 0 
#define PC_CIVILIAN_INITAMMO_ROCKET 0 
#define PC_CIVILIAN_GRENADE_TYPE_1 0
#define PC_CIVILIAN_GRENADE_TYPE_2 0
#define PC_CIVILIAN_GRENADE_INIT_1 0   
#define PC_CIVILIAN_GRENADE_INIT_2 0   
#define PC_CIVILIAN_TF_ITEMS  0 


/*==========================================================================*/
/* TEAMFORTRESS GOALS              */
/*==========================================================================*/
// For all these defines, see the tfortmap.txt that came with the zip
// for complete descriptions.
// Defines for Goal Activation types : goal_activation (in goals)
#define TFGA_TOUCH   1  // Activated when touched
#define TFGA_TOUCH_DETPACK 2  // Activated when touched by a detpack explosion
#define TFGA_REVERSE_AP  4  // Activated when AP details are _not_ met
#define TFGA_SPANNER  8  // Activated when hit by an engineer's spanner

// Defines for Goal Effects types : goal_effect
#define TFGE_AP      1  // AP is affected. Default.
#define TFGE_AP_TEAM    2  // All of the AP's team.
#define TFGE_NOT_AP_TEAM   4  // All except AP's team.
#define TFGE_NOT_AP     8  // All except AP.
#define TFGE_WALL     16 // If set, walls stop the Radius effects
#define TFGE_SAME_ENVIRONMENT 32 // If set, players in a different environment to the Goal are not affected
#define TFGE_TIMER_CHECK_AP   64 // If set, Timer Goals check their critera for all players fitting their effects

// Defines for Goal Result types : goal_result
#define TFGR_SINGLE    1  // Goal can only be activated once
#define TFGR_ADD_BONUSES  2  // Any Goals activated by this one give their bonuses
#define TFGR_ENDGAME   4  // Goal fires Intermission, displays scores, and ends level
#define TFGR_NO_ITEM_RESULTS 8 // GoalItems given by this Goal don't do results
#define TFGR_REMOVE_DISGUISE 16 // Prevent/Remove undercover from any Spy

// Defines for Goal Group Result types : goal_group
// None!
// But I'm leaving this variable in there, since it's fairly likely
// that some will show up sometime.

// Defines for Goal Item types, : goal_activation (in items)
#define TFGI_GLOW   1   // Players carrying this GoalItem will glow
#define TFGI_SLOW   2   // Players carrying this GoalItem will move at half-speed
#define TFGI_DROP   4   // Players dying with this item will drop it
#define TFGI_RETURN_DROP 8   // Return if a player with it dies
#define TFGI_RETURN_GOAL 16  // Return if a player with it has it removed by a goal's activation
#define TFGI_RETURN_REMOVE 32  // Return if it is removed by TFGI_REMOVE
#define TFGI_REVERSE_AP  64  // Only pickup if the player _doesn't_ match AP Details
#define TFGI_REMOVE   128 // Remove if left untouched for 2 minutes after being dropped
#define TFGI_KEEP   256 // Players keep this item even when they die
#define TFGI_ITEMGLOWS  512 // Item glows when on the ground
#define TFGI_DONTREMOVERES 1024 // Don't remove results when the item is removed

// Defines for TeamSpawnpoints : goal_activation (in teamspawns)
#define TFSP_MULTIPLEITEMS 1  // Give out the GoalItem multiple times
#define TFSP_MULTIPLEMSGS 2  // Display the message multiple times

// Defines for TeamSpawnpoints : goal_effects (in teamspawns)
#define TFSP_REMOVESELF  1  // Remove itself after being spawned on

// Defines for Goal States
#define TFGS_ACTIVE  1 
#define TFGS_INACTIVE 2 
#define TFGS_REMOVED 3 
#define TFGS_DELAYED 4


// Legal Playerclass Handling
#define TF_ILL_SCOUT   1
#define TF_ILL_SNIPER  2
#define TF_ILL_SOLDIER  4
#define TF_ILL_DEMOMAN  8
#define TF_ILL_MEDIC  16
#define TF_ILL_HVYWEP  32
#define TF_ILL_PYRO   64
#define TF_ILL_RANDOMPC  128
#define TF_ILL_SPY   256
#define TF_ILL_ENGINEER  512
    
/*==========================================================================*/
/* Flamethrower                */
/*==========================================================================*/
#define FLAME_PLYRMAXTIME 45  // lifetime in 0.1 sec of a flame on a player
#define FLAME_MAXBURNTIME 8   // lifetime in seconds of a flame on the world (big ones)
#define NAPALM_MAXBURNTIME 20  // lifetime in seconds of flame from a napalm grenade
#define FLAME_MAXPLYRFLAMES 4  // maximum number of flames on a player
#define FLAME_NUMLIGHTS  1  // maximum number of light flame 
#define FLAME_BURNRATIO  0.3 // the chance of a flame not 'sticking'
#define GR_TYPE_FLAMES_NO 15  // number of flames spawned when a grenade explode

/*==================================================*/
/* CTF Support defines         */
/*==================================================*/
#define CTF_FLAG1   1
#define CTF_FLAG2   2
#define CTF_DROPOFF1  3
#define CTF_DROPOFF2  4
#define CTF_SCORE1    5
#define CTF_SCORE2    6


/*==================================================*/
/* Death Message defines       */
/*==================================================*/
#define DMSG_SHOTGUN   1
#define DMSG_SSHOTGUN   2
#define DMSG_NAILGUN   3
#define DMSG_SNAILGUN   4
#define DMSG_GRENADEL   5
#define DMSG_ROCKETL   6
#define DMSG_LIGHTNING   7
#define DMSG_GREN_HAND   8
#define DMSG_GREN_NAIL   9
#define DMSG_GREN_MIRV   10
#define DMSG_GREN_PIPE   11
#define DMSG_DETPACK   12
#define DMSG_BIOWEAPON   13
#define DMSG_BIOWEAPON_ATT  14
#define DMSG_FLAME    15
#define DMSG_DETPACK_DIS  16
#define DMSG_AXE    17
#define DMSG_SNIPERRIFLE  18
#define DMSG_AUTORIFLE   19
#define DMSG_ASSAULTCANNON  20
#define DMSG_HOOK    21
#define DMSG_BACKSTAB   22
#define DMSG_MEDIKIT   23
#define DMSG_GREN_GAS   24
#define DMSG_TRANQ    25
#define DMSG_LASERBOLT   26
#define DMSG_SENTRYGUN_BULLET  27
#define DMSG_SNIPERLEGSHOT  28
#define DMSG_SNIPERHEADSHOT  29
#define DMSG_GREN_EMP   30
#define DMSG_GREN_EMP_AMMO  31
#define DMSG_SPANNER   32
#define DMSG_INCENDIARY   33
#define DMSG_SENTRYGUN_ROCKET 34
#define DMSG_GREN_FLASH   35
#define DMSG_TRIGGER   36

entity self;
entity other;
entity world;
float time;
float frametime;
entity newmis;
float force_retouch;
string mapname;
float serverflags;
float total_secrets;
float total_monsters;
float found_secrets;
float killed_monsters;
float parm1;
float parm2;
float parm3;
float parm4;
float parm5;
float parm6;
float parm7;
float parm8;
float parm9;
float parm10;
float parm11;
float parm12;
float parm13;
float parm14;
float parm15;
float parm16;
vector v_forward;
vector v_up;
vector v_right;
float trace_allsolid;
float trace_startsolid;
float trace_fraction;
vector trace_endpos;
vector trace_plane_normal;
float trace_plane_dist;
entity trace_ent;
float trace_inopen;
float trace_inwater;
entity msg_entity;

void () main;
void () StartFrame;
void () PlayerPreThink;
void () PlayerPostThink;
void () ClientKill;
void () ClientConnect;
void () PutClientInServer;
void () ClientDisconnect;
void () SetNewParms;
void () SetChangeParms;

void end_sys_globals;

.float modelindex;
.vector absmin;
.vector absmax;
.float ltime;
.float lastruntime;
.float movetype;
.float solid;
.vector origin;
.vector oldorigin;
.vector velocity;
.vector angles;
.vector avelocity;
.string classname;
.string model;
.float frame;
.float skin;
.float effects;
.vector mins;
.vector maxs;
.vector size;
.void () touch;
.void () use;
.void () think;
.void () blocked; // function haven't internal calls
.float nextthink;
.entity groundentity;
.float health;
.float frags;
.float weapon;
.string weaponmodel;
.float weaponframe;
.float currentammo;
.float ammo_shells;
.float ammo_nails;
.float ammo_rockets;
.float ammo_cells;
.float items;
.float takedamage;
.entity chain;
.float deadflag;
.vector view_ofs;
.float button0;
.float button1;
.float button2;
.float impulse;
.float fixangle;
.vector v_angle;
.string netname;
.entity enemy;
.float flags;
.float colormap;
.float team;
.float max_health;
.float teleport_time;
.float armortype;
.float armorvalue;
.float waterlevel;
.float watertype;
.float ideal_yaw;
.float yaw_speed;
.entity aiment;
.entity goalentity;
.float spawnflags;
.string target;
.string targetname;
.float dmg_take;
.float dmg_save;
.entity dmg_inflictor;
.entity owner;
.vector movedir;
.string message;
.float sounds;
.string noise;
.string noise1;
.string noise2;
.string noise3;

void end_sys_fields;
float movedist;
string string_null;
float empty_float;
entity activator;
entity damage_attacker;
float framecount;
float skill;
float teamplay;
float timelimit;
float fraglimit;
float deathmatch;

.string wad;
.string map;
.float worldtype;
.string killtarget;
.float light_lev;
.float style;
.void () th_stand;
.void () th_walk; // function haven't internal calls
.void () th_run;
.void () th_missile; // function haven't internal calls
.void () th_melee; // function haven't internal calls
.void (entity p1, float p2) th_pain;
.void () th_die;
.entity oldenemy;
.float speed;
.float lefty;
.float search_time;
.float attack_state;
.float walkframe;
.float voided;
.float maxspeed;
.float gravity;
.float attack_finished;
.float pain_finished;
.float invincible_finished;
.float invisible_finished;
.float super_damage_finished;
.float radsuit_finished;
.float invincible_time;
.float invincible_sound;
.float invisible_time;
.float invisible_sound;
.float super_time;
.float super_sound;
.float rad_time;
.float fly_sound;
.float axhitme;
.float show_hostile;
.float jump_flag;
.float swim_flag;
.float air_finished;
.float bubble_count;
.string deathtype;
.string mdl;
.vector mangle;
.float t_length;
.float t_width;
.vector dest;
.vector dest1;
.vector dest2;
.float wait;
.float delay;
.entity trigger_field;
.string noise4;
.float pausetime;
.entity movetarget;
.float aflag;
.float dmg;
.float cnt;
.void () think1;
.vector finaldest;
.vector finalangle;
.float count;
.float lip;
.float state;
.vector pos1;
.vector pos2;
.float height;
.float waitmin;
.float waitmax;
.float distance;
.float volume;

void (vector ang) makevectors = #1;
void (entity e, vector o) setorigin = #2;
void (entity e, string m) setmodel = #3;
void (entity e, vector min, vector max) setsize = #4;
void () break = #6;
float () random = #7;
void (entity e, float chan, string samp, float vol, float atten) sound = #8;
vector (vector v) normalize = #9;
void (string e) error = #10;
void (string e) objerror = #11;
float (vector v) vlen = #12;
float (vector v) vectoyaw = #13;
entity () spawn = #14;
void (entity e) remove = #15;
void (vector v1, vector v2, float nomonsters, entity forent) traceline = #16;
entity () checkclient = #17;
entity (entity start, .string fld, string match) find = #18;
string (string s) precache_sound = #19;
string (string s) precache_model = #20;
void (entity client, string s) stuffcmd = #21;
entity (vector org, float rad) findradius = #22;
void (...) bprint = #23;
void (...) sprint = #24;
void (...) bprint2 = #23;
void (...) sprint2 = #24;
void (...) bprint3 = #23;
void (...) sprint3 = #24;
void (...) bprint4 = #23;
void (...) sprint4 = #24;
void (...) bprint5 = #23;
void (...) sprint5 = #24;
void (...) bprint6 = #23;
void (...) sprint6 = #24;
void (...) bprint7 = #23;
void (...) sprint7 = #24;
void (...) bprint8 = #23;
void (string s) dprint = #25;
string (float f) ftos = #26;
string (vector v) vtos = #27;
void () coredump = #28;
void () traceon = #29;
void () traceoff = #30;
void (entity e) eprint = #31;
float (float yaw, float dist) walkmove = #32;
float (float yaw, float dist) droptofloor = #34;
void (float style, string value) lightstyle = #35;
float (float v) rint = #36;
float (float v) floor = #37;
float (float v) ceil = #38;
float (entity e) checkbottom = #40;
float (vector v) pointcontents = #41;
float (float f) fabs = #43;
vector (entity e, float speed) aim = #44;
float (string s) cvar = #45;
void (string s) localcmd = #46;
entity (entity e) nextent = #47;
void (vector o, vector d, float color, float count) particle = #48;
void () ChangeYaw = #49;
vector (vector v) vectoangles = #51;
void (float to, float f) WriteByte = #52;
void (float to, float f) WriteChar = #53;
void (float to, float f) WriteShort = #54;
void (float to, float f) WriteLong = #55;
void (float to, float f) WriteCoord = #56;
void (float to, float f) WriteAngle = #57;
void (float to, string s) WriteString = #58;
void (float to, entity s) WriteEntity = #59;
void (float step) movetogoal = #67;
string (string s) precache_file = #68;
void (entity e) makestatic = #69;
void (string s) changelevel = #70;
void (string var, string val) cvar_set = #72;
void (...) centerprint = #73;
void (vector pos, string samp, float vol, float atten) ambientsound = #74;
string (string s) precache_model2 = #75;
string (string s) precache_sound2 = #76;
string (string s) precache_file2 = #77;
void (entity e) setspawnparms = #78;
void (entity killer, entity killee) logfrag = #79;
string (entity e, string key) infokey = #80;
float (string s) stof = #81;
void (vector where, float set) multicast = #82;

#ifdef ANTIANTIFLASH
void(entity whom, float time) disable_updates = #83; /* server-side flash */ 
#endif // antiantiflash

//TG defines
#ifdef TG
#define TG_MAINMENU_IMPULSE 220
#define TG_SG_REBUILD_IMPULSE 221
#define TG_SG_RELOAD_IMPULSE 222
#define TG_SG_UPGRADE_IMPULSE 223
#define TG_DISP_LOAD_IMPULSE 224
#define TG_DISP_UNLOAD_IMPULSE 225

#define TG_MENU_MAIN 200
#define TG_MENU_SG 201
#define TG_MENU_DETPACK 202
#define TG_MENU_CHEATS 203
#define TG_MENU_POSITION 204
////////TG SG Options
#define TG_SG_FIND_IGNORE_OFF 3
#define TG_SG_FIND_IGNORE_TEAM 1
#define TG_SG_FIND_IGNORE_OWNER 2
#define TG_SG_FIND_IGNORE_ALL 0

#define TG_SG_FIRE_NORMAL 0
#define TG_SG_FIRE_BULLETS 1
#define TG_SG_FIRE_LIGHTING 2
#endif 

//Sentry types
#define SENTRY_OLD 0
#define SENTRY_FIX 2
#define SENTRY_NEW 3
#define SENTRY_MTFL 1
#define SENTRY_MTFL_NEWFIND 4
#define SENTRY_OLD_NEWFIND 5
#define MAX_SENTRY_TYPES 5

#define TF_AUTOIDTIME 1.0
#define TF_AUTOSCAN_TIME 0.5

#define TF_SPY_SFEIGN_IMPULSE 199

#define TF_EXEC_MAP_MASK  1
#define TF_EXEC_CLASS_MASK  2
#define TF_CLASS_HELP_MASK  4
#define TF_AUTOID_MASK  8
#define TF_MULTISCAN_MASK  16
#define TF_STATUS_STATS_MASK  32
#define TF_STATUS_COORD_MASK  64
#define TF_STATUS_SPY_MASK  128
#define TF_STATUS_DETPACK_MASK  256
#define TF_STATUS_SENTRY_MASK  512


#define DG_TYPE_NORMAL  2 
#define DG_TYPE_CONCUSSION 4 
#define DG_TYPE_NAIL  8 
#define DG_TYPE_MIRV  16
#define DG_TYPE_NAPALM  32
#define DG_TYPE_FLARE  64
#define DG_TYPE_GAS   128
#define DG_TYPE_EMP   256
#define DG_TYPE_FLASH  512
#define DG_TYPE_CALTROPS  1024
#define DG_TYPE_DETPACK  2048

#define BP_GREN  1  
#define BP_GREN_BYTYPE  2  
#define BP_TYPE_ARMOR  4
#define BP_TYPE_HEALTH  8
#define BP_TYPE_DETPACK  16

#ifndef LAN_SERVER
//	#define SPY_INVIS_ONLY		 #OFF	// Spy becomes invisible instead of changing skin/color
//	#define DEFAULT_AUTOZOOM     #OFF
	#define WEINER_SNIPER			 	// autoaiming for sniper rifle
	#define FLAME_MAXWORLDNUM	 20	 	// maximum number of flames in the world. DO NOT PUT BELOW 20.
	#define MAX_WORLD_PIPEBOMBS	 15	 	// This is divided between teams - this is the most you should have on a net server
	#define MAX_WORLD_AMMOBOXES	 20		// This is divided between teams - this is the most you should have on a net server
	#define GR_TYPE_MIRV_NO		 4	 	// Number of Mirvs a Mirv Grenade breaks into
	#define GR_TYPE_NAPALM_NO	 8 	 	// Number of flames napalm grenade breaks into (unused if net server)
	#define MEDIKIT_IS_BIOWEAPON 	 	// Medikit acts as a bioweapon against enemies
//	#define RESTORE_DEAD_SPEEDS     	// If defined, we restore the cl_speeds 
										// everytime a player dies, and set them 
										// everytime a player spawns. This makes
										// more net traffic, but players disconnecting
										// will have their speeds restored, on the
										// assumption people disconnect when dead.
										// I know this isn't strictly true, but we
										// can't do it any other way.
#else			
	// LAN options
//	#define SPY_INVIS_ONLY		 #OFF	// Spy changes skin/color instead of becoming invisible
//	#define DEFAULT_AUTOZOOM 	 #OFF
	#define FLAME_MAXWORLDNUM	 60		// maximum number of flames in the world. DO NOT PUT BELOW 20. 	
	#define MAX_WORLD_PIPEBOMBS	 30 	// This is divided between teams
	#define MAX_WORLD_AMMOBOXES	 20 	// This is divided between teams
	#define GR_TYPE_MIRV_NO		 12		// Number of Mirvs a Mirv Grenade breaks into
	#define GR_TYPE_NAPALM_NO	 12  	// Number of flames napalm grenade breaks into
#endif


// sniper rifle control
#define SR_INITDAMAGE 50
#define SR_INCDAMAGE 216 // by second
#define SR_MAXDAMAGE 398

#define NEW_FLASH_START_TIME 2
#define AUTOSCAN_IMPULSE 210
#define DEFAULT_AUTOSCAN_RANGE 30

#define ASSAULT_MIN_SHELLS 20
#define ASSAULT_SPREAD_MULTIPLY 3
#define ASSAULT_SPREAD_TIME 5
#define ANGEL_VERSION "Compiled: 31.01.2004 r1\n"
