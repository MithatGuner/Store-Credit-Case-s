#define PLUGIN_AUTHOR "KUTU | Mithat Guner"
#define PLUGIN_VERSION "2.00"

#include <sourcemod>
#include <multicolors>
#include <store>

ConVar	JoinCost,
		MinPrice,
		MaxPrice;

public Plugin myinfo = 
{
	name = "Case | Mithat Guner",
	author = PLUGIN_AUTHOR,
	description = "Case | Mithat Guner",
	version = PLUGIN_VERSION,
	url = "pluginler.com"
};

// Thanks To Xines And Shanapu

public void OnPluginStart()
{
	//Load Translations
	LoadTranslations("plugin.creditcases.phrases");

	//Commands
	RegConsoleCmd("sm_case", CaseDD, "Buys a case if enough credits.");
	
	//Others
	JoinCost = CreateConVar("mithat_open_cost", "5000", "Case Cost");
	MinPrice = CreateConVar("mithat_min_price", "1000", "Case Min Credits");
	MaxPrice = CreateConVar("mithat_max_price", "30000", "Case Max Credits");
	AutoExecConfig(true, "mithat_case");
}

public Action CaseDD(int client, int args)
{
	if(!IsValidClient(client)) return Plugin_Handled; //if not valid stop.

	int JoiningCost = JoinCost.IntValue;
	if (Store_GetClientCredits(client) >= JoiningCost)	
	{
		Store_SetClientCredits(client, Store_GetClientCredits(client) - JoiningCost);
		CreateTimer(0.1, OpeningCase, GetClientSerial(client), TIMER_REPEAT);
	}
	else CPrintToChat(client, "%T", "RequiredCredits", JoiningCost);
	
	return Plugin_Handled;
}

public Action OpeningCase(Handle timer, any serial)
{
	int client = GetClientFromSerial(serial); // Validate the client serial
	if(!IsValidClient(client)) return Plugin_Stop; //if not valid stop timer.

	static int Number = 0;
	if (Number >= 100)
	{
		Number = 0;
		int randomNumber = GetRandomInt(MinPrice.IntValue, MaxPrice.IntValue);
		PrintCenterText(client, "%T", "CenterTextToPrint", randomNumber);
		CPrintToChat(client, "%T", "ChatTextToPrint", randomNumber);
		Store_SetClientCredits(client, Store_GetClientCredits(client) + randomNumber);
		return Plugin_Stop;
	}
	
 	int randomNumber = GetRandomInt(MinPrice.IntValue, MaxPrice.IntValue);	
	PrintCenterText(client, "%T", "RandomNumberToPrint", randomNumber);
	Number++;			
	return Plugin_Continue;
}

stock bool IsValidClient(int client)
{
	return (1 <= client <= MaxClients && IsClientInGame(client));
}