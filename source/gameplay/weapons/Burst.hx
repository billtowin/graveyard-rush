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
class Burst extends FlxWeapon
{

	public function new(parentRef:FlxSprite)
	{
		super("Burst", parentRef, FlxBullet);
		makePixelBullet(3, 1, 1, FlxColor.YELLOW);
		setBulletRandomFactor(3, 5, new FlxPoint(0.5, 0.5), 0.2);
		
		fireRate = 50;
		bulletSpeed = 300;
		bulletLifeSpan = 0.8;
		onFireSound = new FlxSound();
		onFireSound.loadEmbedded("assets/sounds/flamethrower.wav");
	}
	
}