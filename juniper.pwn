/*
	Juniper Mod
	@author	Lucie
	@date 	2021.02.20
*/

/*	TODO: Add /a(dmin) commands
	TODO: Add /help commands
	TODO: Add /tp (teleport) commands
	TODO: Add /b(ank) commands
	TODO: Add /v(ehicle) commands
*/

#include <a_samp>
#include <core>
#include <float>

#pragma tabsize 4

// Environment definitions
#define ENV_GMNAME	"Juniper Mod"
#define ENV_MYNAME	"Lucie"
#define ENV_SVNAME	"Old World"
#define ENV_GM_VER	1.0

#define MAX_PLAYERS	24
#define MAX_PLAYER_NAME 24

// Color definitions
#define COLOR_GREY		0xAFAFAFAA
#define COLOR_YELLOW	0xFFFF00AA
#define COLOR_PURPLE	0xC2A2DAAA
#define COLOR_ORANGE	0xFF9900AA
#define COLOR_PINK		0xFF69B4FF
#define COLOR_CYAN		0x00FFFFAA
#define COLOR_BLACK		0x000000FF
#define COLOR_WHITE		0xFFFFFFAA
#define COLOR_BLUE_D	0x2641FEAA
#define COLOR_BLUE		0x33AAFFFF
#define COLOR_GREEN_D	0x008000FF
#define COLOR_GREEN_B	0x08FD04FF
#define COLOR_GREEN		0x33AA33AA
#define COLOR_RED_G		0xF60000AA
#define COLOR_RED_D		0x800000FF
#define COLOR_RED		0xAA3333AA

// Variables
new Text:bottomTextDraw;

new gPlayerClasses[] = {
	0, 266, 267, 268, 269, 270, 271, 272, 280, 281, 282, 283, 284, 285, 286, 287, 254, 255, 256, 257,
	258, 259, 260, 261, 262, 263, 264, 274, 275, 276, 1, 2, 290, 291, 292, 293, 294, 295, 296, 297,
	298, 299, 277, 278, 279, 288, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60,
	61, 62, 63, 64, 66, 67, 68, 69, 70, 71, 72, 73, 75, 76, 78, 79, 80, 81, 82, 83,
	84, 85, 87, 88, 89, 91, 92, 93, 95, 96, 97, 98, 99, 100, 101, 102, 103, 104, 105, 106,
	107, 108, 109, 110, 111, 112, 113, 114, 115, 116, 117, 118, 120, 121, 122, 123, 124, 125, 126, 127,
	128, 129, 131, 133, 134, 135, 136, 137, 138, 139, 140, 141, 142, 143, 144, 145, 146, 147, 148, 150, 151, 152, 153, 
	154, 155, 156, 157, 158, 159, 160, 161, 162, 163, 164, 165, 166, 167, 168, 169,
	170, 171, 172, 173, 174, 175, 176, 177, 178, 179, 180, 181, 182, 183, 184, 185,
	186, 187, 188, 189, 190, 191, 192, 193, 194, 195, 196, 197, 198, 199, 200, 201,
	202, 203, 204, 205, 206, 207, 209, 210, 211, 212, 213, 214, 215, 216, 217, 218,
	219, 220, 221, 222, 223, 224, 225, 226, 227, 228, 229, 230, 231, 232, 233, 234,
	235, 236, 237, 238, 239, 240, 241, 242, 243, 244, 245, 246, 247, 248, 249, 250, 251, 253
};

main()
{
    print("\n");
    print("------------------------------------");
    print(" Juniper Mod by Lucie -- 2021.02.20 ");
    print("------------------------------------");
	print("\n");
}

public OnPlayerConnect(playerid)
{
	// Setup player
	TextDrawShowForPlayer(playerid, bottomTextDraw);

	// Send message to everyone
	new pName[MAX_PLAYER_NAME];
	new string[MAX_PLAYER_NAME + 16];

	GetPlayerName(playerid, pName, MAX_PLAYER_NAME);
	format(string, sizeof(string), "%s is connected...", pName);
	SendClientMessageToAll(COLOR_GREEN_B, string);

	// Send welcome message to the player
	GameTextForPlayer(playerid, "~w~Welcome to ~r~Old World", 5000, 5);

	SendClientMessage(playerid, COLOR_RED,		"^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^");
	SendClientMessage(playerid, COLOR_YELLOW,	" You can get help with: /help");
	SendClientMessage(playerid, COLOR_RED_G,	" Old World Freeroam");
	SendClientMessage(playerid, COLOR_GREEN_B,	"~ ^ Server version: 1.0");
	SendClientMessage(playerid, COLOR_RED,		"^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^");

	return 1;
}

public OnPlayerDisconnect(playerid, reason) {
	new pName[MAX_PLAYER_NAME];
    new string[MAX_PLAYER_NAME + 32];

    GetPlayerName(playerid, pName, sizeof(pName));

    switch (reason) {
        case 0: format(string, sizeof(string), "%s is disconnected (error).", pName);
        case 1: format(string, sizeof(string), "%s is disconnected...", pName);
        case 2: format(string, sizeof(string), "%s is kicked.", pName);
    }

    SendClientMessageToAll(COLOR_WHITE, string);
    return 1;
}

public OnPlayerCommandText(playerid, cmdtext[])
{
	// Prepare to handle commands
	new idx;
	new cmd[256];

	cmd = strtok(cmdtext, idx);

	// Handle /help
	if(strcmp(cmd, "/help", true) == 0) {
    	return 1;
	}

	return 0;
}

public OnPlayerSpawn(playerid)
{
	SetPlayerInterior(playerid, 0);
	TogglePlayerClock(playerid, 0);
	return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
	new pName[MAX_PLAYER_NAME];
	new string[256];
	new deathReason[24];

	GetPlayerName(playerid, pName, sizeof(pName));
	GetWeaponName(reason, deathReason, sizeof(deathReason));

	// If there are no killer, prepare 'died' message. Otherwise prepare 'killed' message.
	// Also gives killer the dead player's money.
	if (killerid == INVALID_PLAYER_ID) {
	    switch (reason) {
			case WEAPON_DROWN: format(string, sizeof(string), "*** %s drowned.", pName);
			default:
			{
			    if (strlen(deathReason) > 0) {
					format(string, sizeof(string), "*** %s died. (%s)", pName, deathReason);
				} else {
				    format(string, sizeof(string), "*** %s died.", pName);
				}
			}
		}
	} else {
		new kName[MAX_PLAYER_NAME];
		new pCash;

		GetPlayerName(killerid, kName, sizeof(kName));

		if (strlen(deathReason) > 0) {
			format(string, sizeof(string), "*** %s killed %s. (%s)", kName, pName, deathReason);
		} else {
			format(string, sizeof(string), "*** %s killed %s.", kName, pName);
		}

		// Give killer the money
		pCash = GetPlayerMoney(playerid);

		if (pCash > 0) {
			GivePlayerMoney(killerid, pCash);
			ResetPlayerMoney(playerid);
		}
	}

	// Send the prepared message
	SendClientMessageToAll(COLOR_RED, string);
   	return 1;
}

SetupPlayerForClassSelection(playerid)
{
 	SetPlayerInterior(playerid, 14);
	SetPlayerPos(playerid, 258.4893, -41.4008, 1002.0234);
	SetPlayerFacingAngle(playerid, 270.0);
	SetPlayerCameraPos(playerid, 256.0815, -43.0475, 1004.0234);
	SetPlayerCameraLookAt(playerid, 258.4893, -41.4008, 1002.0234);
}

public OnPlayerRequestClass(playerid, classid)
{
	SetupPlayerForClassSelection(playerid);
	return 1;
}

public OnGameModeInit()
{
	SetGameModeText("Old World [EN]");
	ShowPlayerMarkers(1);
	ShowNameTags(1);
	AllowAdminTeleport(1);

	// Bottom Text Draw settings
	bottomTextDraw = TextDrawCreate(1.000000, 433.000000, "/help /tp /v /guns -- Old World");
	TextDrawAlignment(bottomTextDraw, 0);
	TextDrawFont(bottomTextDraw, 3);
    TextDrawLetterSize(bottomTextDraw, 0.499999, 1.100000);
	TextDrawColor(bottomTextDraw, 65535);
	TextDrawSetShadow(bottomTextDraw, 1);
	TextDrawSetProportional(bottomTextDraw, 1);
	TextDrawSetOutline(bottomTextDraw, 1);

	// Player classes
	for (new i = 0; i < sizeof(gPlayerClasses); i++) {
		AddPlayerClass(gPlayerClasses[i], 1958.3783, 1343.1572, 15.3746, 270.1425, 0, 0, 0, 0, -1, -1);
	}
	return 1;
}

strtok(const string[], &index)
{
	new length = strlen(string);
	while ((index < length) && (string[index] <= ' ')) {
		index++;
	}

	new offset = index;
	new result[20];
	while ((index < length) && (string[index] > ' ') && ((index - offset) < (sizeof(result) - 1))) {
		result[index - offset] = string[index];
		index++;
	}
	result[index - offset] = EOS;
	return result;
}