package gameplay.weapons ;

import flixel.addons.weapon.FlxWeapon;
import flixel.addons.weapon.FlxBullet;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.util.FlxPoint;
import flixel.system.FlxSound;

/**
 * ...
 * @author Bill Tyros
 */
class Flamethrower extends FlxWeapon
{
	var is_firing:Bool = false;

	public function new(parentRef:FlxSprite)
	{
		super("Flamethrower", parentRef, FlxBullet);
		makePixelBullet(15, 2, 2, FlxColor.RED);
		bulletLifeSpan = 1;
		setBulletRandomFactor(10, 10, new FlxPoint(0.5, 0.5), 0.5);
		
		fireRate = 150;
		bulletSpeed = 150;
		multiShot = 2;
		onFireSound = new FlxSound();
		onFireSound.loadEmbedded("assets/sounds/flamethrower.wav");
	}	
}