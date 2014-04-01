package gameplay ;
import flixel.addons.weapon.FlxWeapon;
import flixel.FlxSprite;
import flixel.FlxState;
import gameplay.characters.Sprite;

/**
 * ...
 * @author Bill Tyros
 */
class Pickup extends Sprite
{
	private var _weapon:Class<FlxWeapon>;
	private var _isActive:Bool;

	public function new(X:Float=0, Y:Float=0) 
	{
		super(X, Y);
		loadGraphic("assets/images/gift.png", false, false);
		_isActive = false;
		visible = false;
	}
	
	override public function addSelfTo(S:FlxState)
	{
		super.addSelfTo(S);
	}
	
	
	override public function update()
	{
		super.update();
	}
	
	public function isActive() : Bool
	{
		return _isActive;
	}
	
	public function trigger(parent:FlxSprite) : FlxWeapon
	{
		if ( isActive() )
		{
			_isActive = false;
			visible = false;
			return Type.createInstance( _weapon, [parent] );
		}
		return null;
	}
	
	public function activate(w:Class<FlxWeapon>, x:Float, y:Float)
	{
		if ( !isActive() )
		{
			_weapon = w;
			visible = true;
			setPosition(x, y);
			_isActive = true;	
		}
	}
	 
}