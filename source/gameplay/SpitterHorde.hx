package gameplay;

import flixel.group.FlxGroup;
import flixel.util.FlxPoint;
import flixel.util.FlxRect;
import flixel.FlxSprite;
import flixel.group.FlxTypedGroup;
import flixel.addons.weapon.FlxBullet;
import flixel.FlxState;

import gameplay.characters.Spitter;
import gameplay.Horde;

/**
 * ...
 * @author Bill Tyros
 */
class SpitterHorde extends Horde
{
	private var _target:FlxSprite;
	private var _projectiles:FlxTypedGroup<FlxTypedGroup<FlxBullet>>;

	public function new(t:FlxSprite, rects:Array<FlxRect>,
		time_between_spawns_in_frames:Int=240, 
		time_decrease_factor_per_round:Float=0.95, 
		minimum_time_between_spawns:Int=60, 
		number_to_spawn:Int=1,
		random_spawn_chance_per_frame:Float=0.0) 
	{
		super(rects, time_between_spawns_in_frames, time_decrease_factor_per_round, 
		minimum_time_between_spawns, number_to_spawn, random_spawn_chance_per_frame);
		_target = t;
		_projectiles = new FlxTypedGroup<FlxTypedGroup<FlxBullet>>();
	}
	
	override public function addSelfTo(S:FlxState)
	{
		S.add(_projectiles);
		super.addSelfTo(S);
	}
	
	public function getProjectiles() : FlxTypedGroup<FlxTypedGroup<FlxBullet>>
	{
		return _projectiles;
	}
	
	public function setTarget(t:FlxSprite)
	{
		_target = t;
	}
	
	override public function onSpawn(p:FlxPoint)
	{
		var s = new Spitter(0, 0);
		s.setPosition(p.x, p.y);
		s.setTarget(_target);
		_projectiles.add(s.getProjectileWeaponGroup());
		add(s);
		
	}
}