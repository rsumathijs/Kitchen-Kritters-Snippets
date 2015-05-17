package 
{
	import flash.events.KeyboardEvent;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.display.DisplayObject;
	import flash.ui.Keyboard;
	import flash.display.MovieClip;
	import flash.geom.Point;
	import flash.system.fscommand;
	import flash.geom.Rectangle;
	import flash.display.Sprite;

	//Manages the game world
	public class LevelManager extends MovieClip
	{
		private var keyArray:Array;
		private var collisionManager:CollisionManager;
		private var stepTimer:Timer;

		private var outerBound:Rectangle;
		private var innerBound:MovieClip;

		private var player1:Player1;
		private var player2:Player2;

		private var headChef1:HeadChef1;
		private var headChef2:HeadChef2;

		private var bubble1:ThoughtBubble1;
		private var bubble2:ThoughtBubble2;

		private var pot1:Pot1;
		private var pot2:Pot2;

		private var cutBoard1:DropArea1;
		private var cutBoard2:DropArea2;

		private var ingredArray:Array;
		private var removedIngredArray:Array;

		private var timeLeft:int;
		private var updateCount:uint;
		private var screenManager:ScreenManager;

		private var endgameText:String;

		private var playerLayer:PlayerLayer;
		private var ingredsLayer:PlayerLayer;

		//constructor to initialise members
		public function LevelManager(screen:ScreenManager)
		{
			screenManager = screen;

			collisionManager = new CollisionManager();
			stepTimer = new Timer(Constants.UPDATE_RATE);
			stepTimer.addEventListener(TimerEvent.TIMER, handleTick);
			outerBound = new Rectangle(Constants.OUTER_BOUND_LEFT_PADDING,
			   Constants.OUTER_BOUND_TOP_PADDING,
			   Constants.OUTER_BOUND_WIDTH-Constants.OUTER_BOUND_RIGHT_PADDING,
			   Constants.OUTER_BOUND_HEIGHT-Constants.OUTER_BOUND_BOTTOM_PADDING);

			player1 = new Player1();
			player2 = new Player2();
		}

		public function init()
		{
			updateCount = 0;

			this.stage.addEventListener(KeyboardEvent.KEY_DOWN, handleKeyDown);
			this.stage.addEventListener(KeyboardEvent.KEY_UP, handleKeyUp);

			initObjects();
			initInputKeys();
			initScoresAndTimer();
			generateRandomIngredients();

			doPregameActions();

			stepTimer.start();
			stage.focus = this.stage;
		}

		// map objects on the level to objects
		private function initObjects()
		{
			playerLayer = playerLayer_mc;
			ingredsLayer = ingredsLayer_mc;

			innerBound = innerBound_mc;

			playerLayer.addChild(player1);
			playerLayer.addChild(player2);

			player1.resetPositions(Constants.PLAYER1_START_POSITION.x, Constants.PLAYER1_START_POSITION.y);
			player1.scaleX = 1;
			if (player1.isHolding())
			{
				player1.removeChildAt(1);
				player1.setHolding(false);
			}

			player2.resetPositions(Constants.PLAYER2_START_POSITION.x, Constants.PLAYER2_START_POSITION.y);
			player2.scaleX = -1;
			if (player2.isHolding())
			{
				player2.removeChildAt(1);
				player2.setHolding(false);
			}

			cutBoard1 = cutboard1_mc;
			cutBoard2 = cutboard2_mc;

			headChef1 = headchef1_mc;
			headChef1.decideIngredients();

			headChef2 = headchef2_mc;
			headChef2.decideIngredients();

			pot1 = new Pot1();
			pot2 = new Pot2();

			bubble1 = bubble1_mc;
			bubble1.textDots.visible = true;
			bubble1.setSequence(headChef1.getChefsRequest());

			bubble2 = bubble2_mc;
			bubble2.textDots.visible = true;
			bubble2.setSequence(headChef2.getChefsRequest());

			combo1.text = "";
			combo2.text = "";
		}

		private function initInputKeys()
		{
			keyArray = new Array();

			//Player 1 (left side) controls
			keyArray[Keyboard.UP] = false;
			keyArray[Keyboard.DOWN] = false;
			keyArray[Keyboard.LEFT] = false;
			keyArray[Keyboard.RIGHT] = false;
			keyArray[Keyboard.ENTER] = false;

			//Player 2 (right side) controls
			keyArray[Keyboard.W] = false;
			keyArray[Keyboard.A] = false;
			keyArray[Keyboard.S] = false;
			keyArray[Keyboard.D] = false;
			keyArray[Keyboard.TAB] = false;
		}

		private function initScoresAndTimer()
		{
			timeLeft = Constants.GAMEPLAY_TIME;
		}

		//generate the ingredients on the counter
		private function generateRandomIngredients()
		{
			ingredArray = new Array();
			removedIngredArray = new Array();

			var ingredient:Ingredient;

			for (var i:uint = 0; i < Constants.INGREDIENTS_LOCATION.length; i++)
			{
				var randQuality:uint = Math.floor(Constants.BAD_INGREDIENT_RATE * Math.random());
				var randPos:uint = Math.floor((Constants.INGREDIENTS_LIST.length / 2) * Math.random());

				if (randQuality == 0)
				{
					randPos +=  Constants.INGREDIENTS_LIST.length / 2;
				}

				ingredient = new Ingredient(i, Constants.INGREDIENTS_LIST[randPos], Constants.QUALITY_LIST[randPos]);

				ingredient.x = Constants.INGREDIENTS_LOCATION[i].x;
				ingredient.y = Constants.INGREDIENTS_LOCATION[i].y;

				ingredArray.push(ingredient);

				ingredsLayer.addChild(ingredient);
			}
		}

		public function handleKeyDown(kbdEvent:KeyboardEvent)
		{
			keyArray[kbdEvent.keyCode] = true;
		}

		public function handleKeyUp(kbdEvent:KeyboardEvent)
		{
			keyArray[kbdEvent.keyCode] = false;
		}

		private function handleTick(tmrEvent:TimerEvent)
		{
			// keep track of elapsed time in seconds
			if (updateCount % (Math.round(1000 / Constants.UPDATE_RATE)) == 0)
			{
				--timeLeft;
			}
			updateCount++;

			updateWorld();
		}

		private function updateWorld()
		{
			//update the timer
			time_left.text = Math.floor(timeLeft / 60) + ((timeLeft % 60 < 10) ? " : 0" : " : ") + timeLeft % 60;

			//update score meter with latests score
			player1_score.updateGauge(headChef1.getSoupScore());
			player2_score.updateGauge(headChef2.getSoupScore());

			handleObjects();

			movePlayers();

			updateThoughtBubbles();

			updateCombo();

			removeItemsFromCutBoard();

			regenerateRandomIngredients();

			if (checkEnd())
			{
				determineWinner();
				stopGame();
			}
		}

		private function updateCombo()
		{
			if (headChef1.getCombo() > 1)
			{
				combo1.text = "Combo x " + headChef1.getCombo();
			}
			else
			{
				combo1.text = "";
			}

			if (headChef2.getCombo() > 1)
			{
				combo2.text = "Combo x " + headChef2.getCombo();
			}
			else
			{
				combo2.text = "";
			}
		}

		private function updateThoughtBubbles()
		{
			var request:Array = headChef1.getChefsRequest();
			bubble1.setSequence(request);
			
			if (request[3] == "OVER")
			{
				bubble1.textDots.visible = false;
			}

			request = headChef2.getChefsRequest();
			bubble2.setSequence(request);
			
			if (request[3] == "OVER")
			{
				bubble2.textDots.visible = false;
			}
		}

		//fill in the gaps where the ingredients were taken out
		private function regenerateRandomIngredients()
		{
			if (removedIngredArray.length >= 5)
			{
				//make a decision whether to generate or not
				var shouldGenerate:uint = Math.floor(Math.random() * Constants.REGENERATE_RATE);

				if (shouldGenerate == 0)
				{
					var randQuality:uint = Math.floor(Constants.BAD_INGREDIENT_RATE * Math.random());
					var randIngred:uint = Math.floor((Constants.INGREDIENTS_LIST.length / 2) * Math.random());

					var randPos:uint = Math.floor(removedIngredArray.length * Math.random());

					if (randQuality == 0)
					{
						randIngred +=  Constants.INGREDIENTS_LIST.length / 2;
					}

					var id:uint = removedIngredArray[randPos];
					
					var ingredient:Ingredient = new Ingredient(id,Constants.INGREDIENTS_LIST[randIngred],Constants.QUALITY_LIST[randIngred]);

					removedIngredArray.splice(randPos, 1);

					ingredient.x = Constants.INGREDIENTS_LOCATION[id].x;
					ingredient.y = Constants.INGREDIENTS_LOCATION[id].y;

					ingredArray.splice(id,0,ingredient);
					ingredsLayer.addChild(ingredient);
				}
			}
		}

		private function stopGame()
		{
			stepTimer.stop();

			cutBoard1.clearCuttingBoard();
			cutBoard2.clearCuttingBoard();

			for (var i:uint; i < ingredArray.length; i++)
			{
				ingredsLayer.removeChild(ingredArray[i]);
			}

			this.stage.removeEventListener(KeyboardEvent.KEY_DOWN, handleKeyDown);
			this.stage.removeEventListener(KeyboardEvent.KEY_UP, handleKeyUp);

			screenManager.displayEndGameScreen();
		}

		public function returnPotContents():Array
		{
			var contents:Array=new Array();
			contents.push(pot1.getDetailedPot());
			contents.push(pot2.getDetailedPot());

			return contents;
		}

		// game ends when time runs out
		private function checkEnd():Boolean
		{
			return timeLeft == 0;
		}

		private function movePlayers()
		{
			//check for keypress on player 1 keys
			if (keyArray[Keyboard.W] == false && keyArray[Keyboard.A] == false && keyArray[Keyboard.S] == false && keyArray[Keyboard.D] == false)
			{
				player1.setPlayerState(Constants.PLAYER_STATE_STOP);
				player1.movePlayer("");
			}
			else
			{
				var moveDirection1;
				player1.setPlayerState(Constants.PLAYER_STATE_MOVE);
				if (keyArray[Keyboard.W])
				{
					moveDirection1 = Constants.MOVE_DIR_UP;
					player1.movePlayer(Constants.MOVE_DIR_UP);
				}
				if (keyArray[Keyboard.A] == true)
				{
					moveDirection1 = Constants.MOVE_DIR_LEFT;
					player1.movePlayer(Constants.MOVE_DIR_LEFT);
				}
				if (keyArray[Keyboard.S] == true)
				{
					moveDirection1 = Constants.MOVE_DIR_DOWN;
					player1.movePlayer(Constants.MOVE_DIR_DOWN);
				}
				if (keyArray[Keyboard.D] == true)
				{
					moveDirection1 = Constants.MOVE_DIR_RIGHT;
					player1.movePlayer(Constants.MOVE_DIR_RIGHT);
				}

				collisionManager.keepInsideGameArea(outerBound, player1);
				collisionManager.keepOutsideGameArea(innerBound,moveDirection1,player1);
			}

			//check for keypress on player 2 keys
			if (keyArray[Keyboard.UP] == false && keyArray[Keyboard.DOWN] == false && keyArray[Keyboard.LEFT] == false && keyArray[Keyboard.RIGHT] == false)
			{
				player2.setPlayerState(Constants.PLAYER_STATE_STOP);
				player2.movePlayer("");
			}
			else
			{
				var moveDirection;
				player2.setPlayerState(Constants.PLAYER_STATE_MOVE);
				if (keyArray[Keyboard.UP] == true)
				{
					moveDirection = Constants.MOVE_DIR_UP;
					player2.movePlayer(Constants.MOVE_DIR_UP);
				}
				if (keyArray[Keyboard.DOWN] == true)
				{
					moveDirection = Constants.MOVE_DIR_DOWN;
					player2.movePlayer(Constants.MOVE_DIR_DOWN);
				}
				if (keyArray[Keyboard.LEFT] == true)
				{
					moveDirection = Constants.MOVE_DIR_LEFT;
					player2.movePlayer(Constants.MOVE_DIR_LEFT);
				}
				if (keyArray[Keyboard.RIGHT] == true)
				{
					moveDirection = Constants.MOVE_DIR_RIGHT;
					player2.movePlayer(Constants.MOVE_DIR_RIGHT);
				}

				collisionManager.keepInsideGameArea(outerBound, player2);
				collisionManager.keepOutsideGameArea(innerBound,moveDirection,player2);
			}
		}

		private function handleObjects()
		{
			var closestIngredient:Ingredient;
			var closestCutBoard:DropArea;
			var closestPot:Pot;
			var player:Player;

			// For Player 1
			if (keyArray[Keyboard.TAB])
			{
				player = player1;
				keyArray[Keyboard.TAB] = false;
			}
			else if (keyArray[Keyboard.ENTER])
			{
				player = player2;
				keyArray[Keyboard.ENTER] = false;
			}

			// if player is holding something, drop it
			// if not, pick up object

			if (player != null)
			{
				if (player.isHolding())
				{
					closestCutBoard = findClosestCutBoardTo(player);

					if (closestCutBoard != null)
					{
						player.setHolding(false);
						closestIngredient = player.removeChildAt(1) as Ingredient;

						closestCutBoard.addtoBoard(closestIngredient);
					}
				}
				else
				{
					closestIngredient = findClosestIngredientTo(player);

					if (closestIngredient != null)
					{
						//reset the ingredient's coordinates so it lands in the center of the new parent
						closestIngredient.x = 0;
						closestIngredient.y = 0;

						player.addChildAt(closestIngredient, 1);
						player.setHolding(true);

						removedIngredArray.push(closestIngredient.getID());
						ingredArray.splice(ingredArray.indexOf(closestIngredient), 1);
					}
				}
			}
		}

		private function findClosestCutBoardTo(object:Object):DropArea
		{
			var cutBoard1Distance:Number = distanceBetween(object,cutBoard1);
			var cutBoard2Distance:Number = distanceBetween(object,cutBoard2);

			if (cutBoard1Distance < cutBoard2Distance)
			{
				if (cutBoard1Distance < Constants.FIELD_OF_VIEW)
				{
					return cutBoard1;
				}
			}
			else
			{
				if (cutBoard2Distance < Constants.FIELD_OF_VIEW)
				{
					return cutBoard2;
				}
			}
			return null;
		}

		private function findClosestIngredientTo(object:Object):Ingredient
		{
			var closestIngredient:Ingredient;
			var min_distance:Number = 99999;

			for (var i:uint = 0; i < ingredArray.length; i++)
			{
				var distance:Number = distanceBetween(object,ingredArray[i]);

				if (distance < min_distance && distance < Constants.FIELD_OF_VIEW)
				{
					min_distance = distance;
					closestIngredient = ingredArray[i];
				}
			}

			return closestIngredient;
		}

		private function distanceBetween(object1:Object, object2:Object):Number
		{
			return (Math.pow((object2.x - object1.x), 2) + Math.pow((object2.y - object1.y), 2));
		}

		// items are removed from screen by dimming them out and then deleting them
		private function removeItemsFromCutBoard()
		{
			var ingred:Ingredient;

			if (! cutBoard1.isHolding() && cutBoard1.getSize() != 0)
			{
				ingred = cutBoard1.removeFromBoard();
				pot1.addToPot(ingred);
				headChef1.reactToIngredient(ingred);
			}

			if (! cutBoard2.isHolding() && cutBoard2.getSize() != 0)
			{
				ingred = cutBoard2.removeFromBoard();
				pot2.addToPot(ingred);
				headChef2.reactToIngredient(ingred);
			}

			if (cutBoard1.isHolding())
			{
				if (cutBoard1.getChildAt(1).alpha > 0)
				{
					cutBoard1.getChildAt(1).alpha -=  Constants.ALPHA_DECREASE_RATE;
				}
				else
				{
					cutBoard1.removeChildAt(1);
					cutBoard1.setHolding(false);
				}
			}

			if (cutBoard2.isHolding())
			{
				if (cutBoard2.getChildAt(1).alpha > 0)
				{
					cutBoard2.getChildAt(1).alpha -=  Constants.ALPHA_DECREASE_RATE;
				}
				else
				{
					cutBoard2.removeChildAt(1);
					cutBoard2.setHolding(false);
				}
			}
		}

		private function determineWinner()
		{
			if (headChef1.getSoupScore() > headChef2.getSoupScore())
			{
				endgameText = Constants.ENDGAME_TEXT_SNAKE_WINS;
			}
			else if (headChef2.getSoupScore() > headChef1.getSoupScore())
			{
				endgameText = Constants.ENDGAME_TEXT_BADGER_WINS;
			}
			else
			{
				endgameText = Constants.ENDGAME_TEXT_NOONE_WINS;
			}
		}

		public function getEndGameText():String
		{
			return endgameText;
		}
	}
}