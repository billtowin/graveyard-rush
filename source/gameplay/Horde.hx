package gameplay ;

import flixel.FlxSprite;
import flixel.group.FlxTypedGroup;
import flixel.util.FlxRandom;
import flixel.util.FlxPoint;
import flixel.util.FlxMath;
import flixel.util.FlxRect;
import flixel.FlxBasic;
import flixel.FlxState;

/**
 * ...
 * @author Bill Tyros
 */
class Horde extends FlxTypedGroup< FlxSprite > implements AddeableToState
{
	private var _spawnZones:Array<FlxRect>;
	private var _isSpawning:Bool = false;
	private var _ticks:Int = 0;
	
	private var _time_between_spawns_in_frames = 60;
	private var _time_decrease_factor_per_round = 0.87;
	private var _minimum_time_between_spawns = 15;
	private var _number_to_spawn = 1;
	private var _random_spawn_chance_per_frame:Float = 0.1; //0.1%
	
	
	public function new(rects:Array<FlxRect>, 
		time_between_spawns_in_frames:Int=60, 
		time_decrease_factor_per_round:Float=0.87, 
		minimum_time_between_spawns:Int=15, 
		number_to_spawn:Int=1,
		random_spawn_chance_per_frame:Float=0.1)
	{
		super();
		_spawnZones = rects;
		_time_between_spawns_in_frames = time_between_spawns_in_frames;
		_time_decrease_factor_per_round = time_decrease_factor_per_round; 
		_minimum_time_between_spawns = minimum_time_between_spawns;
		_number_to_spawn = number_to_spawn;
		_random_spawn_chance_per_frame = random_spawn_chance_per_frame;
	}
	
	public function addSelfTo(S:FlxState)
	{
		S.add(this);
	}
	
	public function spawnWave(numberToSpawn:Int)
	{
	  	var points:List<FlxPoint> = new List<FlxPoint>();
		var numberOfTries:Int = 0;
		var noMoreSpace:Bool = false;
		var spawnX:Float = 0;
		var spawnY:Float = 0;
		var chosenRect:FlxRect = null;
		for (i in 0...numberToSpawn)
		{
			var nextPoint:FlxPoint = null;
			while (true) {
				chosenRect = _spawnZones[FlxRandom.intRanged(0, _spawnZones.length - 1)];
				spawnX = FlxRandom.floatRanged(chosenRect.left, chosenRect.right);
				spawnY = FlxRandom.floatRanged(chosenRect.top, chosenRect.bottom);
				nextPoint = new FlxPoint(spawnX, spawnY);
				var isTooClose:Bool = false;
				if ( !isTooClose ) {
					for (p in points) {
						if (nextPoint.distanceTo(p) < 40) {
							isTooClose = true;
						}
					}
				}
				if (!isTooClose) {
					numberOfTries = 0;
					break;
				} else {
					numberOfTries++;
					if (numberOfTries > 25) {
						noMoreSpace = true;
						break;
					}
				}
			}
			if (noMoreSpace) {
				break;
			}
			points.add(nextPoint);
		}
		for (p in points) {
			onSpawn(p);
		}
	}
	
	override public function update()
	{
		if (_isSpawning) {
			if (_ticks % _time_between_spawns_in_frames == 0 || FlxRandom.chanceRoll(_random_spawn_chance_per_frame)) {
				spawnWave(_number_to_spawn);
			}
		}
		_ticks++;
		super.update();
	}
	
	public function startSpawning()
	{
		_isSpawning = true;
	}
	
	public function stopSpawning()
	{
		_isSpawning = false;
	}
	
	public function rampUp()
	{
		_time_between_spawns_in_frames = 
		Math.round(_time_between_spawns_in_frames * 
					_time_decrease_factor_per_round);
		if ( _time_between_spawns_in_frames < _minimum_time_between_spawns) {
			_time_between_spawns_in_frames = _minimum_time_between_spawns;
		}
	}
	
	public function onSpawn(s:FlxPoint) {}
	
	
}