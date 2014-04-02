package states;

import flash.system.System;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;

/**
 * A FlxState which can be used for the game's menu.
 */
class MenuState extends FlxState
{
	
	private var _title:FlxSprite;
	private var _play:FlxButton;
	private var _how_to_play:FlxButton;
	private var _highScores:FlxButton;
  private var _settings:FlxButton;
	private var _quit:FlxButton;
  
  private var _warning:FlxText;
	
	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		super.create();
    _warning = new FlxText(0, 0, 200, "Go into the settings and set your name first please! You won't regret it.", 12);
		_warning.visible = false;
    add(_warning);
    _title = new FlxSprite(0, 0, "assets/images/title.png");
		_title.setPosition(FlxG.game.width * 0.5, FlxG.game.height * 0.35 - _title.height * 0.5);
		add(_title);
		
		_play = new FlxButton(FlxG.width * 0.5, FlxG.height * 0.4, "Play", onClickPlay);
		_play.x -= _play.width * 0.5;
		add(_play);
		
		_how_to_play = new FlxButton(FlxG.width * 0.5, FlxG.height * 0.5, "How To Play", onClickHowToPlay);
		_how_to_play.x -= _how_to_play.width * 0.5;
		add(_how_to_play);
		
		_highScores = new FlxButton(FlxG.width * 0.5, FlxG.height * 0.6, "Highscores", onClickHighscores);
		_highScores.x -= _highScores.width * 0.5;
		add(_highScores);
		
		_settings = new FlxButton(FlxG.width * 0.5, FlxG.height * 0.7, "Settings", onClickSettings);
		_settings.x -= _settings.width * 0.5;
		add(_settings);
		
		_quit = new FlxButton(FlxG.width * 0.5, FlxG.height * 0.8, "Quit", onClickQuit);
		_quit.x -= _quit.width * 0.5;
		add(_quit);
	}
	
	public function onClickPlay()
	{
    if ( FlxG.save.data.name == null || FlxG.save.data.name == "") {
       _warning.visible = true;
    } else {
      FlxG.switchState(new ClassicPlayState());
    }
	}
	
	public function onClickHowToPlay()
	{
		FlxG.switchState( new HowToPlayState() );
	}
	
	public function onClickHighscores()
	{
		FlxG.switchState( new HighscoresState() );
	}
  
  public function onClickSettings()
  {
    FlxG.switchState( new SettingsState() );
  }
	
	public function onClickQuit()
	{
		System.exit(0);
	}
	
	
	/**
	 * Function that is called when this state is destroyed - you might want to 
	 * consider setting all objects this state uses to null to help garbage collection.
	 */
	override public function destroy():Void
	{
		_title = null;
		
		super.destroy();
	}

	/**
	 * Function that is called once every frame.
	 */
	override public function update():Void
	{
		super.update();
	}	
}