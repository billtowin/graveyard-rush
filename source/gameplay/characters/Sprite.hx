package gameplay.characters;

import flixel.FlxSprite;
import flixel.FlxState;

/**
 * ...
 * @author Bill Tyros
 */
class Sprite extends FlxSprite implements AddeableToState
{

	public function new(X:Float=0, Y:Float=0, ?SimpleGraphic:Dynamic) 
	{
		super(X, Y, SimpleGraphic);
	}
	
	public function addSelfTo(S:FlxState)
	{
		S.add(this);
	}
	
}