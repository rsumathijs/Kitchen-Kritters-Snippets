package 
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;

	public class EndGameScreen extends MovieClip
	{
		private var start_btn:TestButton;
		private var title_btn:TestButton;
		private var screenManager:ScreenManager;

		private var pot1Contents:Array;
		private var pot2Contents:Array;

		private var player1Soup:MovieClip;
		private var player2Soup:MovieClip;

		private var pot1Min:uint;
		private var pot2Min:uint;
		
		//constructor that maps the buttons and movie clips on the scene to variables
		public function EndGameScreen(screen:ScreenManager)
		{
			screenManager = screen;
			start_btn = buttonReplay;
			title_btn = buttonTitle;

			start_btn.addEventListener(MouseEvent.MOUSE_DOWN, ReplayGame);
			title_btn.addEventListener(MouseEvent.MOUSE_DOWN, gotoTitle);

			player1Soup = soup1_mc;
			player2Soup = soup2_mc;
		}

		private function ReplayGame(event:MouseEvent)
		{
			removeIngredientsFromSoup();
			screenManager.displayGameScreen();
		}

		private function removeIngredientsFromSoup()
		{
			for (var i = 0; i < pot1Min; i++)
			{
				player1Soup.removeChild(pot1Contents[i]);
			}

			for (i = 0; i < pot2Min; i++)
			{
				player2Soup.removeChild(pot2Contents[i]);
			}
		}

		private function gotoTitle(event:MouseEvent)
		{
			screenManager.displayTitleScreen();
		}

		public function initScreen(contents:Array)
		{
			pot1Contents = contents[0];
			pot2Contents = contents[1];

			pot1Min = drawContentsInSoup(player1Soup, pot1Contents);
			pot2Min = drawContentsInSoup(player2Soup, pot2Contents);
		}

		private function drawContentsInSoup(soup:MovieClip, contents:Array):uint
		{
			//the soup has a fixed number of slots to display ingredients
			//finding which is minimum : the number of slots or the number of ingredients
			var min:uint = (contents.length < Constants.SOUP_INGREDIENT_POSITIONS.length ? contents.length : Constants.SOUP_INGREDIENT_POSITIONS.length);

			for (var i:uint = 0; i < min; i++)
			{
				var ingredient:Ingredient = new Ingredient(0, "fish", 0);
				ingredient = contents[i];
				ingredient.alpha = 1; //setting alpha back to one because we turned it to 0 while adding to soup
				ingredient.scaleX *=  0.5; //scaling the ingredients since they are a little big for the soup
				ingredient.scaleY *=  0.5;

				ingredient.x = Constants.SOUP_INGREDIENT_POSITIONS[i].x;
				ingredient.y = Constants.SOUP_INGREDIENT_POSITIONS[i].y;
				
				soup.addChild(ingredient);
			}

			return min;
		}

		public function setEndGameText(textValue:String)
		{
			endtext.text = textValue;
		}
	}
}