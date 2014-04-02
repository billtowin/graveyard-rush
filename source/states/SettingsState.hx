package states;

import flixel.FlxState;
import flixel.text.FlxText;

import flixel.ui.FlxButton;
import flixel.addons.ui.FlxInputText;
import flixel.FlxG;
import flixel.util.FlxColor;

/**
 * ...
 * @author Bill Tyros
 */
class SettingsState extends FlxState
{
  private var _name:FlxInputText;
  private var _label:FlxText;
  private var _back:FlxButton;
  private var _text:String;
	
	override public function create() : Void
	{
    _text = "";
    if (FlxG.save.data.name != null) {
      _text = FlxG.save.data.name;
    }
    _name = new FlxInputText(FlxG.width * 0.45, FlxG.height * 0.5, 200, _text, 12, FlxColor.BLACK, FlxColor.WHITE);
    add(_name);
    _label = new FlxText(_name.x - _name.textField.width * 0.5, _name.y, 150, "Name:", 12);
    add(_label);
    _back = new FlxButton(25, FlxG.height * 0.9, "Back", onClickBack);
		add(_back);
		super.create();
	}
  
  override public function update() : Void
  {
    if (_name.hasFocus && _text != _name.text)
    {
      _text = _name.text;
      FlxG.save.data.name = _text;
      FlxG.save.flush();
      trace(FlxG.save.data.name);
    }
    super.update();
  }
  
  
	public function onClickBack()
	{
		FlxG.switchState(new MenuState());
	}
	
}