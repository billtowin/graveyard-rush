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
	
	public function new(X:Float, Y:Float, Name:String, Position:String, Score:String)
	{
    _position = Position;
		_name = Name;
		_score = Score;
		super(X, Y, 300, _position + " | " + _name + " | " + _score);
	}
}