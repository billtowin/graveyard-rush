package gameplay.scenery ;

import flixel.addons.weapon.FlxWeapon;
import flixel.FlxSprite;
import flixel.util.FlxPoint;
import flixel.FlxState;

import gameplay.characters.Sprite;
/**
 * ...
 * @author Bill Tyros
 */
class Crate extends Sprite
{
	static private inline var VELOCITY_CHANGE:Float = 0.05;
	
	
	public function new(X:Float=0, Y:Float=0) 
	{
		super(X, Y);
		loadGraphic("assets/images/crate.png");
		solid = true;
		immovable = false;
	}
	
	override public function addSelfTo(S:FlxState)
	{
		super.addSelfTo(S);
	}
	
	override public function update()
	{
		if (Math.abs(velocity.x) > 0) {
			velocity.x *= VELOCITY_CHANGE;
		}
		if (Math.abs(velocity.y) > 0) {
			velocity.y *= VELOCITY_CHANGE;
		}
		super.update();
	}
	
}