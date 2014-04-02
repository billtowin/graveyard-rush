package gameplay.weapons ;

import flixel.addons.weapon.FlxWeapon;
import flixel.addons.weapon.FlxBullet;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.util.FlxPoint;
import flixel.system.FlxSound;


//TODO develop more weapons and bullets (grenade bullets?)

/**
 * ...
 * @author Bill Tyros
 */
class Shotgun extends FlxWeapon
{
	public function new(parentRef:FlxSprite)
	{
		super("Shotgun", parentRef, FlxBullet);
		makePixelBullet(3, 2, 2, FlxColor.WHITE);
		bulletLifeSpan = 1;
		setBulletRandomFactor(10, 5, new FlxPoint(0.5, 0.5), 0.5);
		
		
		fireRate = 1;
		bulletSpeed = 180;
		onFireSound = new FlxSound();
		onFireSound.loadEmbedded("assets/sounds/shotgun.wav");
	}	
}