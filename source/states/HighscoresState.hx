package states;

import flixel.FlxG;
import flixel.group.FlxTypedGroup.FlxTypedGroup;
import flixel.ui.FlxButton;
import flixel.FlxState;
import playtomic.Leaderboards;

import flash.text.TextFieldAutoSize;

/**
 * ...
 * @author Bill Tyros
 */
class HighscoresState extends FlxState
{
	private var _highscores:FlxTypedGroup<HighScore>;
	private var _back:FlxButton;
	  
	override public function create() : Void
	{
    _highscores = new FlxTypedGroup<HighScore>();
    add(_highscores);
    Leaderboards.list( { table: "highscores", page: 1, perpage: 10, highest: true }, listComplete);
    
		_back = new FlxButton(25, FlxG.height * 0.9, "Back", onClickBack);
		add(_back);
		super.create();
	}

  function listComplete(scores:Array<Dynamic>, numscores:Int, response:Dynamic) : Void
  {
      if(response.success)
      {
          trace(scores.length + " scores returned out of " + numscores);
          var lastHeight = 0.0;
          scores.unshift( { playername: "NAME", points: "SCORE" } );
          var position:String;
          for( i in 0...(scores.length-1))
          {
              var score:Dynamic = scores[i];
              if ( i == 0) {
                position = "POSITION";
              } else {
                position = "" + (i + 1);
              }
              var next = new HighScore(0, 0, score.playername, position, score.points);
              next.textField.autoSize = Aut
              _highscores.add(next);
              next.x = FlxG.width * 0.5;
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
}