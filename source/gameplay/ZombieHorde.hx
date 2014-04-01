package gameplay ;

import flixel.FlxBasic;
import flixel.group.FlxTypedGroup.FlxTypedGroup;
import flixel.util.FlxRect;
import flixel.util.FlxPoint;
import flixel.util.FlxRandom;
import flixel.util.FlxMath;
import flixel.FlxSprite;
import gameplay.characters.Zombie;

import gameplay.Horde;

/**
 * ...
 * @author Bill Tyros
 */
class ZombieHorde extends Horde
{
	private var _target:FlxSprite;

	public function new(t:FlxSprite, rects:Array<FlxRect>,
		time_between_spawns_in_frames:Int=60, 
		time_decrease_factor_per_round:Float=0.87, 
		minimum_time_between_spawns:Int=15, 
		number_to_spawn:Int=1,
		random_spawn_chance_per_frame:Float=0.1) 
	{
		super(rects, time_between_spawns_in_frames, time_decrease_factor_per_round, 
		minimum_time_between_spawns, number_to_spawn, random_spawn_chance_per_frame);
		_target = t;
	}
	
	public function setTarget(t:FlxSprite)
	{
		_target = t;
	}
	
	override public function onSpawn(p:FlxPoint )
	{
		var z = new Zombie(0, 0);
		z.setPosition(p.x, p.y);
		z.setTarget(_target);
		add(z);
	}
}