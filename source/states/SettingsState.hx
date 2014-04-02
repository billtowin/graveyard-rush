package states;

import flixel.FlxState;

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
  private var _back:FlxButton;
  private var _text:String;
	
	override public function create() : Void
	{
    _text = "";
    if (FlxG.save.data.name != null) {
      _text = FlxG.save.data.name;
    }
    _name = new FlxInputText(FlxG.width * 0.5, FlxG.height * 0.5, 200, _text, 12, FlxColor.BLACK, FlxColor.WHITE);
    add(_name);
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