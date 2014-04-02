package states;

import flash.text.TextFieldAutoSize;
import flixel.addons.text.FlxTypeText;
import flixel.addons.weapon.FlxBullet;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
import flixel.util.FlxCollision;
import flixel.group.FlxTypedGroup;
import flixel.util.FlxSave;
import flixel.util.FlxRandom;
import flixel.util.FlxPoint;
import flixel.effects.particles.FlxEmitter;
import flixel.addons.display.FlxBackdrop;
import flixel.util.FlxRect;
import flixel.addons.weapon.FlxWeapon;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import gameplay.characters.Spitter;
import flixel.util.FlxTimer;
import gameplay.Horde;
import gameplay.SpitterHorde;

import gameplay.Pickup;
import gameplay.characters.Player;
import gameplay.characters.Zombie;
import gameplay.scenery.Crate;
import gameplay.scenery.Wall;
import gameplay.weapons.Flamethrower;
import gameplay.weapons.Shotgun;
import gameplay.weapons.Burst;
import gameplay.ZombieHorde;

/**
 * A FlxState which can be used for the actual gameplay.
 */
class ClassicPlayState extends FlxState
{
	private var _player:Player;
	private var _pickup:Pickup;
	private var _crate:Crate;
	private var _wall:Wall;
	private var _tombstone:FlxSprite;
	private var _floor:FlxBackdrop;
	
	private var _enemyHorde:FlxTypedGroup<Horde>;
	private var _zombieHorde:ZombieHorde;
	private var _spitterHorde:SpitterHorde;
	private var _ticks:Int;
	
	private var _score:FlxText;
	private var _highScore:FlxText;
	private var _status:FlxText;
	private var _hints:FlxText = null;
	private var _weaponPopup:FlxText;
	
	
	private var _weaponClasses:Array<Class<FlxWeapon>> = [Flamethrower, Shotgun, Burst];
	private var _lastGivenWeaponClass:Class<FlxWeapon> = null;
	
	private var _roundNumber:Int = 1;
	
	private var SPAWN_ZONE_SIZE:Int = 32;
	
	private var _isBreak:Bool = false;
	private var _breakTime:Int = 0;
	private var _battleDuration:Int = 60 * 15; //in frames
	private var _battleDurationIncreaseFactor:Float = 1.05;
	private var _breakDuration:Int = 60 * 6; //in frames
	
	private var _isGameOver:Bool = false;
	
	private var _bloodSplatter:FlxEmitter;
	
	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		super.create();	
		
		_ticks = 0;
		setupMouseCursorIcon();
		loadSaveData();
		createSprites();
		createTexts();
	}
	
	private function setupMouseCursorIcon()
	{
		var sprite = new FlxSprite();
		sprite.loadGraphic("assets/images/cursor_red.png");
		FlxG.mouse.load(sprite.pixels);
	}
	
	private function loadSaveData()
	{
		Reg.high_score = FlxG.save.data.high_score;
		if (FlxG.save.data.high_score == null) {
			Reg.high_score = 0;
		}
	}
	
	private function createSprites()
	{
		_floor = new FlxBackdrop("assets/images/floor.png", 1, 1, true, true);
		add(_floor);
		
		_bloodSplatter = new FlxEmitter();
		_bloodSplatter.makeParticles("assets/images/zombie_blood.png", 100, 16);
		_bloodSplatter.setXSpeed( 0, 0);
		_bloodSplatter.setYSpeed( 0, 0);
		_bloodSplatter.setRotation(0, 0);
		_bloodSplatter.setScale(0.6, 0.6, 0.6, 0.6);
		add(_bloodSplatter);
		
		_crate = new Crate();
		_crate.setPosition(FlxG.width * 0.5 - _crate.width * 0.5, FlxG.height * 0.7 - _crate.height * 0.5);
		_crate.addSelfTo(this);
		
		_wall = new Wall();
		_wall.setPosition(FlxG.width * 0.5 - _wall.width*0.5, FlxG.height * 0.5 - _wall.height*0.5);
		_wall.addSelfTo(this);
		
		_pickup = new Pickup();
		_pickup.addSelfTo(this);
		resetPickup();
		
		_player = new Player();
		_player.setPosition(FlxG.width * 0.5 - _player.width * 0.5, FlxG.height * 0.4 - _player.height * 0.5);
		_player.addSelfTo(this);
		
		_tombstone = new FlxSprite(FlxG.width * 0.5, -100);
		_tombstone.loadGraphic("assets/images/tombstone.png", true, false, 32, 32);
		_tombstone.animation.add("popup", [0, 1, 2, 3, 4, 5, 6, 7, 8], 30, false);
		_tombstone.visible = false;
		_tombstone.solid = true;
		_tombstone.immovable = true;
		add(_tombstone);
		
		var spawnZones = 		
		[
			new FlxRect(0, -32, FlxG.width -32 , SPAWN_ZONE_SIZE), //TOP
			new FlxRect(0, FlxG.height + 32, FlxG.width -32 , SPAWN_ZONE_SIZE), //BOT
			new FlxRect(-32, 0, SPAWN_ZONE_SIZE , FlxG.height), //LEFT
			new FlxRect(FlxG.width + 32, 0, SPAWN_ZONE_SIZE , FlxG.height) //RIGHT
		];
		_zombieHorde = new ZombieHorde(_player, spawnZones);
		_zombieHorde.addSelfTo(this);
		//TODO build ComboHorde -> a lot of hordes together/ in one
		
		_spitterHorde = new SpitterHorde(_player, spawnZones);
		_spitterHorde.addSelfTo(this);
		
		_enemyHorde = new FlxTypedGroup<Horde>();
		_enemyHorde.add(_zombieHorde);
		_enemyHorde.add(_spitterHorde);
	}
	
	private function createTexts()
	{
		_weaponPopup = new FlxText(0, 0, 200, "nothing", 12);
		_weaponPopup.alpha = 0.0;
		add(_weaponPopup);
		_score = new FlxText(0, 0, 200, "" + Reg.score, 12);
		_score.setPosition(1, 1);
		add(_score);
		
		_highScore = new FlxText(0, 0, 200, "" + Reg.high_score, 12);
		_highScore.setPosition(1, 1 + _score.textField.height);
		add(_highScore);
		
		_status = new FlxText(0, 0, 160, "a", 12);
		_status.setPosition(FlxG.width * 0.41, FlxG.height * 0.46 - _status.textField.height);
		add(_status);
		updateStatusText();
		
		if (Reg.high_score < 5) {
			_hints = new FlxText(0, 0, Std.int(FlxG.width * 0.99), "WASD: move, Mouse: aim. Left click: shoot primary, Right click: shoot secondary (must pick one up), + and - to change volume." +
			" Gather present boxes to score points! Survive increasingly difficult Battle rounds interleaved with Rest rounds.", 12);
			_hints.setPosition(2, FlxG.height * 0.9);
			_hints.alpha = 1.0;
			FlxTween.singleVar(_hints, "alpha", 0.0, 10.0);
			add(_hints);
		}
	}
	
	/**
	 * Function that is called when this state is destroyed - you might want to 
	 * consider setting all objects this state uses to null to help garbage collection.
	 */
	override public function destroy():Void
	{
		super.destroy();
	}

	/**
	 * Function that is called once every frame.
	 */
	override public function update():Void
	{
		if (FlxG.keys.justPressed.DELETE) {
			resetHighScore();
		}
		
		if (_isGameOver && FlxG.mouse.justPressed) {
			onGameOver(null);
		}
		
		if (!_isBreak && _ticks != 0 && _ticks % _battleDuration == 0)
		{
			_battleDuration = Math.round(_battleDuration * _battleDurationIncreaseFactor);
			FlxG.sound.play("assets/sounds/roundSwitch.wav");
			_zombieHorde.stopSpawning();
			_spitterHorde.stopSpawning();
			_isBreak = true;
			updateStatusText();
			FlxTween.color(_status, 1.0, FlxColor.RED, FlxColor.GREEN);
			_breakTime = _ticks;
		}
		
		if (_ticks == 0 || _isBreak && _ticks - _breakTime >= _breakDuration)
		{
			FlxG.sound.play("assets/sounds/roundSwitch.wav");
			if ( _ticks != 0) {
				_zombieHorde.rampUp();
				if (_roundNumber >= 2)
				{
					_spitterHorde.rampUp();
				}
				_roundNumber++;
			}
			_zombieHorde.startSpawning();
			if (_roundNumber >= 2)
			{
				_spitterHorde.startSpawning();
			}
			_isBreak = false;
			updateStatusText();
			FlxTween.color(_status, 1.0, FlxColor.GREEN, FlxColor.RED);
			if (!_pickup.isActive())
			{
				resetPickup();
			}
		}
		if (_pickup.isActive() && _player.overlaps(_pickup)) {
			FlxG.sound.play("assets/sounds/pickup1.wav");
			var pickupSpot:FlxPoint = new FlxPoint(_pickup.x, _pickup.y);
			var newWeap:FlxWeapon = _pickup.trigger(_player);
			_weaponPopup.text = newWeap.name;
			_weaponPopup.setPosition(pickupSpot.x, pickupSpot.y);
			_weaponPopup.alpha = 1.0;
			FlxTween.tween(_weaponPopup, { alpha: 0.0 }, 1.0);
			FlxTween.linearMotion(_weaponPopup, pickupSpot.x, pickupSpot.y, pickupSpot.x, pickupSpot.y - _player.height, 1.0);
			_player.setNewSecondaryWeapon(newWeap, this);
			Reg.score++;
			if (!_isBreak)
			{
				resetPickup(pickupSpot);
			}
		}
		
		performCollisions();
		
		checkForBulletOverlapOnEnemy(_spitterHorde);
		checkForBulletOverlapOnEnemy(_zombieHorde);
		checkForBulletOverlapOnScenery();
		
		checkForGameOver();
		
		_score.text = "" + Reg.score;
		
		_ticks++;
		super.update();
	}
	
	private function updateStatusText()
	{
		if (_isBreak)
		{
			_status.text = "Rest Round #" + _roundNumber;
		} else {
			_status.text = "Battle Round #" + _roundNumber;
		}
	}
	
	private function resetPickup(old:FlxPoint=null)
	{
		var p:FlxPoint = new FlxPoint();
		do {
			p.x = FlxRandom.floatRanged(100, FlxG.width - 100);
			p.y = FlxRandom.floatRanged(100, FlxG.height - 100);
			 //Avoid spawns along the diagonal and the old position
		} while (Math.abs(p.x - FlxG.width*0.5) < 50 
			|| (old != null && (p.distanceTo(old) < 100 || p.distanceTo(old) > 350) ) );
		var wepClass:Class<FlxWeapon> = getRandomWeaponClass();
		_lastGivenWeaponClass = wepClass;
		_pickup.activate(wepClass, p.x, p.y);
	}
	
	private function getRandomWeaponClass() : Class<FlxWeapon>
	{
		var wepClass:Class<FlxWeapon> = null;
		do {
			wepClass = _weaponClasses[FlxRandom.intRanged(0, _weaponClasses.length - 1)];
		} while (_lastGivenWeaponClass != null && _lastGivenWeaponClass == wepClass);
		return wepClass;
	}
	
	private function performCollisions()
	{
		FlxG.collide(_wall, _player);
		FlxG.collide(_wall, _crate);
		FlxG.collide(_wall, _enemyHorde);
		FlxG.collide(_crate, _player);
		FlxG.collide(_crate, _enemyHorde);
		FlxG.collide(_enemyHorde, _enemyHorde);
		FlxG.collide(_tombstone, _enemyHorde);
	}
	
	private function resetHighScore()
	{
		Reg.high_score = 0;
		_highScore.text = "" + Reg.high_score;
		FlxG.save.data.high_score = 0;
		FlxG.save.flush();
	}
	
	private function checkForGameOver()
	{
		if ( !_player.inWorldBounds() || 
			FlxG.collide(_player, _enemyHorde) || 
			FlxG.overlap(_player, _spitterHorde.getProjectiles()) )
		{
			FlxG.sound.play("assets/sounds/tombstoneUp.wav");
			_tombstone.animation.play("popup");
			_tombstone.visible = true;
			_tombstone.x = _player.x;
			_tombstone.y = _player.y;
			_tombstone.alpha = 0.0;
			FlxTween.singleVar(_tombstone, "alpha", 1.0, 0.1);
			_status.text = "Game Over!";
			_status.color = FlxColor.RED;
			_isGameOver = true;
			launchBlood(_player.x, _player.y);
			_player.disable();
			FlxTimer.start(3, onGameOver);
		}
	}
	
	private function checkForBulletOverlapOnEnemy(H:Horde)
	{
		for ( z in H)
		{
			if ( !z.alive ) { continue; }
			if ( _player.isPrimaryWeaponValid())
			{
				for ( b in _player.getPrimaryWeaponGroup())
				{
					if (b.overlaps(z))
					{
						launchBlood(z.x, z.y);
						z.kill();
						disableBullet(b);
					}
				}
			}
			if ( _player.isSecondaryWeaponValid())
			{
				for ( b in _player.getSecondaryWeaponGroup())
				{
					if (b.overlaps(z))
					{
						launchBlood(z.x, z.y);
						z.kill();
						disableBullet(b);
					}
				}
			}
		}
	}
	
	private function checkForBulletOverlapOnScenery()
	{
		if ( _player.isPrimaryWeaponValid())
		{
			for ( b in _player.getPrimaryWeaponGroup())
			{
				if (_crate.overlaps(b) || _wall.overlaps(b)) {
					disableBullet(b);
				}
			}
		}
		if ( _player.isSecondaryWeaponValid())
		{
			for ( b in _player.getSecondaryWeaponGroup())
			{
				if (_crate.overlaps(b) || _wall.overlaps(b)) {
					disableBullet(b);
				}
			}	
		}
		for ( bullets in _spitterHorde.getProjectiles())
		{
			for (b in bullets)
			{
				if (_crate.overlaps(b) || _wall.overlaps(b)) {
					disableBullet(b);
				}
			}
		}
	}
	
	private function disableBullet(b:FlxBullet)
	{
		b.x = -200;
		b.y = -200;
		b.velocity.x = 0;
		b.velocity.y = 0;
	}
	
	private function launchBlood(X:Float, Y:Float):Void
	{
		_bloodSplatter.x = X + 16;
		_bloodSplatter.y = Y + 16;
		_bloodSplatter.start(true, 0, 0, 1, 0);
	}
	
	private function onGameOver(t:FlxTimer)
	{
		if (Reg.high_score < Reg.score)
		{
			Reg.high_score = Reg.score;
			_highScore.text = "" + Reg.high_score;
			FlxG.save.data.high_score = Reg.high_score;
			FlxG.save.flush();
		}
		Reg.score = 0;
		FlxG.resetState();
	}
}