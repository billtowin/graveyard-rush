package gameplay.weapons ;

import flixel.addons.weapon.FlxWeapon;
import flixel.addons.weapon.FlxBullet;
import flixel.FlxSprite;
import flixel.system.FlxSound;
import flixel.util.FlxColor;

/**
 * ...
 * @author Bill Tyros
 */
class Pistol extends FlxWeapon
{

	public function new(parentRef:FlxSprite)
	{
		super("Pistol", parentRef, FlxBullet);
		makePixelBullet(3, 2, 2, FlxColor.YELLOW);
		fireRate = 500;
		bulletSpeed = 450;
		bulletLifeSpan = 0.9;
		onFireSound = new FlxSound();
		onFireSound.loadEmbedded("assets/sounds/pistol2.wav");
	}
	
}