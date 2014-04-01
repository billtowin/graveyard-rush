package gameplay.characters  ;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.util.FlxPoint;
import flixel.util.FlxAngle;
import flixel.util.FlxRandom;
import flixel.util.FlxMath;

/*
 * TODO create more enemies, start appearing after a certain number of rounds (5, 10, ...)
 * 
 * Brainstorm: Ranged Spitter, Teleporter (behind you), Armored Tank
 * */

 //TODO make Enemy class
 //TODO push onHit code into classes
 //TODO make my own Weapon class which takes the parent then has a method activateAt(x,y) where x,y are where the mouse cursor is at
 //TODO comment existing code
/**
 * ...
 * @author Bill Tyros
 */
class Zombie extends Sprite
{
	static private inline var BASE_WALK_SPEED:Int = 60;
	static private inline var RANDOM_SPEED_DIFF:Int = 20;
	private var _speed:Int;
	private var _target:FlxSprite = null;
	
	public function new(X:Float=0, Y:Float=0) 
	{
		super(X, Y);
		loadRotatedGraphic("assets/images/zombie_single.png", 128, -1, false, true);
		solid = true;
		immovable = false;
		
		_speed = BASE_WALK_SPEED + FlxRandom.intRanged(0, RANDOM_SPEED_DIFF);
	}
	
	override public function addSelfTo(S:FlxState)
	{
		super.addSelfTo(S);
	}
	
	public function setTarget(t:FlxSprite)
	{
		_target = t;
	}
	
	override public function update()
	{
		if ( _target != null && FlxMath.distanceBetween(this, _target) > 10)
		{
			angle = FlxAngle.angleBetween(this, _target, true) + 90;
			velocity.x = _speed * Math.cos(FlxAngle.TO_RAD * (angle - 90));
			velocity.y = _speed * Math.sin(FlxAngle.TO_RAD * (angle - 90));
		}
		if (FlxMath.distanceBetween(this, _target) <= 10) {
			angle = FlxAngle.angleBetween(this, _target, true) + 90;
			velocity.x = 0;
			velocity.y = 0;
		}
		super.update();
	}	
}