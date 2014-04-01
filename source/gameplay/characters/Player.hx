package gameplay.characters ;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxTypedGroup.FlxTypedGroup;
import flixel.util.FlxAngle;
import flixel.addons.weapon.FlxWeapon;
import flixel.addons.weapon.FlxBullet;

import gameplay.weapons.Pistol;

/**
 * ...
 * @author Bill Tyros
 */
class Player extends Sprite
{
	static private inline var FORWARD_SPEED:Int = 125;
	static private inline var BACKWARD_SPEED:Int = 65;
	static private inline var STRAFE_SPEED:Int = 85;
	static private inline var BULLET_BUFFER:Int = 35;
	
	private var _weaponPrimary:FlxWeapon;
	private var _weaponSecondary:FlxWeapon;
	
	private var _isDisabled:Bool = false;
	
	public function new(X:Float=0, Y:Float=0) 
	{
		super(X, Y);
		loadGraphic("assets/images/player.png", true, true, 32, 45);
		animation.add("walk", [2, 0, 1], 5, true);
		animation.add("strafeLeft", [2, 3, 4], 5, true);
		animation.add("strafeRight", [2, 4, 3], 5, true);
		animation.add("stand", [2], 5, true);
		setOriginToCenter();
		animation.play("stand");
		solid = true;
		immovable = false;
		
		_weaponPrimary = new Pistol(this);
		_weaponSecondary = null;
	}
	
		
	override public function addSelfTo(S:FlxState)
	{
		addWeaponsInState(S);
		super.addSelfTo(S);
	}
	
	override public function update()
	{
		if ( !_isDisabled )
		{
			if ( Math.abs(FlxG.mouse.x - this.x) + Math.abs(FlxG.mouse.y - this.y) > 20)
			{
				angle = FlxAngle.angleBetweenMouse(this, true) + 90;
			}
			
			if (FlxG.keys.anyPressed(["UP", "W"])) {
				animation.play("walk");
				velocity.x = FORWARD_SPEED * Math.cos(FlxAngle.TO_RAD * (angle - 90));
				velocity.y = FORWARD_SPEED * Math.sin(FlxAngle.TO_RAD * (angle - 90));
			} else if (FlxG.keys.anyPressed(["DOWN", "S"])) {
				animation.play("walk");
				velocity.x = - BACKWARD_SPEED * Math.cos(FlxAngle.TO_RAD * (angle - 90));
				velocity.y = - BACKWARD_SPEED * Math.sin(FlxAngle.TO_RAD * (angle - 90));
			} else if (FlxG.keys.anyPressed(["LEFT", "A"])) {
				animation.play("strafeLeft");
				velocity.x = - STRAFE_SPEED * Math.cos(FlxAngle.TO_RAD * angle);
				velocity.y = - STRAFE_SPEED * Math.sin(FlxAngle.TO_RAD * angle);
			} else if (FlxG.keys.anyPressed(["RIGHT", "D"])) {
				animation.play("strafeRight");
				velocity.x = STRAFE_SPEED * Math.cos(FlxAngle.TO_RAD * angle);
				velocity.y = STRAFE_SPEED * Math.sin(FlxAngle.TO_RAD * angle);
			} else {
				animation.play("stand");
				velocity.x = 0;
				velocity.y = 0;
			}
			
			if (FlxG.mouse.pressed || FlxG.mouse.pressedRight) {
				var x:Float = BULLET_BUFFER * Math.cos(FlxAngle.TO_RAD * (angle - 90)) + _halfWidth;
				var y:Float = BULLET_BUFFER * Math.sin(FlxAngle.TO_RAD * (angle - 90)) + _halfHeight;
				if (_weaponPrimary != null && FlxG.mouse.pressed)
				{
					_weaponPrimary.setBulletOffset(x, y);
					if (_weaponPrimary.fireFromAngle(Std.int(angle) - 90))
					{
						//gun fired
					} else {
						//gun did not fire, no bullets
					}
				} else if ( _weaponSecondary != null && FlxG.mouse.pressedRight) {
					_weaponSecondary.setBulletOffset(x, y);
					if (_weaponSecondary.fireFromAngle(Std.int(angle) - 90))
					{
						//gun fired
					} else {
						//gun did not fire, no bullets
					}
				}
			}	
		}
		
		super.update();
	}
	
	private function removeWeaponsInState(s:FlxState) {
		if (_weaponPrimary != null)
		{
			s.remove(_weaponPrimary.group);
		}
		if (_weaponSecondary != null)
		{
			s.remove(_weaponSecondary.group);			
		}
	}
	
	public function addWeaponsInState(s:FlxState) {
		if (_weaponPrimary != null)
		{
			s.add(_weaponPrimary.group);
		}
		if (_weaponSecondary != null)
		{
			s.add(_weaponSecondary.group);			
		}
	}
	
	public function setNewSecondaryWeapon(w:FlxWeapon, s:FlxState)
	{
		if (_weaponSecondary != null)
		{
			s.remove(_weaponSecondary.group);
		}
		_weaponSecondary = w;
		s.add(_weaponSecondary.group);
	}
	
	public function getPrimaryWeaponGroup() : FlxTypedGroup<FlxBullet>
	{
		if (_weaponPrimary != null)
		{
			return _weaponPrimary.group;
		}
		return null;
	}
	public function getSecondaryWeaponGroup() : FlxTypedGroup<FlxBullet>
	{
		if (_weaponSecondary != null)
		{
			return _weaponSecondary.group;
		}
		return null;
	}
	
	public function isPrimaryWeaponValid() : Bool
	{
		return _weaponPrimary != null;
	}
	
	public function isSecondaryWeaponValid() : Bool
	{
		return _weaponSecondary != null;
	}
	
	public function disable()
	{
		visible = false;
		_isDisabled = true;
		velocity.x = 0.0;
		velocity.y = 0.0;
		solid = false;
	}
	
	public function enable()
	{
		visible = true;
		_isDisabled = false;
		solid = true;
	}
}