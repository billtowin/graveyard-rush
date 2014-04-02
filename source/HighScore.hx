package ;
import flixel.text.FlxText;

/**
 * ...
 * @author Bill Tyros
 */
class HighScore extends FlxText
{
	private var _name:String;
	private var _position:String;
	private var _score:String;
  private var _postedTime:String;
	
	public function new(X:Float, Y:Float, Name:String, Position:String, Score:String, PostedTime:String)
	{
    _postedTime = PostedTime;
    _position = Position;
		_name = Name;
		_score = Score;
		super(X, Y, 300, _position + " | " + _score + " | " + _name + " | " + _postedTime, 12);
	}
}