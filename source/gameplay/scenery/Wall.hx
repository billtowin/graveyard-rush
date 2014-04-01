package gameplay.scenery ;

import flixel.addons.weapon.FlxWeapon;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.util.FlxPoint;
import gameplay.characters.Sprite;
/**
 * ...
 * @author Bill Tyros
 */
class Wall extends Sprite
{
	public function new(X:Float=0, Y:Float=0) 
	{
		super(X, Y);
		loadGraphic("assets/images/wall.png");
		solid = true;
		immovable = true;
	}
	
	override public function addSelfTo(S:FlxState)
	{
		super.addSelfTo(S);
	}
	
	override public function update()
	{
		super.update();
	}
	
}