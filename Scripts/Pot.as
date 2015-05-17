package 
{
	import flash.display.MovieClip;

	//class to represent the Soup pot
	//keeps track of all the ingredients added
	public class Pot extends MovieClip
	{
		private var ingredsInPot:Array; //stores all the ingredients added to the pot as a dictionary of name and number of times added
		private var detailedPot:Array; //stores the actual ingredient 

		public function Pot()
		{
			detailedPot = new Array();
			ingredsInPot = new Array();
			
			for (var i:uint = 0; i < Constants.INGREDIENTS_LIST.length; i++)
			{
				ingredsInPot[Constants.INGREDIENTS_LIST[i]] = 0;
				//getting the name of the ingredient and initialising the initial count of that to 0
			}
		}

		//add ingredient to pot, if not already in there
		public function addToPot(object:Ingredient)
		{
			ingredsInPot[object.getName()]++;
			detailedPot.push(object);
		}

		//get all the ingredients in the pot as a single string
		public function getPot(strict:Boolean):String
		{
			var potItems:String = "";

			for (var i:uint=0; i<Constants.INGREDIENTS_LIST.length; i++)
			{
				if (!(ingredsInPot[Constants.INGREDIENTS_LIST[i]]==0 && strict))
				{
					potItems +=  Constants.INGREDIENTS_LIST[i] + " x " + ingredsInPot[Constants.INGREDIENTS_LIST[i]] + "\n";
				}
			}
			
			return potItems;
		}

		//return the list of added ingredients
		public function getDetailedPot():Array
		{
			return detailedPot;
		}
	}
}