package states;

import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.FlxG;

/**
 * ...
 * @author Bill Tyros
 */
class HowToPlayState extends FlxState
{
	private var _controls:FlxText;
	private var _gameplay:FlxText;
	private var _back:FlxButton;
	
	override public function create() : Void
	{
		_controls = new FlxText(FlxG.width * 0.5, FlxG.height * 0.5, Std.int(FlxG.width * 0.99), "WASD: move\nMouse: aim\nLeft click: shoot primary\nRight click: shoot secondary\n+ and - to change volume\n", 12);
		_controls.x -= _controls.width * 0.25;
		add(_controls);
		
		_gameplay = new FlxText(0, 0, Std.int(FlxG.width * 0.99), "Gather present boxes to score points!\nSurvive increasingly difficult Battle rounds interleaved with Rest rounds.", 12);
		_gameplay.y = _controls.y + _controls.textField.height;
		add(_gameplay);
		
		_back = new FlxButton(25, FlxG.height * 0.9, "Back", onClickBack);
		add(_back);
		super.create();
	}
	
	public function onClickBack()
	{
		FlxG.switchState(new MenuState());
	}
}