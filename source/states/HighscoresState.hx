package states;

import flixel.FlxG;
import flixel.group.FlxTypedGroup.FlxTypedGroup;
import flixel.ui.FlxButton;
import flixel.FlxState;
import flixel.util.FlxTimer;
import playtomic.Leaderboards;
import flixel.text.FlxText;

import flash.text.TextFieldAutoSize;

/**
 * ...
 * @author Bill Tyros
 */
class HighscoresState extends FlxState
{
	private var _highscores:FlxTypedGroup<HighScore>;
  private var _top:FlxText;
  private var _refresh:FlxButton;
  private var _canRefresh:Bool = true;
  private var _refreshDelay:Float = 2.0;
	private var _back:FlxButton;
  private var _left:FlxButton;
  private var _right:FlxButton;
  private var _pageNumber:Int = 1;
  private var _numberOfPages:Int = 0;
  private var _numberEntriesPerPage:Int = 10;
	  
	override public function create() : Void
	{
    _highscores = new FlxTypedGroup<HighScore>();
    add(_highscores);
    
    _top = new FlxText(0, FlxG.height * 0.2, 300, "Rank | Score | Name | Time Posted", 12);
    _top.textField.autoSize = TextFieldAutoSize.CENTER;
    _top.x = FlxG.width * 0.5 - _top.textField.width * 0.5;
    add(_top);
    
    _refresh = new FlxButton(25, FlxG.height * 0.8, "Refresh", onClickRefresh);
		add(_refresh);
    
		_back = new FlxButton(25, FlxG.height * 0.9, "Back", onClickBack);
		add(_back);
    
    _left = new FlxButton(FlxG.width * 0.4, FlxG.height * 0.8, "<-", onClickLeft);
    add(_left);
    _right = new FlxButton(FlxG.width * 0.6, FlxG.height * 0.8, "->", onClickRight);
    add(_right);
    onClickRefresh();
		super.create();
	}

  function listComplete(scores:Array<Dynamic>, numscores:Int, response:Dynamic) : Void
  {
      if(response.success)
      {
        _numberOfPages = Math.floor(numscores / _numberEntriesPerPage) + 1;
        for (highscore in _highscores) 
        {
          highscore.visible = false;
          highscore.destroy();
        }
        _highscores.clear();
        trace(scores.length + " scores returned out of " + numscores);
        var lastHeight = FlxG.height * 0.25;
        var position:String;
        for( score in scores )
        {
            var next = new HighScore(0, 0, score.playername, score.rank, score.points, score.rdate);
            next.textField.autoSize = TextFieldAutoSize.CENTER;
            _highscores.add(next);
            next.x = FlxG.width * 0.5 - next.textField.width * 0.5;
            next.y = lastHeight;
            lastHeight += next.textField.height;
            // including custom data?  score.fields.property
        }
      }
      else
      {
          // score listing failed because of response.errorMessage with response.errorcode
      }
  }
  
	public function onClickBack()
	{
		FlxG.switchState(new MenuState());
	}
  
  public function onClickRefresh()
  {
    if ( _canRefresh )
    {
      _canRefresh = false;
      Leaderboards.list( { table: "highscores", page: _pageNumber, perpage: _numberEntriesPerPage, highest: true }, listComplete);
      FlxTimer.start(_refreshDelay, enableRefresh);
    }
  }
  
  public function enableRefresh(f:FlxTimer)
  {
    _canRefresh = true;
  }
  
  public function onClickLeft()
  {
    if ( _pageNumber > 1) {
      _pageNumber--;
      enableRefresh(null);
      onClickRefresh();
    }
  }
  
  public function onClickRight()
  {
    if (_pageNumber < _numberOfPages)
    {
      _pageNumber++;
      enableRefresh(null);
      onClickRefresh();
    }
  }
}