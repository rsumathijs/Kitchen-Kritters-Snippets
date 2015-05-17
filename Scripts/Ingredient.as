package 
{
	import flash.display.MovieClip;

	//class representing a soup ingredient
	public class Ingredient extends MovieClip
	{
		private var ingredientName:String;
		private var quality:uint;
		private var points:int;
		private var ingredientId:uint;

		//constructor to initialise the ingredient
		public function Ingredient(id:uint, ingredName:String, ingredQuality:uint)
		{
			ingredientId = id;
			ingredientName = ingredName;
			quality = ingredQuality;
			gotoAndStop(ingredientName);

			if (quality == Constants.INGRED_BAD)
			{
				points = Constants.POINTS_BAD;
			}
			else
			{
				points = Constants.POINTS_GOOD;
			}
		}

		public function getName():String
		{
			return ingredientName;
		}

		public function setName(newName:String)
		{
			ingredientName = newName;
			gotoAndStop(newName);
		}

		public function getQuality():uint
		{
			return quality;
		}

		public function getPoints():int
		{
			return points;
		}

		public function getID():uint
		{
			return ingredientId;
		}
	}
}