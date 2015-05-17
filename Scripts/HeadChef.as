package 
{
	import flash.display.MovieClip;
	import flash.utils.Timer;

	//class containing the headchef's behaviour
	public class HeadChef extends MovieClip
	{
		private var ingredientsList:Array; //a queue of ingredients chef wants
		private var ingredientPointer:uint; //pointer to the head of the queue
		private var soupScore:int;
		private var combo:int;

		//default constructor that does nothing
		public function HeadChef()
		{
		}

		//Pre-generate the list of ingredients that the chef wants
		//Chef wants only good ingredients
		public function decideIngredients()
		{
			soupScore = Constants.SCORE_START;
			combo = 0;
			ingredientsList = new Array();

			for (var i:uint = 0; i < Constants.NO_OF_PREDETERMINED_INGREDS; )
			{
				var randPos:uint = Math.floor(Constants.INGREDIENTS_LIST.length / 2 * Math.random()); //only half of the ingredients are good
				//specifically the first half

				//introducing repetition in the list by adding the ingredient 1 to MAX_NO_OF_INGREDS times continuously
				var randNumber:uint = Math.floor(Constants.MAX_NO_OF_INGREDS * Math.random()) + 1;

				for (var j:uint = 0; j < randNumber; j++)
				{
					var ingredient:Ingredient = new Ingredient(0, Constants.INGREDIENTS_LIST[randPos], Constants.QUALITY_LIST[randPos]);
					ingredientsList.push(ingredient);
					i++;
				}
			}
			
			ingredientPointer = 0;
		}

		//we add value to the soup based on the chef's reaction to the ingredient
		public function reactToIngredient(ingredient:Ingredient)
		{
			//Chef got the ingredient he wanted
			if (ingredient.getName() == ingredientsList[ingredientPointer].getName())
			{	
				ingredientPointer++;
				combo++;
				soupScore +=  ingredient.getPoints() + ingredient.getPoints() / 2 * combo;
			}
			//Chef got one of the other ingredients he wanted
			else if (ingredient.getName() == ingredientsList[ingredientPointer + 1].getName() || 
					ingredient.getName() == ingredientsList[ingredientPointer + 2].getName())
			{
				//removing that ingredient from the queue
				if (ingredient.getName() == ingredientsList[ingredientPointer + 1].getName())
				{
					ingredientsList.splice(ingredientPointer + 1, 1);
				}
				else
				{
					ingredientsList.splice(ingredientPointer + 2, 1);
				}

				combo++;
				soupScore +=  ingredient.getPoints() / 2 * combo;
			}
			//Chef got a good ingredient, but not what he wanted
			else if (ingredient.getQuality() == Constants.INGRED_GOOD)
			{
				combo = 0;
				soupScore +=  ingredient.getPoints() / 2;
			}
			//Chef got a bad ingredient
			else if (ingredient.getQuality() == Constants.INGRED_BAD)
			{
				combo = 0;
				soupScore +=  ingredient.getPoints() * 2; //the points are negative for bad ingredients
			}
		}

		//Returns the first 3 ingredients in the queue
		public function getChefsRequest():Array
		{
			var requestIngreds:Array = new Array();

			if (ingredientPointer < ingredientsList.length)
			{
				requestIngreds.push(ingredientsList[ingredientPointer].getName());
			}
			if (ingredientPointer + 1 < ingredientsList.length)
			{
				requestIngreds.push(ingredientsList[ingredientPointer + 1].getName());
			}
			if (ingredientPointer + 2 < ingredientsList.length)
			{
				requestIngreds.push(ingredientsList[ingredientPointer + 2].getName());
			}

			if (ingredientPointer + 3 == ingredientsList.length)
			{
				requestIngreds.push("OVER"); //marker to indicate end of list. This will be used to disable the "..." text on the thought bubbles
			}

			return requestIngreds;
		}

		public function getSoupScore():int
		{
			return soupScore;
		}

		public function getCombo():uint
		{
			return combo;
		}
	}
}