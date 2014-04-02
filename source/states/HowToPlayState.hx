package states;

import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.FlxG;

import flash.text.TextFieldAutoSize;

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
		_controls = new FlxText(FlxG.width * 0.5, FlxG.height * 0.3, Std.int(FlxG.width * 0.99), "WASD: move\nMouse: aim\nLeft click: shoot primary\nRight click: shoot secondary\n+ and - to change volume\nEscape to quit the game.\nBackspace to return to the menu.", 12);
		_controls.textField.autoSize = TextFieldAutoSize.CENTER;
    _controls.x -= _controls.textField.width * 0.5;
		add(_controls);
		
		_gameplay = new FlxText(FlxG.width * 0.5, 0, Std.int(FlxG.width * 0.99), "Gather present boxes to score points!\nSurvive increasingly difficult Battle rounds interleaved with Rest rounds.", 12);
		_gameplay.textField.autoSize = TextFieldAutoSize.CENTER;
    _gameplay.x -= _gameplay.textField.width * 0.5;
    _gameplay.y = _controls.y + _controls.textField.height * 1.5;
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