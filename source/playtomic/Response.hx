package playtomic;

/**
 * ...
 * @author Ben Lowry
 */
class Response
{
	private static var ERRORS:Map<Int, String>;
	
	public static function initialize()
	{
		ERRORS = new Map<Int, String>();
		
		// General Errors
		ERRORS[0] = "Nothing went wrong!";
		ERRORS[1] = "General error, this typically means the player is unable to connect to the server";
		ERRORS[2] = "Invalid game credential, mkae sure you use the right public and private keys";
		ERRORS[3] = "Request timed out";
		ERRORS[4] = "Invalid request";
		
		// GeoIP Errors
		ERRORS[100] = "GeoIP API has been disabled for this game";
		
		// Leaderboard Errors
		ERRORS[200] = "Leaderboard API has been disabled for this game";
		ERRORS[201] = "The player's name wasn't provided";
		ERRORS[203] = "Player is banned from submitting scores in this game";
		ERRORS[204] = "Score was not saved because it was not the player's best.  You can allow players to have	more than one score by specifying allowduplicates=true in your save options";
		
		// GameVars Errors
		ERRORS[300] = "GameVars API has been disabled for this game";
		
		// LevelSharing Errors
		ERRORS[400] = "Level sharing API has been disabled for this game";
		ERRORS[401] = "Invalid rating value (must be 1 - 10)";
		ERRORS[402] = "Player has already rated that level";
		ERRORS[403] = "Missing level name";
		ERRORS[404] = "Missing level id";
		ERRORS[405] = "Level already exists";
				
		// Achievement Errors
		ERRORS[500] = "Achievements API has been disabled for this game";
		ERRORS[501] = "Missing playerid";
		ERRORS[502] = "Missing player name";
		ERRORS[503] = "Missing achievementid";
		ERRORS[504] = "Invalid achievementid or achievement key";
		ERRORS[505] = "Player already had the achievement, you can overwrite old achievements with overwrite=true or save each time the player is awarded with allowduplicates=true";
		ERRORS[506] = "Player already had the achievement and it was overwritten or a duplicate was saved successfully";
		
		// Newsletter Errors
		ERRORS[600] = "Newsletter API has been disabled for this game";
		ERRORS[601] = "MailChimp API key is configured";
		ERRORS[602] = "The MailChimp API returned an error";
	}
	
	public var success:Bool = false;
	public var errorcode:Int = 0;
	
	/**
	 * Creates a response
	 * @param	status		The status returned from the server
	 * @param	errorcode	The errorcode returned from the server
	 */
	public function new(s:Bool, e:Int)
	{
		success = s;
		errorcode = e;
	}

	/**
	 * Returns the error message for a number
	 */
	public function errorMessage():String
	{
		return ERRORS[errorcode];
	}
}