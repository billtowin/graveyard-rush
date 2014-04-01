package gameplay.characters   ;

import flixel.addons.weapon.FlxWeapon;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.group.FlxTypedGroup.FlxTypedGroup;
import flixel.util.FlxPoint;
import flixel.util.FlxAngle;
import flixel.util.FlxRandom;
import flixel.util.FlxMath;
import flixel.addons.weapon.FlxBullet;
import flixel.util.FlxColor;
import flixel.FlxState;

/**
 * ...
 * @author Bill Tyros
 */
class Spitter extends Sprite
{
	static private inline var BASE_WALK_SPEED:Int = 40;
	static private inline var RANDOM_SPEED_DIFF:Int = 10;
	static private inline var BULLET_BUFFER:Int = 30;
	private var _speed:Int;
	private var _target:FlxSprite;
	
	private var _spit:FlxWeapon;
	
	public function new(X:Float=0, Y:Float=0)
	{
		super(X, Y);
		loadRotatedGraphic("assets/images/spitter.png", 128, -1, false, true);
		solid = true;
		immovable = false;
		
		_speed = BASE_WALK_SPEED + FlxRandom.intRanged(0, RANDOM_SPEED_DIFF);
		
		_spit = new FlxWeapon("Spit", this, FlxBullet);
		_spit.makePixelBullet(2, 7, 7, FlxColor.GREEN);
		_spit.fireRate = 1;
		_spit.bulletSpeed = 120;
		_spit.bulletLifeSpan = 2.0;
	}
	
	public function getProjectileWeaponGroup() : FlxTypedGroup<FlxBullet>
	{
		return _spit.group;
	}
	
	override public function addSelfTo(S:FlxState)
	{
		S.add(_spit.group);
		super.addSelfTo(S);
	}
	
	public function setTarget(t:FlxSprite)
	{
		_target = t;
	}
	
	public function spitAtTarget()
	{
		var x:Float = BULLET_BUFFER * Math.cos(FlxAngle.TO_RAD * (angle - 90)) + _halfWidth;
		var y:Float = BULLET_BUFFER * Math.sin(FlxAngle.TO_RAD * (angle - 90)) + _halfHeight;
		_spit.setBulletOffset(x, y);
		if (_spit.fireFromAngle(Std.int(angle) - 90))
		{
			//gun fired
		} else {
			//gun did not fire, no bullets
		}
	}
	
	override public function update()
	{
		if ( _target != null)
		{
			var dist:Int = FlxMath.distanceBetween(this, _target);
			if ( dist > 10 && dist < 250) {
				spitAtTarget();
			}
			angle = FlxAngle.angleBetween(this, _target, true) + 90;
			if ( dist > 10)
			{
				velocity.x = _speed * Math.cos(FlxAngle.TO_RAD * (angle - 90));
				velocity.y = _speed * Math.sin(FlxAngle.TO_RAD * (angle - 90));
			} else {
				velocity.x = 0;
				velocity.y = 0;
			}	
		}
		super.update();
	}	
}